set(ARDUINO_BOARD "arduino_zero")
set(ARDUINO_MCU "cortex-m0plus")
set(ARDUINO_FCPU "48000000L")
set(ARDUINO_ROOT "$ENV{HOME}/.arduino15/packages/arduino/")

set(CMAKE_C_COMPILER "${ARDUINO_ROOT}/tools/arm-none-eabi-gcc/4.8.3-2014q1/bin/arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "${ARDUINO_ROOT}/tools/arm-none-eabi-gcc/4.8.3-2014q1/bin/arm-none-eabi-g++")
set(CMAKE_ASM_COMPILER "${ARDUINO_ROOT}/tools/arm-none-eabi-gcc/4.8.3-2014q1/bin/arm-none-eabi-gcc")

set(ARDUINO_OPENOCD "${ARDUINO_ROOT}/tools/openocd/0.9.0-arduino/bin/openocd")
set(ARDUINO_BOOTLOADER "${ARDUINO_ROOT}/hardware/samd/1.6.1/variants/arduino_zero/linker_scripts/gcc/flash_with_bootloader.ld")
set(ARDUINO_OBJCOPY "${ARDUINO_ROOT}/tools/arm-none-eabi-gcc/4.8.3-2014q1/bin/arm-none-eabi-objcopy")

include(${CMAKE_SOURCE_DIR}/scripts/libarduino_zero.cmake)