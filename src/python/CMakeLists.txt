##---------------------------------------------------------------------------
## CMakeLists.txt - The VRmeer Library - Delft University of Technology
##
##---------------------------------------------------------------------------
## Created by René Molenaar - Aug 2007
## 
## osg python bindings
##---------------------------------------------------------------------------
FIND_PACKAGE(OpenThreads REQUIRED) 
FIND_PACKAGE(SWIG REQUIRED)

# Build a swig module for python
INCLUDE(${SWIG_USE_FILE})

## additional include directories
INCLUDE_DIRECTORIES(
	${OSG_INCLUDE_DIR}
)

FIND_PACKAGE(PythonLibs)
INCLUDE_DIRECTORIES(
	${PYTHON_INCLUDE_PATH}
)

##set and create the output dir
SET(OUTPUT_LIBDIR ${PROJECT_BINARY_DIR}/lib/python)
MAKE_DIRECTORY(${OUTPUT_LIBDIR})
SET(LIBRARY_OUTPUT_PATH ${OUTPUT_LIBDIR})
SET(CMAKE_SWIG_OUTDIR ${OUTPUT_LIBDIR})

SET(CMAKE_CURRENT_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/")

SET_SOURCE_FILES_PROPERTIES(osg.i osgUtil.i osgFX.i osgDB.i osgGA.i osgText.i osgViewer.i PROPERTIES CPLUSPLUS TRUE)
SET_SOURCE_FILES_PROPERTIES(osg.i PROPERTIES SWIG_FLAGS "-make_default")

SET(SWIGLINKLIBS ${OSG_LIBRARY} ${PYTHON_LIBRARIES} ${OPENTHREADS_LIBRARY} ${OPENGL_LIBRARIES})

SWIG_ADD_MODULE(osg python osg.i)
SWIG_LINK_LIBRARIES(osg ${SWIGLINKLIBS})

SWIG_ADD_MODULE(osgUtil python osgUtil.i)
SWIG_LINK_LIBRARIES(osgUtil ${SWIGLINKLIBS} ${OSGUTIL_LIBRARY})

SWIG_ADD_MODULE(osgFX python osgFX.i)
SWIG_LINK_LIBRARIES(osgFX ${SWIGLINKLIBS} ${OSGUTIL_LIBRARY} ${OSGDB_LIBRARY} ${OSGFX_LIBRARY})

SWIG_ADD_MODULE(osgDB python osgDB.i)
SWIG_LINK_LIBRARIES(osgDB ${SWIGLINKLIBS} ${OSGDB_LIBRARY})

SWIG_ADD_MODULE(osgGA python osgGA.i)
SWIG_LINK_LIBRARIES(osgGA ${SWIGLINKLIBS} ${OSGGA_LIBRARY})

SWIG_ADD_MODULE(osgViewer python osgViewer.i)
SWIG_LINK_LIBRARIES(osgViewer ${SWIGLINKLIBS} ${OSGGA_LIBRARY} ${OSGVIEWER_LIBRARY})

SWIG_ADD_MODULE(osgText python osgText.i)
SWIG_LINK_LIBRARIES(osgText ${SWIGLINKLIBS} ${OSGGA_LIBRARY} ${OSGTEXT_LIBRARY})

