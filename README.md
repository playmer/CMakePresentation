CMakePresentation

(1) Hello World
    - core structure
    - demo targets
    - demo adding source
    - demo adding sub directory
    - show doing out of source builds

(2) External Libs
    - show how to import a library
    - show that target includes work on an imported library
    - show that the library actually works correctly
    - show setting target properties (include folders for glfw)

(3) Cleanup Stuff
    - show setting directory properties (VS_STARTUP_PROJECT)
    - show setting target properties (output folders)
    - compiler options
    
(4) Write a function
    have it recurse over each file on a target and print the file, as a debug function

(5) Add a command
```cmake
# copy the error dialog
add_custom_command(TARGET ${aTarget} POST_BUILD
    # executes "cmake -E copy_if_different
    COMMAND ${CMAKE_COMMAND} -E copy_if_different  
    # input file
    ${aZeroCoreDirectory}/Projects/Win32Shared/ErrorDialog.exe
    #output file
    ${aBuildOutputDirectory}/${aTarget}/ErrorDialog.exe
)
```

(6) Advanced 1: Multitarget functions, Variable functions
```cmake
#### Sets the output directories for intermediate files
# as an exercise, make the start of function as a macro
function(zero_multitarget_output_directories)
    set(oneValueArgs LIBRARY_DIRECTORY RUNTIME_DIRECTORY)
    # empty since we leave targets as "unparsed" for consistancy
    set(multiValueArgs )

    cmake_parse_arguments(PARSED "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(PARSED_TARGETS ${PARSED_UNPARSED_ARGUMENTS})

    foreach(target ${PARSED_TARGETS})
        set_target_properties(
            ${target}
            PROPERTIES
                ARCHIVE_OUTPUT_DIRECTORY ${PARSED_LIBRARY_DIRECTORY}/${target}
                LIBRARY_OUTPUT_DIRECTORY ${PARSED_LIBRARY_DIRECTORY}/${target}
                RUNTIME_OUTPUT_DIRECTORY ${PARSED_RUNTIME_DIRECTORY}/${target}
        )
    endforeach()
endfunction()
####
Fisher has a different solution to the problem this function solves, this is a good example
how there is no right way for how to do something, and depends very much on what
you prioritize in your project.

He takes one target and traverses their dependencies recursively to apply
flags.

One could envision a combination of these solutions where we took a list of
targets and traversed their dependencies recursively to apply flags and
whatnot.
####
```
    
(7) Advanced 2: Source Group

(8) Advanced 3: External Libs, No Source solution

(9) Advanced 4: External Libs, Source solution

(10)Advanced 5: Precompiled, sigh

(11)BonusTopic: PrototypeOfZeroPlatfromCMakeFiles
