#ifndef DUT_IF_H
#define DUT_IF_H



class DutIf {
public:
	DutIf();
	virtual ~DutIf();

	virtual bool RunTests() = 0;

	int mErrorCount;    ///< Number of test errors
	int mPassCount;     ///< Number of tests passed
};

#endif
