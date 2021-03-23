
#include "MipsAxiIf.hpp"
#include "Constants.hpp"

MipsAxiIf::MipsAxiIf(uint32_t physAddr)
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
