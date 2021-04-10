#ifndef ROM_LOADER_HPP
#define ROM_LOADER_HPP

#include <string>
#include <stdint.h>
#include <vector>

class SocAxiIf;

class RomLoader {
public:
	///@brief Constructor
	RomLoader(SocAxiIf* axi, uint32_t mem);

	///@brief Load the binary file into ROM
	bool LoadBin(const std::string& binFile);
	///@brief Verify the ROM contents against local copy
	bool VerifyRom();

	SocAxiIf* mAxi;              ///< SOC I/F
	std::vector<uint32_t> mRom;  ///< ROM Local Copy
	uint32_t mSel;               ///< ROM Select

private:
	RomLoader();
};

#endif
