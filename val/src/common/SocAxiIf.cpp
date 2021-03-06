
#include "SocAxiIf.hpp"
#include "RomLoader.hpp"
#include "Constants.hpp"

#include <unistd.h>

SocAxiIf::SocAxiIf(uint32_t physAddr)
	: AxiIf(physAddr)
	, mSysCtrl(      (uint32_t*)mVirtBaseAddr + AXI_SOC_SYSCTRL_OFFSET)
	, mMipsRfCtrl(   (uint32_t*)mVirtBaseAddr + AXI_SOC_MIPSRFCTRL_OFFSET)
	, mRomCtrl(      (uint32_t*)mVirtBaseAddr + AXI_SOC_ROMCTRL_OFFSET)
	, mRomWriteData( (uint32_t*)mVirtBaseAddr + AXI_SOC_ROMWRITEDATA_OFFSET)
	, mTestCtrl(     (uint32_t*)mVirtBaseAddr + AXI_SOC_RESV0_OFFSET)
	, mMipsPc(       (uint32_t*)mVirtBaseAddr + AXI_SOC_MIPSPC_OFFSET)
	, mRomReadData(  (uint32_t*)mVirtBaseAddr + AXI_SOC_ROMREADDATA_OFFSET)
	, mMipsRfData(   (uint32_t*)mVirtBaseAddr + AXI_SOC_MIPSRFDATA_OFFSET)
{
}

///@details Read a register from the MIPS register file.
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

///@details Load the given binary file into the given ROM segment.
/// Additionally, verify that the ROM load was successful.
bool SocAxiIf::LoadRom(std::string& bin, uint32_t mem)
{
	bool success(true);
	RomLoader romLoader(this, mem);
	if (!romLoader.LoadBin(bin))
	{
		printf("\tERROR: Failed to load ROM[%02d]\n",mem);
		success = false;
	}
	else
	{
		if (!romLoader.VerifyRom())
		{
			printf("\tERROR: ROM[%02d] Verification Failed!\n",mem);
			success = false;
		}
	}
	return success;
}

///@details Reset the SoC and restore the system clock
void SocAxiIf::Reset()
{
	mSysCtrl.Write(SYSCTRL_RESET | SYSCTRL_CLK_SELECT);
	usleep(DUT_DELAY);
	CycleHostClock();
	mSysCtrl.Write(0);
}

///@details Cycle the host clock.
void SocAxiIf::CycleHostClock()
{
	mSysCtrl.WriteToggle(SYSCTRL_CLK_HOST);
	usleep(DUT_DELAY);
	mSysCtrl.WriteToggle(SYSCTRL_CLK_HOST);
	usleep(DUT_DELAY);
}
