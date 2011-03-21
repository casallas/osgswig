%{
#include <osgGA/Export>
#include <osgGA/Version>
#include <osgGA/EventQueue>
#include <osgGA/EventVisitor>
#include <osgGA/GUIActionAdapter>
#include <osgGA/GUIEventAdapter>
#include <osgGA/GUIEventHandler>
// #include <osgGA/GUIEventHandlerVisitor>
#include <osgGA/FlightManipulator>
// #include <osgGA/SetSceneViewVisitor>
#include <osgGA/CameraViewSwitchManipulator>
#include <osgGA/OrbitManipulator>
#include <osgGA/SphericalManipulator>
#include <osgGA/StandardManipulator>
#include <osgGA/FirstPersonManipulator>
#include <osgGA/CameraManipulator>
#include <osgGA/KeySwitchMatrixManipulator>
#include <osgGA/StateSetManipulator>
#include <osgGA/TerrainManipulator>
#include <osgGA/TrackballManipulator>
#include <osgGA/UFOManipulator>
#include <osgGA/FlightManipulator>
#include <osgGA/AnimationPathManipulator>
#include <osgGA/DriveManipulator>
#include <osgGA/NodeTrackerManipulator>

typedef osgGA::CameraManipulator::CoordinateFrameCallback CoordinateFrameCallback;
typedef osgGA::AnimationPathManipulator::AnimationCompletedCallback AnimationCompletedCallback;

%}
