
#include "common/TestFramework.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <string>

//Entry point for DUT validation

void Usage()
{
	printf("Invalid Arguments\n\tUsage: ./validate <intc|soc>\n");
}

int main(int argc, char** argv)
{
	TestTarget target;

	if (argc != 2)
	{
		Usage();
		exit(1);
	}
	std::string targetStr(argv[1]);
	if (targetStr.compare("intc") == 0)
	{
		target = TARGET_INTC;
	}
	else if (targetStr.compare("soc") == 0)
	{
		target = TARGET_SOC;
	}
	else
	{
		Usage();
		exit(1);
	}

	TestFramework tester(targetStr,target);

	if (!tester.Go())
	{
		exit(1);
	}

	return 0;
}

