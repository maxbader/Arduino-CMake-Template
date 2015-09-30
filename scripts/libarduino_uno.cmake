# This file is based on the work of:
#
# http://mjo.tc/atelier/2009/02/arduino-cli.html
# http://johanneshoff.com/arduino-command-line.html
# http://www.arduino.cc/playground/Code/CmakeBuild
# http://www.tmpsantos.com.br/en/2010/12/arduino-uno-ubuntu-cmake/
# http://forum.arduino.cc/index.php?topic=244741.0


set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
enable_language(ASM)

set(EXECUTABLE_OUTPUT_PATH  "${CMAKE_CURRENT_SOURCE_DIR}/lib/uno")
set(LIBRARY_OUTPUT_PATH  "${CMAKE_CURRENT_SOURCE_DIR}/lib/uno")

# C only fine tunning
set(TUNNING_FLAGS "-funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums") 

set(CMAKE_CXX_FLAGS "-mmcu=${ARDUINO_UNO_MCU} -DF_CPU=${ARDUINO_UNO_FCPU} -Os")
set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS} ${TUNNING_FLAGS} -Wall -Wstrict-prototypes -std=gnu99")

set(ARDUINO_UNO_CORE_DIR "${ARDUINO_UNO_ROOT}/hardware/arduino/avr/cores/arduino/")
set(ARDUINO_UNO_PINS_DIR "${ARDUINO_UNO_ROOT}/hardware/arduino/avr/variants/${ARDUINO_UNO_BOARD}")
set(ARDUINO_UNO_PINS_DIR "${ARDUINO_UNO_ROOT}/hardware/arduino/avr/variants/${ARDUINO_UNO_BOARD}")
set(ARDUINO_UNO_AVR_DIR "${ARDUINO_UNO_ROOT}/hardware/tools/avr/avr/include")
set(AVRDUDE_CONFIG "${ARDUINO_UNO_ROOT}/hardware/tools/avr/etc/avrdude.conf")

include_directories(${ARDUINO_UNO_PINS_DIR})
include_directories(${ARDUINO_UNO_CORE_DIR})
include_directories(${ARDUINO_UNO_AVR_DIR})

set(ARDUINO_UNO_SOURCE_FILES
	${ARDUINO_UNO_CORE_DIR}/wiring_pulse.S
	${ARDUINO_UNO_CORE_DIR}/wiring_digital.c
	${ARDUINO_UNO_CORE_DIR}/wiring.c
	${ARDUINO_UNO_CORE_DIR}/WInterrupts.c
	${ARDUINO_UNO_CORE_DIR}/wiring_pulse.c
	${ARDUINO_UNO_CORE_DIR}/wiring_shift.c
	${ARDUINO_UNO_CORE_DIR}/hooks.c 
	${ARDUINO_UNO_CORE_DIR}/wiring_analog.c
	${ARDUINO_UNO_CORE_DIR}/WMath.cpp
	${ARDUINO_UNO_CORE_DIR}/IPAddress.cpp
	${ARDUINO_UNO_CORE_DIR}/Tone.cpp
	${ARDUINO_UNO_CORE_DIR}/HardwareSerial2.cpp
	${ARDUINO_UNO_CORE_DIR}/HID.cpp
	${ARDUINO_UNO_CORE_DIR}/Print.cpp
	${ARDUINO_UNO_CORE_DIR}/new.cpp
	${ARDUINO_UNO_CORE_DIR}/HardwareSerial0.cpp
	${ARDUINO_UNO_CORE_DIR}/HardwareSerial.cpp
	${ARDUINO_UNO_CORE_DIR}/WString.cpp
	${ARDUINO_UNO_CORE_DIR}/abi.cpp
	${ARDUINO_UNO_CORE_DIR}/USBCore.cpp
	${ARDUINO_UNO_CORE_DIR}/Stream.cpp
	${ARDUINO_UNO_CORE_DIR}/CDC.cpp
)

add_library(core STATIC  ${ARDUINO_UNO_SOURCE_FILES})

set(PORT $ENV{ARDUINO_UNO_PORT})
if (NOT PORT)
    set(PORT ${ARDUINO_UNO_PORT})
endif()

add_custom_target(reset_uno)
add_custom_command(TARGET reset POST_BUILD
    COMMAND echo 0 > ${PORT}
)

macro(arduino TRAGET_NAME TRAGET_SOURCE_FILES)

  #add_library(${TRAGET_NAME} STATIC ${TRAGET_SOURCE_FILES})
  #add_dependencies(${TRAGET_NAME} core)
  
  #add_executable(${TRAGET_NAME}.elf  ${TRAGET_SOURCE_FILES})
  #add_dependencies(${TRAGET_NAME}.elf core)
  
  
  add_library(${TRAGET_NAME} STATIC ${ARDUINO_UNO_CORE_DIR}/main.cpp ${SOURCE_FILES})
  
  add_custom_target(${TRAGET_NAME}.elf )
  add_dependencies(${TRAGET_NAME}.elf core ${TRAGET_NAME})

  add_custom_command(TARGET ${TRAGET_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_C_COMPILER}  -w -Os -Wl,--gc-sections -mmcu=atmega328p -o ${LIBRARY_OUTPUT_PATH}/${TRAGET_NAME}.elf -lm ${LIBRARY_OUTPUT_PATH}/lib${TRAGET_NAME}.a -lm ${LIBRARY_OUTPUT_PATH}/libcore.a
  )
  

  add_custom_target(${TRAGET_NAME}.hex)
  add_dependencies(${TRAGET_NAME}.hex ${TRAGET_NAME}.elf)

  add_custom_command(TARGET ${TRAGET_NAME}.hex POST_BUILD
      COMMAND ${ARDUINO_UNO_OBJCOPY} -O ihex -R .eeprom ${LIBRARY_OUTPUT_PATH}/${TRAGET_NAME}.elf ${LIBRARY_OUTPUT_PATH}/${TRAGET_NAME}.hex
  )
  
  add_custom_target(${TRAGET_NAME}.upload)
  add_dependencies(${TRAGET_NAME}.upload ${TRAGET_NAME}.hex)

  add_custom_command(TARGET ${TRAGET_NAME}.upload POST_BUILD
      COMMAND ${ARDUINO_UNO_AVRDUDE} -C${AVRDUDE_CONFIG} -v -p${ARDUINO_UNO_MCU} -c${ARDUINO_UNO_PROTOCOL}  -P${PORT} -b${ARDUINO_UNO_UPLOAD_SPEED} -D -Uflash:w:${LIBRARY_OUTPUT_PATH}/${TRAGET_NAME}.hex:i
  )
endmacro()
