################################################################################
# Author: Joshua Shlemmer
# Copyright 2017, DigiPen Institute of Technology
# configuration for using the LLVM_2014 toolset on the windows platform
################################################################################
include(${cmake_platform_dir}/Windows.cmake)
include(${cmake_compiler_dir}/Clang.cmake)
include(${cmake_flags_dir}/MSVC_FLAGS.cmake)
include(${cmake_platform_dir}/SDLSTLEmpty.cmake)

unset(common_flags)
# override the flags because clangs hates some of the normal msvc flags
set(common_flags     
    -MP
    $<$<CONFIG:Debug>:-GS>
    $<$<CONFIG:Release>:-GS->
    $<$<CONFIG:Release>:-GL>
    -analyze-
    -W3 
    -wd"4302"
    -Zc:wchar_t
    $<$<CONFIG:Debug>:-Od>
    $<$<CONFIG:Release>:-O2>
    -Zc:inline 
    -fp:fast 
    -errorReport:prompt 
    -WX 
    -Zc:forScope 
    -GR- 
    -Gd
    $<$<CONFIG:Release>:-arch:SSE2>
    -Oy-
    $<$<CONFIG:Debug>:-MDd>
    $<$<CONFIG:Release>:-Oi>
    $<$<CONFIG:Release>:-MT>
    -EHsc 
    -nologo
    -DDEBUG  
    "-D \"_CRT_SECURE_NO_WARNINGS\"" 
    "-Wno-unused-command-line-argument"
    -FIPrecompiled.hpp
)

