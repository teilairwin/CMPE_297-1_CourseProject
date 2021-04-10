#ifndef INTC_AXI_IF_HPP
#define INTC_ACI_IF_HPP

#include "AxiIf.hpp"

class IntcAxiIf : public AxiIf {
public:
	IntcAxiIf(uint32_t physAddr);

	///@brief Reset the INTC
	void Reset(bool restoreClock = true);
	///@brief Cycle the host cycle
	void CycleHostClock();
	///@brief Read a register from the INTC register bank
	uint32_t ReadRegisterBank(uint32_t index);
	///@brief Write a register in the INTC register bank
	void WriteRegisterBank(uint32_t index, uint32_t value);
	///@brief Write the done signal of the given index
	void WriteDone(uint32_t index);
	///@brief Send an IACK to clear an interrupt
	void SendIack();

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
