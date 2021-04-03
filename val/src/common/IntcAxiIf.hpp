#ifndef INTC_AXI_IF_HPP
#define INTC_ACI_IF_HPP

#include "AxiIf.hpp"

class IntcAxiIf : public AxiIf {
public:
	IntcAxiIf(uint32_t physAddr);

	void Reset();
	void CycleHostClock();

	//Inputs
	AxiReg mExtInt;  
	AxiReg mRegAddr;
	AxiReg mRegWriteData;
	AxiReg mRegCtrl;
	AxiReg mCtrl;
	//Outputs
	AxiReg mStatus;
	AxiReg mIsrAddr;
	AxiReg mRegReadData;
};

#endif
