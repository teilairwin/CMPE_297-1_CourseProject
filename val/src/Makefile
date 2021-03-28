
COMMON_SRC := common
COMMON_OBJ := common

COMMON_SRCS := $(wildcard $(COMMON_SRC)/*.cpp)
COMMON_OBJS := $(patsubst $(COMMON_SRC)/%.cpp, $(COMMON_OBJ)/%.o, $(COMMON_SRCS))
COMMON_LIB := libCommon.so

TESTCASE_SRC := test-cases
TESTCASE_OBJ := test-cases

TESTCASE_SRCS := $(wildcard $(TESTCASE_SRC)/*.cpp)
TESTCASE_OBJS := $(patsubst $(TESTCASE_SRC)/%.cpp, $(TESTCASE_OBJ)/%.o, $(TESTCASE_SRCS))
TESTCASE_LIB := libTestCase.so

ALL_LIB := $(COMMON_LIB) $(TESTCASE_LIB)
LIBS := -lCommon -lTestCase
PROGRAM := validate.bin

all: validate.bin

$(COMMON_OBJ)/%.o: $(COMMON_SRC)/%.cpp
	g++ -I$(COMMON_SRC) -I$(TESTCASE_SRC) -fPIC -Wno-pointer-arith -c $< -o $@

$(COMMON_LIB): $(COMMON_OBJS)
	g++ $^ -shared -o $@

$(TESTCASE_OBJ)/%.o: $(TESTCASE_SRC)/%.cpp
	g++ -I$(COMMON_SRC) -I$(TESTCASE_SRC) -fPIC -Wno-pointer-arith -c $< -o $@

$(TESTCASE_LIB): $(TESTCASE_OBJS)
	g++ $^ -shared -o $@

romTest: mainRomLoader.cpp $(COMMON_LIB) $(TESTCASE_LIB)
	g++ mainRomLoader.cpp -o romTest -L. $(LIBS)

validate.bin: mainValidate.cpp $(ALL_LIB)
	g++ mainValidate.cpp -o $@ -L. $(LIBS)


clean:
	rm -f $(COMMON_OBJS) $(TESTCASE_OBJS)
	rm -f $(ALL_LIB)
	rm -f $(PROGRAM)

