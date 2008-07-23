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

//added for VRMeer
%feature("director") osg::Group;
%feature("director") osg::Transform;
%feature("director") osg::PositionAttitudeTransform;
%feature("director") osg::MatrixTransform;
// directors - preliminary set
%feature("director") osg::NodeCallback;
%feature("director") osg::NodeVisitor;


//%feature("docstring");
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


typedef unsigned int GLenum;
typedef unsigned int GLuint;
typedef float GL_FLOAT;
typedef double GL_DOUBLE;
typedef int GLsizei;
typedef int GLint;
typedef unsigned char GLboolean;

%{
#include <osg/ref_ptr>

#if (OSG_VERSION_MAJOR > 1)
#include <osg/DeleteHandler>
#endif
#include <osg/Notify>
#include <osg/ApplicationUsage>
#include <osg/AnimationPath>
#include <osg/ArgumentParser>

#if (OPENSCENEGRAPH_MINOR_VERSION > 4)
#include <osg/MixinVector>
#endif

#include <osg/Array>
#include <osg/Version>
#include <osg/State>
#include <osg/StateSet>
#include <osg/StateAttribute>
#include <osg/PolygonMode>
#include <osg/Point>
#include <osg/LineWidth>
#include <osg/LineStipple>
#include <osg/Material>
#include <osg/Node>
#include <osg/Group>
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

#if (OSG_VERSION_MAJOR > 1)
#if (OSG_VERSION_MINOR > 0)
#include <osg/OperationThread>
#endif
#include <osg/GraphicsThread>
#include <osg/GraphicsContext>
#endif

#include <osg/TexMat>
#include <osg/TexEnv>
#include <osg/TexEnvCombine>
#include <osg/TexEnvFilter>

#include <osg/TexGen>
#include <osg/TexGenNode>

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

#if (OSG_VERSION_MAJOR > 0)

#include <osg/PositionAttitudeTransform>
#include <osg/AutoTransform>
#include <osg/Camera>
#include <osg/CameraNode>
#include <osg/CameraView>
#include <osg/Uniform>

#endif

#include <osg/Timer>

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


// fix by René Molenaar
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

%ignore osg::StateAttribute::setUpdateCallback;
%ignore osg::StateAttribute::getUpdateCallback;
%ignore osg::StateAttribute::setEventCallback;
%ignore osg::StateAttribute::getEventCallback;

%ignore osg::StateAttribute::getModeUsage;
%ignore osg::StateAttribute::ModeUsage;

%ignore osg::State::setDynamicObjectRenderingCompletedCallback;
%ignore osg::State::getDynamicObjectRenderingCompletedCallback;

%ignore osg::Drawable::getUpdateCallback;
%ignore osg::Drawable::setUpdateCallback;
%ignore osg::Drawable::getComputeBoundingBoxCallback;
%ignore osg::Drawable::setComputeBoundingBoxCallback;
%ignore osg::Drawable::getEventCallback;
%ignore osg::Drawable::setEventCallback;
%ignore osg::Drawable::getDrawCallback;
%ignore osg::Drawable::setDrawCallback;
%ignore osg::Drawable::getCullCallback;
%ignore osg::Drawable::setCullCallback;
%ignore osg::Drawable::supports;
%ignore osg::Drawable::accept;
%ignore osg::Drawable::getExtensions;
%ignore osg::Drawable::setExtensions;

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

%ignore osg::TriangleMesh::setVertices;
%ignore osg::TriangleMesh::getVertices;
%ignore osg::TriangleMesh::setIndices;
%ignore osg::TriangleMesh::getIndices;

//%ignore osg::Geometry::set*;
//%ignore osg::Geometry::get*;

%ignore osg::BlendFunc::getExtensions;
%ignore osg::BlendFunc::setExtensions;

%ignore osg::Node::setComputeBoundingSphereCallback;
%ignore osg::Node::getComputeBoundingSphereCallback;
%ignore osg::NodeVisitor::setDatabaseRequestHandler;
%ignore osg::NodeVisitor::getDatabaseRequestHandler;

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
%ignore osg::Camera::setPostDrawCallback;
%ignore osg::Camera::getPostDrawCallback;
%ignore osg::Camera::setPreDrawCallback;
%ignore osg::Camera::getPreDrawCallback;
%ignore osg::Camera::getInitialDrawCallback;
%ignore osg::Camera::setInitialDrawCallback;
%ignore osg::Camera::getIntialDrawCallback;
%ignore osg::Camera::setIntialDrawCallback;
%ignore osg::Camera::getFinalDrawCallback;
%ignore osg::Camera::setFinalDrawCallback;
%ignore osg::CameraNode::Attachment;
%ignore osg::CameraNode::BufferAttachmentMap;

// more finegrain manipulation needed
%ignore osg::GraphicsThread::add;
%ignore osg::GraphicsThread::remove;
%ignore osg::GraphicsThread::getCurrentOperation;

%ignore osg::GraphicsContext::add;
%ignore osg::GraphicsContext::remove;
%ignore osg::GraphicsContext::getCurrentOperation;


%ignore osg::Texture::getExtensions;
%ignore osg::Texture::setExtensions;

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

%ignore osg::GraphicsContext::setCreateGraphicsContextCallback;
%ignore osg::GraphicsContext::getCreateGraphicsContextCallback;
%ignore osg::GraphicsContext::setWindowingSystemInterface;
%ignore osg::GraphicsContext::getWindowingSystemInterface;
%ignore osg::GraphicsContext::setResizedCallback;
%ignore osg::GraphicsContext::getResizedCallback;
%ignore osg::GraphicsContext::createGraphicsContext;
%ignore osg::GraphicsContext::getTraits;

%ignore osg::BlendEquation::getExtensions;
%ignore osg::BlendEquation::setExtensions;
%ignore osg::BlendColor::getExtensions;
%ignore osg::BlendColor::setExtensions;
%ignore osg::BufferObject::getExtensions;
%ignore osg::BufferObject::setExtensions;

%ignore osg::Point::Extensions;
%ignore osg::Point::getExtensions;
%ignore osg::Point::setExtensions;

%ignore osg::View::addSlave;
%ignore osg::View::getSlave;
%ignore osg::View::removeSlave;
%ignore osg::View::findSlaveForCamera;

%ignore osg::ArgumentParser::read;


#ifdef SWIGPYTHON
%feature("ref") osg::Referenced "$this->ref();"
%feature("unref") osg::Referenced "$this->unref();"
#endif

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

%include osg/Notify

%include osg/ref_ptr
%include osg/Referenced

#if (OSG_VERSION_MAJOR > 1)
%include osg/DeleteHandler
#endif
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

%include osg/FrameStamp
%include osg/StateSet
%include osg/StateAttribute
%include osg/PolygonMode
%include osg/Point
%include osg/LineWidth
%include osg/LineStipple
%include osg/Material
%include osg/Stencil
%include osg/Depth

%include osg/TexEnv
%include osg/TexEnvCombine
%include osg/TexEnvFilter
%include osg/TexGen

%include osg/AlphaFunc
%include osg/BlendFunc
%include osg/BlendEquation
%include osg/BlendColor

%include osg/BufferObject
%include osg/Image
%include osg/ImageStream
%extend osg::Image {
	virtual osg::ImageStream* asImageStream() {return dynamic_cast<osg::ImageStream*>(self);}
};


#if (OSG_VERSION_MAJOR > 0)
#if (OSG_VERSION_MINOR > 0)
%include osg/OperationThread
#endif
%include osg/GraphicsThread
%include osg/GraphicsContext
#endif

%include osg/Texture
%include osg/TexMat
%include osg/Texture1D
%include osg/Texture2D
%include osg/Texture3D
%include osg/TextureCubeMap
%include osg/TextureRectangle
%include osg/VertexProgram
%include osg/ColorMask

// In osg/Viewport, the return as by-reference function x() precedes the by-value function x()
// we can ignore the declarations, and extend the class with calls to the by-value function
// we cannot use the same names for the extensions as the original function (or one should change the header files)
// note that with SWIG extend-ing, a class's "this" is not available (neither explicitly nor implicitly), 
// so an explicit $self is needed for all member access, see 
//  http://www.swig.org/Doc1.3/SWIGPlus.html#SWIGPlus_class_extension 
%ignore osg::Viewport::x;
%ignore osg::Viewport::y;
%ignore osg::Viewport::width;
%ignore osg::Viewport::height;
%extend osg::Viewport {	value_type getX() {return $self->x();}};
%extend osg::Viewport {	value_type getY() {return $self->y();}};
%extend osg::Viewport {	value_type getWidth() {return $self->width();}};
%extend osg::Viewport {	value_type getHeight() {return $self->height();}};
%include osg/Viewport

%include osg/Shader
%include osg/Program
%include osg/DisplaySettings
%include osg/State
%include osg/NodeCallback

// Nodes

#if (OSG_VERSION_MAJOR > 1)
%include osg/View
%include osg/RenderInfo
#endif
%include osg/Drawable


#if (OPENSCENEGRAPH_MINOR_VERSION > 4)
%include osg/MixinVector
#endif

%include osg/Array
//Definition of array types which are useful in python
%template(vectorVec2)     std::vector<osg::Vec2f>;
%template(vectorVec3)     std::vector<osg::Vec3f>;
%template(vectorVec4)     std::vector<osg::Vec4f>;
%template(vectorVec2d)    std::vector<osg::Vec2d>;
%template(vectorVec3d)    std::vector<osg::Vec3d>;
%template(vectorVec4d)    std::vector<osg::Vec4d>;
%template(vectorGLshort)  std::vector<GLshort>;
%template(vectorGLint)    std::vector<GLint>;
%template(vectorGLubyte)  std::vector<GLubyte>;
%template(vectorGLushort) std::vector<GLushort>;
%template(vectorGLuint)   std::vector<GLuint>;
%template(Vec2Array)      osg::TemplateArray<osg::Vec2,osg::Array::Vec2ArrayType,2,0x1406>;		// GL_FLOAT
%template(Vec3Array)      osg::TemplateArray<osg::Vec3,osg::Array::Vec3ArrayType,3,0x1406>;		// GL_FLOAT
%template(Vec4Array)      osg::TemplateArray<osg::Vec4,osg::Array::Vec4ArrayType,4,0x1406>;		// GL_FLOAT
%template(Vec2dArray)     osg::TemplateArray<osg::Vec2d,osg::Array::Vec2dArrayType,2,0x140A>;		// GL_DOUBLE
%template(Vec3dArray)     osg::TemplateArray<osg::Vec3d,osg::Array::Vec3dArrayType,3,0x140A>;		// GL_DOUBLE
%template(Vec4dArray)     osg::TemplateArray<osg::Vec4d,osg::Array::Vec4dArrayType,4,0x140A>;		// GL_DOUBLE
%template(ShortArray)     osg::TemplateIndexArray<GLshort,osg::Array::ShortArrayType,1,0x1402>;		// GL_SHORT
%template(IntArray)       osg::TemplateIndexArray<GLint,osg::Array::IntArrayType,1,0x1404>;		// GL_INT
%template(UByteArray)     osg::TemplateIndexArray<GLubyte,osg::Array::UByteArrayType,1,0x1401>;		// GL_UNSIGNED_BYTE
%template(UShortArray)    osg::TemplateIndexArray<GLushort,osg::Array::UShortArrayType,1,0x1403>;	// GL_UNSIGNED_SHORT
%template(UIntArray)      osg::TemplateIndexArray<GLuint,osg::Array::UIntArrayType,1,0x1405>;		// GL_UNSIGNED_INT

%include osg/Geometry
%include osg/Shape
%include osg/ShapeDrawable

//Nodepath
%template(vectorNode) std::vector<osg::Node*>;

%include osg/Node
%include osg/Geode
%include osg/Billboard
%include osg/Group
%include osg/Switch
%include osg/LOD
%include osg/PagedLOD
%include osg/ProxyNode
%include osg/NodeVisitor
%include osg/Projection
%include osg/Transform
%include osg/PositionAttitudeTransform
%include osg/TexGenNode

# %include osg/AnimationPath
%include osg/ApplicationUsage
%include osg/ArgumentParser
%include osg/Array

%include osg/PrimitiveSet


%include osg/BoundingBox
%include osg/BoundingSphere
%include osg/BoundsChecking
%include osg/BufferObject

%include osg/MatrixTransform
%include osg/CullSettings

%include osg/Light
%include osg/LightModel
%include osg/LightSource


#if (OSG_VERSION_MAJOR > 0)

%include osg/AutoTransform
%include osg/Camera
%include osg/CameraNode
%include osg/CameraView


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

%extend osg::Group {
	osg::ProxyNode* asProxyNode() {return dynamic_cast<osg::ProxyNode*>(self);}
};
