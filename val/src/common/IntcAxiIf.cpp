
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

void IntcAxiIf::Reset()
{
	mCtrl.Write(ICTRL_RESET | ICTRL_CLK_SELECT);
	usleep(DUT_DELAY);
	CycleHostClock();
	mCtrl.Write(0);
}

void IntcAxiIf::CycleHostClock()
{
	mCtrl.WriteToggle(ICTRL_CLK_HOST);
	usleep(DUT_DELAY);
	mCtrl.WriteToggle(ICTRL_CLK_HOST);
	usleep(DUT_DELAY);
}
