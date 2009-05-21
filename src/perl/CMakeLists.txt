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

# Build a swig module for perl
INCLUDE(${SWIG_USE_FILE})

## additional include directories
INCLUDE_DIRECTORIES(
	${OSG_INCLUDE_DIR}
)

SET(CMAKE_SWIG_FLAGS "")

FIND_PACKAGE(PerlLibs)
INCLUDE_DIRECTORIES(
	${PERL_INCLUDE_PATH}
)

##set and create the output dir
SET(OUTPUT_LIBDIR ${PROJECT_BINARY_DIR}/lib/perl)
MAKE_DIRECTORY(${OUTPUT_LIBDIR})
SET(LIBRARY_OUTPUT_PATH ${OUTPUT_LIBDIR})
SET(CMAKE_SWIG_OUTDIR ${OUTPUT_LIBDIR})

SET_SOURCE_FILES_PROPERTIES(osg.i osgUtil.i osgFX.i osgDB.i osgGA.i osgViewer.i PROPERTIES CPLUSPLUS TRUE)
SET_SOURCE_FILES_PROPERTIES(osg.i PROPERTIES SWIG_FLAGS "-make_default")

SET(SWIGLINKLIBS ${OSG_LIBRARY} ${PERL_LIBRARY} ${OPENTHREADS_LIBRARY} ${OPENGL_LIBRARIES})

SWIG_ADD_MODULE(osg-perl perl osg.i)
SWIG_LINK_LIBRARIES(osg-perl ${SWIGLINKLIBS})
SET_TARGET_PROPERTIES(osg-perl PROPERTIES OUTPUT_NAME osg)

SWIG_ADD_MODULE(osgUtil-perl perl osgUtil.i)
SWIG_LINK_LIBRARIES(osgUtil-perl ${SWIGLINKLIBS} ${OSGUTIL_LIBRARY})
SET_TARGET_PROPERTIES(osgUtil-perl PROPERTIES OUTPUT_NAME osgUtil)

SWIG_ADD_MODULE(osgFX-perl perl osgFX.i)
SWIG_LINK_LIBRARIES(osgFX-perl ${SWIGLINKLIBS} ${OSGUTIL_LIBRARY} ${OSGDB_LIBRARY} ${OSGFX_LIBRARY})
SET_TARGET_PROPERTIES(osgFX-perl PROPERTIES OUTPUT_NAME osgFX)

SWIG_ADD_MODULE(osgDB-perl perl osgDB.i)
SWIG_LINK_LIBRARIES(osgDB-perl ${SWIGLINKLIBS} ${OSGDB_LIBRARY})
SET_TARGET_PROPERTIES(osgDB-perl PROPERTIES OUTPUT_NAME osgDB)

SWIG_ADD_MODULE(osgGA-perl perl osgGA.i)
SWIG_LINK_LIBRARIES(osgGA-perl ${SWIGLINKLIBS} ${OSGGA_LIBRARY})
SET_TARGET_PROPERTIES(osgGA-perl PROPERTIES OUTPUT_NAME osgGA)

SWIG_ADD_MODULE(osgViewer-perl perl osgViewer.i)
SWIG_LINK_LIBRARIES(osgViewer-perl ${SWIGLINKLIBS} ${OSGGA_LIBRARY} ${OSGVIEWER_LIBRARY})
SET_TARGET_PROPERTIES(osgViewer-perl PROPERTIES OUTPUT_NAME osgViewer)

