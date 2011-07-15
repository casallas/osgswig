find_package(OpenSceneGraph 3.0.0 REQUIRED osgDB osgViewer)
find_package(SWIG REQUIRED)
find_package(OpenGL REQUIRED)

find_path(JNI_HEADER_DIR jni.h
	/usr/lib/jvm/default-java/include/
	/usr/include
	)

include(${SWIG_USE_FILE})

include_directories(${JNI_HEADER_DIR})

set_source_files_properties(
	osg.i osgUtil.i osgFX.i osgDB.i osgGA.i osgText.i osgSim.i osgViewer.i osgManipulator.i
	PROPERTIES CPLUSPLUS TRUE)
	
SWIG_ADD_MODULE(osg java osg.i)

SWIG_LINK_LIBRARIES(osg ${SWIGLINKLIBS} ${OPENSCENEGRAPH_LIBRARIES} ${OPENGL_LIBRARIES})
