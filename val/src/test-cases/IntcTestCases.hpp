
#ifndef INTC_TEST_CASES_H
#define INTC_TEST_CASES_H

#define TC_STR(X) #X
#include <fstream>

class IntcAxiIf;

namespace IntcTestCases {
	//TestCase Function Typedef
	typedef bool IntcTestCase(IntcAxiIf&, std::ostream&);
	//TestCaseInfo Struct
	typedef struct {
		std::string nm;
		IntcTestCases::IntcTestCase* tc;
	} IntcTestInfo;

	//Test IDs
	enum Name {
		TC_INTC_ISR_ReadWrite = 0,
		TC_MAX
	};

	//////////////////////////////////////////////////////////////////////////
	/// TEST CASES
	//////////////////////////////////////////////////////////////////////////
	//Base Functionality
	IntcTestCase TestIsr_ReadWrite;



	//Test Case Table
	static const IntcTestInfo TestSet[TC_MAX] = {
		{TC_STR(TC_INTC_ISR_ReadWrite), &TestIsr_ReadWrite }
		
	};

}

#endif
