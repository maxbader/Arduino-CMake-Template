project(ARDUINO_PROJECTS)
cmake_minimum_required(VERSION 2.6)
set( CMAKE_VERBOSE_MAKEFILE on )

#include(${CMAKE_SOURCE_DIR}/scripts/arduino_uno.cmake)
include(${CMAKE_SOURCE_DIR}/scripts/arduino_m0plus.cmake)
#include(${CMAKE_SOURCE_DIR}/scripts/arduino_zero.cmake)

add_subdirectory(src)