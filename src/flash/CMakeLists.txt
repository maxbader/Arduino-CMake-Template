
set(SOURCE_FILES
    sketch.cpp
    flash.cpp
)
include_directories(./)

add_library(sketch STATIC  ${SOURCE_FILES})

flashZero(sketch)