#include "RomLoader.hpp"
#include "SocAxiIf.hpp"
#include "Constants.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <iostream>
#include <fstream>


//////////////////////////////////////////////////////////////////////////////
///@param axi Soc Mips Interface ptr
///@param mem ROM Select (PMEM or EMEM)
//////////////////////////////////////////////////////////////////////////////
RomLoader::RomLoader(SocAxiIf* axi,uint32_t mem)
	:mAxi(axi)
	,mRom(SOC_ROM_SIZE,0)
	,mSel(mem)
{
}

bool RomLoader::LoadBin(const std::string& binFile)
{
	bool good(true);
	std::ifstream reader(binFile.c_str(), std::ios::binary);
	if (!reader)
	{
		printf("ERROR: Failed to open file '%s'\n",binFile.c_str());
		good = false;
	}
	if (!(mAxi->mSysCtrl.Read() & SYSCTRL_RESET))
	{
		printf("ERROR: Target system must be in reset before loading ROM!\n");
		good = false;
	}
	if (good)
	{
		printf("\tReading bin file: '%s'\n",binFile.c_str());
		uint32_t buff;
		uint32_t index(0);
		while (reader.read((char*)&buff, 4))
		{
			if (index == SOC_ROM_SIZE)
			{
				printf("ERROR: The program file is too big to fit into ROM!\n");
				good = false;
				break;
			}
			//printf("\t0x%08x\n", buff);
			mRom[index] = buff;
			index++;
		}
	}
	if (good)
	{
		printf("\tLoading ROM[%02d]...\n",mSel);

		for (uint32_t ii = 0; ii < SOC_ROM_SIZE; ii++)
		{
			//Set ROM - WE & ADDR & SEL
			mAxi->mRomCtrl.Write(ROMCTRL_WE | ROMCTRL_ADDR(ii) | ROMCTRL_SELECT(mSel));
			//Set ROM W Data
			mAxi->mRomWriteData.Write(mRom[ii]);

			//Clock in the Data
			mAxi->mSysCtrl.WriteToggle(SYSCTRL_CLK_HOST);
			usleep(DUT_DELAY);
			mAxi->mSysCtrl.WriteToggle(SYSCTRL_CLK_HOST);
			usleep(DUT_DELAY);
		}

		//Disable the ROM Ctrl WE
		mAxi->mRomCtrl.Write(0);

		//printf("Finished Loading ROM\n");
	}
	return good;
}

bool RomLoader::VerifyRom()
{
	bool good(true);
	printf("\tVerifying ROM[%02d]...\n",mSel);
	for (uint32_t ii = 0; ii < mRom.size(); ii++)
	{
		//Set ROM Ctrl
		mAxi->mRomCtrl.Write(ROMCTRL_ADDR(ii) | ROMCTRL_SELECT(mSel));
		usleep(DUT_DELAY);

		//Read Rom Data
		uint32_t expRom = mRom[ii];
		uint32_t gotRom = mAxi->mRomReadData.Read();
		if (expRom != gotRom)
		{
			good = false;
			printf("\tROM[%d][%02d] Exp:0x%08x Real:0x%08x\n", mSel, ii, expRom, gotRom);
			printf("\tERROR: ROM loaded incorrectly!\n");
			break;
		}
	}
	//printf("Finished Verifying ROM\n");
	return good;
}
