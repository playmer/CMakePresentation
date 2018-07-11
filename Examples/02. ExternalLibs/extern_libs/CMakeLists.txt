
#HEY CHANGE ALL OF THIS TO GLFW

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

#target_include_directories(
#    glfwStatic
#    INTERFACE
#    ${CMAKE_CURRENT_LIST_DIR}/include
#)

set_property(TARGET glfwStatic APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_LIST_DIR}/include)
