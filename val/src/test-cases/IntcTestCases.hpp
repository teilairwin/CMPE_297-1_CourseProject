
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
		std::string nm;                   ///< Test Case Name
		IntcTestCases::IntcTestCase* tc;  ///< Test Case FuncPtr
	} IntcTestInfo;

	//Test IDs
	enum Name {
		TC_INTC_ISR_ReadWrite = 0,
		TC_INTC_IRQ_SingleSource0,
		TC_INTC_IRQ_SingleSource1,
		TC_INTC_IRQ_SingleSource2,
		TC_INTC_IRQ_SingleSource3,
		TC_INTC_IRQ_Simultaneous2,
		TC_INTC_IRQ_Simultaneous3,
		TC_INTC_IRQ_Simultaneous4,
		TC_INTC_IRQ_MultipleHigherAfterLower,
		TC_INTC_IRQ_MultipleLowerAfterHigher,
		TC_MAX
	};

	//////////////////////////////////////////////////////////////////////////
	/// TEST CASES
	//////////////////////////////////////////////////////////////////////////
	IntcTestCase TestIsr_ReadWrite;
	IntcTestCase TestIrq_SingleSource0;
	IntcTestCase TestIrq_SingleSource1;
	IntcTestCase TestIrq_SingleSource2;
	IntcTestCase TestIrq_SingleSource3;
	IntcTestCase TestIrq_Simultaneous2;
	IntcTestCase TestIrq_Simultaneous3;
	IntcTestCase TestIrq_Simultaneous4;
	IntcTestCase TestIrq_MultipleHigherAfterLower;
	IntcTestCase TestIrq_MultipleLowerAfterHigher;


	//Test Case Table
	static const IntcTestInfo TestSet[TC_MAX] = {
		{TC_STR(TC_INTC_ISR_ReadWrite), &TestIsr_ReadWrite },
		{TC_STR(TC_INTC_IRQ_SingleSource0), &TestIrq_SingleSource0},
		{TC_STR(TC_INTC_IRQ_SingleSource1), &TestIrq_SingleSource1},
		{TC_STR(TC_INTC_IRQ_SingleSource2), &TestIrq_SingleSource2},
		{TC_STR(TC_INTC_IRQ_SingleSource3), &TestIrq_SingleSource3},
		{TC_STR(TC_INTC_IRQ_Simultaneous2), &TestIrq_Simultaneous2},
		{TC_STR(TC_INTC_IRQ_Simultaneous3), &TestIrq_Simultaneous3},
		{TC_STR(TC_INTC_IRQ_Simultaneous4), &TestIrq_Simultaneous4},
		{TC_STR(TC_INTC_IRQ_MultipleHigherAfterLower), &TestIrq_MultipleHigherAfterLower},
		{TC_STR(TC_INTC_IRQ_MultipleLowerAfterHigher), &TestIrq_MultipleLowerAfterHigher},
	};

}

#endif
