#ifndef SOC_AXI_IF_HPP
#define SOC_ACI_IF_HPP

#include "AxiIf.hpp"
#include <string>

class SocAxiIf : public AxiIf {
public:
	SocAxiIf(uint32_t physAddr);

	uint32_t ReadRegisterFile(uint32_t reg);
	bool LoadRom(std::string& bin, uint32_t mem);
	void Reset();
	void CycleHostClock();

	//Inputs
	AxiReg mSysCtrl;  
	AxiReg mMipsRfCtrl;
	AxiReg mRomCtrl;
	AxiReg mRomWriteData;
	AxiReg mResv0;
	//Outputs
	AxiReg mMipsPc;
	AxiReg mRomReadData;
	AxiReg mMipsRfData;
};

#endif
