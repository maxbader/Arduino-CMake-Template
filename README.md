# Arduino-CMake-Template
Starting point for Arduino development using CMake
#Thanks
- http://mjo.tc/atelier/2009/02/arduino-cli.html
- http://johanneshoff.com/arduino-command-line.html
- http://www.arduino.cc/playground/Code/CmakeBuild
- http://www.tmpsantos.com.br/en/2010/12/arduino-uno-ubuntu-cmake/
- http://forum.arduino.cc/index.php?topic=244741.0

# Install
- Install at least the Arduino IDE 1.6.5
  * File > Preferences > Show verbose output --> activate compilation and upload
- For Arduino UNO 
    * Check the verbose ouput and remember the path to
     - avr-gcc
     - avr-g++
     - avr-objcopy
     - avrdude
    * update the script/arduino_uno.cmake
- For Arduino M0/M0pro/Zero
    * Check the verbose ouput and remember the path to
     - arm-none-eabi-gcc
     - arm-none-eabi-g++
     - openocd
     - flash_with_bootloader.ld
     - arm-none-eabi-objcopy
    * update the script/arduino_m0plus.cmake

# Usage
1. Check the project root CMakeList.txt 
    - include(${CMAKE_SOURCE_DIR}/scripts/arduino_m0plus.cmake or
    - include(${CMAKE_SOURCE_DIR}/scripts/arduino_uno.cmake
2. Compile a demo
```
mkdir build
cd build
cmake ..
make demo_blink.upload # to upload compile, link and upload
make demo_flash.upload # to upload compile, link and upload
```
New cmake targets can be added by using the __arduino__ macro.

# Updates

## 2015-09-05 
Markus Bader
- Tested with Ardunio Zero
- arduino macros added

## 2015-08-20 
Markus Bader
- Works with Arduino IDE 1.6.5
- Tested with Ardunio UNO
