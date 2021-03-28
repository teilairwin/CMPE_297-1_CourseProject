
#ifndef TEST_FRAMEWORK_H
#define TEST_FRAMEWORK_H

#include <string>
#include <fstream>
#include <ostream>

enum TestTarget {
	TARGET_INTC,
	TARGET_SOC
};

class DutIf;

class TestFramework {
public:
	TestFramework(std::string targetStr, TestTarget target);

	bool Go();

	bool InitLogging();
	bool CreateDutInterface();


	std::string mTargetName;
	TestTarget mTarget;
	DutIf* mDut;

	static std::ostream& mLogger;
};


#endif
