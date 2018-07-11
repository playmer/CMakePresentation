####
# Sets the output directories for given targets. This version of this function 
# also has support for specific subdirectories for configs. Not something
# I use in production, but thought it was a nice example for multi-value 
# arguments.
####
function(multitarget_output_directory_properties)
    # NOTE: as an exercise to the reader, make the boilerplate start of variatic
    # functions a macro

    set(oneValueArgs LIBRARY_DIRECTORY RUNTIME_DIRECTORY)

    # Allow for setting specific directories per config
    # each entry should look like: "<config> <rest_of_path>"
    # e.g. "debug extrafolder/IamAString/debug/${target}"
    set(multiValueArgs SPECIFIC_CONFIG_DIRECTORIES)

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

        # get each passed config pair from our multivalue arguement
        foreach(configPair ${PARSED_SPECIFIC_CONFIG_DIRECTORIES})
            # seperate both parts of the pair
            list(GET ${configPair} 0 config)
            list(GET ${configPair} 1 restOfPath)

            set_target_properties(
            ${target}
            PROPERTIES
                ARCHIVE_OUTPUT_DIRECTORY_${config} 
                    ${PARSED_LIBRARY_DIRECTORY}/${restOfPath}
                LIBRARY_OUTPUT_DIRECTORY_${config}
                    ${PARSED_LIBRARY_DIRECTORY}/${restOfPath}
                RUNTIME_OUTPUT_DIRECTORY_${config} 
                    ${PARSED_RUNTIME_DIRECTORY}/${restOfPath}
        )

        endforeach()
    endforeach()
endfunction()

####
# Fisher has a different solution to the problem this function solves,
# this is a good example how there is no right way for how to do something,
# and depends very much on what you prioritize in your project.
####
