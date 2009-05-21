%module osgFX

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


%{

#include <osgFX/Export>
#include <osgFX/AnisotropicLighting>
#include <osgFX/BumpMapping>
#include <osgFX/Cartoon>
#include <osgFX/Effect>
#include <osgFX/MultiTextureControl>
#include <osgFX/Registry>
#include <osgFX/Scribe>
#include <osgFX/SpecularHighlights>
#include <osgFX/Technique>
#include <osgFX/Validator>

%}

%define OSG_EXPORT
%enddef
%define OSGFX_EXPORT
%enddef

%include osgFX/Export
%include osgFX/Technique
%include osgFX/Effect
%include osgFX/AnisotropicLighting
%include osgFX/BumpMapping
%include osgFX/Cartoon
%include osgFX/MultiTextureControl
%include osgFX/Registry
%include osgFX/Scribe
%include osgFX/SpecularHighlights
%include osgFX/Validator


