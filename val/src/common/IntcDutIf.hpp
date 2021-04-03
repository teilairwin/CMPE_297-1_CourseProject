#ifndef INTC_DUT_IF_H
#define INTC_DUT_IF_H

#include "DutIf.hpp"
#include "IntcAxiIf.hpp"

class IntcDutIf : public DutIf {
public:
	IntcDutIf();
	virtual ~IntcDutIf();

	bool RunTests();

	IntcAxiIf mAxiIf;
};


#endif
