
#include "SocTestCases.hpp"
#include "SocAxiIf.hpp"
#include "Constants.hpp"
#include "RomLoader.hpp"

#include <stdlib.h>
#include <unistd.h>

bool SocTestCases::TestRom_LoadPmem(SocAxiIf& soc, std::ostream& log)
{
	bool success(true);
	//Put the processor into reset & switch to host clock
	soc.mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);

	RomLoader romLoaderP(&soc, ROM_PMEM);
	std::string binFile("mips-bin/regfile.bin");
	if (!romLoaderP.LoadBin(binFile))
	{
		log << "\tFailed to load Program-ROM\n";
		success = false;
	}
	else
	{
		if (!romLoaderP.VerifyRom())
		{
			log << "\tProgram-ROM Verification Failed!\n";
			success = false;
		}
	}

	//Release reset lock
	soc.mSysCtrl.Write(0);
	return success;
}

bool SocTestCases::TestRom_LoadPmemEmem(SocAxiIf& soc, std::ostream& log)
{
	bool success(true);
	//Put the processor into reset & switch to host clock
	soc.mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);

	RomLoader romLoaderP(&soc, ROM_PMEM);
	std::string binFileP("mips-bin/regfile.bin");
	if (!romLoaderP.LoadBin(binFileP))
	{
		log << "\tFailed to load Program-ROM!\n";
		success = false;
	}
	else
	{
		if (!romLoaderP.VerifyRom())
		{
			log << "\tProgram-ROM Verification Failed!\n";
			success = false;
		}
	}

	RomLoader romLoaderE(&soc, ROM_EMEM);
	std::string binFileE("mips-bin/exc.bin");
	if (!romLoaderE.LoadBin(binFileE))
	{
		log << "\tFailed to load Exception-ROM!\n";
		success = false;
	}
	else
	{
		if (!romLoaderE.VerifyRom())
		{
			log << "\tException-ROM Verification Failed!\n";
			success = false;
		}
	}

	//Now that we've loaded a program, deassert resert switch to onboard clock
	log << "\tRunning MIPS Program...\n";
	soc.mSysCtrl.Write(0);
	sleep(5);

	//Read the Register File
	log << "\tChecking Register File...\n";
	uint32_t results[8] = { 100,201,302,403,504,605,706,807 };
	for (uint32_t ii = 0; ii < 8; ii++)
	{
		uint32_t rf_reg = MIPSRF_T0 + ii;
		uint32_t testData = soc.ReadRegisterFile(rf_reg);
		if (testData != results[ii])
		{
			log << "\tRF-Reg[" << rf_reg << "] Exp[0x" << std::hex << results[ii]
				<< "] Got[0x" << testData << "]\n" << std::dec;
			success = false;
		}
	}

	return success;
}





