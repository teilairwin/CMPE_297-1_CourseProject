
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
		std::string nm;
		SocTestCases::SocTestCase* tc;
	} SocTestInfo;

	//Test IDs
	enum Name {
		TC_SOC_ROM_LoadPmem = 0,
		TC_SOC_ROM_LoadPmemEmem,
		TC_MAX
	};

	//////////////////////////////////////////////////////////////////////////
	/// TEST CASES
	//////////////////////////////////////////////////////////////////////////
	//Base Functionality
	SocTestCase TestRom_LoadPmem;
	SocTestCase TestRom_LoadPmemEmem;

	//Context Switching


	//Test Case Table
	static const SocTestInfo TestSet[TC_MAX] = {
		{TC_STR(TC_SOC_ROM_LoadPmem), &TestRom_LoadPmem },
		{TC_STR(TC_SOC_ROM_LoadPmemEmem), &TestRom_LoadPmemEmem }
	};

}

#endif
