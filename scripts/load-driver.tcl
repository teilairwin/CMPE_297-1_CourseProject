
cd ../val/src
exec pscp -P 22 -pw root -r common root@zybo:/home/root
exec pscp -P 22 -pw root mainRomLoader.cpp root@zybo:/home/root
exec pscp -P 22 -pw root exc.bin root@zybo:/home/root
exec pscp -P 22 -pw root regfile.bin root@zybo:/home/root
exec pscp -P 22 -pw root buildAll.sh root@zybo:/home/root
cd ../../scripts
exec putty.exe -ssh root@zybo -pw root -m make_driver
