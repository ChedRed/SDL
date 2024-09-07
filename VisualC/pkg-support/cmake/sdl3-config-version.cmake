# based on the files generated by CMake's write_basic_package_version_file

# SDL CMake version configuration file:
# This file is meant to be placed in a cmake subfolder of SDL3-devel-3.x.y-VC

if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/../include/SDL3/SDL_version.h")
    message(AUTHOR_WARNING "Could not find SDL3/SDL_version.h. This script is meant to be placed in the root of SDL3-devel-3.x.y-VC")
    return()
endif()

file(READ "${CMAKE_CURRENT_LIST_DIR}/../include/SDL3/SDL_version.h" _sdl_version_h)
string(REGEX MATCH "#define[ \t]+SDL_MAJOR_VERSION[ \t]+([0-9]+)" _sdl_major_re "${_sdl_version_h}")
set(_sdl_major "${CMAKE_MATCH_1}")
string(REGEX MATCH "#define[ \t]+SDL_MINOR_VERSION[ \t]+([0-9]+)" _sdl_minor_re "${_sdl_version_h}")
set(_sdl_minor "${CMAKE_MATCH_1}")
string(REGEX MATCH "#define[ \t]+SDL_MICRO_VERSION[ \t]+([0-9]+)" _sdl_micro_re "${_sdl_version_h}")
set(_sdl_micro "${CMAKE_MATCH_1}")
if(_sdl_major_re AND _sdl_minor_re AND _sdl_micro_re)
    set(PACKAGE_VERSION "${_sdl_major}.${_sdl_minor}.${_sdl_micro}")
else()
    message(AUTHOR_WARNING "Could not extract version from SDL3/SDL_version.h.")
    return()
endif()

if(PACKAGE_FIND_VERSION_RANGE)
    # Package version must be in the requested version range
    if ((PACKAGE_FIND_VERSION_RANGE_MIN STREQUAL "INCLUDE" AND PACKAGE_VERSION VERSION_LESS PACKAGE_FIND_VERSION_MIN)
        OR ((PACKAGE_FIND_VERSION_RANGE_MAX STREQUAL "INCLUDE" AND PACKAGE_VERSION VERSION_GREATER PACKAGE_FIND_VERSION_MAX)
        OR (PACKAGE_FIND_VERSION_RANGE_MAX STREQUAL "EXCLUDE" AND PACKAGE_VERSION VERSION_GREATER_EQUAL PACKAGE_FIND_VERSION_MAX)))
        set(PACKAGE_VERSION_COMPATIBLE FALSE)
    else()
        set(PACKAGE_VERSION_COMPATIBLE TRUE)
    endif()
else()
    if(PACKAGE_VERSION VERSION_LESS PACKAGE_FIND_VERSION)
        set(PACKAGE_VERSION_COMPATIBLE FALSE)
    else()
        set(PACKAGE_VERSION_COMPATIBLE TRUE)
        if(PACKAGE_FIND_VERSION STREQUAL PACKAGE_VERSION)
            set(PACKAGE_VERSION_EXACT TRUE)
        endif()
    endif()
endif()

# if the using project doesn't have CMAKE_SIZEOF_VOID_P set, fail.
if("${CMAKE_SIZEOF_VOID_P}" STREQUAL "")
    set(PACKAGE_VERSION_UNSUITABLE TRUE)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/sdlcpu.cmake")
SDL_DetectTargetCPUArchitectures(_detected_archs)

# check that the installed version has a compatible architecture as the one which is currently searching:
if(NOT(SDL_CPU_X86 OR SDL_CPU_X64 OR SDL_CPU_ARM64 OR SDL_CPU_ARM64EC))
    set(PACKAGE_VERSION "${PACKAGE_VERSION} (X86,X64,ARM64)")
    set(PACKAGE_VERSION_UNSUITABLE TRUE)
endif()
