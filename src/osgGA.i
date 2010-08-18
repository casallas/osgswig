%module(directors="1") osgGA

#ifdef SWIGPYTHON
%feature("director") osgGA::GUIEventHandler;
#endif

#ifdef SWIGPERL
%{
#undef STATIC
#ifdef WIN32
#undef pause
#undef ERROR
#undef accept
#endif
%}
#endif

%include "globals.i"

/* import headers */
%include osg_header.i

/* import stuff from OpenSceneGraph */
%import osg.i

%include osgGA_header.i

%define OSG_EXPORT
%enddef
%define OSGGA_EXPORT
%enddef


%ignore osgGA::MatrixManipulator::setCoordinateFrameCallback;
%ignore osgGA::MatrixManipulator::getCoordinateFrameCallback;
%ignore osgGA::EventVisitor::setEvents;
%ignore osgGA::EventVisitor::getEvents;

%include osgGA/Export
%include osgGA/Version
%include osgGA/GUIActionAdapter
%include osgGA/GUIEventAdapter
%include osgGA/EventQueue
// %include osgGA/GUIEventHandlerVisitor
%include osgGA/GUIEventHandler
%include osgGA/EventVisitor
%include osgGA/FlightManipulator
// %include osgGA/SetSceneViewVisitor
%include osgGA/CameraManipulator


%{
   typedef osgGA::CameraManipulator::CoordinateFrameCallback CoordinateFrameCallback;
%}

struct CoordinateFrameCallback : public virtual osg::Referenced
{
    virtual osg::CoordinateFrame getCoordinateFrame(const osg::Vec3d& position) const = 0;
};


%include osgGA/CameraViewSwitchManipulator
%include osgGA/KeySwitchMatrixManipulator
%include osgGA/StateSetManipulator
%include osgGA/OrbitManipulator
%include osgGA/SphericalManipulator
%include osgGA/StandardManipulator
%include osgGA/TerrainManipulator
%include osgGA/TrackballManipulator
%include osgGA/UFOManipulator
%include osgGA/FirstPersonManipulator
%include osgGA/AnimationPathManipulator
%include osgGA/DriveManipulator
%include osgGA/NodeTrackerManipulator

