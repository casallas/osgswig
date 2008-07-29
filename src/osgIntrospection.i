%module osgIntrospection

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

// Suppress SWIG warning
//#pragma SWIG nowarn=SWIGWARN_PARSE_NESTED_CLASS

%include "globals.i"
%include "typemaps.i"
%include "std_vector.i"
%include "std_map.i"
%include "std_string.i"
%include "std_multiset.i"

%define OSG_EXPORT
%enddef
%define OSGINTROSPECTION_EXPORT
%enddef

/* import headers */
//%include osg_header.i

/* import stuff from OpenSceneGraph */
//%import osg.i

%{
#include <osgIntrospection/CustomAttributeProvider>

#include <osgIntrospection/Utility>
#include <osgIntrospection/type_traits>
#include <osgIntrospection/Value>
#include <osgIntrospection/PublicMemberAccessor>
#include <osgIntrospection/ExtendedTypeInfo>
#include <osgIntrospection/Attributes>
#include <osgIntrospection/Comparator>
#include <osgIntrospection/ConstructorInfo>
#include <osgIntrospection/Converter>
#include <osgIntrospection/ConverterProxy>
#include <osgIntrospection/CustomAttribute>

#include <osgIntrospection/Exceptions>
#include <osgIntrospection/Export>
#include <osgIntrospection/InstanceCreator>
#include <osgIntrospection/MethodInfo>
#include <osgIntrospection/ParameterInfo>
#include <osgIntrospection/PropertyInfo>
#include <osgIntrospection/ReaderWriter>
#include <osgIntrospection/Reflection>
#include <osgIntrospection/ReflectionMacros>
#include <osgIntrospection/Reflector>
#include <osgIntrospection/StaticMethodInfo>
#include <osgIntrospection/Type>
#include <osgIntrospection/TypedConstructorInfo>
#include <osgIntrospection/TypedMethodInfo>
#include <osgIntrospection/TypeNameAliasProxy>
#include <osgIntrospection/Version>
#include <osgIntrospection/variant_cast>


using namespace osgIntrospection;

%}
%include <osgIntrospection/Utility>
%include <osgIntrospection/CustomAttributeProvider>

//Difficulties with the osgIntrospection::ExtendedTypeInfo type, SWIG cannot make stub return objects without parameters
%ignore osgIntrospection::Type::getExtendedTypeInfo;
%include <osgIntrospection/ExtendedTypeInfo>

%include <osgIntrospection/MethodInfo>
%include <osgIntrospection/PropertyInfo>
%include <osgIntrospection/ConstructorInfo>
%include <osgIntrospection/StaticMethodInfo>
%include <osgIntrospection/TypedConstructorInfo>
%include <osgIntrospection/TypedMethodInfo>
%include <osgIntrospection/ParameterInfo>

%include <osgIntrospection/CustomAttribute>
%include <osgIntrospection/Type>

%template(MethodInfoList_) std::vector<const osgIntrospection::MethodInfo* >;
%template(PropertyInfoList_) std::vector<const osgIntrospection::PropertyInfo* >;
%template(ParameterInfoList_) std::vector<const osgIntrospection::ParameterInfo* >;
%template(ConstructorInfoList_) std::vector<const osgIntrospection::ConstructorInfo* >;

// apparently there is a SWIG problem with pointer-to-consts in containers
// see SWIG Mailing list post: http://www.nabble.com/Problems-with-container-of-pointer-to-const-td18594426.html
// or this post http://thread.gmane.org/gmane.comp.programming.swig/12098/focus=12100
// or the following bug report:
// http://sourceforge.net/tracker/index.php?func=detail&aid=1550362&group_id=1645&atid=101645
// using a workaround, but apparently __getitem__ still doesn't work correctly

%{
    namespace swig {
    template <>  struct traits<osgIntrospection::MethodInfo> {
     typedef pointer_category category;
      static const char* type_name() { return "osgIntrospection::MethodInfo";}
    };
  }
%}
%{
    namespace swig {
    template <>  struct traits<osgIntrospection::PropertyInfo> {
     typedef pointer_category category;
      static const char* type_name() { return "osgIntrospection::PropertyInfo";}
    };
  }
%}
 
%{
    namespace swig {
    template <>  struct traits<osgIntrospection::ParameterInfo> {
     typedef pointer_category category;
      static const char* type_name() { return "osgIntrospection::ParameterInfo";}
    };
  }
%}
 
%{
    namespace swig {
    template <>  struct traits<osgIntrospection::ConstructorInfo> {
     typedef pointer_category category;
      static const char* type_name() { return "osgIntrospection::ConstructorInfo";}
    };
  }
%}


%{
    namespace swig {
    template <>  struct traits<osgIntrospection::Type> {
     typedef pointer_category category;
      static const char* type_name() { return "osgIntrospection::Type";}
    };
  }
%}

%template(PropertyInfoMap_) std::map<const osgIntrospection::Type*, osgIntrospection::PropertyInfoList >;
%template(MethodInfoMap_) std::map<const osgIntrospection::Type*, osgIntrospection::MethodInfoList >;

%template(EnumLabelMap_) std::map<int, std::string>;



%include <osgIntrospection/Value>
%include <osgIntrospection/Attributes>
%include <osgIntrospection/Comparator>
%include <osgIntrospection/Converter>
%include <osgIntrospection/ConverterProxy>

%include <osgIntrospection/Exceptions>
%include <osgIntrospection/InstanceCreator>
%include <osgIntrospection/PublicMemberAccessor>
%include <osgIntrospection/ReaderWriter>

%include <osgIntrospection/Reflection>

//Also here difficulties with the osgIntrospection::ExtendedTypeInfo type
//%template(TypeMapper) std::map<osgIntrospection::ExtendedTypeInfo, osgIntrospection::Type*>;

%include <osgIntrospection/ReflectionMacros>

%include <osgIntrospection/Reflector>

%include <osgIntrospection/TypeNameAliasProxy>

%include <osgIntrospection/type_traits>

%include <osgIntrospection/Version>

%include <osgIntrospection/variant_cast>


