# This file is based on the work of:
#
# http://mjo.tc/atelier/2009/02/arduino-cli.html
# http://johanneshoff.com/arduino-command-line.html
# http://www.arduino.cc/playground/Code/CmakeBuild
# http://www.tmpsantos.com.br/en/2010/12/arduino-uno-ubuntu-cmake/
# http://forum.arduino.cc/index.php?topic=244741.0


set(LIBRARY_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/lib")
set(TUNNING_FLAGS "") 

set(CMAKE_BOARD_FLAGS "-DF_CPU=${ARDUINO_FCPU} -DARDUINO=10605 -DARDUINO_SAMD_ZERO -DARDUINO_ARCH_SAMD -D__SAMD21G18A__ -DUSB_VID=0x2341 -DUSB_PID=0x804d -DUSBCON -DUSB_MANUFACTURER=\"Arduino LLC\" -DUSB_PRODUCT=\"\\\"Arduino Zero\\\"\"")
set(CMAKE_CXX_FLAGS "-g -Os -w -std=gnu++11 -ffunction-sections -fdata-sections -fno-threadsafe-statics -nostdlib --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -MMD -mcpu=${ARDUINO_MCU} -mthumb ${CMAKE_BOARD_FLAGS}")
set(CMAKE_C_FLAGS   "-g -Os -w -std=gnu11   -ffunction-sections -fdata-sections                         -nostdlib --param max-inline-insns-single=500                           -MMD -mcpu=${ARDUINO_MCU} -mthumb ${CMAKE_BOARD_FLAGS}")
set(CMAKE_ASM_FLAGS "-g -x assembler-with-cpp                                                                                                                                                                     ${CMAKE_BOARD_FLAGS}")


set(AVRDUDE_CONFIG "${ARDUINO_ROOT}/hardware/tools/avr/etc/avrdude.conf")
set(ARDUINO_CORE_DIR "${ARDUINO_ROOT}/hardware/samd/1.6.1/cores/arduino/")
set(ARDUINO_CMSIS_DIR "${ARDUINO_ROOT}/tools/CMSIS/4.0.0-atmel/CMSIS/Include/")
set(ARDUINO_DEVICE_DIR "${ARDUINO_ROOT}/tools/CMSIS/4.0.0-atmel/Device/ATMEL/")
set(ARDUINO_SCRIPTS "${ARDUINO_ROOT}/tools/openocd/0.9.0-arduino/share/openocd/scripts/")
set(ARDUINO_BOARD_DIR "${ARDUINO_ROOT}/hardware/samd/1.6.1/variants/${ARDUINO_BOARD}")
set(OPENOCD_CFG "${ARDUINO_BOARD_DIR}/openocd_scripts/arduino_zero.cfg")

include_directories(${ARDUINO_CMSIS_DIR})
include_directories(${ARDUINO_DEVICE_DIR})
include_directories(${ARDUINO_CORE_DIR})
include_directories(${ARDUINO_BOARD_DIR})

set(ARDUINO_SOURCE_FILES
        ${ARDUINO_BOARD_DIR}/variant.cpp
        ${ARDUINO_CORE_DIR}/pulse_asm.S
	${ARDUINO_CORE_DIR}/avr/dtostrf.c
	${ARDUINO_CORE_DIR}/wiring_shift.c
	${ARDUINO_CORE_DIR}/WInterrupts.c
	${ARDUINO_CORE_DIR}/pulse.c
	${ARDUINO_CORE_DIR}/cortex_handlers.c
	${ARDUINO_CORE_DIR}/wiring_digital.c
	${ARDUINO_CORE_DIR}/startup.c
	${ARDUINO_CORE_DIR}/hooks.c
	${ARDUINO_CORE_DIR}/wiring_private.c
	${ARDUINO_CORE_DIR}/itoa.c
	${ARDUINO_CORE_DIR}/delay.c
	${ARDUINO_CORE_DIR}/wiring_analog.c
	${ARDUINO_CORE_DIR}/USB/USB_interrupt.c
	${ARDUINO_CORE_DIR}/USB/samd21_host.c
	${ARDUINO_CORE_DIR}/USB/samd21_device.c
	${ARDUINO_CORE_DIR}/wiring.c
	${ARDUINO_CORE_DIR}/abi.cpp
	${ARDUINO_CORE_DIR}/Print.cpp
	${ARDUINO_CORE_DIR}/Reset.cpp
	${ARDUINO_CORE_DIR}/Stream.cpp
        ${ARDUINO_CORE_DIR}/Tone.cpp
        ${ARDUINO_CORE_DIR}/WMath.cpp
        ${ARDUINO_CORE_DIR}/RingBuffer.cpp
        ${ARDUINO_CORE_DIR}/SERCOM.cpp
        ${ARDUINO_CORE_DIR}/Uart.cpp
        ${ARDUINO_CORE_DIR}/USB/CDC.cpp
        ${ARDUINO_CORE_DIR}/USB/USBCore.cpp
        ${ARDUINO_CORE_DIR}/USB/HID.cpp
        ${ARDUINO_CORE_DIR}/WString.cpp
        ${ARDUINO_CORE_DIR}/new.cpp
        ${ARDUINO_CORE_DIR}/IPAddress.cpp
        ${ARDUINO_CORE_DIR}/main.cpp
)

add_library(core STATIC  ${ARDUINO_SOURCE_FILES})
                             

macro(arduino_flash PROJECT_TRAGET_NAME)

  add_custom_target(${PROJECT_TRAGET_NAME}_upload)
  add_dependencies(${PROJECT_TRAGET_NAME}_upload ${PROJECT_TRAGET_NAME} core )

  add_custom_command(TARGET ${PROJECT_TRAGET_NAME}_upload POST_BUILD
    COMMAND ${CMAKE_C_COMPILER} -Os -Wl,--gc-sections -save-temps -T${BOOTLOADER} --specs=nano.specs --specs=nosys.specs -mcpu=${ARDUINO_MCU} -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,${LIBRARY_OUTPUT_PATH}/${PROJECT_TRAGET_NAME}.cpp.map -o ${LIBRARY_OUTPUT_PATH}/${PROJECT_TRAGET_NAME}.cpp.elf -lm ${LIBRARY_OUTPUT_PATH}/lib${PROJECT_TRAGET_NAME}.a -lm ${LIBRARY_OUTPUT_PATH}/libcore.a
    COMMAND ${OBJCOPY} -O binary ${LIBRARY_OUTPUT_PATH}/${PROJECT_TRAGET_NAME}.cpp.elf ${LIBRARY_OUTPUT_PATH}/${PROJECT_TRAGET_NAME}.bin
    COMMAND ${OPENOCD} -d2 -s ${ARDUINO_SCRIPTS} -f ${OPENOCD_CFG} -c "program ${LIBRARY_OUTPUT_PATH}/${PROJECT_TRAGET_NAME}.bin verify reset 0x00002000 exit"
    
  )

      
endmacro()
