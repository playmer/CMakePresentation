####
# This is a modified snippet of how externals currently work for the
# Zero Engine. Extra things that only made sense in the context of the
# Zero Engine have been removed, as well as an attempt to remove anything
# that makes this file unclear. However, pieces of the solution are hacky
# looking, and you will have to make changes for your own project. This
# solution makes assumptions of external library folder structure that it can
# only make because all folder structures in the Zero Engine's Externals folder
# are consistaint.

# Anyway, this is going to attempt to get all of the external libraries
# and make them easy to add as a dependency without having to care about
# what config is being built.
####

# In this snippet the globals ${platform} and ${bit} are referenced,
# they are something I define in Zero's Platform files.
################################################################################
# Specify our list of StaticExternals (use the same name as the folder in External/)
################################################################################

# obviously, if you use this change this to a list of your static externals
set(StaticExternals 
    Assimp 
    CEF 
    Freetype 
    GL 
    GLEW 
    Libpng 
    MemoryDebugger 
    MemoryTracker 
    Nvtt 
    Opus 
    WinHid 
    ZLib
)

# list of shared (dlls)
set(SharedExternals
    Assimp
    CEF
    Freetype
    GLEW
    MemoryDebugger
    MemoryTracker
    Nvtt
)
################################################################################
# specify the include directories for each of the dependencies.
# use parent scope so the folders are accessible anywhere
################################################################################

foreach(externLib ${StaticExternals})
    set(${externLib}Headers ${${CMAKE_CURRENT_LIST_DIR}}/${externLib}/include PARENT_SCOPE)
endforeach()

################################################################################
# Set path to library folders
################################################################################

# set lib paths
set(AssimpPath ${${CMAKE_CURRENT_LIST_DIR}}/Assimp)
set(CEFPath ${${CMAKE_CURRENT_LIST_DIR}}/CEF)
set(FreetypePath ${${CMAKE_CURRENT_LIST_DIR}}/Freetype)
set(GLPath ${${CMAKE_CURRENT_LIST_DIR}}/GL)
set(GLEWPath ${${CMAKE_CURRENT_LIST_DIR}}/GLEW)
set(LibpngPath ${${CMAKE_CURRENT_LIST_DIR}}/libpng)
set(MemoryDebuggerPath ${${CMAKE_CURRENT_LIST_DIR}}/MemoryDebugger)
set(MemoryTrackerPath ${${CMAKE_CURRENT_LIST_DIR}}/MemoryTracker)
set(NvttPath ${${CMAKE_CURRENT_LIST_DIR}}/Nvtt)
set(OpusPath ${${CMAKE_CURRENT_LIST_DIR}}/Opus)
set(WinHidPath ${${CMAKE_CURRENT_LIST_DIR}}/WinHid)
set(ZLibPath ${${CMAKE_CURRENT_LIST_DIR}}/ZLib)
set(SDLPath ${${CMAKE_CURRENT_LIST_DIR}}/SDL)

################################################################################
# Find all libraries from listed dependencies and make them globally available
################################################################################

foreach(libStatic ${StaticExternals})
    #variable to easily check if an external exists
    set(${libStatic}_exists ON)

    # get lists of libraries
    if ("${bit}" STREQUAL "")
        file(GLOB ${libStatic}StaticPath ${${libStatic}Path}/lib/${platform}/*.*)
        file(GLOB ${libStatic}StaticDebugPath ${${libStatic}Path}/lib/${platform}/Debug/*.*)
        file(GLOB ${libStatic}StaticReleasePath ${${libStatic}Path}/lib/${platform}/Release/*.*)
    else()
        file(GLOB ${libStatic}StaticPath ${${libStatic}Path}/lib/${platform}/${bit}/*.*)
        file(GLOB ${libStatic}StaticDebugPath ${${libStatic}Path}/lib/${platform}/${bit}/Debug/*.*)
        file(GLOB ${libStatic}StaticReleasePath ${${libStatic}Path}/lib/${platform}/${bit}/Release/*.*)
    endif()

    if ("${${libStatic}StaticPath}"        STRGREATER "" 
     OR "${${libStatic}StaticDebugPath}"   STRGREATER ""
     OR "${${libStatic}StaticReleasePath}" STRGREATER "")

        # COMMON
        foreach(libPath ${${libStatic}StaticPath})
            #get name of library
            get_filename_component(libName ${libPath} NAME_WE)

            
            #create library using that name
            #insert into list of libraries under this name
            add_library(${libName} STATIC IMPORTED GLOBAL) 
            set_target_properties(${libName} PROPERTIES
                IMPORTED_LOCATION ${libPath}
            )
            set(${libStatic}Static ${${libStatic}Static} ${libName})
            set(${libStatic}Static ${${libStatic}Static} PARENT_SCOPE)
        endforeach()

        # DEBUG
        foreach(libPath ${${libStatic}StaticDebugPath})
            #get name of library
            get_filename_component(libNameDebug ${libPath} NAME_WE)
            set(libNameDebug ${libNameDebug}Debug)

            #create library using that name
            #insert into list of libraries under this name
            add_library(${libNameDebug} STATIC IMPORTED GLOBAL) 
            set_target_properties(${libNameDebug} PROPERTIES
                IMPORTED_LOCATION ${libPath}
            )
            set(${libStatic}Static ${${libStatic}Static} $<$<CONFIG:Debug>:${libNameDebug}>)
            set(${libStatic}Static ${${libStatic}Static} PARENT_SCOPE)
            set(${libStatic}StaticDebug ${${libStatic}StaticDebug} ${libNameDebug})
            set(${libStatic}StaticDebug ${${libStatic}StaticDebug} PARENT_SCOPE)
        endforeach()

        # RELEASE
        foreach(libPath ${${libStatic}StaticReleasePath})
            #get name of library
            get_filename_component(libNameRelease ${libPath} NAME_WE)
            set(libNameRelease ${libNameRelease}Release)

            #create library using that name
            #insert into list of libraries under this name
            add_library(${libNameRelease} STATIC IMPORTED GLOBAL) 
            set_target_properties(${libNameRelease} PROPERTIES
                IMPORTED_LOCATION ${libPath}
            )
            set(${libStatic}Static ${${libStatic}Static} $<$<CONFIG:Release>:${libNameRelease}>)
            set(${libStatic}Static ${${libStatic}Static} PARENT_SCOPE)
            set(${libStatic}StaticRelease ${${libStatic}StaticRelease} ${libNameRelease})
            set(${libStatic}StaticRelease ${${libStatic}StaticRelease} PARENT_SCOPE)
        endforeach()
    else()
        message("THE PATH: ${${libStatic}Path}/lib/${platform}/${bit}/")
        message("${${libStatic}StaticPath}")
        message(FATAL_ERROR "Unable to find any static libraries in the '${libStatic}/lib' folder in the External folder.\
         \nCheck specified path in the CMakeLists.txt file in the 'External' folder of ZeroCore.")
    endif()
endforeach()

foreach(libShared ${SharedExternals})
    # set easy variable for seeing if a lib exists
    set(${libShared}_exists ON)

    # get list of shared libraries
    file(GLOB ${libShared}SharedPath ${${libShared}Path}/bin/*.dll)

    # add the path to parent scope since we are gonna have to move them to executable directory
    set(${libShared}SharedPath ${${libShared}SharedPath} PARENT_SCOPE)

    # make sure we actually found anything
    if ("${${libShared}SharedPath}" STRGREATER "")

        set(${libShared}Shared)

        foreach(libPath ${${libShared}SharedPath})
            get_filename_component(libName ${libPath} NAME_WE)
            set(libName ${libName}Shared)

            add_library(${libName} SHARED IMPORTED GLOBAL)

            set_target_properties(
                ${libName} PROPERTIES
                IMPORTED_LOCATION ${libPath}
            )

            # set the libraries that can be added by targets
            set(${libShared}Shared ${${libShared}Shared} ${libName})
            set(${libShared}Shared ${libShared}Shared PARENT_SCOPE)

        endforeach()

    else()
        message("DLL PATH: ${${libShared}Path}/bin/*.dll")
        message("${${libShared}SharedPath}")
        message(FATAL_ERROR "Unable to find any shared libraries in the '${libShared}/bin' folder in the External folder.\
        \n Check specified path in the CMakeLists.txt file in the 'External' folder of ZeroCore.")
    endif()
endforeach()
