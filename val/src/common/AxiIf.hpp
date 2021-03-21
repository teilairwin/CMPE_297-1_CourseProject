#ifndef AXI_IF_HPP
#define AXI_IF_HPP

#include <stdint.h>

class AxiReg {
public:
	///@brief Constructor
	AxiReg(uint32_t* addr);

	///@brief Read the register
	uint32_t Read();
	///@brief Write data to the register
	void Write(uint32_t data);
	///@brief Toggle the data bits in the last write
	void WriteToggle(uint32_t data);

	uint32_t* mVirtAddr;   ///< Address of the Register
	uint32_t mLastWrite;   ///< Value of the last write
};

class AxiIf {
public:
	///@brief Constructor
	AxiIf(uint32_t physAddr);

	uint32_t mPhysBaseAddr;  ///< Physical Address
	void* mVirtBaseAddr;     ///< Base virtual address

private:
	AxiIf();
};

#endif
