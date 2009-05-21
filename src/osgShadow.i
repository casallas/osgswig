%module osgShadow

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

#include <osgShadow/OccluderGeometry>
#include <osgShadow/ShadowedScene>
#include <osgShadow/ShadowMap>
#include <osgShadow/ShadowTechnique>
#include <osgShadow/ShadowTexture>
#include <osgShadow/ShadowVolume>
#include <osgShadow/Version>

using namespace osg;

%}


/* remove the linkage macros */
%define OSG_EXPORT
%enddef
%define OSGSHADOW_EXPORT
%enddef

// ignore nested stuff




/* include the actual headers */

// %include osgShadow/Version
%include osgShadow/OccluderGeometry
%include osgShadow/ShadowTechnique
%include osgShadow/ShadowedScene
%include osgShadow/ShadowMap
%include osgShadow/ShadowTexture
%include osgShadow/ShadowVolume

