
#include "TestFramework.hpp"
#include "IntcDutIf.hpp"
#include "Constants.hpp"
#include "IntcTestCases.hpp"

IntcDutIf::IntcDutIf()
	: DutIf()
	, mAxiIf(AXI_DUT_BASE_ADDR)
{
	
}

IntcDutIf::~IntcDutIf()
{

}

bool IntcDutIf::RunTests()
{
	bool success(true);
	for (uint32_t ii = 0; ii < IntcTestCases::TC_MAX; ii++)
	{
		TestFramework::mLogger << "------------------------------------------------\n";
		TestFramework::mLogger << "Starting TC:" << IntcTestCases::TestSet[ii].nm << "\n";
		bool testResult = (*IntcTestCases::TestSet[ii].tc)(mAxiIf, TestFramework::mLogger);
		if (testResult)
		{
			mPassCount++;
		}
		else
		{
			mErrorCount++;
			success = false;
		}
		TestFramework::mLogger << "Finished TC:" << IntcTestCases::TestSet[ii].nm << "\n";
		TestFramework::mLogger << "------------------------------------------------\n";
	}
	return success;
}


