
cd ../val/src
exec pscp -P 22 -pw root -r zybo-ui root@zybo:/home/root
cd ../../scripts
exec putty.exe -ssh root@zybo -pw root -m make_driver
