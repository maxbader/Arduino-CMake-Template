
set(SOURCE_FILES
    flash.cpp
    demo_flash.cpp
)
include_directories(./)

arduino(demo_flash ${SOURCE_FILES})