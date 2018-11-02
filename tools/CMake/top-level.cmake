#
# Copyright 2018, Mokshasoft AB (mokshasoft.com)
#
# This software may be distributed and modified according to the terms of
# the BSD 2-Clause license. Note that NO WARRANTY is provided.
# See "LICENSE_BSD2.txt" for details.
#

cmake_minimum_required(VERSION 3.7.2)

#
# This file should be copied/symlinked into the top level of a project.
# See https://github.com/mokshasoft/bare-metal-idris-manifest
#

# Include functions used to build Idris source
include(tools/CMake/Idris.cmake)

# Add all directories needed to build the Idris apps
add_subdirectory(starterwarefree)
add_subdirectory(starterwarefree-idris-ffi)
add_subdirectory(libsel4-idris-rts)
add_subdirectory(bare-metal-idris)
