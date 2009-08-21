%module osgDB

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

%include std_deque.i
%include stl.i

%include typemaps.i

%include osg_header.i
%import osg.i

/* instantiate the required template specializations */
%template() std::vector<std::string>;    
 
namespace std
{
        %template(stdFilePathList) deque<string>;
}

#ifdef SWIGPYTHON
%typemap(out) osgDB::FilePathList {
    $result = PyList_New(0);
        
        if ($result == 0) return NULL;
    
    for (osgDB::FilePathList::iterator i = $1.begin(); i != $1.end(); ++i) 
        {
                PyObject * str = PyString_FromString((*i).c_str());
                if (str == 0) return NULL;
                if (PyList_Append($result, str) == -1) return NULL;
    }
}
#endif

%{

#include <osg/Version>

#include <osg/BlendFunc>
#include <osg/BlendEquation>
#include <osg/BlendColor>

#include <osgDB/Version>
#if (OPENSCENEGRAPH_SOVERSION > 40)
#include <osgDB/AuthenticationMap>
#include <osgDB/FileCache>
#endif
#include <osgDB/DatabasePager>
#include <osgDB/Registry>
#include <osgDB/WriteFile>
#include <osgDB/SharedStateManager>
#include <osgDB/ReadFile>
#include <osgDB/ReaderWriter>
#include <osgDB/Output>
#include <osgDB/ParameterOutput>
#include <osgDB/Input>
#include <osgDB/ImageOptions>
#include <osgDB/FileUtils>
#include <osgDB/FileNameUtils>
#include <osgDB/FieldReaderIterator>
#include <osgDB/FieldReader>
#include <osgDB/Field>
#include <osgDB/Export>
#include <osgDB/DynamicLibrary>
#include <osgDB/DotOsgWrapper>
#include <osgDB/DatabasePager>
#include <osgDB/Archive>

#if (OPENSCENEGRAPH_SOVERSION > 40)
using namespace osgDB;
#include <osgDB/Callbacks>
#endif

%}



%define OSG_EXPORT
%enddef
%define OSGDB_EXPORT
%enddef

%ignore osgDB::ReaderWriter;

%ignore osgDB::Registry::getReadFileCallback;
%ignore osgDB::Registry::setReadFileCallback;
%ignore osgDB::Registry::getWriteFileCallback;
%ignore osgDB::Registry::setWriteFileCallback;

%ignore osgDB::ImageOptions::_sourceImageSamplingMode;
%ignore osgDB::ImageOptions::_sourceImageWindowMode;
%ignore osgDB::ImageOptions::_sourceRatioWindow;
%ignore osgDB::ImageOptions::_sourcePixelWindow;
%ignore osgDB::ImageOptions::_destinationImageWindowMode;
%ignore osgDB::ImageOptions::_destinationRatioWindow;
%ignore osgDB::ImageOptions::_destinationPixelWindow;

%ignore osgDB::Archive::readObject;
%ignore osgDB::Archive::readImage;
%ignore osgDB::Archive::readHeightField;
%ignore osgDB::Archive::readNode;

%ignore osgDB::Archive::writeObject;
%ignore osgDB::Archive::writeImage;
%ignore osgDB::Archive::writeHeightField;
%ignore osgDB::Archive::writeNode;

%ignore osgDB::Input::read;

%ignore osgDB::DatabasePager::DatabaseThread;
%ignore osgDB::DatabasePager::getDatabaseThread;
%ignore osgDB::DatabasePager::getNumDatabaseThreads;
%ignore osgDB::DatabasePager::addDatabaseThread;


%include osg/Version
%include osgDB/Version
%include osgDB/Export

#if (OPENSCENEGRAPH_SOVERSION > 40)
%include osgDB/AuthenticationMap
%include osgDB/FileCache
#endif

%include osgDB/ReaderWriter
%include osgDB/WriteFile
%include osgDB/SharedStateManager

%typemap(out) osg::Node* {
    //  osgDB::readNodeFile(s) returns a raw Node* with 0 reference count.
    //  custom typemap to ensure a target-language-owned Node object, while increasing reference counting
    //  alternative to %newobject directive, because reference counting had to be included (?)
    if ($1)
    {
        $result = SWIG_NewPointerObj((void*)($1), $1_descriptor, SWIG_POINTER_OWN | 0);
        $1->ref();
#ifdef OSGSWIGDEBUG
        printf("osgDB::$symname:: Typemap Ref for Obj %x\n",$result);
#endif OSGSWIGDEBUG
    }
    else
    {
        SWIG_exception(SWIG_IOError,"osgDB::$symname:: Could not load file");
    }
}
 
%include osgDB/ReadFile
%typemap(out) osg::Node*;   //resets the typemap

%include osgDB/FieldReader
%include osgDB/FieldReaderIterator
%include osgDB/Input
%include osgDB/Output
%include osgDB/ParameterOutput
%include osgDB/Input
%include osgDB/ImageOptions
%include osgDB/FileUtils
%include osgDB/FileNameUtils
%include osgDB/Field
%include osgDB/DynamicLibrary
%include osgDB/DatabasePager
%include osgDB/Archive
%include osgDB/DotOsgWrapper
%include osgDB/Registry
