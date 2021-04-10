
#include "IntcTestCases.hpp"
#include "IntcAxiIf.hpp"
#include "Constants.hpp"

#include <stdlib.h>
#include <unistd.h>

//Test to validate reading and writing to the ISR address table
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
				printf("\tExp:0x%08x Got:0x%08x\n", isrAddr[ii], readVal);
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

//Helper Function to test triggering and clearing an interrupt from a single source. 
bool TestSingleSource(IntcAxiIf& intc, std::ostream& log, uint32_t index)
{
	bool success(true);
	intc.Reset(false);
	if (intc.mStatus.Read())
	{
		log << "\tUncleared interrupt after reset!\n";
		success = false;
	}

	//Set the ISR Table
	log << "\tLoading ISR Table...\n";
	uint32_t isrAddr[] = { 0x00001111,0x00002222,0x00003333,0x00004444 };
	if (success)
	{
		for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
		{
			intc.WriteRegisterBank(ii, isrAddr[ii]);
		}
		if (intc.mStatus.Read())
		{
			log << "\tUnexpected interrupt after writing ISR table!\n";
			success = false;
		}
	}

	//Trigger interrupt
	log << "\tTriggering Interrupt...\n";
	if (success)
	{
		//Send the interrupt
		//intc.mExtInt.Write(0x2); 
		intc.WriteDone(index);
		usleep(DUT_DELAY);
		intc.CycleHostClock();
		//Now check the IRQ and IRQ address signals
		uint32_t irqState = intc.mStatus.Read();
		if (irqState == 0)
		{
			log << "\tFailure - no IRQ asserted cycle after external signal asserted\n";
			success = false;
		}
		uint32_t isrState = intc.mIsrAddr.Read();
		printf("\t\tRead IRQ-State:0x%08x ISR-ADDR:0x%08x\n", irqState, isrState);
		if (isrState != isrAddr[index])
		{
			log << "\tFailure - ISR Address is incorrect for given external signal\n";
			printf("\tExpAddr:0x%08x GotAddr:0x%08x\n", isrAddr[index], isrState);
			success = false;
		}
	}

	//Clear Interrupt
	log << "\tClearing Interrupt...\n";
	if (success)
	{
		intc.mExtInt.Write(0);
		intc.CycleHostClock();
		intc.SendIack();

		if (intc.mStatus.Read())
		{
			log << "\tFailure - IRQ failed to be cleared\n";
			success = false;
		}
	}

	return success;
}

//Test case to validate an interrupt on source 0
bool IntcTestCases::TestIrq_SingleSource0(IntcAxiIf& intc, std::ostream& log)
{
	return TestSingleSource(intc, log, 0);
}

//Test case to validate an interrupt on source 1
bool IntcTestCases::TestIrq_SingleSource1(IntcAxiIf& intc, std::ostream& log)
{
	return TestSingleSource(intc, log, 1);
}

//Test case to validate an interrupt on source 2
bool IntcTestCases::TestIrq_SingleSource2(IntcAxiIf& intc, std::ostream& log)
{
	return TestSingleSource(intc, log, 2);
}

//Test case to validate an interrupt on source 3
bool IntcTestCases::TestIrq_SingleSource3(IntcAxiIf& intc, std::ostream& log)
{
	return TestSingleSource(intc, log, 3);
}

//Helper funtion to test simultaneous interrupts. Each bit in the given mask represents an interrupt
bool TestSimultaneous(IntcAxiIf& intc, std::ostream& log, uint32_t mask)
{
	uint32_t intMask(mask);
	bool success(true);
	intc.Reset(false);
	if (intc.mStatus.Read())
	{
		log << "\tUncleared interrupt after reset!\n";
		success = false;
	}

	//Set the ISR Table
	log << "\tLoading ISR Table...\n";
	uint32_t isrAddr[] = { 0x00001111,0x00002222,0x00003333,0x00004444 };
	if (success)
	{
		for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
		{
			intc.WriteRegisterBank(ii, isrAddr[ii]);
		}
		if (intc.mStatus.Read())
		{
			log << "\tUnexpected interrupt after writing ISR table!\n";
			success = false;
		}
	}

	//Trigger interrupt
	log << "\tTriggering Simultaneous Interrupts...\n";
	if (success)
	{
		//Send the interrupt
		uint32_t intSigs(0);
		uint32_t intCount(0);
		for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
		{
			if (intMask & 0x1) 
			{
				intSigs |= EXTINT_DONE(ii);
				intCount++;
			}
			intMask = intMask >> 1;
		}
		printf("\t\tFinal IntSigs:0x%08x\n", intSigs);
		intc.mExtInt.Write(intSigs); 
		usleep(DUT_DELAY);
		intc.CycleHostClock();
		intc.mExtInt.Write(0); //Finish Ext Int pulse
		usleep(DUT_DELAY);
		intc.CycleHostClock();

		//Now check the IRQ and IRQ address signals
		uint32_t intServicing = intSigs >> 1; //hack
		for (uint32_t ii = 0; ii < intCount; ii++)
		{
			printf("\tExpected Interrupts to Service:0x%08x\n", intServicing);
			uint32_t irqState = intc.mStatus.Read();
			if (irqState == 0)
			{
				log << "\t\tFailure - no IRQ asserted cycle after external signal asserted\n";
				success = false;
			}
				
			uint32_t isrState = intc.mIsrAddr.Read();
			printf("\t\tRead IRQ-State:0x%08x ISR-ADDR:0x%08x\n", irqState,isrState);
			//We need to determine isr index, it should be the first bit not serviced
			uint32_t serviceIndex(0);
			for (; serviceIndex < INTC_INT_SOURCE_MAX; serviceIndex++)
			{
				if (intServicing & (0x1 << serviceIndex))
				{
					break;
				}
			}
			if (serviceIndex == INTC_INT_SOURCE_MAX)
			{
				log << "\t\tIntCount didn't match IntMask!\n";
				break;
			}
			intServicing ^= (0x1 << serviceIndex); //Disable for next pass
			printf("\t\tServicing Index:0x%08x\n", serviceIndex);
			if (isrState != isrAddr[serviceIndex])
			{
				log << "\t\tFailure - ISR Address is incorrect for given external signal\n";
				printf("\t\tExpAddr:0x%08x GotAddr:0x%08x\n", isrAddr[serviceIndex], isrState);
				success = false;
			}
			else
			{
				log << "\t\tClearing Interrupt:" << serviceIndex << "\n";
				//intc.mExtInt.Write(EXTINT_IACK);
				intc.SendIack();
			}
		}
	}
	return success;
}

//Test case to validate the handling and order of two simultaneous interrupts
bool IntcTestCases::TestIrq_Simultaneous2(IntcAxiIf& intc, std::ostream& log)
{
	return TestSimultaneous(intc, log, 0x6);
}

//Test case to validate the handling and order of three simultaneous interrupts
bool IntcTestCases::TestIrq_Simultaneous3(IntcAxiIf& intc, std::ostream& log)
{
	return TestSimultaneous(intc, log, 0xE);
}

//Test case to validate the handling and order of four simultaneous interrrupts
bool IntcTestCases::TestIrq_Simultaneous4(IntcAxiIf& intc, std::ostream& log)
{
	return TestSimultaneous(intc, log, 0xF);
}

//Test case to validate a higher priority interrupt taking higher order over an
//already asserted lower priority interrupt
bool IntcTestCases::TestIrq_MultipleHigherAfterLower(IntcAxiIf& intc, std::ostream& log)
{
	//Trigger a Low Priority Interrupt and afterwards a higher priority int.
	//Verify that Higher Priority Init is selected
	bool success(true);
	intc.Reset(false);
	if (intc.mStatus.Read())
	{
		log << "\tUncleared interrupt after reset!\n";
		success = false;
	}

	//Set the ISR Table
	log << "\tLoading ISR Table...\n";
	uint32_t isrAddr[] = { 0x00001111,0x00002222,0x00003333,0x00004444 };
	if (success)
	{
		for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
		{
			intc.WriteRegisterBank(ii, isrAddr[ii]);
		}
		if (intc.mStatus.Read())
		{
			log << "\tUnexpected interrupt after writing ISR table!\n";
			success = false;
		}
	}

	//Trigger int
	log << "\tTriggering Interrupts...\n";
	if (success)
	{
		uint32_t irqIndexLow(2);
		log << "\t\tSetting HighPriority Int:" << irqIndexLow << "\n";
		intc.WriteDone(irqIndexLow);
		intc.CycleHostClock();

		//Now check the IRQ and IRQ address signals
		uint32_t irqState = intc.mStatus.Read();
		if (irqState == 0)
		{
			log << "\tFailure - no IRQ asserted cycle after external signal asserted\n";
			success = false;
		}
		uint32_t isrState = intc.mIsrAddr.Read();
		printf("\t\tRead IRQ-State:0x%08x ISR-ADDR:0x%08x\n", irqState, isrState);
		if (isrState != isrAddr[irqIndexLow])
		{
			log << "\tFailure - ISR Address is incorrect for given external signal\n";
			printf("\tExpAddr:0x%08x GotAddr:0x%08x\n", isrAddr[irqIndexLow], isrState);
			success = false;
		}

		intc.CycleHostClock();
		uint32_t irqIndexHi(0);
		log << "\t\tSetting Higher Priority Int:" << irqIndexHi << "\n";
		intc.mExtInt.Write(EXTINT_DONE(irqIndexHi) | EXTINT_DONE(irqIndexLow));
		usleep(DUT_DELAY);
		intc.CycleHostClock();

		//Now check the IRQ and IRQ address signals
		irqState = intc.mStatus.Read();
		if (irqState == 0)
		{
			log << "\tFailure - no IRQ asserted cycle after external signal asserted\n";
			success = false;
		}
		isrState = intc.mIsrAddr.Read();
		printf("\t\tRead IRQ-State:0x%08x ISR-ADDR:0x%08x\n", irqState, isrState);
		if (isrState != isrAddr[irqIndexHi])
		{
			log << "\tFailure - ISR Address is incorrect for given external signal\n";
			printf("\tExpAddr:0x%08x GotAddr:0x%08x\n", isrAddr[irqIndexHi], isrState);
			success = false;
		}
	}

	log << "\tClearing Interrupts...\n";
	if (success)
	{
		intc.SendIack();
		uint32_t irqState = intc.mStatus.Read();
		uint32_t isrState = intc.mIsrAddr.Read();
		printf("\t\tRead IRQ-State:0x%08x ISR-ADDR:0x%08x\n", irqState, isrState);
		if (isrState != isrAddr[2])
		{
			log << "\tFailure - ISR Address is incorrect for given external signal\n";
			printf("\tExpAddr:0x%08x GotAddr:0x%08x\n", isrAddr[2], isrState);
			success = false;
		}

		intc.SendIack();
		irqState = intc.mStatus.Read();
		if (irqState != 0)
		{
			log << "\t\tFailure - failed to clear all IRQs!\n";
			success = false;
		}
	}

	return success;
}

//Test case to validate a low priority interrupt asserted after a higher priority int is already
//active, does not effect the ordering.
bool IntcTestCases::TestIrq_MultipleLowerAfterHigher(IntcAxiIf& intc, std::ostream& log)
{
	//Trigger a High Priority Interrupt and afterwards a lower priority int.
	//Verify that Higher Priority Init is held selected
	bool success(true);
	intc.Reset(false);
	if (intc.mStatus.Read())
	{
		log << "\tUncleared interrupt after reset!\n";
		success = false;
	}

	//Set the ISR Table
	log << "\tLoading ISR Table...\n";
	uint32_t isrAddr[] = { 0x00001111,0x00002222,0x00003333,0x00004444 };
	if (success)
	{
		for (uint32_t ii = 0; ii < INTC_INT_SOURCE_MAX; ii++)
		{
			intc.WriteRegisterBank(ii, isrAddr[ii]);
		}
		if (intc.mStatus.Read())
		{
			log << "\tUnexpected interrupt after writing ISR table!\n";
			success = false;
		}
	}

	//Trigger int
	log << "\tTriggering Interrupts...\n";
	if (success)
	{
		uint32_t irqIndex(1);
		log << "\t\tSetting HighPriority Int:" << irqIndex << "\n";
		intc.WriteDone(irqIndex);
		intc.CycleHostClock();

		//Now check the IRQ and IRQ address signals
		uint32_t irqState = intc.mStatus.Read();
		if (irqState == 0)
		{
			log << "\tFailure - no IRQ asserted cycle after external signal asserted\n";
			success = false;
		}
		uint32_t isrState = intc.mIsrAddr.Read();
		printf("\t\tRead IRQ-State:0x%08x ISR-ADDR:0x%08x\n", irqState, isrState);
		if (isrState != isrAddr[irqIndex])
		{
			log << "\tFailure - ISR Address is incorrect for given external signal\n";
			printf("\tExpAddr:0x%08x GotAddr:0x%08x\n", isrAddr[irqIndex], isrState);
			success = false;
		}

		intc.CycleHostClock();
		log << "\t\tSetting Lower Priority Int:" << 3 << "\n";
		intc.mExtInt.Write(EXTINT_DONE(1) | EXTINT_DONE(3));
		usleep(DUT_DELAY);
		intc.CycleHostClock();

		//Now check the IRQ and IRQ address signals
		irqState = intc.mStatus.Read();
		if (irqState == 0)
		{
			log << "\tFailure - no IRQ asserted cycle after external signal asserted\n";
			success = false;
		}
		isrState = intc.mIsrAddr.Read();
		printf("\t\tRead IRQ-State:0x%08x ISR-ADDR:0x%08x\n", irqState, isrState);
		if (isrState != isrAddr[irqIndex])
		{
			log << "\tFailure - ISR Address is incorrect for given external signal\n";
			printf("\tExpAddr:0x%08x GotAddr:0x%08x\n", isrAddr[irqIndex], isrState);
			success = false;
		}
	}

	log << "\tClearing Interrupts...\n";
	if (success)
	{
		intc.SendIack();
		uint32_t irqState = intc.mStatus.Read();
		uint32_t isrState = intc.mIsrAddr.Read();
		printf("\t\tRead IRQ-State:0x%08x ISR-ADDR:0x%08x\n", irqState, isrState);

		intc.SendIack();
		irqState = intc.mStatus.Read();
		if (irqState != 0)
		{
			log << "\t\tFailure - failed to clear all IRQs!\n";
			success = false;
		}
	}

	return success;
}
