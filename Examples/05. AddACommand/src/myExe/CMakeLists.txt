# add_executable will create a project that outputs an executable, we're using
# a "" here because prior to 3.11 the add_executable command requires at least
# an empty string to search for files. We could just add main.cpp here, but we
# want to get in the habit of using target_sources.
add_executable(myExe "")

# We use target_link_libraries to say libraries we want to add. The PRIVATE 
# attribute exists to state that all the following libraries should not be 
# included in any targets that depends on the myExe target through a call to
# target_link_libraries.
#
# Note that we must begin the command by passing in the target to which we're
# adding dependencies too.
target_link_libraries(myExe PRIVATE myLib)

target_sources(myExe PRIVATE main.cpp)

set_target_properties(
    myExe
    PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/output/lib
        LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/output/lib
        RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/output/bin
)

# As a contrived example, lets say that we want to keep a copy of the executable
# in the top level folder of the project, we can add a command to be ran
# after a build  (POST_BUILD), as a bonus, CMake gives us platform
# agnostic commands so this post build command should work everywhere

# copy the error dialog
add_custom_command(TARGET myExe POST_BUILD
    # executes "cmake -E copy_if_different
    COMMAND ${CMAKE_COMMAND} -E copy_if_different  
    # input file
    ${PROJECT_SOURCE_DIR}/output/bin/$<CONFIG>/myExe.exe
    #output file
    ${PROJECT_SOURCE_DIR}/myCopiedExe.exe
)
