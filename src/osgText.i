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


%include std_pair.i

%include "globals.i"

%include osg_header.i

/* import stuff from OpenSceneGraph */
%import osg.i


%{
#include <osgText/Export>
#include <osgText/KerningType>
#include <osgText/TextBase>
#include <osgText/FadeText>
#include <osgText/Font>
#include <osgText/String>
#include <osgText/Text>
#include <osgText/Version>

// using namespace osg;
// using namespace osgSim;

%}


/* remove the linkage macros */
%define OSG_EXPORT
%enddef
%define OSGTEXT_EXPORT
%enddef

// ignore nested stuff

%ignore osgText::Text::getGlyphQuads;
%ignore osgText::Text::getTextureGlyphQuadMap;
%ignore osgText::Font::getKerning;
%ignore osgText::Font::getGlyph;

/* include the actual headers */
%include osgText/Export
%include osgText/String
%include osgText/Font
%include osgText/Text
%include osgText/FadeText
%include osgText/Version
%include osgText/KerningType

# %template(FontResolution) std::pair<unsigned int,unsigned int>;





