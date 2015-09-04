# This file is based on the work of:
#
# http://mjo.tc/atelier/2009/02/arduino-cli.html
# http://johanneshoff.com/arduino-command-line.html
# http://www.arduino.cc/playground/Code/CmakeBuild
# http://www.tmpsantos.com.br/en/2010/12/arduino-uno-ubuntu-cmake/
# http://forum.arduino.cc/index.php?topic=244741.0


set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER avr-gcc)
set(CMAKE_CXX_COMPILER avr-g++)
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
enable_language(ASM)

# C only fine tunning
set(TUNNING_FLAGS "-funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums") 

set(CMAKE_CXX_FLAGS "-mmcu=${ARDUINO_MCU} -DF_CPU=${ARDUINO_FCPU} -Os")
set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS} ${TUNNING_FLAGS} -Wall -Wstrict-prototypes -std=gnu99")

set(ARDUINO_CORE_DIR "${ARDUINO_ROOT}/hardware/arduino/avr/cores/arduino/")
set(ARDUINO_PINS_DIR "${ARDUINO_ROOT}/hardware/arduino/avr/variants/${ARDUINO_BOARD}")
set(ARDUINO_PINS_DIR "${ARDUINO_ROOT}/hardware/arduino/avr/variants/${ARDUINO_BOARD}")
set(ARDUINO_AVR_DIR "${ARDUINO_ROOT}/hardware/tools/avr/avr/include")
set(AVRDUDE_CONFIG "${ARDUINO_ROOT}/hardware/tools/avr/etc/avrdude.conf")

include_directories(${ARDUINO_PINS_DIR})
include_directories(${ARDUINO_CORE_DIR})
include_directories(${ARDUINO_AVR_DIR})

set(ARDUINO_SOURCE_FILES
	${ARDUINO_CORE_DIR}/wiring_pulse.S
	${ARDUINO_CORE_DIR}/wiring_digital.c
	${ARDUINO_CORE_DIR}/wiring.c
	${ARDUINO_CORE_DIR}/WInterrupts.c
	${ARDUINO_CORE_DIR}/wiring_pulse.c
	${ARDUINO_CORE_DIR}/wiring_shift.c
	${ARDUINO_CORE_DIR}/hooks.c 
	${ARDUINO_CORE_DIR}/wiring_analog.c
	${ARDUINO_CORE_DIR}/WMath.cpp
	${ARDUINO_CORE_DIR}/IPAddress.cpp
	${ARDUINO_CORE_DIR}/Tone.cpp
	${ARDUINO_CORE_DIR}/HardwareSerial2.cpp
	${ARDUINO_CORE_DIR}/HID.cpp
	${ARDUINO_CORE_DIR}/Print.cpp
	${ARDUINO_CORE_DIR}/new.cpp
	${ARDUINO_CORE_DIR}/HardwareSerial0.cpp
	${ARDUINO_CORE_DIR}/HardwareSerial.cpp
	${ARDUINO_CORE_DIR}/WString.cpp
	${ARDUINO_CORE_DIR}/abi.cpp
	${ARDUINO_CORE_DIR}/USBCore.cpp
	${ARDUINO_CORE_DIR}/Stream.cpp
	${ARDUINO_CORE_DIR}/CDC.cpp
)

add_library(core STATIC  ${ARDUINO_SOURCE_FILES})


macro(arduino_flash PROJECT_TRAGET_NAME)

  add_executable(${PROJECT_TRAGET_NAME}_elf ${ARDUINO_CORE_DIR}/main.cpp)
  target_link_libraries(${PROJECT_TRAGET_NAME}_elf core ${PROJECT_TRAGET_NAME})
  
  add_custom_target(${PROJECT_TRAGET_NAME}_upload)
  add_dependencies(${PROJECT_TRAGET_NAME}_upload ${PROJECT_TRAGET_NAME}_elf )

  add_custom_command(TARGET ${PROJECT_TRAGET_NAME}_upload POST_BUILD
        COMMAND ${AVROBJCOPY} -O ihex -R .eeprom ${CMAKE_CURRENT_BINARY_DIR}/firmware firmware.hex
        COMMAND ${AVRDUDE} -C${AVRDUDE_CONFIG} -v -p${ARDUINO_MCU} -c${ARDUINO_PROTOCOL}  -P${PORT} -b${ARDUINO_UPLOAD_SPEED} -D -Uflash:w:firmware.hex:i 
  )

      
endmacro()
