##---------------------------------------------------------------------------
## CMakeLists.txt - OpenSceneGraphWrappers 
##
##---------------------------------------------------------------------------
##
## Based upon OpenSceneGraph CMakeLists
##
## People :
## Eric Griffith
## Gerwin de Haan
## Rene Molenaar
## Hartmut Seichter
## 
##---------------------------------------------------------------------------


IF(WIN32)
    CMAKE_MINIMUM_REQUIRED(VERSION 2.4.6 FATAL_ERROR)
ENDIF(WIN32)

# Our project is called 'osgswig' this is how it will be called in
# visual studio, and in our makefiles.
PROJECT(osgswig)

# Using full paths for link libraries (CMake 2.6)
IF(COMMAND cmake_policy)
  CMAKE_POLICY(SET CMP0003 NEW)
ENDIF(COMMAND cmake_policy)


# We want to build SONAMES shared librariess
SET(OSGSWIG_SONAMES TRUE)

# We have some custom .cmake scripts not in the official distribution.
# Maybe this can be used override existing behavior if needed?
SET(CMAKE_MODULE_PATH 
	${CMAKE_SOURCE_DIR}/CMakeModules
	${CMAKE_MODULE_PATH}
	)

# some simple parser for OSG version numbers
INCLUDE(parse_OSG_version)

# Find OpenGL
FIND_PACKAGE(OpenGL)

IF(UNIX)
    # Not sure what this will do on Cygwin and Msys
    # Also, remember OS X X11 is a user installed option so it may not exist.
    FIND_PACKAGE(X11)
    # Some Unicies need explicit linkage to the Math library or the build fails.
    FIND_LIBRARY(MATH_LIBRARY m)
    SET(CMAKE_CXX_FLAGS_RELEASE "-O2")
ENDIF(UNIX)
    
  
########################################################################################################
##### use the module to include the OpenSceneGraph files
########################################################################################################
FIND_PACKAGE(OSG) #OpenSceneGraph

check_osg_version(${OSG_INCLUDE_DIR}/osg/Version)
#
# Now we tie ourself to the OSG version numbering
# 


SET(OSGSWIG_MAJOR_VERSION ${OSG_VERSION_MAJOR})
SET(OSGSWIG_MINOR_VERSION ${OSG_VERSION_MINOR})
SET(OSGSWIG_PATCH_VERSION ${OSG_VERSION_PATCH})

SET(OSGSWIG_SOVERSION ${OSG_VERSION_SO})
MESSAGE("OSG VERSION " ${OSG_VERSION_MAJOR}.${OSG_VERSION_MINOR}.${OSG_VERSION_PATCH})

SET(OSGSWIG_VERSION ${OSGSWIG_MAJOR_VERSION}.${OSGSWIG_MINOR_VERSION}.${OSGSWIG_PATCH_VERSION})

# Optional / HITLabNZ
FIND_PACKAGE(OSGART) #osgART
FIND_PACKAGE(OSGODE) #osgODE
FIND_PACKAGE(OSGVERSE) #osgODE

# Optional / Mike Weiblen 
#FIND_PACKAGE(OSGVRPN) #osgVRPN

OPTION(BUILD_WITH_OSGART "Create wrappers for osgART (Augmented Reality Toolkit for OpenSceneGraph)" OFF)
OPTION(BUILD_WITH_OSGODE "Create wrappers for osgODE (ODE - Open Dynamics Environment for OpenSceneGraph)" OFF)
OPTION(BUILD_WITH_OSGVRPN "Create wrappers for osgVRPN (VRPN - Virtual Reality Peripherals Network)" OFF)
OPTION(BUILD_WITH_OSGVERSE "Create wrappers for osgVerse (lightweight, low latency, general-purpose network protocol for 3D data)" OFF)

OPTION(BUILD_WITH_OSGINTROSPECTION "Create wrappers for osgIntrospection (OSG's own introspection library needs to be available)" OFF)
OPTION(BUILD_WITH_OSGANIMATION     "Create wrappers for osgAnimation (available from osg 2.8)" ON)

# bug on CMake 2.6 and 2.7 on Mac 
IF (APPLE)
	SET(OSG_INCLUDE_DIR "/${OSG_INCLUDE_DIR}")
ENDIF(APPLE)


# Make the headers visible to everything
INCLUDE_DIRECTORIES(
    ${OSG_INCLUDE_DIR}
    ${osgswig_SOURCE_DIR}/include
    ${OSG_GEN_INCLUDE_DIR}
)


################################################################################
# 3rd Party Dependency Stuff


################################################################################
# Create bin and lib directories if required

IF("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   FILE(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
ENDIF("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")


################################################################################
# Installation stuff

SET(CMAKE_DEBUG_POSTFIX  "d")
SET(CMAKE_RELWITHDEBINFO_POSTFIX  "rd")

IF(UNIX AND NOT WIN32 AND NOT APPLE)
  IF(CMAKE_SIZEOF_VOID_P MATCHES "8")
      SET(LIB_POSTFIX "64" CACHE STRING "suffix for 32/64 dir placement")
      MARK_AS_ADVANCED(LIB_POSTFIX)
  ENDIF(CMAKE_SIZEOF_VOID_P MATCHES "8")
ENDIF(UNIX AND NOT WIN32 AND NOT APPLE)
IF(NOT DEFINED LIB_POSTFIX)
    SET(LIB_POSTFIX "")
ENDIF(NOT DEFINED LIB_POSTFIX)
    

SET(OUTPUT_LIBDIR ${PROJECT_BINARY_DIR}/lib)
MAKE_DIRECTORY(${OUTPUT_LIBDIR})
SET(LIBRARY_OUTPUT_PATH ${OUTPUT_LIBDIR})


################################################################################
# User Options

# Expose CMAKE_INCLUDE_PATH and CMAKE_LIBARY_PATH to the GUI so users
# may set these values without needing to manipulate the environment.
SET(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} CACHE STRING "You may add additional search paths here. Use ; to separate multiple paths.")
SET(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} CACHE STRING "You may add additional search paths here. Use ; to separate multiple paths.")
SET(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} CACHE STRING "(EXPERIMENTAL) You may add additional search paths here. Use ; to separate multiple paths.")

# Dynamic vs Static Linking
#OPTION(DYNAMIC_OSGSWIG "Set to ON to build OSGSWIG for dynamic linking.  Use OFF for static." ON)
#IF   (DYNAMIC_OSGSWIG)
#    SET(OSGSWIG_USER_DEFINED_DYNAMIC_OR_STATIC "SHARED")
#ELSE (DYNAMIC_OSGSWIG)
#    SET(OSGSWIG_USER_DEFINED_DYNAMIC_OR_STATIC "STATIC")
#ENDIF(DYNAMIC_OSGSWIG)

OPTION(VERBOSE_OSGSWIG "Set to ON to build OSGSWIG with verbose generating output.  Use OFF for simple output." ON)
IF   (VERBOSE_OSGSWIG)
    SET (CMAKE_VERBOSE_MAKEFILE "ON")
ELSE (VERBOSE_OSGSWIG)
    SET (CMAKE_VERBOSE_MAKEFILE "OFF")
ENDIF(VERBOSE_OSGSWIG)


INCLUDE(OsgMacroUtils)

# osg swig Core
ADD_SUBDIRECTORY(src)



# For Doxygen
#FIXME: I haven't figured out what to do with VRM's multiple doxyfiles 
# and footer.
#INCLUDE(${CMAKE_ROOT}/Modules/Documentation.cmake OPTIONAL)


# This needs to be run very last so other parts of the scripts can take
# advantage of this.
IF(NOT VRM_CONFIG_HAS_BEEN_RUN_BEFORE)
    SET(VRM_CONFIG_HAS_BEEN_RUN_BEFORE 1 CACHE INTERNAL "Flag to track whether this is the first time running CMake or if CMake has been configured before")
ENDIF(NOT VRM_CONFIG_HAS_BEEN_RUN_BEFORE)


#-----------------------------------------------------------------------------
### uninstall target
#-----------------------------------------------------------------------------
CONFIGURE_FILE(
  "${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules/cmake_uninstall.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
  IMMEDIATE @ONLY)
ADD_CUSTOM_TARGET(uninstall
  "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake")
