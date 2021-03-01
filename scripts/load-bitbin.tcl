
exec putty.exe -ssh root@zybo -pw root -m mkdir_firmware
cd ../localbin
exec pscp -P 22 -pw root bitstream.bit.bin root@zybo:/lib/firmware
cd ../scripts
exec putty.exe -ssh root@zybo -pw root -m echo_bitstream
