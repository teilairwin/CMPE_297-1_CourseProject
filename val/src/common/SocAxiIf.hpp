#ifndef SOC_AXI_IF_HPP
#define SOC_ACI_IF_HPP

#include "AxiIf.hpp"
#include <string>

class SocAxiIf : public AxiIf {
public:
	SocAxiIf(uint32_t physAddr);

	///@brief Read the given register from the MIPS register file
	uint32_t ReadRegisterFile(uint32_t reg);
	///@brief Load the given binary into the selected ROM
	bool LoadRom(std::string& bin, uint32_t mem);
	///@brief Perform a reset
	void Reset();
	///@brief Cycle the host clock
	void CycleHostClock();

	//Inputs
	AxiReg mSysCtrl;  
	AxiReg mMipsRfCtrl;
	AxiReg mRomCtrl;
	AxiReg mRomWriteData;
	AxiReg mTestCtrl;
	//Outputs
	AxiReg mMipsPc;
	AxiReg mRomReadData;
	AxiReg mMipsRfData;
};

#endif
