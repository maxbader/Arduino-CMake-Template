# This file is based on the work of:
#
# http://mjo.tc/atelier/2009/02/arduino-cli.html
# http://johanneshoff.com/arduino-command-line.html
# http://www.arduino.cc/playground/Code/CmakeBuild
# http://www.tmpsantos.com.br/en/2010/12/arduino-uno-ubuntu-cmake/
# http://forum.arduino.cc/index.php?topic=244741.0


set(EXECUTABLE_OUTPUT_PATH  "${CMAKE_CURRENT_SOURCE_DIR}/lib")
set(LIBRARY_OUTPUT_PATH  "${CMAKE_CURRENT_SOURCE_DIR}/lib")
set(TUNNING_FLAGS "") 
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_BOARD_FLAGS "-DF_CPU=${ARDUINO_M0PLUS_FCPU} -DARDUINO_M0PLUS=10605 -DARDUINO_M0PLUS_SAMD_ZERO -DARDUINO_M0PLUS_ARCH_SAMD -D__SAMD21G18A__ -DUSB_VID=0x2341 -DUSB_PID=0x804d -DUSBCON -DUSB_MANUFACTURER=\"Arduino LLC\" -DUSB_PRODUCT=\"\\\"Arduino Zero\\\"\"")
set(CMAKE_C_FLAGS   "-g -Os -w -std=gnu11   -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -MMD -mcpu=${ARDUINO_M0PLUS_MCU} -mthumb ${CMAKE_BOARD_FLAGS}")
set(CMAKE_CXX_FLAGS "-g -Os -w -std=gnu++11 -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -MMD -mcpu=${ARDUINO_M0PLUS_MCU} -mthumb ${CMAKE_BOARD_FLAGS}  -fno-threadsafe-statics  -fno-rtti -fno-exceptions")
set(CMAKE_ASM_FLAGS "-g -x assembler-with-cpp                                                                                                                   ${CMAKE_BOARD_FLAGS}")


set(ARDUINO_M0PLUS_AVRDUDE_CONFIG "${ARDUINO_M0PLUS_ROOT}/hardware/tools/avr/etc/avrdude.conf")
set(ARDUINO_M0PLUS_CORE_DIR "${ARDUINO_M0PLUS_ROOT}/hardware/samd/1.6.1/cores/arduino/")
set(ARDUINO_M0PLUS_CMSIS_DIR "${ARDUINO_M0PLUS_ROOT}/tools/CMSIS/4.0.0-atmel/CMSIS/Include/")
set(ARDUINO_M0PLUS_DEVICE_DIR "${ARDUINO_M0PLUS_ROOT}/tools/CMSIS/4.0.0-atmel/Device/ATMEL/")
set(ARDUINO_M0PLUS_SCRIPTS "${ARDUINO_M0PLUS_ROOT}/tools/openocd/0.9.0-arduino/share/openocd/scripts/")
set(ARDUINO_M0PLUS_BOARD_DIR "${ARDUINO_M0PLUS_ROOT}/hardware/samd/1.6.1/variants/${ARDUINO_M0PLUS_BOARD}")
set(ARDUINO_M0PLUS_OPENOCD_CFG "${ARDUINO_M0PLUS_BOARD_DIR}/openocd_scripts/arduino_zero.cfg")

#include_directories("/usr/include/c++/4.8")
include_directories(${ARDUINO_M0PLUS_CMSIS_DIR})
include_directories(${ARDUINO_M0PLUS_DEVICE_DIR})
include_directories(${ARDUINO_M0PLUS_CORE_DIR})
include_directories(${ARDUINO_M0PLUS_BOARD_DIR})

set(ARDUINO_M0PLUS_SOURCE_FILES
        ${ARDUINO_M0PLUS_BOARD_DIR}/variant.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/pulse_asm.S
	${ARDUINO_M0PLUS_CORE_DIR}/avr/dtostrf.c
	${ARDUINO_M0PLUS_CORE_DIR}/wiring_shift.c
	${ARDUINO_M0PLUS_CORE_DIR}/WInterrupts.c
	${ARDUINO_M0PLUS_CORE_DIR}/pulse.c
	${ARDUINO_M0PLUS_CORE_DIR}/cortex_handlers.c
	${ARDUINO_M0PLUS_CORE_DIR}/wiring_digital.c
	${ARDUINO_M0PLUS_CORE_DIR}/startup.c
	${ARDUINO_M0PLUS_CORE_DIR}/hooks.c
	${ARDUINO_M0PLUS_CORE_DIR}/wiring_private.c
	${ARDUINO_M0PLUS_CORE_DIR}/itoa.c
	${ARDUINO_M0PLUS_CORE_DIR}/delay.c
	${ARDUINO_M0PLUS_CORE_DIR}/wiring_analog.c
	${ARDUINO_M0PLUS_CORE_DIR}/USB/USB_interrupt.c
	${ARDUINO_M0PLUS_CORE_DIR}/USB/samd21_host.c
	${ARDUINO_M0PLUS_CORE_DIR}/USB/samd21_device.c
	${ARDUINO_M0PLUS_CORE_DIR}/wiring.c
	${ARDUINO_M0PLUS_CORE_DIR}/abi.cpp
	${ARDUINO_M0PLUS_CORE_DIR}/Print.cpp
	${ARDUINO_M0PLUS_CORE_DIR}/Reset.cpp
	${ARDUINO_M0PLUS_CORE_DIR}/Stream.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/Tone.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/WMath.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/RingBuffer.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/SERCOM.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/Uart.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/USB/CDC.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/USB/USBCore.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/USB/HID.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/WString.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/new.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/IPAddress.cpp
        ${ARDUINO_M0PLUS_CORE_DIR}/main.cpp
)

add_library(core_m0plus STATIC  ${ARDUINO_M0PLUS_SOURCE_FILES})
                             

macro(arduino TRAGET_NAME TRAGET_SOURCE_FILES)

  # A hack to force the the gcc instead of the g++
  # add_library(${TRAGET_NAME} STATIC ${ARDUINO_M0PLUS_CORE_DIR}/main.cpp ${SOURCE_FILES})
  #set(CMAKE_EXE_LINKER_FLAGS "-Os -Wl,--gc-sections -save-temps -T${BOOTLOADER} --specs=nano.specs --specs=nosys.specs -mcpu=${ARDUINO_M0PLUS_MCU} -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,${LIBRARY_OUTPUT_PATH}/${TRAGET_NAME}.map")
  #SET(CMAKE_CXX_LINK_EXECUTABLE  "<CMAKE_C_COMPILER> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
  
  # gernerates the elf file
  #add_executable(${TRAGET_NAME}.elf  ${ARDUINO_M0PLUS_CORE_DIR}/main.cpp)
  #target_link_libraries(${TRAGET_NAME}.elf core ${TRAGET_NAME})
   
    
  add_library(${TRAGET_NAME} STATIC ${ARDUINO_M0PLUS_CORE_DIR}/main.cpp ${SOURCE_FILES})
  
  add_custom_target(${TRAGET_NAME}.elf )
  add_dependencies(${TRAGET_NAME}.elf core_m0plus ${TRAGET_NAME})

  add_custom_command(TARGET ${TRAGET_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_C_COMPILER} -Os -Wl,--gc-sections -save-temps -T${ARDUINO_M0PLUS_BOOTLOADER} --specs=nano.specs --specs=nosys.specs -mcpu=${ARDUINO_M0PLUS_MCU} -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,${LIBRARY_OUTPUT_PATH}/${TRAGET_NAME}.map -o ${LIBRARY_OUTPUT_PATH}/${TRAGET_NAME}.elf -lm ${LIBRARY_OUTPUT_PATH}/lib${TRAGET_NAME}.a -lm ${LIBRARY_OUTPUT_PATH}/libcore_m0plus.a
  )
  
  # converts elf to bin
  add_custom_target(${TRAGET_NAME}.bin)
  add_dependencies(${TRAGET_NAME}.bin ${TRAGET_NAME}.elf )
  add_custom_command(TARGET ${TRAGET_NAME}.bin POST_BUILD
    COMMAND ${ARDUINO_M0PLUS_OBJCOPY} -O binary ${EXECUTABLE_OUTPUT_PATH}/${TRAGET_NAME}.elf ${EXECUTABLE_OUTPUT_PATH}/${TRAGET_NAME}.bin
  )
  
  # uploads the bin 
  add_custom_target(${TRAGET_NAME}.upload)
  add_dependencies(${TRAGET_NAME}.upload ${TRAGET_NAME} ${TRAGET_NAME}.bin )
  add_custom_command(TARGET ${TRAGET_NAME}.upload POST_BUILD
    COMMAND ${ARDUINO_M0PLUS_OPENOCD} -d2 -s ${ARDUINO_M0PLUS_SCRIPTS} -f ${ARDUINO_M0PLUS_OPENOCD_CFG} -c "program ${EXECUTABLE_OUTPUT_PATH}/${TRAGET_NAME}.bin verify reset 0x00002000 exit" 
  )      
endmacro()
