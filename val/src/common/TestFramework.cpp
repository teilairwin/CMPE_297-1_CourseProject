
#include "TestFramework.hpp"
#include "SocDutIf.hpp"
#include "IntcDutIf.hpp"
#include <iostream>

//std::ofstream TestFramework::mLogger;
std::ostream& TestFramework::mLogger = std::cout;

TestFramework::TestFramework(std::string targetStr,TestTarget target)
	: mTargetName(targetStr), mTarget(target)
{

}

bool TestFramework::InitLogging()
{
	bool status(true);
	/*std::string filename = "/home/root/val_log_" + mTargetName;
	mLogger.open(filename, std::ios::out | std::ios::trunc);
	if (!mLogger.is_open())
	{
		printf("Error: failed to open report file '%s'\n", filename.c_str());
		status = false;
	}*/
	return status;
}

bool TestFramework::CreateDutInterface()
{
	bool status(true);
	mLogger << "================================================\n";
	if (mTarget == TARGET_INTC)
	{
		mDut = new IntcDutIf();
		mLogger << "Running Validation for DUT: INTC\n";
	}
	else if (mTarget == TARGET_SOC)
	{
		mDut = new SocDutIf();
		mLogger << "Running Validation for DUT: SoC\n";
	}
	else
	{
		printf("Error: unknown DUT target\n");
		status = false;
	}
	mLogger << "================================================\n";
	return status;
}

bool TestFramework::Go()
{
	bool status(true);
	//Init Report Logging
	status = InitLogging();
	//Init DUT I/F
	if (status)
	{
		status = CreateDutInterface();
	}

	//Run Tests
	if (status)
	{
		status = mDut->RunTests();
		mLogger << "================================================\n";
		mLogger << "Validation Tests " << (status ? "Passed" : "Failed") << "!\n";
		mLogger << "\tTotal Passed: " << mDut->mPassCount << "\n";
		mLogger << "\tTotal Failed: " << mDut->mErrorCount << "\n";
		mLogger << "================================================\n";
	}
	
	return status;
}

