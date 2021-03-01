
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>

#define MAP_SIZE 4096UL
#define MAP_MASK (MAP_SIZE - 1)

#define ADDER_BASE_ADDR 0x43C00000 // this is the offset address from earlier

void *getvaddr(int phys_addr)
{
	void *mapped_base;
	int memfd;

	void *mapped_dev_base;
	off_t dev_base = phys_addr;
	
	memfd = open("/dev/mem", O_RDWR | O_SYNC); // to open this the program needs to be run as root
	if (memfd == -1) {
		printf("Can’t open /dev/mem.\n");
		exit(0);
	}

	// Map one page of memory into user space such that the device is in that page, but it may not
	// be at the start of the page
	
	mapped_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, memfd, dev_base & ~MAP_MASK);
	if (mapped_base == (void *) -1) {
		printf("Can’t map the memory to user space.\n");
		exit(0);
	}

	// get the address of the device in user space which will be an offset from the base
	// that was mapped as memory is mapped at the start of a page

	mapped_dev_base = mapped_base + (dev_base & MAP_MASK);
	return mapped_dev_base;
}

int _7seg_to_dec (uint8_t LEDOUT)
{
    int dec_out = 0;
    switch(LEDOUT) {
        case 0b11000000: dec_out = 0; break; 
        case 0b11111001: dec_out = 1; break; 
        case 0b10100100: dec_out = 2; break; 
        case 0b10110000: dec_out = 3; break; 
        case 0b10011001: dec_out = 4; break; 
        case 0b10010010: dec_out = 5; break; 
        case 0b10000010: dec_out = 6; break; 
        case 0b11111000: dec_out = 7; break; 
        case 0b10000000: dec_out = 8; break; 
        case 0b10010000: dec_out = 9; break; 
        default: dec_out = 0;
    }
    return dec_out;
}

int _7segs_to_dec (uint32_t LEDOUT_all)
{
    int dec_out = _7seg_to_dec((uint8_t) ~(LEDOUT_all & (0xff << (3 << 3))) >> (3 << 3)) * 1000
                + _7seg_to_dec((uint8_t) ~(LEDOUT_all & (0xff << (2 << 3))) >> (2 << 3)) * 100
                + _7seg_to_dec((uint8_t) ~(LEDOUT_all & (0xff << (1 << 3))) >> (1 << 3)) * 10
                + _7seg_to_dec((uint8_t) ~(LEDOUT_all &  0xff));
    return dec_out;
}

int main(int argc, char** argv)
{
	if (argc != 2) printf("Usage:\n\t./a.out <switches_input>\n");
	else {
		int * dev_base_vaddr= getvaddr(ADDER_BASE_ADDR);
		int * switches = dev_base_vaddr + 2;
		int * buttons = dev_base_vaddr + 3;
		int * leds = dev_base_vaddr + 5;
		int * _7seg = dev_base_vaddr + 6;

		char *p;
        int switches_input = (int) strtol(argv[1], &p, 2);

        if(switches_input > 7 | switches_input < 0)   printf("binary between 'b000 and 'b111 expected for switches_input");
        else {
            *(switches) = switches_input;
            int snapshot_leds = *(leds);
            int a_led = (snapshot_leds & (1 << 2)) >> 2;
            int b_led = (snapshot_leds & (1 << 1)) >> 1;
            int c_led =  snapshot_leds &  1;

            sleep(1);// insert delay here

            int snapshot_7seg = *(_7seg);

            printf("A_led B_led C_led 7seg\n");
            printf("    %d     %d     %d %04d\n", a_led, b_led, c_led, _7segs_to_dec(snapshot_7seg));
            // printf("    %d     %d     %d %04d\n", a_led, b_led, c_led, snapshot_7seg);
        }
		// *(input_a) = (int) strtol(argv[1], &p, 10);
		// *(input_b) = (int) strtol(argv[2], &p, 10);

		// printf("answer %d\n", *(output_c));
	}
	return 0;
}
