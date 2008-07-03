%module osgART

%include "globals.i"

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

%include osg_header.i

/* import stuff from OpenSceneGraph */
%import osg.i


%{
#include <osgART/Foundation>
#include <osgART/Field>
#include <osgART/Calibration>
#include <osgART/Tracker>
#include <osgART/VideoConfig>
#include <osgART/Marker>
#include <osgART/MarkerCallback>
#include <osgART/PluginManager>
#include <osgART/Video>
#include <osgART/VideoGeode>
#include <osgART/VideoLayer>
#include <osgART/VideoImageStream>
#include <osgART/TransformFilterCallback>
#include <osgART/GeometryUtils>

%}


%define OSG_EXPORT
%enddef
%define OSGART_EXPORT
%enddef

%ignore osgART::Marker::setFilterCallback;
%ignore osgART::Marker::getFilterCallback;

%newobject osgART::PluginManager::get;

%template(FieldRef) osg::ref_ptr<osgART::Field>;

%include osgART/Calibration
%include osgART/Field
%include osgART/Foundation
%include osgART/VideoConfig
%include osgART/VideoImageStream
%include osgART/Video
%include osgART/VideoGeode
%include osgART/VideoPlugin
%include osgART/Marker
%include osgART/MarkerCallback
%include osgART/Tracker
%include osgART/PluginManager
%include osgART/VideoLayer
%include osgART/TransformFilterCallback
%include osgART/Utils
%include osgART/GeometryUtils




