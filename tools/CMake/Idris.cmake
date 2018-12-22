#
# Copyright 2018, Mokshasoft AB (mokshasoft.com)
#
# This software may be distributed and modified according to the terms of
# the BSD 2-Clause license. Note that NO WARRANTY is provided.
# See "LICENSE_BSD2.txt" for details.
#

cmake_minimum_required(VERSION 3.7.2)

function(idris_add_module module files)
    set_property(GLOBAL PROPERTY idris_module_include_dir_${module} ${CMAKE_CURRENT_SOURCE_DIR})
    set_property(GLOBAL PROPERTY idris_module_dependent_files_${module} ${files})
endfunction()

function(idris_module_link_libraries module libraries)
    # get the libraries
    set(libs ${ARGV})
    list(REMOVE_AT libs 0)
    # store libraries
    set_property(GLOBAL PROPERTY idris_module_link_libraries_${module} ${libs})
endfunction()

function(idris_app_link_libraries app libraries)
    # get the libraries
    set(libs ${ARGV})
    list(REMOVE_AT libs 0)
    # store libraries
    set_property(GLOBAL PROPERTY idris_app_link_libraries_${app} ${libs})
endfunction()

function(idris_app_link_modules app modules)
    # get the modules
    set(mods ${ARGV})
    list(REMOVE_AT mods 0)
    # store modules
    set_property(GLOBAL PROPERTY idris_app_link_modules_${app} "${mods}")
endfunction()

function(idris_add_app app srcs)
    # find and add all include directories from the app modules
    get_property(app_inc_mods GLOBAL PROPERTY idris_app_link_modules_${app})
    foreach(mod ${app_inc_mods})
	# get dependent files and their root folders
        get_property(mod_inc_dir GLOBAL PROPERTY idris_module_include_dir_${mod})
        get_property(mod_dep_files GLOBAL PROPERTY idris_module_dependent_files_${mod})
        if("${mod_inc_dir}" STREQUAL "")
            message(FATAL_ERROR "Did not find Idris module ${mod}")
        else()
            set(app_inc_dirs ${app_inc_dirs} -i ${mod_inc_dir})
            set(app_dep_files ${app_dep_files} ${mod_dep_files})
        endif()
        # get all dependent libraries
        get_property(mod_link_lib GLOBAL PROPERTY idris_module_link_libraries_${mod})
        if(NOT "${mod_link_lib}" STREQUAL "")
            set(app_link_lib ${app_link_lib} ${mod_link_lib})
        endif()
    endforeach(mod)

    # get all the apps dependent libraries
    get_property(link_lib GLOBAL PROPERTY idris_app_link_libraries_${app})
    if(NOT "${link_lib}" STREQUAL "")
        set(app_link_lib ${app_link_lib} ${link_lib})
    endif()

    # add a target that transcompiles Idris to C
    add_custom_command(
        OUTPUT main.c
        COMMAND idris
            -i ${CMAKE_CURRENT_SOURCE_DIR}
            ${app_inc_dirs}
            --sourcepath ${CMAKE_CURRENT_SOURCE_DIR}
            --codegen C
            --codegenonly
            -o main.c
            ${srcs}
        DEPENDS ${srcs} ${app_dep_files}
    )
    add_custom_target(${app}-idr2c DEPENDS main.c)

    # Compile and link everything to a static binary
    add_executable(${app} EXCLUDE_FROM_ALL
        main.c
	${CMAKE_SOURCE_DIR}/libsel4-idris-rts/rts/bare-metal/idris_main.c
    )
    add_dependencies(${app} ${app}-idr2c)
    # Ignore warning from unused loop label in generated code in Idris RTS
    set_target_properties(${app} PROPERTIES COMPILE_FLAGS "-Wno-unused-label")
    target_link_libraries(
        ${app}
	idris-rts-bare-metal
	${app_link_lib}
	drivers
	platform
	system_config
	utils
        -T ${CMAKE_SOURCE_DIR}/starterwarefree/build/beaglebone.lds
    )
    gen_bin(${app})
endfunction()
