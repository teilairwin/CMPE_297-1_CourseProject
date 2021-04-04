
#include "SocTestCases.hpp"
#include "SocAxiIf.hpp"
#include "RomLoader.hpp"
#include "Constants.hpp"

#include <stdint.h>
#include <unistd.h>

bool SocTestCases::TestMips_RegisterFile(SocAxiIf& soc, std::ostream& log)
{
	bool success(true);
	//Put the processor into reset & switch to host clock
	soc.mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);
	std::string program("mips-bin/testmips-regfile.bin");
	if (!soc.LoadRom(program, ROM_PMEM))
	{
		return false;
	}

	//Release reset lock
	soc.mSysCtrl.Write(0);
	sleep(5);

	log << "\tChecking Register File...\n";
	uint32_t results[32] = {    0,1001,1002,1003,1004,1005,1006,1007,
							 1008,1009,1010,1011,1012,1013,1014,1015,
							 1016,1017,1018,1019,1020,1021,1022,1023,
							 1024,1025,1026,1027,1028,1029,1030,1031 };

	for (uint32_t ii = 0; ii < MIPS_REGFILE_SIZE; ii++)
	{
		uint32_t rf_reg = ii;
		uint32_t testData = soc.ReadRegisterFile(rf_reg);
		if (testData != results[ii])
		{
			log << "\tRF-Reg[" << rf_reg << "] Exp[0x" << std::hex << results[ii]
				<< "] Got[0x" << testData << "]\n" << std::dec;
			success = false;
		}
	}

	//Reseting MIPS to check RegFile Cleared
	log << "\tChecking Register File Reset...\n";
	//soc.Reset();
	soc.mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);
	usleep(DUT_DELAY);
	soc.CycleHostClock();

	for (uint32_t ii = 0; ii < MIPS_REGFILE_SIZE; ii++)
	{
		uint32_t rf_reg = ii;
		uint32_t testData = soc.ReadRegisterFile(rf_reg);
		if (testData != 0)
		{
			log << "\tRF-Reg[" << rf_reg << "] Exp[0x" << std::hex << 0
				<< "] Got[0x" << testData << "]\n" << std::dec;
			success = false;
		}
	}

	return success;
}


