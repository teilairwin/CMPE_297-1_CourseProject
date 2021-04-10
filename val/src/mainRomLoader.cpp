
#include "common/Constants.hpp"
#include "common/SocAxiIf.hpp"
#include "common/RomLoader.hpp"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//Initial test program for loading ROM

SocAxiIf* soc;

int main(int argc, char** argv)
{
	soc = new SocAxiIf(AXI_DUT_BASE_ADDR);

	//Put the processor into reset & switch to host clock
	soc->mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);
	
	RomLoader romLoaderP(soc,ROM_PMEM);
	std::string binFile("regfile.bin");
	if (!romLoaderP.LoadBin(binFile))
	{
		printf("Failed to load Program-ROM!\n");
		exit(1);
	}
	if (!romLoaderP.VerifyRom())
	{
		printf("Program-ROM Verification Failed!\n");
		exit(1);
	}
	RomLoader romLoaderE(soc, ROM_EMEM);
	std::string binFileE("exc.bin");
	if(!romLoaderE.LoadBin(binFileE))
	{
		printf("Failed to load Exception-ROM!\n");
		exit(1);
	}
	if (!romLoaderE.VerifyRom())
	{
		printf("Exception-ROM Verification Failed!\n");
		exit(1);
	}

	//Now that we've loaded a program, deassert resert switch to onboard clock
	printf("Running Program...\n");
	soc->mSysCtrl.Write(0);
	sleep(10);

	//Now read the regfile and look at the results. 
	printf("Reading Register File...\n");
	for (uint32_t ii = 0; ii < MIPS_REGFILE_SIZE; ii++)
	{
		//Select the register
		soc->mMipsRfCtrl.Write(MIPSRFCTRL_ADDR(ii));
		usleep(DUT_DELAY);
		//Read it
		uint32_t rfGot = soc->mMipsRfData.Read();
		printf("\t $%02d 0x%08x\n", ii, rfGot);
	}
	printf("Done reading RegFile\n");

	return 0;
}
