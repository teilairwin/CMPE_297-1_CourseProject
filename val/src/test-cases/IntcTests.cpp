
#include "IntcTestCases.hpp"
#include "IntcAxiIf.hpp"
#include "Constants.hpp"

#include <stdlib.h>
#include <unistd.h>

bool IntcTestCases::TestIsr_ReadWrite(IntcAxiIf& intc, std::ostream& log)
{
	bool success(true);
	//Reset intc, but leave host clock selected
	intc.Reset(false);

	//Check reset values of zero
	log << "\tChecking reset state...\n";
	uint32_t readVal(0);
	for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
	{
		readVal = intc.ReadRegisterBank(ii);
		if (readVal != 0x0)
		{
			log << "\tFailed reset of Isr registers. Value was non-zero!\n";
			success = false;
		}
	}
	
	//Write the ISR table and check the read values
	log << "\tChecking writes and readback...\n";
	if (success)
	{
		uint32_t isrAddr[] = { 0xDEADBEEF,0xBA5EB411,0xCAFECAFE,0x12345678 };
		for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
		{
			intc.WriteRegisterBank(ii, isrAddr[ii]);
		}
		for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
		{
			readVal = intc.ReadRegisterBank(ii);
			if (readVal != isrAddr[ii])
			{
				log << "\tFailed write/read of Isr registers!\n";
				printf("Exp:0x%08x Got:0x%08x\n", isrAddr[ii], readVal);
				success = false;
			}
		}
	}

	//Reset the INTc again to check the registers cleared
	log << "\tChecking reset readback after write...\n";
	if (success)
	{
		intc.Reset(false);
		for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
		{
			readVal = intc.ReadRegisterBank(ii);
			if (readVal != 0x0)
			{
				log << "\tFailed reset of Isr registers after write. Value was non-zero!\n";
				success = false;
			}
		}
	}

	return success;
}



