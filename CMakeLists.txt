project(ARDUINO_PROJECTS)
cmake_minimum_required(VERSION 2.6)

#include(${CMAKE_SOURCE_DIR}/scripts/arduino_uno.cmake)
include(${CMAKE_SOURCE_DIR}/scripts/arduino_m0plus.cmake)

add_subdirectory(src)