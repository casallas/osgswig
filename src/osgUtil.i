%module osgUtil

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
%include "std_string.i"
%include "std_multiset.i"


/* import headers */
%include osg_header.i

/* import stuff from OpenSceneGraph */
%import osg.i


%{

#include <set>

#include <osgUtil/CubeMapGenerator>
#include <osgUtil/CullVisitor>
#include <osgUtil/DelaunayTriangulator>
#include <osgUtil/DisplayRequirementsVisitor>
#include <osgUtil/Export>
#include <osgUtil/GLObjectsVisitor>
#include <osgUtil/HalfWayMapGenerator>
#include <osgUtil/HighlightMapGenerator>
#include <osgUtil/IntersectVisitor>
#include <osgUtil/IntersectionVisitor>
#include <osgUtil/Optimizer>
#include <osgUtil/PositionalStateContainer>
#include <osgUtil/ReflectionMapGenerator>
#include <osgUtil/RenderBin>
#include <osgUtil/RenderLeaf>
#include <osgUtil/RenderStage>
#include <osgUtil/SceneView>
#include <osgUtil/Simplifier>
#include <osgUtil/SmoothingVisitor>
#include <osgUtil/StateGraph>
#include <osgUtil/Statistics>
#include <osgUtil/TangentSpaceGenerator>
// #include <osgUtil/Tesselator>
#include <osgUtil/TransformAttributeFunctor>
#include <osgUtil/TransformCallback>
#include <osgUtil/TriStripVisitor>
#include <osgUtil/UpdateVisitor>
#include <osgUtil/Version>
#include <osgUtil/LineSegmentIntersector>
//#include <osgUtil/PolytopeIntersector>

%}

%define OSG_EXPORT
%enddef
%define OSGUTIL_EXPORT
%enddef

%ignore osgUtil::SceneView::ComputeStereoMatricesCallback;
%ignore osgUtil::SceneView::setComputeStereoMatricesCallback;
%ignore osgUtil::SceneView::getComputeStereoMatricesCallback;

%ignore osgUtil::RenderBin::setSortCallback;
%ignore osgUtil::RenderBin::getSortCallback;
%ignore osgUtil::RenderBin::setDrawCallback;
%ignore osgUtil::RenderBin::getDrawCallback;

%ignore osgUtil::Optimizer::setIsOperationPermissibleForObjectCallback;
%ignore osgUtil::Optimizer::getIsOperationPermissibleForObjectCallback;
%ignore osgUtil::Simplifier::setContinueSimplificationCallback;
%ignore osgUtil::Simplifier::getContinueSimplificationCallback;

%include osgUtil/RenderLeaf
%include osgUtil/StateGraph
%include osgUtil/RenderBin
%include osgUtil/PositionalStateContainer
%include osgUtil/RenderStage
%include osgUtil/CubeMapGenerator
%include osgUtil/CullVisitor
%include osgUtil/DelaunayTriangulator
%include osgUtil/DisplayRequirementsVisitor
%include osgUtil/GLObjectsVisitor
%include osgUtil/HalfWayMapGenerator
%include osgUtil/HighlightMapGenerator
	
///////////////////////////////////////////////////////////////////////////////
/// Duplicate nested class from osgUtil/IntersectionVisitor
struct ReadCallback : public osg::Referenced
	{
	    virtual osg::Node* readNodeFile(const std::string& filename) = 0;
	};
%include osgUtil/IntersectionVisitor
%{
typedef osgUtil::IntersectionVisitor::ReadCallback ReadCallback;
%}

%include osgUtil/IntersectVisitor

%include osgUtil/Optimizer
%include osgUtil/ReflectionMapGenerator
%include osgUtil/SceneView
%include osgUtil/Simplifier
%include osgUtil/SmoothingVisitor
%include osgUtil/Statistics
%include osgUtil/TangentSpaceGenerator
// %include osgUtil/Tesselator
%include osgUtil/TransformAttributeFunctor
%include osgUtil/TransformCallback
%include osgUtil/TriStripVisitor
%include osgUtil/UpdateVisitor
%include osgUtil/Version

///////////////////////////////////////////////////////////////////////////////
/// Duplicate nested class from osgUtil/LineSegmentIntersector 
struct Intersection
{
    Intersection():
	ratio(-1.0),
	primitiveIndex(0) {}

    bool operator < (const Intersection& rhs) const { return ratio < rhs.ratio; }

    typedef std::vector<unsigned int>   IndexList;
    typedef std::vector<double>         RatioList;

    double                          ratio;
    osg::NodePath                   nodePath;
    osg::ref_ptr<osg::Drawable>     drawable;
    osg::ref_ptr<osg::RefMatrix>    matrix;
    osg::Vec3d                      localIntersectionPoint;
    osg::Vec3                       localIntersectionNormal;
    IndexList                       indexList;
    RatioList                       ratioList;
    unsigned int                    primitiveIndex;
    
    const osg::Vec3d& getLocalIntersectPoint() const { return localIntersectionPoint; }
    osg::Vec3d getWorldIntersectPoint() const { return matrix.valid() ? localIntersectionPoint * (*matrix) : localIntersectionPoint; }
    
    const osg::Vec3& getLocalIntersectNormal() const { return localIntersectionNormal; }
    osg::Vec3 getWorldIntersectNormal() const { return matrix.valid() ? osg::Matrix::transform3x3(osg::Matrix::inverse(*matrix),localIntersectionNormal) : localIntersectionNormal; }
};

#ifdef SWIGPYTHON
%typemap(out) osgUtil::LineSegmentIntersector::Intersections& {
    
	$result = PyList_New(0);
	
	if ($result == 0 || $1 == 0) return NULL;

    for (osgUtil::LineSegmentIntersector::Intersections::iterator i = $1->begin(); i != $1->end(); ++i) 
	{
		PyObject* obj = SWIG_NewPointerObj((new Intersection(static_cast< const Intersection& >(*i))), SWIGTYPE_p_Intersection, SWIG_POINTER_OWN |  0 );

		if (obj) 
			if (PyList_Append($result, obj) == -1) return NULL;
    }
}

#endif // SWIGPYTHON

%include osgUtil/LineSegmentIntersector


%{
typedef osgUtil::LineSegmentIntersector::Intersection Intersection;
%}


//%include osgUtil/PolytopeIntersector

