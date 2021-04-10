
#include "common/Constants.hpp"
#include "common/AddressMapper.hpp"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//Initial test program for AXI interface and loading ROM

uint32_t romSize(64);

//Outputs
uint32_t* regControl(0);
uint32_t* regRfAddr(0);
uint32_t* regRomControl(0);
uint32_t* regRomWData(0);
uint32_t* regResv0(0);
//Inputs
uint32_t* regMipsPc(0);
uint32_t* regRomRData(0);
uint32_t* regRfData(0);

uint32_t dataControl(0);
uint32_t dataRomControl(0);
uint32_t dataRomWData(0);
uint32_t dataRomRData(0);

//Init the register addresses from the given base address
void InitRegisters(void* baseAddr)
{
	regControl =    (uint32_t*)baseAddr + 0;
	regRfAddr =     (uint32_t*)baseAddr + 1;
	regRomControl = (uint32_t*)baseAddr + 2;
	regRomWData =   (uint32_t*)baseAddr + 3;
	regResv0 =      (uint32_t*)baseAddr + 4;
	regMipsPc =     (uint32_t*)baseAddr + 5;
	regRomRData =   (uint32_t*)baseAddr + 6;
	regRfData =     (uint32_t*)baseAddr + 7;
}

void LoadRom()
{
	printf("Loading ROM...\n");

	for (uint32_t ii = 0; ii < romSize; ii++)
	{
		//Set ROM - WE & ADDR
		dataRomControl = 0x1 | (ii << 1);
		*regRomControl = dataRomControl;
		//Set ROM W Data
		dataRomWData = 0xdead0000 + ii;
		*regRomWData = dataRomWData;

		//Clock in the Data
		dataControl ^= (0x1 << 1);
		*regControl = dataControl;
		sleep(1);
		dataControl ^= (0x1 << 1);
		*regControl = dataControl;
		sleep(1);
	}

	//Disable the ROM Ctrl WE
	dataRomControl = 0x0;
	*regRomControl = dataRomControl;

	printf("Finished Loading ROM\n");
}

void VerifyRom()
{
	printf("Verifying ROM...\n");

	for (uint32_t ii = 0; ii < romSize; ii++)
	{
		//Set ROM Ctrl
		dataRomControl = (ii << 1);  //read addr
		*regRomControl = dataRomControl;

		sleep(1);

		//Read Rom Data
		dataRomRData = *regRomRData;
		printf("\t ROM[%d] Data:0x%08x\n", ii, dataRomRData);
	}

	printf("Finished Verifying ROM\n");
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

	//Put the processor into reset & switch to host clock
	dataControl = 0x1 | (0x1 << 2);
	*regControl = dataControl;

	//Load a program into ROM
	LoadRom();
	VerifyRom();

	return 0;
}
