
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

int * dev_base_vaddr;
int * reg_switches;
int * reg_buttons;
int * reg_leds;
int * reg_7seg;

void init_reg_ptrs() {
    dev_base_vaddr= getvaddr(ADDER_BASE_ADDR);
    reg_switches = dev_base_vaddr + 2;
    reg_buttons = dev_base_vaddr + 3;
    reg_leds = dev_base_vaddr + 5;
    reg_7seg = dev_base_vaddr + 6;
}

void set_reg_switches(uint32_t switches_val) {
    *(reg_switches) = switches_val;
}
void set_reg_buttons(uint32_t buttons_val) {
    *(reg_buttons) = buttons_val;
}

int get_reg_switches() {
    return *(reg_switches);
}
int get_reg_buttons() {
    return *(reg_buttons);
}

int get_reg_leds() {
    return *(reg_leds);
}
int get_reg_7seg() {
    return *(reg_7seg);
}

