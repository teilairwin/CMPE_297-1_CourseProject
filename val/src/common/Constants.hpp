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

//MIPS Register File
enum {
	MIPSRF_ZERO = 0,
	MIPSRF_AT,
	MIPSRF_V0,MIPSRF_V1,
	MIPSRF_A0,MIPSRF_A1,MIPSRF_A2,MIPSRF_A3,
	MIPSRF_T0,MIPSRF_T1,MIPSRF_T2,MIPSRF_T3,MIPSRF_T4,MIPSRF_T5,MIPSRF_T6,MIPSRF_T7,
	MIPSRF_S0,MIPSRF_S1,MIPSRF_S2,MIPSRF_S3,MIPSRF_S4,MIPSRF_S5,MIPSRF_S6,MIPSRF_S7,
	MIPSRF_T8,MIPSRF_T9,
	MIPSRF_K0,MIPSRF_K1,
	MIPSRF_GP,
	MIPSRF_SP,
	MIPSRF_FP,
	MIPSRF_RA
};


#endif 
