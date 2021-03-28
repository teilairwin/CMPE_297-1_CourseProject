
#include "TestFramework.hpp"
#include "SocDutIf.hpp"
#include "Constants.hpp"
#include "SocTestCases.hpp"

SocDutIf::SocDutIf()
	: DutIf()
	, mAxiIf(AXI_DUT_BASE_ADDR)
{
	
}

SocDutIf::~SocDutIf()
{

}

bool SocDutIf::RunTests()
{
	bool success(true);
	for (uint32_t ii = 0; ii < SocTestCases::TC_MAX; ii++)
	{
		TestFramework::mLogger << "------------------------------------------------\n";
		TestFramework::mLogger << "Starting TC:" << SocTestCases::TestSet[ii].nm << "\n";
		//bool testResult = (*mTestSet[ii].tc)(mAxiIf, TestFramework::mLogger);
		bool testResult = (*SocTestCases::TestSet[ii].tc)(mAxiIf, TestFramework::mLogger);
		if (testResult)
		{
			mPassCount++;
		}
		else
		{
			mErrorCount++;
			success = false;
		}
		TestFramework::mLogger << "Finished TC:" << SocTestCases::TestSet[ii].nm << "\n";
		TestFramework::mLogger << "------------------------------------------------\n";
	}
	return success;
}


