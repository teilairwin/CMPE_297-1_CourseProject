
#include "AxiIf.hpp"
#include "AddressMapper.hpp"

#include <stdio.h>
#include <stdlib.h>

AxiReg::AxiReg(uint32_t* virtAddr)
	: mVirtAddr(virtAddr)
	, mLastWrite(0)
{
}

uint32_t AxiReg::Read()
{
	return *mVirtAddr;
}

void AxiReg::Write(uint32_t data)
{
	mLastWrite = data;
	*mVirtAddr = data;
}
void AxiReg::WriteToggle(uint32_t data)
{
	mLastWrite ^= data;
	*mVirtAddr = mLastWrite;
}
void AxiReg::WriteSet(uint32_t data)
{
	mLastWrite |= data;
	*mVirtAddr = mLastWrite;
}


AxiIf::AxiIf(uint32_t physAddr)
	: mPhysBaseAddr(physAddr)
	, mVirtBaseAddr(0)
{
	if (!AddressMapper::GetVirtualAddr(mPhysBaseAddr, &mVirtBaseAddr))
	{
		printf("Failed to Map DUT!\n");
		exit(1); //probably shoudl do this somewhere else...
	}
}

