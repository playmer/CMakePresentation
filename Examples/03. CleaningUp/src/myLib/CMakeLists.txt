# add_library will create a project that outputs an executable, we're using
# a "" here because prior to 3.11 the add_executable command requires at least
# an empty string to search for files. We could just add main.cpp here, but we
# want to get in the habit of using target_sources.
add_library(myLib "")

# target_include_directories will add an include directory to the given target.
# This is useful because we're intentionally using PUBLIC so that anything 
# (in this case myExe) that depends on myLib can see the header files/folders
# in the given directory.
#
# Notice that in this case, the given directory is actually a variable, we're
# using CMAKE_CURRENT_LIST_DIR which is an implcit variable in CMake, it allows
# retrieivng the directory of the current list file. the ${} syntax can be
# thought of as a way to dereference the variable name, and getting the value
# it points to.
target_include_directories(myLib PUBLIC ${CMAKE_CURRENT_LIST_DIR})

# We use target_sources to explicitly say what files we want to add, and also
# to not muddle the add_executable command with extra information. The PRIVATE
# exists to state that we don't want these files included in any targets that
# dependes on the myLib target through a command like target_link_libraries.
#
# Note that we must begin the command by passing in the target to which we're
# adding files too.
target_sources(myLib 
    PRIVATE 
        myLib.hpp
        myLib.cpp
)

# We defined glfwStatic as a global, so we can reference it here to link to it.
# We also made sure to set the INTERFACE_INCLUDE_DIRECTORIES on the IMPORTED
# target we made for it, so we don't need to do any messing around with
# include directories right here.
target_link_libraries(myLib
    PRIVATE 
    glfwStatic
)

# Conditionals in CMake! They don't add a scope, so be wary. This is also a
# newer way of checking if we're compiling with MSVC, you might also see 
# something like: if (${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC) which also 
# works.
if (MSVC)
    # We want to set some MSVC specific flags, so we're just setting
    # permissive- so the compiler is as standards compliant as it can be
    # and std:c++17 so we get all the fancy new fully standardized features
    # they have availible for us.
    target_compile_options(myLib PRIVATE 
        PUBLIC
            -permissive- -std:c++17
    )
endif()