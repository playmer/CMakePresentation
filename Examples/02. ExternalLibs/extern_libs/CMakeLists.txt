# create a static library target, that is imported, meaning it is imported from
# a location, not build from source.
add_library(glfwStatic STATIC IMPORTED GLOBAL) 

# set the location that we are going to import the library from
set_target_properties(
    glfwStatic 
    PROPERTIES
        IMPORTED_LOCATION 
            ${CMAKE_CURRENT_LIST_DIR}/lib-vc2015/glfw3.lib
)

# This should work according to docs, but I think my version is either out of
# date, or this needs to be slightly changed.
#target_include_directories(
#    glfwStatic
#    INTERFACE
#    ${CMAKE_CURRENT_LIST_DIR}/include
#)

# So instead, we're using set_target_properties to do the same job. This is a
# function that allows us to set properties manually. In this case, we're
# setting the INTERFACE_INCLUDE_DIRECTORIES property on glfwStatic.
#
# This function is very versatile and we can't possibly go over everything it
# can do. Be sure to look at the cmake properties page to see target properties
# as well as all the other properties that can be set by set_properties.
set_target_properties(glfwStatic PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_LIST_DIR}/include)
