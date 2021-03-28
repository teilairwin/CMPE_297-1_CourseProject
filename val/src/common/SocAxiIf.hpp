#ifndef SOC_AXI_IF_HPP
#define SOC_ACI_IF_HPP

#include "AxiIf.hpp"

class SocAxiIf : public AxiIf {
public:
	SocAxiIf(uint32_t physAddr);

	uint32_t ReadRegisterFile(uint32_t reg);

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
