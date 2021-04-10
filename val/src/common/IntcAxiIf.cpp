
#include "IntcAxiIf.hpp"
#include "Constants.hpp"

#include <unistd.h>

IntcAxiIf::IntcAxiIf(uint32_t physAddr)
	: AxiIf(physAddr)
	, mExtInt(       (uint32_t*)mVirtBaseAddr + AXI_INTC_EXTINT_OFFSET)
	, mRegAddr(      (uint32_t*)mVirtBaseAddr + AXI_INTC_REGADDR_OFFSET)
	, mRegWriteData( (uint32_t*)mVirtBaseAddr + AXI_INTC_REGWDATA_OFFSET)
	, mRegCtrl(      (uint32_t*)mVirtBaseAddr + AXI_INTC_REGCTRL_OFFSET)
	, mCtrl(         (uint32_t*)mVirtBaseAddr + AXI_INTC_ICTRL_OFFSET)
	, mStatus(       (uint32_t*)mVirtBaseAddr + AXI_INTC_ISTATUS_OFFSET)
	, mIsrAddr(      (uint32_t*)mVirtBaseAddr + AXI_INTC_ISRADDR_OFFSET)
	, mRegReadData(  (uint32_t*)mVirtBaseAddr + AXI_INTC_REGRDATA_OFFSET)
{
}

///@details Reset the INTC and either restore the onboard clock or leave
/// the host clock selected
void IntcAxiIf::Reset(bool restoreClock)
{
	mCtrl.Write(ICTRL_RESET | ICTRL_CLK_SELECT);
	usleep(DUT_DELAY);
	CycleHostClock();
	if (restoreClock)
	{
		mCtrl.Write(0);
	}
	else
	{
		mCtrl.WriteToggle(ICTRL_RESET);
	}
}

///@details Cycle the host clock one cycle
void IntcAxiIf::CycleHostClock()
{
	mCtrl.WriteToggle(ICTRL_CLK_HOST);
	usleep(DUT_DELAY);
	mCtrl.WriteToggle(ICTRL_CLK_HOST);
	usleep(DUT_DELAY);
}

///@details Read the register of the given index in the register bank
uint32_t IntcAxiIf::ReadRegisterBank(uint32_t index)
{
	uint32_t data(0);

	//Select the register
	mRegAddr.Write(index << 2);
	usleep(DUT_DELAY);
	//Read it
	data = mRegReadData.Read();

	return data;
}

///@details Write the register of the given index in the register bank
void IntcAxiIf::WriteRegisterBank(uint32_t index, uint32_t value)
{
	//Set the address & data
	mRegAddr.Write(index << 2);
	mRegWriteData.Write(value);
	usleep(DUT_DELAY);
	//Set WE
	mRegCtrl.Write(REGCTRL_WE);
	usleep(DUT_DELAY);

	CycleHostClock();
	mRegCtrl.Write(0);
	usleep(DUT_DELAY);
}

///@details Write the interrupt signal that corresponds to the given index
void IntcAxiIf::WriteDone(uint32_t index)
{
	mExtInt.WriteSet(EXTINT_DONE(index));
	usleep(DUT_DELAY);
}

///@details Send an iack to the INTC to clear the highest priority interrupt
void IntcAxiIf::SendIack()
{
	mExtInt.Write(EXTINT_IACK);
	CycleHostClock();
	mExtInt.Write(0);
	CycleHostClock();
}
