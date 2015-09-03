
set(MYPROJECT_SOURCE_FILES
    sketch.cpp
    flash.cpp
)
include_directories(./)

add_library(sketch STATIC  ${MYPROJECT_SOURCE_FILES})