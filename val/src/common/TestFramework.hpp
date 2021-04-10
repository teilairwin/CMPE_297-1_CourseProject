
#ifndef TEST_FRAMEWORK_H
#define TEST_FRAMEWORK_H

#include <string>
#include <fstream>
#include <ostream>

//DUT test target
enum TestTarget {
	TARGET_INTC,
	TARGET_SOC
};

class DutIf;

class TestFramework {
public:
	TestFramework(std::string targetStr, TestTarget target);

	//Run the test set for the given target
	bool Go();
    //Initialize logging
	bool InitLogging();
	//Create DUT interface
	bool CreateDutInterface();


	std::string mTargetName;   ///< Name of the target DUT
	TestTarget mTarget;        ///< Enum of the target DUT
	DutIf* mDut;               ///< DUT interface handle

	static std::ostream& mLogger; ///< logger for report
};


#endif
