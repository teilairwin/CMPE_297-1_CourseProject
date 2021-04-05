
#include "SocTestCases.hpp"
#include "SocAxiIf.hpp"
#include "RomLoader.hpp"
#include "Constants.hpp"

#include <stdint.h>
#include <unistd.h>

bool SocTestCases::TestSoc_Fact0(SocAxiIf& soc, std::ostream& log)
{
	bool success(true);
	//Put the processor into reset & switch to host clock
	soc.mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);
	std::string program("mips-bin/testsoc-fact0.bin");
	if (!soc.LoadRom(program, ROM_PMEM))
	{
		return false;
	}
	program = "mips-bin/testsoc-fact-isrs.bin";
	if (!soc.LoadRom(program, ROM_EMEM))
	{
		return false;
	}

	//Release reset lock
	soc.mSysCtrl.WriteToggle(SYSCTRL_RESET);
	soc.mTestCtrl.Write(0x1);
	printf("Manualy Stepping Program..\n");
	for (uint32_t ii = 0; ii < 100; ii++)
	{
		soc.CycleHostClock();
		printf("\tPC[0x%08x]\n", soc.mMipsPc.Read());
		//printf("\tPC[0x%08x] IntcTestData[0x%08x]\n", 
		//	soc.mMipsPc.Read(), soc.mMipsRfData.Read());
		//uint32_t intcData = soc.mMipsRfData.Read();
	}
	soc.mTestCtrl.Write(0x0);
	log << "\tChecking Results written back to RegisterFile...\n";
	uint32_t resultLoc[] = { MIPSRF_S0,MIPSRF_S1,MIPSRF_T2,MIPSRF_T4,MIPSRF_T5};
	uint32_t resultVal[] = { 0x1,120,20,0x1,120}; //Good,N,BackgroundWork,Good,N
	for (uint32_t ii = 0; ii < (sizeof(resultLoc)/4); ii++)
	{
		uint32_t testData = soc.ReadRegisterFile(resultLoc[ii]);
		printf("\t\tRF[%d] Data:0x%08x\n", resultLoc[ii], testData);
		if (testData != resultVal[ii])
		{
			log << "\t\tError! RF-Reg[" << resultLoc[ii] << "] Exp[0x" << std::hex << resultVal[ii]
				<< "] For[0x" << testData << "]\n" << std::dec;
			success = false;
		}
	}

	return success;
}

bool SocTestCases::TestSoc_Fact1(SocAxiIf& soc, std::ostream& log)
{
	bool success(true);
	//Put the processor into reset & switch to host clock
	soc.mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);
	std::string program("mips-bin/testsoc-fact1.bin");
	if (!soc.LoadRom(program, ROM_PMEM))
	{
		return false;
	}
	program = "mips-bin/testsoc-fact-isrs.bin";
	if (!soc.LoadRom(program, ROM_EMEM))
	{
		return false;
	}

	//Release reset lock
	soc.mSysCtrl.WriteToggle(SYSCTRL_RESET);
	soc.mTestCtrl.Write(0x1);
	printf("Manualy Stepping Program..\n");
	for (uint32_t ii = 0; ii < 100; ii++)
	{
		soc.CycleHostClock();
		printf("\tPC[0x%08x]\n", soc.mMipsPc.Read());
		//printf("\tPC[0x%08x] IntcTestData[0x%08x]\n", 
		//	soc.mMipsPc.Read(), soc.mMipsRfData.Read());
		//uint32_t intcData = soc.mMipsRfData.Read();
	}
	soc.mTestCtrl.Write(0x0);
	log << "\tChecking Results written back to RegisterFile...\n";
	uint32_t resultLoc[] = { MIPSRF_S2,MIPSRF_S3,MIPSRF_T2,MIPSRF_T4,MIPSRF_T5 };
	uint32_t resultVal[] = { 0x1,720,20,0x1,720 }; //Good,N,BackgroundWork,Good,N
	for (uint32_t ii = 0; ii < (sizeof(resultLoc) / 4); ii++)
	{
		uint32_t testData = soc.ReadRegisterFile(resultLoc[ii]);
		printf("\t\tRF[%d] Data:0x%08x\n", resultLoc[ii], testData);
		if (testData != resultVal[ii])
		{
			log << "\t\tError! RF-Reg[" << resultLoc[ii] << "] Exp[0x" << std::hex << resultVal[ii]
				<< "] For[0x" << testData << "]\n" << std::dec;
			success = false;
		}
	}

	return success;
}

bool SocTestCases::TestSoc_Fact2(SocAxiIf& soc, std::ostream& log)
{
	bool success(true);
	//Put the processor into reset & switch to host clock
	soc.mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);
	std::string program("mips-bin/testsoc-fact2.bin");
	if (!soc.LoadRom(program, ROM_PMEM))
	{
		return false;
	}
	program = "mips-bin/testsoc-fact-isrs.bin";
	if (!soc.LoadRom(program, ROM_EMEM))
	{
		return false;
	}

	//Release reset lock
	soc.mSysCtrl.WriteToggle(SYSCTRL_RESET);
	
	printf("Manualy Stepping Program..\n");
	for (uint32_t ii = 0; ii < 100; ii++)
	{
		soc.CycleHostClock();
		printf("\tPC[0x%08x]\n", soc.mMipsPc.Read());
	}
	
	log << "\tChecking Results written back to RegisterFile...\n";
	uint32_t resultLoc[] = { MIPSRF_S4,MIPSRF_S5,MIPSRF_T2,MIPSRF_T4,MIPSRF_T5 };
	uint32_t resultVal[] = { 0x1,5040,20,0x1,5040 }; //Good,N,BackgroundWork,Good,N
	for (uint32_t ii = 0; ii < (sizeof(resultLoc) / 4); ii++)
	{
		uint32_t testData = soc.ReadRegisterFile(resultLoc[ii]);
		printf("\t\tRF[%d] Data:0x%08x\n", resultLoc[ii], testData);
		if (testData != resultVal[ii])
		{
			log << "\t\tError! RF-Reg[" << resultLoc[ii] << "] Exp[0x" << std::hex << resultVal[ii]
				<< "] For[0x" << testData << "]\n" << std::dec;
			success = false;
		}
	}

	return success;
}

bool SocTestCases::TestSoc_Fact3(SocAxiIf& soc, std::ostream& log)
{
	bool success(true);
	//Put the processor into reset & switch to host clock
	soc.mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);
	std::string program("mips-bin/testsoc-fact3.bin");
	if (!soc.LoadRom(program, ROM_PMEM))
	{
		return false;
	}
	program = "mips-bin/testsoc-fact-isrs.bin";
	if (!soc.LoadRom(program, ROM_EMEM))
	{
		return false;
	}

	//Release reset lock
	soc.mSysCtrl.WriteToggle(SYSCTRL_RESET);

	printf("Manualy Stepping Program..\n");
	for (uint32_t ii = 0; ii < 100; ii++)
	{
		soc.CycleHostClock();
		printf("\tPC[0x%08x]\n", soc.mMipsPc.Read());
	}

	log << "\tChecking Results written back to RegisterFile...\n";
	uint32_t resultLoc[] = { MIPSRF_S6,MIPSRF_S7,MIPSRF_T2,MIPSRF_T4,MIPSRF_T5 };
	uint32_t resultVal[] = { 0x1,40320,20,0x1,40320 }; //Good,N,BackgroundWork,Good,N
	for (uint32_t ii = 0; ii < (sizeof(resultLoc) / 4); ii++)
	{
		uint32_t testData = soc.ReadRegisterFile(resultLoc[ii]);
		printf("\t\tRF[%d] Data:0x%08x\n", resultLoc[ii], testData);
		if (testData != resultVal[ii])
		{
			log << "\t\tError! RF-Reg[" << resultLoc[ii] << "] Exp[0x" << std::hex << resultVal[ii]
				<< "] For[0x" << testData << "]\n" << std::dec;
			success = false;
		}
	}

	return success;
}

bool SocTestCases::TestSoc_IsrReconfigure(SocAxiIf& soc, std::ostream& log)
{
	return false;
}

bool SocTestCases::TestSoc_IsrSimultaneous(SocAxiIf& soc, std::ostream& log)
{
	return false;
}

bool SocTestCases::TestSoc_IsrMultiple(SocAxiIf& soc, std::ostream& log)
{
	return false;
}



