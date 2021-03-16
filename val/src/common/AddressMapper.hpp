
#ifndef ADDRESS_MAPPER_HPP
#define ADDRESS_MAPPER_HPP

#include <stdint.h>

namespace AddressMapper {

	bool GetVirtualAddr(uint32_t physAddr, void** virtAddr);
}

#endif
