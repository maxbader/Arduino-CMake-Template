project(MYPROJECT)

cmake_minimum_required(VERSION 2.6)

include(${CMAKE_SOURCE_DIR}/scripts/arduino_zero.cmake)

add_subdirectory(src)