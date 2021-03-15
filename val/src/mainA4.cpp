
#include "common/Constants.hpp"
#include "common/AddressMapper.hpp"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>



uint32_t maxN = 12;
uint32_t* regSwitches(0);
uint32_t* regButtons(0);
uint32_t* regLeds(0);
uint32_t* reg7Seg(0);

//Init the register addresses from the given base address
void InitRegisters(void* baseAddr)
{
	regSwitches = (uint32_t*) baseAddr + 2;
	regButtons = (uint32_t*) baseAddr + 3;
	regLeds = (uint32_t*) baseAddr + 5;
	reg7Seg = (uint32_t*) baseAddr + 6;
}

uint8_t ConvertSegToDigit(uint8_t seg)
{
	uint8_t digit(0);
	switch (seg) {
	case 0x3F: digit = 0x0; break;
	case 0x06: digit = 0x1; break;
	case 0x5B: digit = 0x2; break;
	case 0x4F: digit = 0x3; break;
	case 0x66: digit = 0x4; break;
	case 0x6D: digit = 0x5; break;
	case 0x7D: digit = 0x6; break;
	case 0x07: digit = 0x7; break;
	case 0x7F: digit = 0x8; break;
	case 0x6F: digit = 0x9; break;
	case 0x77: digit = 0xA; break;
	//case 0x00: digit = 0xB; break;
	case 0x39: digit = 0xC; break;
	//case 0x00: digit = 0xD; break;
	case 0x79: digit = 0xE; break;
	case 0x71: digit = 0xF; break;
	default: digit = 0; break;
	}
	return digit;
}

//Compute and display n! for the given n
void ComputeFactorial(uint32_t n)
{
	printf("Computing Factorial %d\n", n);
	uint8_t digits[8];
	uint32_t switches(n);
	uint8_t segs[4];

	*regSwitches = switches;  //Set N
	sleep(1);
	*((uint32_t*)&segs[0]) = *reg7Seg;
	for(uint8_t ii=0; ii<4; ii++)
	{ 
		digits[ii] = ConvertSegToDigit(segs[ii]);
	}
	uint16_t low = (digits[3] << 12) | (digits[2] << 8) | (digits[1] << 4) | (digits[0]);
	
	switches |= 0x1 << 4;   //Set bit for high half of n!
	*regSwitches = switches;
	sleep(1);
	*((uint32_t*)&segs[0]) = *reg7Seg;
	for (uint8_t ii = 0; ii < 4; ii++)
	{
		digits[ii] = ConvertSegToDigit(segs[ii]);
	}
	uint16_t high = (digits[3] << 12) | (digits[2] << 8) | (digits[1] << 4) | (digits[0]);

	printf("\t %d!: 0x%04x_%04x\n", n,high,low);
}

int main(int argc, char** argv)
{
	void* dutAddr(0);
	if (!AddressMapper::GetVirtualAddr(AXI_SOC_BASE_ADDR, &dutAddr))
	{
		printf("Failed to Map DUT!\n");
		exit(1);
	}
	InitRegisters(dutAddr);

	for (uint32_t ii = 0; ii <= maxN; ii++)
	{
		ComputeFactorial(ii);
	}

	return 0;
}
