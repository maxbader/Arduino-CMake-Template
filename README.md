# Arduino-CMake-Template
Starting point for Arduino development using CMake
#Thanks
- http://mjo.tc/atelier/2009/02/arduino-cli.html
- http://johanneshoff.com/arduino-command-line.html
- http://www.arduino.cc/playground/Code/CmakeBuild
- http://www.tmpsantos.com.br/en/2010/12/arduino-uno-ubuntu-cmake/
- http://forum.arduino.cc/index.php?topic=244741.0

#Install
- General
- For Arduino UNO 
- For Arduino M0/M0pro/Zerp
```
sudo apt-get remove binutils-arm-none-eabi gcc-arm-none-eabi
sudo add-apt-repository ppa:terry.guo/gcc-arm-embedded
sudo apt-get update
sudo apt-get install gcc-arm-none-eabi=4.8.2-14ubuntu1+6
```
#Usage
1. Check the project root CMakeList.txt 
  * Update the project name
  * Update include and use one of
    - include(${CMAKE_SOURCE_DIR}/scripts/arduino_zero.cmake or
    - include(${CMAKE_SOURCE_DIR}/scripts/arduino_uno.cmake
2. Check the used included script
  * for m0/zero
    - update the paths to your arduino arm enviroment
  * for uno
    - sorry currently not working
3. CMake
```
mkdir build
cd build
cmake ..
make demo_blink_upload # to upload compile, link and upload a demo program
```

#Updates
##2015-09-04 
Markus Bader
- Tested with Ardunio Zero
- Ardunio broeken
##2015-08-20 
Markus Bader
- Works with Arduino IDE 1.6.5
- Tested with Ardunio UNO
