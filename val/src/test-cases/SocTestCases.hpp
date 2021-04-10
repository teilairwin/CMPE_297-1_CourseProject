
#ifndef SOC_TEST_CASES_H
#define SOC_TEST_CASES_H

#define TC_STR(X) #X
#include <fstream>

class SocAxiIf;

namespace SocTestCases {
	//TestCase Function Typedef
	typedef bool SocTestCase(SocAxiIf&, std::ostream&);
	//TestCaseInfo Struct
	typedef struct {
		std::string nm;                 ///< Test case name
		SocTestCases::SocTestCase* tc;  ///< Test case funcPtr
	} SocTestInfo;

	//Test IDs
	enum Name {
		TC_SOC_ROM_LoadPmem = 0,
		TC_SOC_ROM_LoadPmemEmem,
		TC_SOC_MIPS_RegisterFile,
		TC_SOC_MIPS_DmemReadWrite,
		TC_SOC_FACT_Fact0,
		TC_SOC_FACT_Fact1,
		TC_SOC_FACT_Fact2,
		TC_SOC_FACT_Fact3,
		TC_SOC_ISR_Reconfigure,
		TC_SOC_ISR_Simultaneous,
		TC_SOC_ISR_Multiple,
		TC_MAX
	};

	//////////////////////////////////////////////////////////////////////////
	/// TEST CASES
	//////////////////////////////////////////////////////////////////////////
	//Base Functionality
	SocTestCase TestRom_LoadPmem;
	SocTestCase TestRom_LoadPmemEmem;
	SocTestCase TestMips_RegisterFile;
	SocTestCase TestMips_DmemReadWrite;
	//Context Switching
	SocTestCase TestSoc_Fact0;
	SocTestCase TestSoc_Fact1;
	SocTestCase TestSoc_Fact2;
	SocTestCase TestSoc_Fact3;
	SocTestCase TestSoc_IsrReconfigure;
	SocTestCase TestSoc_IsrSimultaneous;
	SocTestCase TestSoc_IsrMultiple;

	//Test Case Table
	static const SocTestInfo TestSet[TC_MAX] = {
		{TC_STR(TC_SOC_ROM_LoadPmem), &TestRom_LoadPmem },
		{TC_STR(TC_SOC_ROM_LoadPmemEmem), &TestRom_LoadPmemEmem },
		{TC_STR(TC_SOC_MIPS_RegisterFile), &TestMips_RegisterFile },
		{TC_STR(TC_SOC_MIPS_DmemReadWrite), &TestMips_DmemReadWrite },
		{TC_STR(TC_SOC_FACT_Fact0), &TestSoc_Fact0},
		{TC_STR(TC_SOC_FACT_Fact1), &TestSoc_Fact1},
		{TC_STR(TC_SOC_FACT_Fact2), &TestSoc_Fact2},
		{TC_STR(TC_SOC_FACT_Fact3), &TestSoc_Fact3},
		{TC_STR(TC_SOC_ISR_Reconfigure), &TestSoc_IsrReconfigure},
		{TC_STR(TC_SOC_ISR_Simultaneous), &TestSoc_IsrSimultaneous},
		{TC_STR(TC_SOC_ISR_Multiple), &TestSoc_IsrMultiple},
	};

}

#endif
