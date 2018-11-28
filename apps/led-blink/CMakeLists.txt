#
# Copyright 2018, Mokshasoft AB (mokshasoft.com)
#
# This software may be distributed and modified according to the terms of
# the BSD 2-Clause license. Note that NO WARRANTY is provided.
# See "LICENSE_BSD2.txt" for details.
#

cmake_minimum_required(VERSION 3.7.2)

project(busywait C)
file(GLOB ffi_files
    busywait.c
)
add_library(busywait EXCLUDE_FROM_ALL ${ffi_files})
target_include_directories(busywait PUBLIC .)

project(led-blink C)

file(GLOB static
    *.idr
)

idris_app_link_modules(
    led-blink
    StarterWareFree.Drivers
    StarterWareFree.Platform
)
idris_app_link_libraries(led-blink busywait)
idris_add_app(led-blink ${static})
