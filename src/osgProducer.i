%module osgProducer

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
%include osgGA_header.i

/* import stuff from OpenSceneGraph */
%import osg.i
%import osgGA.i


%{

#include <Producer/CameraConfig>
#include <Producer/CameraGroup>
#include <Producer/RenderSurface>
#include <osgProducer/Version>
#include <osgProducer/ViewerEventHandler>
#include <osgProducer/Viewer>

%}


/* remove the linkage macros */
%define OSG_EXPORT
%enddef
%define OSGPRODUCER_EXPORT
%enddef

/* ignore everything related to nested classes */
%ignore osgProducer::GraphicsContextImplementation::GraphicsContextImplementation(Traits* );

%ignore osgProducer::OsgSceneHandler::setClearCallback;
%ignore osgProducer::OsgSceneHandler::getClearCallback;

%ignore osgProducer::OsgSceneHandler::setCullCallback;
%ignore osgProducer::OsgSceneHandler::getCullCallback;

%ignore osgProducer::OsgSceneHandler::setDrawCallback;
%ignore osgProducer::OsgSceneHandler::getDrawCallback;

%ignore osgProducer::Viewer::realize(ThreadingModel thread_model);
%ignore osgProducer::OsgCameraGroup::setRealizeCallback;
%ignore osgProducer::OsgCameraGroup::getRealizeCallback;


/* include the actual headers */

%include "osgProducer/Version"
%include "osgProducer/GraphicsContextImplementation"
%include "osgProducer/KeyboardMouseCallback"
%include "osgProducer/OsgSceneHandler"
%include "osgProducer/OsgCameraGroup"
%include "osgProducer/Viewer"
%include "osgProducer/ViewerEventHandler"