%module(directors="1") osg

#ifdef SWIGPYTHON
// Workaround for this bug - triggered when iterating vectorNode
// http://sourceforge.net/tracker/index.php?func=detail&aid=1863647&group_id=1645&atid=101645
//
#define PySwigIterator osg_module_PySwigIterator
#endif // SWIGPYTHON

%include "globals.i"
#ifdef SWIGPYTHON
%include "osgPyExtend.i"
%include "argv.i"

//%exception {
//    try { $action }
//    catch (Swig::DirectorException &){SWIG_fail;}
//}

//std::cerr << "osgswig Swig::DirectorMethodException" << std::endl;        

//Enable exception handling in directors 
%feature("director:except") {
    if ($error != NULL) {
        PyErr_Print();
        PyErr_SetString($error, "osgswig Swig::DirectorMethodException");
    }
}

//added for VRMeer
%feature("director") osg::Group;
%feature("director") osg::Transform;
%feature("director") osg::PositionAttitudeTransform;
%feature("director") osg::MatrixTransform;
// directors - preliminary set
%feature("director") osg::NodeCallback;
%feature("director") osg::NodeVisitor;


// Experimental: Integrating Doxygen-generated docs from OSG in python docstrings
//  requires some more tooling/options to automate build
//
// %feature("docstring");
// %include "osg_doxy2swig.i"

#endif

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

%include "typemaps.i"
%include "std_vector.i"
%include "std_string.i"
%include "osg_header.i"

#if !defined(__APPLE__) 
	%include GL.i
#endif

%{

#if defined(_MSC_VER)
#pragma warning( disable: 4101 )
#endif

#include <osg/ref_ptr>


#include <osg/DeleteHandler>
#include <osg/Notify>
#include <osg/ApplicationUsage>
#include <osg/AnimationPath>
#include <osg/ArgumentParser>
#include <osg/Math>

//for osg 2.6 and up, include MixinVector
#if (OPENSCENEGRAPH_SOVERSION > 41)
#include <osg/MixinVector>
#endif

#include <osg/Array>
#include <osg/Version>
#include <osg/State>
#include <osg/StateSet>
#include <osg/StateAttribute>
#include <osg/PolygonMode>
#include <osg/Point>
#include <osg/PolygonOffset>
#include <osg/LineWidth>
#include <osg/LineStipple>
#include <osg/Material>
#include <osg/BoundingSphere>
#include <osg/BoundingBox>
#include <osg/Node>
#include <osg/Group>
#include <osg/Sequence>
#include <osg/Switch>
#include <osg/LOD>
#include <osg/PagedLOD>
#include <osg/ProxyNode>
#include <osg/MatrixTransform>
#include <osg/Projection>
#include <osg/CullSettings>
#include <osg/ColorMask>

#include <osg/Light>
#include <osg/LightModel>
#include <osg/LightSource>

#include <osg/OperationThread>
#include <osg/GraphicsThread>
#include <osg/GraphicsContext>

#include <osg/TexMat>
#include <osg/TexEnv>
#include <osg/TexEnvCombine>
#include <osg/TexEnvFilter>

#include <osg/TexGen>
#include <osg/TexGenNode>
#include <osg/ClipNode>

#include <osg/Texture>
#include <osg/Texture1D>
#include <osg/Texture2D>
#include <osg/Texture3D>
#include <osg/TextureCubeMap>
#include <osg/TextureRectangle>
#include <osg/AlphaFunc>
#include <osg/BlendFunc>
#include <osg/BlendEquation>
#include <osg/BlendColor>

#include <osg/VertexProgram>

#include <osg/Node>
#include <osg/Geode>
#include <osg/Billboard>

#include <osg/PositionAttitudeTransform>
#include <osg/AutoTransform>
#include <osg/Camera>
#include <osg/CameraNode>
#include <osg/CameraView>
#include <osg/Uniform>


#include <osg/Timer>

#if (OPENSCENEGRAPH_SOVERSION > 41)
//forward declaration of the function that will be defined further on
template<class ValueT> std::vector<ValueT> *asVectorTemplate(osg::MixinVector<ValueT> *base);
#endif

%}

%define OSG_EXPORT
%enddef

// language specific renames
#ifdef SWIGRUBY
%rename(allocatefield) osg::HeightField::allocate(unsigned int numColumns,unsigned int numRows);
#endif


#%ignore osg::ref_ptr::operator=;
#%ignore osg::ref_ptr::operator!;

%ignore osg::Referenced::operator=;
%ignore osg::ref_ptr::operator<;
%ignore osg::ref_ptr::operator==;
%ignore osg::ref_ptr::operator!=;
%ignore osg::ref_ptr::operator.;

// fix by Ren� Molenaar
//This is a little macro trick to prevent a swig error
#define X_AXIS(a,b,c) X_AXIS=Vec3f(1.0,0.0,0.0);
#define Y_AXIS(a,b,c) Y_AXIS=Vec3f(0.0,1.0,0.0);
#define Z_AXIS(a,b,c) Z_AXIS=Vec3f(0.0,0.0,1.0);

%ignore osg::Geometry::s_InvalidArrayData;

/* getRotate conversion */
%apply double *OUTPUT {double &angle, double &x, double &y, double &z};

%define VECIGNOREHELPER(name)
%ignore osg::## name::operator[];
%ignore osg::## name::operator*=;
%ignore osg::## name::operator/=;
%ignore osg::## name::operator+=;
%ignore osg::## name::operator-=;

/* ignore all by reference version */
%ignore osg::## name::x();
%ignore osg::## name::y();
%ignore osg::## name::z();
%ignore osg::## name::w();
%ignore osg::## name::r();
%ignore osg::## name::g();
%ignore osg::## name::b();
%ignore osg::## name::a();
%enddef

VECIGNOREHELPER(Vec2b)
VECIGNOREHELPER(Vec2s)
VECIGNOREHELPER(Vec2f)
VECIGNOREHELPER(Vec2d)

VECIGNOREHELPER(Vec3b)
VECIGNOREHELPER(Vec3s)
VECIGNOREHELPER(Vec3f)
VECIGNOREHELPER(Vec3d)

VECIGNOREHELPER(Vec4ub)
VECIGNOREHELPER(Vec4b)
VECIGNOREHELPER(Vec4s)
VECIGNOREHELPER(Vec4f)
VECIGNOREHELPER(Vec4d)

VECIGNOREHELPER(Quat)
%ignore osg::Quat::operator=;

// ignore override for osg::Matrix2 and osg::Matrix3
%ignore osg::Matrix2::operator ()(int,int) ;
%ignore osg::Matrix3::operator ()(int,int) ;
%ignore osg::Node::getParents() ;
%ignore osg::Uniform::getParents();

// correct override for osg::Uniform::get
%rename(get_float) osg::Uniform::get( float& ) const;
%rename(get_int) osg::Uniform::get( int&  ) const;
%rename(get_blool) osg::Uniform::get( bool&  ) const;
%rename(get_vec2) osg::Uniform::get( osg::Vec2&  ) const;
%rename(get_vec3) osg::Uniform::get( osg::Vec3&  ) const;
%rename(get_vec4) osg::Uniform::get( osg::Vec4&  ) const;
%rename(get_m2) osg::Uniform::get( osg::Matrix2&  ) const;
%rename(get_m3) osg::Uniform::get( osg::Matrix3& ) const;
%rename(get_mf) osg::Uniform::get( osg::Matrixf&  ) const;
%rename(get_m4) osg::Uniform::get( osg::Matrixd&  ) const;
%rename(get_int2) osg::Uniform::get( int& , int&  ) const;
%rename(get_int3) osg::Uniform::get( int& , int& , int&  ) const;
%rename(get_int4) osg::Uniform::get( int& , int& , int& , int&  ) const;
%rename(get_bool2) osg::Uniform::get( bool& , bool&  ) const;
%rename(get_bool3) osg::Uniform::get( bool& , bool& , bool&  ) const;
%rename(get_bool4) osg::Uniform::get( bool& , bool& , bool& , bool&  ) const;

// rename for set
%rename(set_float) osg::Uniform::set( float );
%rename(set_int) osg::Uniform::set( int  );
%rename(set_bool) osg::Uniform::set( bool  );
%rename(set_vec2) osg::Uniform::set( const osg::Vec2&  );
%rename(set_vec3) osg::Uniform::set( const osg::Vec3&  );
%rename(set_vec4) osg::Uniform::set( const osg::Vec4&  );
%rename(set_m2) osg::Uniform::set( const osg::Matrix2&  );
%rename(set_m3) osg::Uniform::set( const osg::Matrix3& );
%rename(set_m4f) osg::Uniform::set( const osg::Matrixf&  );
%rename(set_m4d) osg::Uniform::set( const osg::Matrixd&  );
%rename(set_int2) osg::Uniform::set( int , int  );
%rename(set_int3) osg::Uniform::set( int , int , int  );
%rename(set_int4) osg::Uniform::set( int , int , int , int  );
%rename(set_bool2) osg::Uniform::set( bool , bool  );
%rename(set_bool3) osg::Uniform::set( bool , bool , bool  );
%rename(set_bool4) osg::Uniform::set( bool , bool , bool , bool  );


// correct override for osg::Uniform::getElement
%rename(get_int_float) osg::Uniform::getElement( unsigned int , float&  ) const;
%rename(get_int_int) osg::Uniform::getElement( unsigned int , int&  ) const;
%rename(get_int_bool) osg::Uniform::getElement( unsigned int , bool&  ) const;
%rename(get_int_vec2) osg::Uniform::getElement( unsigned int , osg::Vec2&  ) const;
%rename(get_int_vec3) osg::Uniform::getElement( unsigned int , osg::Vec3&  ) const;
%rename(get_int_vec4) osg::Uniform::getElement( unsigned int , osg::Vec4&  ) const;
%rename(get_int_m2) osg::Uniform::getElement( unsigned int , osg::Matrix2&  ) const;
%rename(get_int_m3) osg::Uniform::getElement( unsigned int , osg::Matrix3&  ) const;
%rename(get_int_mf) osg::Uniform::getElement( unsigned int , osg::Matrixf&  ) const;
%rename(get_int_md) osg::Uniform::getElement( unsigned int , osg::Matrixd&  ) const;
%rename(get_int_int2) osg::Uniform::getElement( unsigned int , int& , int&  ) const;
%rename(get_int_int3) osg::Uniform::getElement( unsigned int , int& , int& , int&  ) const;
%rename(get_int_int4) osg::Uniform::getElement( unsigned int , int& , int& , int& , int&  ) const;
%rename(get_int_bool2) osg::Uniform::getElement( unsigned int , bool& , bool&  ) const;
%rename(get_int_bool3) osg::Uniform::getElement( unsigned int , bool& , bool& , bool& ) const;
%rename(get_int_bool4) osg::Uniform::getElement( unsigned int , bool& , bool& , bool& , bool&  ) const;


// correct override for osg::NodeVisitor::apply
%rename("apply_Node") osg::NodeVisitor::apply(Node&);
%rename("apply_Geode") osg::NodeVisitor::apply(Geode&);
%rename("apply_Billboard") osg::NodeVisitor::apply(Billboard&);
%rename("apply_Group") osg::NodeVisitor::apply(Group&);
%rename("apply_ProxyNode") osg::NodeVisitor::apply(ProxyNode&);
%rename("apply_Projection") osg::NodeVisitor::apply(Projection&);
%rename("apply_CoordinateSystemNode") osg::NodeVisitor::apply(CoordinateSystemNode&);
%rename("apply_ClipNode") osg::NodeVisitor::apply(ClipNode&);
%rename("apply_TexGenNode") osg::NodeVisitor::apply(TexGenNode&);
%rename("apply_LightSource") osg::NodeVisitor::apply(LightSource&);       
%rename("apply_Transform") osg::NodeVisitor::apply(Transform&);
%rename("apply_Camera") osg::NodeVisitor::apply(Camera&);
%rename("apply_CameraView") osg::NodeVisitor::apply(CameraView&);
%rename("apply_MatrixTransform") osg::NodeVisitor::apply(MatrixTransform&);
%rename("apply_PositionAttitudeTransform") osg::NodeVisitor::apply(PositionAttitudeTransform&);
%rename("apply_Switch") osg::NodeVisitor::apply(Switch&);
%rename("apply_Sequence") osg::NodeVisitor::apply(Sequence&);
%rename("apply_LOD") osg::NodeVisitor::apply(LOD&);
%rename("apply_PagedLOD") osg::NodeVisitor::apply(PagedLOD&);
%rename("apply_ClearNode") osg::NodeVisitor::apply(ClearNode&);
%rename("apply_OccluderNode") osg::NodeVisitor::apply(OccluderNode&);
%rename("apply_OcclusionQueryNode") osg::NodeVisitor::apply(OcclusionQueryNode&);



// mappings for matrix transform
// \TODO fix the mappings back
// %apply const& double {double& left, double& right, double& bottom, double& top, double& zNear, double& zFar};
// %apply const& double {double& fovy,  double& aspectRatio, double& zNear, double& zFar};
// %apply const& float {float& left, float& right, float& bottom, float& top, float& zNear,  float& zFar};
// %apply const& float {float& fovy,  float& aspectRatio, float& zNear, float& zFar};

%ignore osg::Matrixd::operator=;
%ignore osg::Matrixd::operator*=;

%apply double *OUTPUT { double& d};

%ignore osg::Matrixf::operator=;
%ignore osg::Matrixf::operator*=;

%ignore osg::BoundingSphereImpl::center();
%ignore osg::BoundingSphereImpl::radius();
%ignore osg::BoundingSphereImpl::radius2();

%ignore osg::BoundingBoxImpl::xMin();
%ignore osg::BoundingBoxImpl::xMax();

%ignore osg::BoundingBoxImpl::yMin();
%ignore osg::BoundingBoxImpl::yMax();

%ignore osg::BoundingBoxImpl::zMin();
%ignore osg::BoundingBoxImpl::zMax();

%ignore osg::BoundingSphere::center();
%ignore osg::BoundingSphere::radius();
%ignore osg::BoundingSphere::radius2();

%ignore osg::BoundingBox::xMin();
%ignore osg::BoundingBox::xMax();

%ignore osg::BoundingBox::yMin();
%ignore osg::BoundingBox::yMax();

%ignore osg::BoundingBox::zMin();
%ignore osg::BoundingBox::zMax();


%ignore osg::Plane::operator=;
%ignore osg::Plane::operator[];

%ignore osg::Polytope::operator=;
%ignore osg::Polytope::operator[];


%ignore osg::StateSet::setUpdateCallback;
%ignore osg::StateSet::getUpdateCallback;
%ignore osg::StateSet::setEventCallback;
%ignore osg::StateSet::getEventCallback;
%ignore osg::StateSet::Callback;

%ignore osg::StateAttribute::ModeUsage;
%ignore osg::StateAttribute::Callback;

%ignore osg::StateAttribute::setUpdateCallback;
%ignore osg::StateAttribute::getUpdateCallback;
%ignore osg::StateAttribute::setEventCallback;
%ignore osg::StateAttribute::getEventCallback;
%ignore osg::StateAttribute::getModeUsage;
%ignore osg::StateAttribute::ModeUsage;

%ignore osg::State::setDynamicObjectRenderingCompletedCallback;
%ignore osg::State::getDynamicObjectRenderingCompletedCallback;


//osg::Geometry, list of ignored Nested Classes
%ignore osg::Geometry::ArrayData;
%ignore osg::Geometry::Vec3ArrayData;

%ignore osg::Geometry::setTexCoordIndices;
%ignore osg::Geometry::getTexCoordIndices;
%ignore osg::Geometry::setVertexAttribIndices;
%ignore osg::Geometry::getVertexAttribIndices;
%ignore osg::Geometry::setVertexIndices;
%ignore osg::Geometry::getVertexIndices;
%ignore osg::Geometry::setVertexData;
%ignore osg::Geometry::getVertexData;
%ignore osg::Geometry::setNormalData;
%ignore osg::Geometry::getNormalData;
%ignore osg::Geometry::setVertexAttribData;
%ignore osg::Geometry::getVertexAttribData;
%ignore osg::Geometry::setNormalIndices;
%ignore osg::Geometry::getNormalIndices;
//%ignore osg::Geometry::setColorIndices;
//%ignore osg::Geometry::getColorIndices;
%ignore osg::Geometry::setColorData;
%ignore osg::Geometry::getColorData;
%ignore osg::Geometry::setSecondaryColorIndices;
%ignore osg::Geometry::getSecondaryColorIndices;
%ignore osg::Geometry::setSecondaryColorData;
%ignore osg::Geometry::getSecondaryColorData;
%ignore osg::Geometry::setFogCoordIndices;
%ignore osg::Geometry::getFogCoordIndices;
%ignore osg::Geometry::setFogCoordData;
%ignore osg::Geometry::getFogCoordData;
%ignore osg::Geometry::setTexCoordData;
%ignore osg::Geometry::getTexCoordData;
//%ignore osg::Geometry::set*;
//%ignore osg::Geometry::get*;

%ignore osg::TriangleMesh::setVertices;
%ignore osg::TriangleMesh::getVertices;
%ignore osg::TriangleMesh::setIndices;
%ignore osg::TriangleMesh::getIndices;

%ignore osg::BlendFunc::getExtensions;
%ignore osg::BlendFunc::setExtensions;

%ignore osg::Node::setComputeBoundingSphereCallback;
%ignore osg::Node::getComputeBoundingSphereCallback;
%ignore osg::NodeVisitor::setDatabaseRequestHandler;
%ignore osg::NodeVisitor::getDatabaseRequestHandler;
%ignore osg::NodeVisitor::setImageRequestHandler;
%ignore osg::NodeVisitor::getImageRequestHandler;

//%ignore osg::Transform::asPositionAttitudeTransform;

%ignore osg::CullSettings::ClampProjectionMatrixCallback;
%ignore osg::CullSettings::setClampProjectionMatrixCallback;
%ignore osg::CullSettings::getClampProjectionMatrixCallback;

%ignore osg::Camera::Attachment;
%ignore osg::Camera::BufferAttachmentMap;
%ignore osg::Camera::getBufferAttachmentMap;

%ignore osg::Camera::setCameraThread;
%ignore osg::Camera::getCameraThread;

%ignore osg::Camera::DrawCallback;

%ignore osg::CameraNode::Attachment;
%ignore osg::CameraNode::BufferAttachmentMap;

// more finegrain manipulation needed
%ignore osg::GraphicsThread::add;
%ignore osg::GraphicsThread::remove;
%ignore osg::GraphicsThread::getCurrentOperation;



%ignore osg::Texture::getExtensions;
%ignore osg::Texture::setExtensions;
%ignore osg::Texture::getTextureObjectManager;
%ignore osg::Texture::s_numberTextureReusedLastInLastFrame;
%ignore osg::Texture::s_numberNewTextureInLastFrame;
%ignore osg::Texture::s_numberDeletedTextureInLastFrame;

%ignore osg::Texture1D::setSubloadCallback;
%ignore osg::Texture1D::getSubloadCallback;

%ignore osg::Texture2D::setSubloadCallback;
%ignore osg::Texture2D::getSubloadCallback;

%ignore osg::Texture3D::setSubloadCallback;
%ignore osg::Texture3D::getSubloadCallback;
%ignore osg::Texture3D::getExtensions;
%ignore osg::Texture3D::setExtensions;

%ignore osg::TextureCubeMap::setSubloadCallback;
%ignore osg::TextureCubeMap::getSubloadCallback;
%ignore osg::TextureCubeMap::getExtensions;
%ignore osg::TextureCubeMap::setExtensions;

%ignore osg::TextureRectangle::setSubloadCallback;
%ignore osg::TextureRectangle::getSubloadCallback;

%ignore osg::VertexProgram::getExtensions;
%ignore osg::VertexProgram::setExtensions;

%ignore osg::BlendEquation::getExtensions;
%ignore osg::BlendEquation::setExtensions;
%ignore osg::BlendColor::getExtensions;
%ignore osg::BlendColor::setExtensions;

%ignore osg::BufferObject::getExtensions;
%ignore osg::BufferObject::setExtensions;
%ignore osg::GLBufferObject::getExtensions;
%ignore osg::GLBufferObject::setExtensions;
%ignore osg::GLBufferObject::_extensions;

%ignore osg::Point::Extensions;
%ignore osg::Point::getExtensions;
%ignore osg::Point::setExtensions;

%ignore osg::View::getSlave;
%ignore osg::View::findSlaveForCamera;

%ignore osg::ArgumentParser::read;


#ifdef SWIGPERL
%feature("ref") osg::Referenced "$this->ref();"
%feature("unref") osg::Referenced "$this->unref();"
#endif

#ifdef SWIGCSHARP
%ignore osg::Referenced::ref;
%ignore osg::Referenced::unref;
#endif

// Now the headers
%include osg/Version

#if (OPENSCENEGRAPH_SOVERSION > 41)
%include osg/Config
%feature("director") DrawCallback;
struct DrawCallback : virtual public Object
{
    DrawCallback() {}
    DrawCallback(const DrawCallback&,const CopyOp&) {}
    virtual void operator () (osg::RenderInfo& renderInfo) const;
    virtual void operator () (const osg::Camera&) const {}
};
#endif


%include osg/Notify
%include osg/Math
%extend osg::Referenced {
	
    ~Referenced() 
   {
#ifdef OSGSWIGDEBUG
     printf("osg::~Referenced Obj %x, refcount before [%d]\n",self,self->referenceCount());
#endif OSGSWIGDEBUG
     self->unref();
   }
};
#ifdef SWIGPYTHON
%feature("ref") osg::Referenced {
	$this->ref();
#ifdef OSGSWIGDEBUG
	printf("osg::Referenced::Ref   Obj %x, refcount[%d]\n",$this,$this->referenceCount());
#endif OSGSWIGDEBUG
	}
%feature("unref") osg::Referenced {
#ifdef OSGSWIGDEBUG
	printf("osg::UnRef Obj %x, refcount before [%d]\n",$this,$this->referenceCount());
#endif OSGSWIGDEBUG
	$this->unref();
	}
#endif
%include osg/Referenced
%include osg/ref_ptr

#if (OPENSCENEGRAPH_SOVERSION > 41)
%include osg/MixinVector
#endif

%include osg/DeleteHandler
%include osg/CopyOp
%include osg/Object



%include osg/Vec2s
%include osg/Vec3s
%include osg/Vec4s

%include osg/Vec4ub


%include osg/Vec2b
%include osg/Vec3b
%include osg/Vec4b

%include osg/Vec2f
%include osg/Vec3f
%include osg/Vec4f

%include osg/Vec2d
%include osg/Vec3d
%include osg/Vec4d

%include osg/Vec4
%include osg/Vec3
%include osg/Vec2

#ifdef SWIGPYTHON
%pythoncode %{
Vec2 = Vec2f
Vec3 = Vec3f
Vec4 = Vec4f
%}
#else
%{
namespace osg {
	typedef Vec2f Vec2;
	typedef Vec3f Vec3;
	typedef Vec4f Vec4;
}
%}

#include <osg/Vec2>
#include <osg/Vec2f>
#include <osg/Vec3>
#include <osg/Vec3f>
#include <osg/Vec4>
#include <osg/Vec4f>
namespace osg {
	typedef Vec2f Vec2;
	typedef Vec3f Vec3;
	typedef Vec4f Vec4;
}

#endif

//GDH, ignore operators allow one to use "Matrixd::operator()(int, int) const", (notice the const) e.g. m(1,1)
%ignore osg::Matrixd::operator()(int, int);
%ignore osg::Matrixf::operator()(int, int);

%include osg/Quat
%include osg/Matrixd
%include osg/Matrixf
%include osg/Matrix

%include osg/BoundingSphere
%include osg/Plane
%include osg/Polytope

//
%template(vectorStateSet) std::vector<osg::StateSet*>;
//RefAttributePair
%template(refStateAttribute) osg::ref_ptr< osg::StateAttribute >;

//%template(refAttributePair_) std::pair< osg::ref_ptr< osg::StateAttribute >, osg::StateAttribute::OverrideValue >);



%include osg/FrameStamp
%include osg/StateSet
%include osg/StateAttribute
%include osg/PolygonMode
%include osg/Point
%include osg/PolygonOffset
%include osg/LineWidth
%include osg/LineStipple
%include osg/LogicOp
%include osg/Material
%ignore osg::Stencil::Extensions;
%ignore osg::Stencil::getExtensions;
%ignore osg::Stencil::setExtensions; 
%include osg/Stencil
%include osg/Depth

//%include std::tm;

%include osg/TexEnv
%include osg/TexEnvCombine
%include osg/TexEnvFilter
%include osg/TexGen

%include osg/AlphaFunc
%include osg/BlendFunc
%include osg/BlendEquation
%include osg/BlendColor

%include osg/BufferObject
%ignore osg::BufferObject;
%{
typedef osg::BufferData::ModifiedCallback ModifiedCallback;
%}
//%ignore osg::BufferObject::ModifiedCallback;

%typemap(in) unsigned char * data {
    if (PyString_Check($input)) {
        Py_ssize_t len;
        char *buf;
        PyString_AsStringAndSize($input, &buf, &len);
        $1 = (unsigned char *)malloc(len);
        memcpy($1, buf, len);
    } else {
        SWIG_exception(SWIG_TypeError, "string expected");
    }
}
%typemap(typecheck) unsigned char * data = char *;

%include osg/Image
%include osg/ImageStream
%include osg/ImageSequence

%extend osg::Image {
	virtual osg::ImageStream* asImageStream() {return dynamic_cast<osg::ImageStream*>($self);}
	PyObject* dataAsString() {
	return PyString_FromStringAndSize((char *)(self)->data(), self->getImageSizeInBytes());
	}
};

%include osg/OperationThread
%include osg/GraphicsThread
%include "osg_GraphicsContext.i"

%include osg/Texture
%include osg/TexMat
%include osg/Texture1D
%include osg/Texture2D
%include osg/Texture3D
%include osg/TextureCubeMap
%include osg/TextureRectangle
%include osg/VertexProgram
%include osg/ColorMask

/*
In osg/Viewport, the return as by-reference function x() precedes the by-value function x()
we can ignore the declarations, and extend the class with calls to the by-value function
we cannot use the same names for the extensions as the original function (or one should change the header files)
note that with SWIG extend-ing, a class's "this" is not available (neither explicitly nor implicitly), 
so an explicit $self is needed for all member access, see http://www.swig.org/Doc1.3/SWIGPlus.html#SWIGPlus_class_extension 
*/

%ignore osg::Viewport::x;
%ignore osg::Viewport::y;
%ignore osg::Viewport::width;
%ignore osg::Viewport::height;
%extend osg::Viewport {	value_type getX() {return $self->x();}};
%extend osg::Viewport {	value_type getY() {return $self->y();}};
%extend osg::Viewport {	value_type getWidth() {return $self->width();}};
%extend osg::Viewport {	value_type getHeight() {return $self->height();}};
%include osg/Viewport

%ignore osg::Shader::Extensions; 
%ignore osg::Shader::getExtensions; 
%ignore osg::Shader::setExtensions; 
%ignore osg::Shader::getPCS;
%include osg/Shader

%{
    typedef osg::Shader::PerContextShader PerContextShader ;
%}

%ignore osg::Program::Extensions; 
%ignore osg::Program::getExtensions; 
%ignore osg::Program::setExtensions; 
%include osg/Program

%extend osg::Program { 
GLuint getHandle(int contextID) {
    return $self->getPCP(contextID)->getHandle();
}
GLint getUniformLocation(int contextID, std::string name) {
    return $self->getPCP(contextID)->getUniformLocation(name);
}
GLint getAttribLocation(int contextID, std::string name) {
    return $self->getPCP(contextID)->getAttribLocation(name);
}
} 

%include osg/DisplaySettings
%include osg/State
%include osg/NodeCallback

// Nodes

#if (OSG_VERSION_MAJOR > 1)
%include osg/View
%include osg/RenderInfo
#endif
%include "osg_Drawable.i"


%ignore std::tm;

%include osg/Array
%extend osg::Array {
	osg::Vec2Array* asVec2Array() {return dynamic_cast<osg::Vec2Array*>(self);}
	osg::Vec3Array* asVec3Array() {return dynamic_cast<osg::Vec3Array*>(self);}
	osg::Vec4Array* asVec4Array() {return dynamic_cast<osg::Vec4Array*>(self);}
	osg::Vec2dArray* asVec2dArray() {return dynamic_cast<osg::Vec2dArray*>(self);}
	osg::Vec3dArray* asVec3dArray() {return dynamic_cast<osg::Vec3dArray*>(self);}
	osg::Vec4dArray* asVec4dArray() {return dynamic_cast<osg::Vec4dArray*>(self);}
	osg::ShortArray* asShortArray() {return dynamic_cast<osg::ShortArray*>(self);}
	osg::IntArray* asIntArray() {return dynamic_cast<osg::IntArray*>(self);}
	osg::UByteArray* asUByteArray() {return dynamic_cast<osg::UByteArray*>(self);}
	osg::UShortArray* asUShortArray() {return dynamic_cast<osg::UShortArray*>(self);}
	osg::UIntArray* asUIntArray() {return dynamic_cast<osg::UIntArray*>(self);}
	osg::FloatArray* asFloatArray() {return dynamic_cast<osg::FloatArray*>(self);}
};

//Definition of array types which are useful in python
//for osg 2.4, use template for Array types
//for osg 2.6 and up, ignore the MixinVector (issue 12) and ignore Arrays
//it seems either patching OSG or using Joe Kilner's trick fixes MixinVectors again


%template(vectorGLshort)  std::vector<GLshort>;
%template(vectorGLint)    std::vector<GLint>;
%template(vectorGLubyte)  std::vector<GLubyte>;
%template(vectorGLushort) std::vector<GLushort>;
%template(vectorGLuint)   std::vector<GLuint>;
%template(vectorGLfloat)  std::vector<float>;       //std::vector<GLfloat>;

%template(vectorVec2)     std::vector<osg::Vec2f>;
%template(vectorVec3)     std::vector<osg::Vec3f>;
%template(vectorVec4)     std::vector<osg::Vec4f>;
%template(vectorVec2d)    std::vector<osg::Vec2d>;
%template(vectorVec3d)    std::vector<osg::Vec3d>;
%template(vectorVec4d)    std::vector<osg::Vec4d>;

%template(ShortArray)     osg::TemplateIndexArray<GLshort,osg::Array::ShortArrayType,1,GL_SHORT>;
%template(IntArray)       osg::TemplateIndexArray<GLint,osg::Array::IntArrayType,1,GL_INT>;
%template(UByteArray)     osg::TemplateIndexArray<GLubyte,osg::Array::UByteArrayType,1,GL_UNSIGNED_BYTE>;
%template(UShortArray)    osg::TemplateIndexArray<GLushort,osg::Array::UShortArrayType,1,GL_UNSIGNED_SHORT>;
%template(UIntArray)      osg::TemplateIndexArray<GLuint,osg::Array::UIntArrayType,1,GL_UNSIGNED_INT>;
%template(FloatArray)     osg::TemplateIndexArray<float,osg::Array::FloatArrayType,1,GL_FLOAT>;

%template(Vec2Array)      osg::TemplateArray<osg::Vec2,osg::Array::Vec2ArrayType,2,GL_FLOAT>;
%template(Vec3Array)      osg::TemplateArray<osg::Vec3,osg::Array::Vec3ArrayType,3,GL_FLOAT>;
%template(Vec4Array)      osg::TemplateArray<osg::Vec4,osg::Array::Vec4ArrayType,4,GL_FLOAT>;
%template(Vec2dArray)     osg::TemplateArray<osg::Vec2d,osg::Array::Vec2dArrayType,2,GL_DOUBLE>;
%template(Vec3dArray)     osg::TemplateArray<osg::Vec3d,osg::Array::Vec3dArrayType,3,GL_DOUBLE>;
%template(Vec4dArray)     osg::TemplateArray<osg::Vec4d,osg::Array::Vec4dArrayType,4,GL_DOUBLE>;

// These fail for reasons unclear  
//%template(vectorGLdouble) std::vector<double>;      //std::vector<GLdouble>;
//%template(DoubleArray)    osg::TemplateIndexArray<double,osg::Array::DoubleArrayType,1,GL_DOUBLE>;


// -----------  MixinVector Helper section ------------------------------------
#if (OPENSCENEGRAPH_SOVERSION > 41)
%{
template <class ValueT>
struct MixinVectorAccessor {
    virtual ~MixinVectorAccessor();
    std::vector<ValueT> vec;
};
%}

%inline %{
template<class ValueT> std::vector<ValueT> *asVectorTemplate(osg::MixinVector<ValueT> *base){return &(((MixinVectorAccessor<ValueT> *)base)->vec);}
std::vector<GLubyte>  *asVector(osg::DrawElementsUByte  *base){return asVectorTemplate(base);}
std::vector<GLushort> *asVector(osg::DrawElementsUShort *base){return asVectorTemplate(base);}
std::vector<GLuint>   *asVector(osg::DrawElementsUInt   *base){return asVectorTemplate(base);}
%}

%template(asVector)     asVectorTemplate<GLshort>;
%template(asVector)     asVectorTemplate<GLint>;
%template(asVector)     asVectorTemplate<GLubyte>;
%template(asVector)     asVectorTemplate<GLushort>;
%template(asVector)     asVectorTemplate<GLuint>;
%template(asVector)     asVectorTemplate<float>;         //asVectorTemplate<GLfloat>;
//%template(asGLdoubleVector) asVector<double>;          //asVectorTemplate<GLdouble>;

%template(asVector)     asVectorTemplate<osg::Vec2f>;
%template(asVector)     asVectorTemplate<osg::Vec3f>;
%template(asVector)     asVectorTemplate<osg::Vec4f>;
%template(asVector)     asVectorTemplate<osg::Vec2d>;
%template(asVector)     asVectorTemplate<osg::Vec3d>;
%template(asVector)     asVectorTemplate<osg::Vec4d>;

// This part extends every MixinVector type with some methods to directly access the underlying std::vectors

//The following macros expands to a manual definition for one templated type, e.g.
//%extend osg::TemplateArray<osg::Vec4,osg::Array::Vec4ArrayType,4,GL_FLOAT> {
//	std::vector<Vec4f>* asVector() {return asVectorTemplate(dynamic_cast<osg::MixinVector<Vec4f>*>(self));}
//};
%define MIXINVECTORHELPER( dataName, dataType, dataElements, dataSize)
%extend osg::TemplateArray<##dataName, ##dataType, ##dataElements, ##dataSize>
{
	std::vector<##dataName>* asVector() {return asVectorTemplate(dynamic_cast<osg::MixinVector<##dataName>*>(self));}
	void push_back(##dataName el) {dynamic_cast<osg::MixinVector<##dataName>*>(self)->push_back(el);}
	int size() {return dynamic_cast<osg::MixinVector<##dataName>*>(self)->size();}
};
%enddef

%define MIXINVECTORINDEXEDHELPER( dataName, dataType, dataElements, dataSize)
%extend osg::TemplateIndexArray<##dataName, ##dataType, ##dataElements, ##dataSize>
{
	std::vector<##dataName>* asVector() {return asVectorTemplate(dynamic_cast<osg::MixinVector<##dataName>*>(self));}
	void push_back(##dataName el) {dynamic_cast<osg::MixinVector<##dataName>*>(self)->push_back(el);}
	int size() {return dynamic_cast<osg::MixinVector<##dataName>*>(self)->size();}
};
%enddef

%define DRAWELEMENTSHELPER( className, dataName)
%extend osg::##className
{
	std::vector<##dataName>* asVector() {return asVectorTemplate(dynamic_cast<osg::MixinVector<##dataName>*>(self));}
	void push_back(##dataName el) {dynamic_cast<osg::MixinVector<##dataName>*>(self)->push_back(el);}
	int size() {return dynamic_cast<osg::MixinVector<##dataName>*>(self)->size();}
};
%enddef

MIXINVECTORINDEXEDHELPER ( GLshort   , osg::Array::ShortArrayType  ,1, GL_SHORT);
MIXINVECTORINDEXEDHELPER ( GLint     , osg::Array::IntArrayType    ,1, GL_INT);
MIXINVECTORINDEXEDHELPER ( GLubyte   , osg::Array::UByteArrayType  ,1, GL_UNSIGNED_BYTE);
MIXINVECTORINDEXEDHELPER ( GLushort  , osg::Array::UShortArrayType ,1, GL_UNSIGNED_SHORT);
MIXINVECTORINDEXEDHELPER ( GLuint    , osg::Array::UIntArrayType   ,1, GL_UNSIGNED_INT);
MIXINVECTORINDEXEDHELPER ( float     , osg::Array::FloatArrayType  ,1, GL_FLOAT);

MIXINVECTORHELPER ( osg::Vec2 , osg::Array::Vec2ArrayType   ,2, GL_FLOAT);
MIXINVECTORHELPER ( osg::Vec3 , osg::Array::Vec3ArrayType   ,3, GL_FLOAT);
MIXINVECTORHELPER ( osg::Vec4 , osg::Array::Vec4ArrayType   ,4, GL_FLOAT);
MIXINVECTORHELPER ( osg::Vec2d, osg::Array::Vec2dArrayType  ,2, GL_DOUBLE);
MIXINVECTORHELPER ( osg::Vec3d, osg::Array::Vec3dArrayType  ,3, GL_DOUBLE);
MIXINVECTORHELPER ( osg::Vec4d, osg::Array::Vec4dArrayType  ,4, GL_DOUBLE);

DRAWELEMENTSHELPER ( DrawElementsUByte, GLubyte);
DRAWELEMENTSHELPER ( DrawElementsUInt, GLuint);
DRAWELEMENTSHELPER ( DrawElementsUShort, GLushort);

#endif
// -----------  MixinVector Helper section ------------------------------------

%include osg/Geometry
%include osg/Shape
%include osg/ShapeDrawable

//Nodepath
%template(vectorNode) std::vector<osg::Node*>;
//ParentList
%template(vectorGroup) std::vector<osg::Group*>;
//DescriptionList
//%template(vectorString) std::vector<std::string>;
//ParentList in osg::StateSet
//%template(vectorObject) std::vector<osg::Object*>

%include osg/BoundingSphere
%include osg/BoundingBox
%include osg/Node
%include osg/Geode
%include osg/Billboard
%include osg/Group
%include osg/Sequence
%include osg/Switch
%include osg/LOD
%include osg/PagedLOD
%include osg/ProxyNode
%include osg/NodeVisitor
%include osg/Projection
%include osg/Transform
%include osg/PositionAttitudeTransform
%include osg/TexGenNode
%include osg/ClipNode

%include osg/AnimationPath
%include osg/ApplicationUsage
%include osg/ArgumentParser
%include osg/Array

%ignore osg::PrimitiveSet::Extensions; 
%ignore osg::PrimitiveSet::getExtensions; 
%ignore osg::PrimitiveSet::setExtensions;
%include osg/PrimitiveSet


%include osg/BoundingBox
%include osg/BoundingSphere
%include osg/BoundsChecking

%{
   typedef osg::BufferData::ModifiedCallback ModifiedCallback;
%}

struct ModifiedCallback : public virtual osg::Object
{
    ModifiedCallback() {}
    virtual void modified(osg::BufferData* /*bufferData*/) const {}
};

%include osg/BufferObject

%include osg/MatrixTransform
%include osg/CullSettings

%include osg/Light
%include osg/LightModel
%include osg/LightSource


#if (OSG_VERSION_MAJOR > 0)

%include osg/AutoTransform
%include osg/Camera
%{
typedef osg::Camera::DrawCallback DrawCallback;
%}
%include osg/CameraNode
%include osg/CameraView

%include osg/ComputeBoundsVisitor

// Reference stuff


%template(ImageRef) osg::ref_ptr<osg::Image>;
%template(TextureRef) osg::ref_ptr<osg::Texture>;
%template(GroupRef) osg::ref_ptr<osg::Group>;
%template(NodeRef) osg::ref_ptr<osg::Node>;
%template(TransformRef) osg::ref_ptr<osg::Transform>;
%template(GeodeRef) osg::ref_ptr<osg::Geode>;
%template(BillboardRef) osg::ref_ptr<osg::Billboard>;
%template(SwitchRef) osg::ref_ptr<osg::Switch>;
%template(LODRef) osg::ref_ptr<osg::LOD>;
%template(PagedLODRef) osg::ref_ptr<osg::PagedLOD>;
%template(ProxyNodeRef) osg::ref_ptr<osg::ProxyNode>;
%template(ProjectionRef) osg::ref_ptr<osg::Projection>;
%template(LightRef) osg::ref_ptr<osg::Light>;
%template(MatrixTransformRef) osg::ref_ptr<osg::MatrixTransform>;
%template(AutoTransformRef) osg::ref_ptr<osg::AutoTransform>;
%template(CameraNodeRef) osg::ref_ptr<osg::CameraNode>;
%template(CameraViewRef) osg::ref_ptr<osg::CameraView>;
%template(CameraRef) osg::ref_ptr<osg::Camera>;

#if (OPENSCENEGRAPH_SOVERSION > 54)
using namespace osg;
%template(BoundingBoxf) osg::BoundingBoxImpl<osg::Vec3f>;
%template(BoundingSpheref) osg::BoundingSphereImpl<osg::Vec3f>;
typedef osg::BoundingBoxf  BoundingBox;
typedef osg::BoundingSpheref  BoundingSphere;
#ifdef SWIGPYTHON
%pythoncode %{
BoundingBox = BoundingBoxf
BoundingSphere = BoundingSpheref
%}
#endif
#endif

// belongs to osg::Uniform
%apply float *OUTPUT { float& f };
%apply int   *OUTPUT { int& i };
%apply bool  *OUTPUT { bool& f };
%apply int   *OUTPUT { int& i0, int& i1 };
%apply int   *OUTPUT { int& i0, int& i1, int& i2 };
%apply int   *OUTPUT { int& i0, int& i1, int& i2, int& i3 };

%apply bool  *OUTPUT { bool& b0, bool& b1 };
%apply bool  *OUTPUT { bool& b0, bool& b1, bool& b2 };
%apply bool  *OUTPUT { bool& b0, bool& b1, bool& b2, bool& b3 };

%ignore osg::Uniform::setUpdateCallback;
%ignore osg::Uniform::getUpdateCallback;
%ignore osg::Uniform::setEventCallback;
%ignore osg::Uniform::getEventCallback;
%ignore osg::Uniform::Extensions; 
%ignore osg::Uniform::getExtensions; 
%ignore osg::Uniform::setExtensions; 
%include osg/Uniform
#endif

%include osg/Timer

//casting helpers

%inline %{
osg::Geode *NodeToGeode(osg::Node *b) {
  return dynamic_cast<osg::Geode*>(b);
}
%}

%inline %{
osg::PositionAttitudeTransform *NodeToPositionAttitudeTransform(osg::Node *b) {
  return dynamic_cast<osg::PositionAttitudeTransform*>(b);
}
%}

%inline %{
osg::MatrixTransform *NodeToMatrixTransform(osg::Node *b) {
  return dynamic_cast<osg::MatrixTransform*>(b);
}
%}

%inline %{
osg::Texture *StateAttributeToTexture(osg::StateAttribute *b) {
  return dynamic_cast<osg::Texture*>(b);
}
%}

%inline %{
osg::LOD *NodeToLOD(osg::Node *b) {
  return dynamic_cast<osg::LOD*>(b);
}
%}

%extend osg::Node {
	osg::LOD* asLOD() {return dynamic_cast<osg::LOD*>(self);}
};

%inline %{
osg::PagedLOD *NodeToPagedLOD(osg::Node *b) {
  return dynamic_cast<osg::PagedLOD*>(b);
}
%}

%extend osg::LOD {
	osg::PagedLOD* asPagedLOD() {return dynamic_cast<osg::PagedLOD*>(self);}
};

%inline %{
osg::ProxyNode *NodeToProxyNode(osg::Node *b) {
  return dynamic_cast<osg::ProxyNode*>(b);
}
%}

%inline %{
osg::Node *ReferencedToNode(osg::Referenced *b) {
  return dynamic_cast<osg::Node*>(b);
}
%}

%extend osg::Group {
	osg::ProxyNode* asProxyNode() {return dynamic_cast<osg::ProxyNode*>(self);}
};
