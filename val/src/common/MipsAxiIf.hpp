#ifndef MIPS_AXI_IF_HPP
#define MIPS_ACI_IF_HPP

#include "AxiIf.hpp"

class MipsAxiIf : public AxiIf {
public:
	MipsAxiIf(uint32_t physAddr);

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
