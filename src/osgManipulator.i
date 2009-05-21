%module osgManipulator

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


#include <osgManipulator/AntiSquish>
#include <osgManipulator/Command>
#include <osgManipulator/CommandManager>
#include <osgManipulator/Constraint>
#include <osgManipulator/Dragger>
#include <osgManipulator/Projector>
#include <osgManipulator/RotateCylinderDragger>
#include <osgManipulator/RotateSphereDragger>
#include <osgManipulator/Scale1DDragger>
#include <osgManipulator/Scale2DDragger>
#include <osgManipulator/ScaleAxisDragger>
#include <osgManipulator/Selection>
#include <osgManipulator/TabBoxDragger>
#include <osgManipulator/TabPlaneDragger>
#include <osgManipulator/TabPlaneTrackballDragger>
#include <osgManipulator/TrackballDragger>
#include <osgManipulator/Translate1DDragger>
#include <osgManipulator/Translate2DDragger>
#include <osgManipulator/TranslateAxisDragger>
#include <osgManipulator/TranslatePlaneDragger>

using namespace osg;

%}


/* remove the linkage macros */
%define OSG_EXPORT
%enddef
%define OSGMANIPULATOR_EXPORT
%enddef

// ignore nested stuff




/* include the actual headers */
%include osgManipulator/Selection
%include osgManipulator/AntiSquish
%include osgManipulator/Command
%include osgManipulator/Dragger
%include osgManipulator/CommandManager
%include osgManipulator/Constraint
%include osgManipulator/Projector
%include osgManipulator/RotateCylinderDragger
%include osgManipulator/RotateSphereDragger
%include osgManipulator/Scale1DDragger
%include osgManipulator/Scale2DDragger
%include osgManipulator/ScaleAxisDragger
%include osgManipulator/TabBoxDragger
%include osgManipulator/TabPlaneDragger
%include osgManipulator/TabPlaneTrackballDragger
%include osgManipulator/TrackballDragger
%include osgManipulator/Translate1DDragger
%include osgManipulator/Translate2DDragger
%include osgManipulator/TranslateAxisDragger
%include osgManipulator/TranslatePlaneDragger

%inline %{
osgManipulator::Dragger *NodeToDragger(osg::Node *d) {
  return dynamic_cast<osgManipulator::Dragger*>(d);
}
%}

%inline %{
osgManipulator::Selection *NodeToSelection(osg::Node *d) {
  return dynamic_cast<osgManipulator::Selection*>(d);
}
%}




