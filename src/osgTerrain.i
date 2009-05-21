%module osgText

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

#include <osgTerrain/Export>
#include <osgTerrain/Locator>
#include <osgTerrain/GeometryTechnique>
#include <osgTerrain/Layer>
#include <osgTerrain/TerrainNode>
#include <osgTerrain/TerrainTechnique>
#include <osgTerrain/ValidDataOperator>
#include <osgTerrain/Version>


// using namespace osg;
// using namespace osgSim;

%}


/* remove the linkage macros */
%define OSG_EXPORT
%enddef
%define OSGTERRAIN_EXPORT
%enddef

// ignore nested stuff


/* include the actual headers */

%include osgTerrain/Export
%include osgTerrain/GeometryTechnique
%include osgTerrain/Locator
%include osgTerrain/ValidDataOperator
%include osgTerrain/Layer
%include osgTerrain/TerrainTechnique
%include osgTerrain/TerrainNode
%include osgTerrain/Version

