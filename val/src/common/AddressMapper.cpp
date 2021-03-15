
#include "AddressMapper.hpp"
#include <sys/mman.h>
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>

namespace AddressMapper {

	#define MAP_SIZE 4096UL
    #define MAP_MASK (MAP_SIZE - 1)

	///@details Map the given phys addr to a virt addr
	///@param [in] physAddr
	///@param [out] virtAddr
	///@return bool Success
	bool GetVirtualAddr(uint32_t physAddr, void** virtAddr)
	{
		void* mapped_base;
		int memfd;

		void* mapped_dev_base;
		off_t dev_base = physAddr;

		memfd = open("/dev/mem", O_RDWR | O_SYNC); // to open this the program needs to be run as root
		if (memfd == -1) {
			printf("Can’t open /dev/mem.\n");
			return false;
		}

		// Map one page of memory into user space such that the device is in that page, but it may not
		// be at the start of the page

		mapped_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, memfd, dev_base & ~MAP_MASK);
		if (mapped_base == (void*)-1) {
			printf("Can’t map the memory to user space.\n");
			return false;
		}

		// get the address of the device in user space which will be an offset from the base
		// that was mapped as memory is mapped at the start of a page

		mapped_dev_base = mapped_base + (dev_base & MAP_MASK);
		*virtAddr = mapped_dev_base;

		return true;
    }


} //end namespace AddressMapper

