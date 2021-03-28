
#include "SocAxiIf.hpp"
#include "Constants.hpp"

#include <unistd.h>

SocAxiIf::SocAxiIf(uint32_t physAddr)
	: AxiIf(physAddr)
	, mSysCtrl(      (uint32_t*)mVirtBaseAddr + AXI_SOC_SYSCTRL_OFFSET)
	, mMipsRfCtrl(   (uint32_t*)mVirtBaseAddr + AXI_SOC_MIPSRFCTRL_OFFSET)
	, mRomCtrl(      (uint32_t*)mVirtBaseAddr + AXI_SOC_ROMCTRL_OFFSET)
	, mRomWriteData( (uint32_t*)mVirtBaseAddr + AXI_SOC_ROMWRITEDATA_OFFSET)
	, mResv0(        (uint32_t*)mVirtBaseAddr + AXI_SOC_RESV0_OFFSET)
	, mMipsPc(       (uint32_t*)mVirtBaseAddr + AXI_SOC_MIPSPC_OFFSET)
	, mRomReadData(  (uint32_t*)mVirtBaseAddr + AXI_SOC_ROMREADDATA_OFFSET)
	, mMipsRfData(   (uint32_t*)mVirtBaseAddr + AXI_SOC_MIPSRFDATA_OFFSET)
{
}

uint32_t SocAxiIf::ReadRegisterFile(uint32_t reg)
{
	uint32_t data(0);

	//Select the register
	mMipsRfCtrl.Write(MIPSRFCTRL_ADDR(reg));
	usleep(DUT_DELAY);
	//Read it
	data = mMipsRfData.Read();

	return data;
}

