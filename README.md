# CMPE_297-1_CourseProject
Course project for CMPE 297-1.

Project Setup
 1) Create ZYBO target project
 2) Link github sources (Do not select copy to project; Select add from subdirs)
   a) Add 'design/src' as design sources directory
   b) Add 'ver/dat/a4_polling.dat' as design source
   c) Add 'design/constraints/Zybo-Z7.xdc' as constraint file
 3) Create axi_dut_iface AxiIp
   a) Tools > Create & Package New IP > Create new AXI4 Periph named 'axi_dut_iface'
   b) Replace the axi_ip sources on disk from 'design/src/axi_ip/*.v'
   c) Window > IP Catalog; Search axi_dut_iface, [Right Click] Edit in IP Packager
   d) 'Merge'; Review & Package > Re-Package IP
 4) Block Design (experimental..)
   a) Add 'design/block/design_1.bd' as design source
   b) Flow > Open Block Design > design_1.bd
     1) I get some warnings here, something was not 100% with my original... to fix later..
   c) [Right Click] design_1 > Create HDL Wrapper..
   d) Set design_1_wrapper as top

Env Setup (optional)
 1) Putty install
   a) Scripts bellow use putty.exe and pscp (should both be with putty install). 
 2) Setup zybo hostname
   a) I added '192.168.0.16    zybo' to the file: 'C:\Windows\System32\drivers\etc\hosts' on Win10
   b) In my setup at home my zybo IP never changes. 
      As alternative to editing the 'hosts' file, replace 'zybo' with your IP in 'load-bitbin.tcl' etc

Loading Steps 
 1) Flow > 'Generate Bitstream' to synthesize and update implementation etc.
 2) In Vivavo TCL Console cd to <Github-Project-Location>/scripts
 3) Do either A or B
   a) Individual scripts..
     1) To create bit/bif/bin, In TCL Console run 'source ./gen-bitbin.tcl'
	   a) Note this will write files to '<Github-Loc>/localbin'. These may need to be deleted in subsequent 'runs'
     2) To load bitstream to Zybo, In TCL Console run 'source ./load-bitbin.tcl'
     3) To load/make driver to Zybo, In TCL Console run 'source ./load-driver.tcl'
   b) Or Do everything at once..
     1) In TCL Console run 'source ./load-all.tcl'


# CMPE_297-1_CourseProject_Description (from Lecture 5)

Requirements
- The interrupt controller (Intc):
1) Must be able to handle at least 4 interrupt sources
2) Support at least one of the resolving policy:
   - Fixed priority
   - Round robin
   - Rotated priority
3) Allow the lite MIPS to perform one-cycle context switching

Validation method:
- Complete validation determined by the end application (in our case, the factorial computation)
- Transaction-level, completed by the master processor (Cotex-A9)

Purpose:
As a preparation for your MS projects, which can include:
- Design, verification/validation and system integration
- Full stack of embedded software: firmware, system software, and application software
- Hardware-software co-design
You will define your MS project topics based on your interest.