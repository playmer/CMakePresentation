
#HEY CHANGE ALL OF THIS TO GLFW

# create a static library target, that is imported, meaning it is imported from
# a location, not build from source.
add_library(ZLibStatic STATIC IMPORTED) 

# set the location that we are going to import the library from
set_target_properties(
    ${libNameDebug} 
    PROPERTIES
        IMPORTED_LOCATION 
            ${CMAKE_CURRENT_LIST_DIR}/Windows/Debug/zlibd.lib
)

target_include_directories(
    ZLibStatic
    ${CMAKE_CURRENT_LIST_DIR}/include
)

