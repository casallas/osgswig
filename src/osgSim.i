%module osgSim

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

%include osg_header.i

/* import stuff from OpenSceneGraph */
%import osg.i




%{

#include <osgSim/BlinkSequence>
#include <osgSim/ColorRange>
#include <osgSim/DOFTransform>
#include <osgSim/ElevationSlice>
#include <osgSim/Export>
#include <osgSim/GeographicLocation>
#include <osgSim/HeightAboveTerrain>
#include <osgSim/Impostor>
#include <osgSim/ImpostorSprite>
#include <osgSim/InsertImpostorsVisitor>
#include <osgSim/LightPoint>
#include <osgSim/LightPointNode>
#include <osgSim/LightPointSystem>
#include <osgSim/LineOfSight>
#include <osgSim/MultiSwitch>
#include <osgSim/ObjectRecordData>
#include <osgSim/OverlayNode>
#include <osgSim/ScalarBar>
#include <osgSim/ScalarsToColors>
#include <osgSim/Sector>
#include <osgSim/ShapeAttribute>
#include <osgSim/SphereSegment>
#include <osgSim/Version>
#include <osgSim/VisibilityGroup>

// using namespace osg;
using namespace osgSim;

%}


/* remove the linkage macros */
%define OSG_EXPORT
%enddef
%define OSGSIM_EXPORT
%enddef

// ignore nested stuff

// something in ScalarBar upsets SWIG
%ignore osgSim::ScalarBar;
// %ignore osgSim::ScalarBar::setTextProperties;
// %ignore osgSim::ScalarBar::getTextProperties;

%ignore osgSim::SphereSegment::computeIntersection;

/* include the actual headers */

%include osgSim/BlinkSequence
%include osgSim/ColorRange
%include osgSim/DOFTransform
%include osgSim/ElevationSlice
%include osgSim/Export
%include osgSim/GeographicLocation
%include osgSim/HeightAboveTerrain
%include osgSim/Impostor
%include osgSim/ImpostorSprite
%include osgSim/InsertImpostorsVisitor
%include osgSim/LightPoint
%include osgSim/LightPointNode
%include osgSim/LightPointSystem
%include osgSim/LineOfSight
%include osgSim/MultiSwitch
%include osgSim/ObjectRecordData
%include osgSim/OverlayNode
//%include osgSim/ScalarBar
%include osgSim/ScalarsToColors
%include osgSim/Sector
%include osgSim/SphereSegment
%include osgSim/Version
%include osgSim/VisibilityGroup

