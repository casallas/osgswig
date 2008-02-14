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

#include <osgART/Field>
#include <osgART/GenericTracker>
#include <osgART/VideoConfig>
#include <osgART/Marker>
// #include <osgART/MarkerCallback>
#include <osgART/PluginManager>
#include <osgART/GenericVideo>
#include <osgART/VideoLayer>
#include <osgART/VideoBillboard>
#include <osgART/VideoPlane>
#include <osgART/ShadowRenderer>
#include <osgART/PlaneARShadowRenderer>
#include <osgART/VideoImageStream>
#include <osgART/ARSceneNode>

// later version will not have this header
#include <osgART/ARTTransform>

%}


%define OSG_EXPORT
%enddef
%define OSGART_EXPORT
%enddef

%ignore osgART::Marker::setFilterCallback;
%ignore osgART::Marker::getFilterCallback;

%newobject osgART::PluginManager::get;

%template(FieldRef) osg::ref_ptr<osgART::Field>;

%include osgART/Field
%include osgART/VideoConfig
%include osgART/VideoImageStream
%include osgART/GenericVideo
%include osgART/Marker
// %include osgART/MarkerCallback
%include osgART/GenericTracker
%include osgART/GenericVideoShader
%include osgART/GenericVideoObject
%include osgART/PluginManager
%include osgART/VideoLayer
%include osgART/VideoPlane
%include osgART/VideoBillboard
%include osgART/ShadowRenderer
%include osgART/PlaneARShadowRenderer
%include osgART/ARSceneNode

// later version will not have this header
%include osgART/ARTTransform




