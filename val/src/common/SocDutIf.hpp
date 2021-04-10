#ifndef SOC_DUT_IF_H
#define SOC_DUT_IF_H

#include "DutIf.hpp"
#include "SocAxiIf.hpp"

class SocDutIf : public DutIf {
public:
	SocDutIf();
	virtual ~SocDutIf();

	bool RunTests();

	SocAxiIf mAxiIf;  //< AXI interface for the SoC DUT
};


#endif
