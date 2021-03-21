
echo "Building ZYBO-UI"
cd zybo-ui
make
cd ../

echo "Building Test App for A4"
g++ -o testA4 mainA4.cpp common/AddressMapper.cpp 

echo "Building Test App for ROM"
g++ -o testRom mainRomTest.cpp common/AddressMapper.cpp
