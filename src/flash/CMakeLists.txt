
set(SOURCE_FILES
    ${ARDUINO_CORE_DIR}/main.cpp
    demo_flash.cpp
    flash.cpp
)
include_directories(./)

add_library(demo_flash STATIC  ${SOURCE_FILES})

arduino_flash(demo_flash)