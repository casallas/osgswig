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


%include osgGA/Export
%include osgGA/Version
%include osgGA/GUIActionAdapter

%ignore osgGA::GUIEventAdapter::TouchData;
%ignore osgGA::GUIEventAdapter::getTouchData;
%ignore osgGA::GUIEventAdapter::setTouchData;
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
%include osgGA/OrbitManipulator
%include osgGA/TerrainManipulator
%include osgGA/TrackballManipulator
%include osgGA/UFOManipulator
%include osgGA/FirstPersonManipulator

%include osgGA/AnimationPathManipulator
struct AnimationCompletedCallback : public virtual osg::Referenced
{
    virtual void completed(const osgGA::AnimationPathManipulator* apm) = 0;
}; 
%{
   typedef osgGA::AnimationPathManipulator::AnimationCompletedCallback AnimationCompletedCallback;
%}

%include osgGA/DriveManipulator
%include osgGA/NodeTrackerManipulator

%ignore osgGA::EventVisitor::setEvents;
%ignore osgGA::EventVisitor::getEvents;

