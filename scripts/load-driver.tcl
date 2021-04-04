
cd ../val/src
exec pscp -P 22 -pw root -r common root@zybo:/home/root
exec pscp -P 22 -pw root -r test-cases root@zybo:/home/root
exec pscp -P 22 -pw root -r mips-bin root@zybo:/home/root
exec pscp -P 22 -pw root Makefile root@zybo:/home/root
exec pscp -P 22 -pw root validate root@zybo:/home/root
exec pscp -P 22 -pw root mainValidate.cpp root@zybo:/home/root

cd ../../scripts
exec putty.exe -ssh root@zybo -pw root -m make_driver

