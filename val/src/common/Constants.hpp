#ifndef CONSTANTS_HPP
#define CONSTANTS_HPP

///@details The base address on the host system for the AXI interface to the SOC
#define AXI_DUT_BASE_ADDR 0x43C00000

//TODO - necessary?
#define DUT_DELAY  2000

//////////////////////////////////////////////////////////////////////////////
/// INTC DUT
//////////////////////////////////////////////////////////////////////////////

//TODO

//////////////////////////////////////////////////////////////////////////////
/// SoC DUT
//////////////////////////////////////////////////////////////////////////////

//AXI IF Register Offsets
#define AXI_SOC_SYSCTRL_OFFSET    0
#define AXI_SOC_MIPSRFCTRL_OFFSET 1
#define AXI_SOC_ROMCTRL_OFFSET    2
#define AXI_SOC_ROMWRITEDATA_OFFSET  3
#define AXI_SOC_RESV0_OFFSET         4
#define AXI_SOC_MIPSPC_OFFSET        5
#define AXI_SOC_ROMREADDATA_OFFSET   6
#define AXI_SOC_MIPSRFDATA_OFFSET    7

//System Contants
#define SOC_ROM_SIZE  64
#define MIPS_REGFILE_SIZE 32

//REG-SysControl Bitfields
#define SYSCTRL_RESET  0x1
#define SYSCTRL_CLK_HOST   (0x1 << 1)
#define SYSCTRL_CLK_SELECT (0x1 << 2)

//REG-MipsRfCtrl Bitfields
#define MIPSRFCTRL_ADDR(X)  (X)

//REG-RomControl Bitfields
#define ROMCTRL_WE  0x1
#define ROMCTRL_ADDR(X)   (X << 1)
#define ROM_PMEM   0x0
#define ROM_EMEM   0x1
#define ROMCTRL_SELECT(X)  (X << 7)


#endif 
