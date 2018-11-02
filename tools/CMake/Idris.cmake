#
# Copyright 2018, Mokshasoft AB (mokshasoft.com)
#
# This software may be distributed and modified according to the terms of
# the BSD 2-Clause license. Note that NO WARRANTY is provided.
# See "LICENSE_BSD2.txt" for details.
#

cmake_minimum_required(VERSION 3.7.2)

function(idris_add_module module srcs)
endfunction()

function(idris_add_app app srcs)
    # add an ${app} target
    add_custom_command(
        OUTPUT main.c
        COMMAND idris
            -i ${CMAKE_CURRENT_SOURCE_DIR}
            --sourcepath ${CMAKE_CURRENT_SOURCE_DIR}
            --codegen C
            --codegenonly
            -o main.c
            ${srcs}
        DEPENDS ${srcs}
    )
    add_custom_target(${app} DEPENDS main.c)
endfunction()

function(idris_link_modules app modules)
endfunction()
