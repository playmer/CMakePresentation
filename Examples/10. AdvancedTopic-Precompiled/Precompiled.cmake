####
# This is a modified snippet of how defining precompiled headers works in
# Zero Engine. I have attempted to remove any globals that are specific to
# the Zero Engine's cmake files but I probably missed something. If you plan
# on using this in a project, I recommend looking at topic 06 and creating a
# multitarget wrapper around this function. Also as you can see, this is 
# currently very platform specific, I have not written a version of this
# yet for building on a platform other then windows, but the process should
# be very similar. I would recommend writting a different version for each
# platform then having a function do the platform checks to decide what to call.

# Anyway, this should go over the files in a target and set the currect
# precompiled flags, as well as set the correct precompiled flags on the target
####

# Should be run after all link targets are defined, and all sources are added.
function(example_target_precompiled_headers aTarget aIntPath aHeaderName aSourceName aSubFolder aIgnoreTarget)

    # get the soruce directory from the target, then based on options,
    # create the directory that is actually correct because stuff happens
    get_target_property(sourceDir ${aTarget} SOURCE_DIR)
    if ("${aSubFolder}" STREQUAL "")
        if (aIgnoreTarget)
            set(sourceDir ${sourceDir})
        else()
            set(sourceDir ${sourceDir}/${aTarget})
        endif()
    else()
        if (aIgnoreTarget)
            set(sourceDir ${sourceDir}/${aSubFolder})
        else()
            set(sourceDir ${sourceDir}/${aSubFolder}/${aTarget})
        endif()
    endif()

    # we use this later to compare if a source file is the precompiled file
    set(pathToSource ${sourceDir}/${aSourceName})

    # path where the pch will be output
    set(precompiledObj "${aIntPath}/${aTarget}.pch")

    # get all the source files a target has
    get_target_property(targetSources ${aTarget} SOURCES)

    # for each source file, if it is a cpp, tell it to use the precompiled,
    # if it is a cpp and it is the precompiled file, tell it to create the
    # recompiled file
    foreach (targetSource ${targetSources})
        # if this is a cpp
        if(${targetSource} MATCHES \\.\(cpp|cxx|cc\)$)
            # if it is the precompiled cpp
            if(${targetSource} STREQUAL ${pathToSource})
                set_source_files_properties(${targetSource}
                    PROPERTIES 
                        COMPILE_FLAGS "/Yc${aHeaderName} /Fp${precompiledObj}"
                        OBJECT_OUTPUTS ${precompiledObj}
                )
            # if it is every other cpp
            else()
                set_source_files_properties(${targetSource} 
                    PROPERTIES 
                        OBJECT_DEPENDS ${precompiledObj}
                        COMPILE_FLAGS "/Yu${aHeaderName} /Fp${precompiledObj}"
                )
            endif()
        endif()
    endforeach()

    target_compile_options(${aTarget} 
        PRIVATE 
            "/Yu${aHeaderName}"
            "/Fp${precompiledObj}"
    )

    # I use this just to keep track of all the targets that have precompiled
    message("Precompiled header added for target: ${aTarget}")                                    

    # used to be able to check if a project has precompiled headers
    set_property(GLOBAL PROPERTY "${aTarget}_Precompiled_Headers_Enabled" TRUE)

endfunction()
