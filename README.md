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
    # copy the error dialog
    add_custom_command(TARGET ${aTarget} POST_BUILD
        # executes "cmake -E copy_if_different
        COMMAND ${CMAKE_COMMAND} -E copy_if_different  
        # input file
        ${aZeroCoreDirectory}/Projects/Win32Shared/ErrorDialog.exe
        #output file
        ${aBuildOutputDirectory}/${aTarget}/ErrorDialog.exe
    )

(6) Advanced 1: Multitarget functions, Variable functions
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
    ####
    
(7) Advanced 2: Source Group
  function(YTE_Source_Group aRoot aTarget) 
    get_target_property(targetBinaryDir ${aTarget} BINARY_DIR)
    get_target_property(targetSourceDir ${aTarget} SOURCE_DIR)
    get_target_property(targetSources ${aTarget} SOURCES)
  
    # This will determine if the given files are in a folder or not and separate 
    # them on that alone. 
    foreach(aFile ${targetSources}) 
      file(TO_CMAKE_PATH ${aFile} resultFile) 
      get_filename_component(nameComponent ${resultFile} NAME) 
      get_filename_component(fullPath ${nameComponent} ABSOLUTE) 
      
      if(IS_ABSOLUTE ${aFile})
        # It's only safe to call RELATIVE_PATH if the path begins with our "root" dir.
        string(FIND "${aFile}" "${targetSourceDir}" checkIfRelativeToSourceDir)
        string(FIND "${aFile}" "${targetBinaryDir}" checkIfRelativeToBinaryDir)
  
        if ("${checkIfRelativeToSourceDir}" EQUAL 0)
          file(RELATIVE_PATH relativePath ${targetSourceDir} ${aFile})
        elseif ("${checkIfRelativeToBinaryDir}" EQUAL 0)
          file(RELATIVE_PATH relativePath ${targetBinaryDir} ${aFile})
          set(fullPath ${targetBinaryDir}/${nameComponent})
        endif()
      else()
        set(relativePath ${aFile})
      endif()
  
      if(EXISTS ${fullPath}) 
        set(notInAFolder ${notInAFolder} ${relativePath}) 
      else()
        set(inAFolder ${inAFolder} ${relativePath}) 
      endif() 
    endforeach() 
  
    # We use a no space prefix with files from folders, otherwise the filters  
    # don't get made. 
    source_group(TREE ${${aRoot}}  
                 PREFIX "" 
                 FILES ${inAFolder}) 
  
    # We use a one space prefix with files not in folders, otherwise the files 
    # are put into "Source Files" and "Header Files" filters. 
    source_group(TREE ${${aRoot}}  
                 PREFIX " " 
                 FILES ${notInAFolder}) 
  endfunction() 


(8) Advanced 3: External Libs, No Source solution

(9) Advanced 4: External Libs, Source solution

(10)Advanced 5: Precompiled, sigh

(11)BonusTopic: PrototypeOfZeroPlatfromCMakeFiles