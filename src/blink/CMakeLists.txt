
set(SOURCE_FILES
    ${ARDUINO_CORE_DIR}/main.cpp
    demo_blink.cpp
)
include_directories(./)

add_library(demo_blink STATIC  ${SOURCE_FILES})

arduino_flash(demo_blink)