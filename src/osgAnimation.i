%module osgAnimation

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

%include "std_vector.i"
%include "std_map.i"
%include "std_pair.i"
%include "std_string.i"

%{
#include <osgAnimation/Animation>
#include <osgAnimation/AnimationManagerBase>
#include <osgAnimation/BasicAnimationManager>
#include <osgAnimation/Bone>
#include <osgAnimation/Channel>
#include <osgAnimation/CubicBezier>
#include <osgAnimation/EaseMotion>
#include <osgAnimation/Export>
#include <osgAnimation/Interpolator>
#include <osgAnimation/Keyframe>
#include <osgAnimation/LinkVisitor>
#include <osgAnimation/RigGeometry>
#include <osgAnimation/Sampler>
#include <osgAnimation/Skeleton>
#include <osgAnimation/Skinning>
#include <osgAnimation/Target>
#include <osgAnimation/Timeline>
#include <osgAnimation/TimelineAnimationManager>
#include <osgAnimation/UpdateCallback>
#include <osgAnimation/Vec3Packed>
#include <osgAnimation/VertexInfluence>

//using namespace osg;

%}

// remove the linkage macros
%define OSG_EXPORT
%enddef
%define OSGANIMATION_EXPORT
%enddef

// ignore nested stuff

// not sure why this needs ignoring but it generates an undefined symbol if it isn't ignored
%ignore osgAnimation::Bone::needLink;

%inline %{

static osgAnimation::Bone *dynamic_cast_Bone(osg::Node *node) {
    return dynamic_cast<osgAnimation::Bone *>(node);
}

static osgAnimation::Skeleton *dynamic_cast_Skeleton(osg::Node *node) {
    return dynamic_cast<osgAnimation::Skeleton *>(node);
}

static osgAnimation::RigGeometry *dynamic_cast_RigGeometry(osg::Geometry *geometry) {
    return dynamic_cast<osgAnimation::RigGeometry *>(geometry);
}

static osgAnimation::Bone *fromBoneMap(osgAnimation::Bone::BoneMap *pBoneMap, std::string name) {
    return (*pBoneMap)[name];
}

static osgAnimation::VertexInfluence *fromVertexInfluenceMap(osgAnimation::VertexInfluenceMap *pVIMap, std::string name) {
    return &(*pVIMap)[name];
}

static std::vector<std::pair<int, float> > *asVertexList(osgAnimation::VertexInfluence *pVI) {
    return pVI;
}

// typedefs
typedef std::pair<int, float> VertexIndexWeight;
typedef std::vector<std::pair<int, float> > VertexList;
typedef osgAnimation::TemplateKeyframe<osg::Quat> QuatKeyframe;
typedef osgAnimation::TemplateKeyframeContainer<osg::Quat> QuatKeyframeContainer;
typedef osgAnimation::TemplateSphericalLinearInterpolator<osg::Quat, osg::Quat> QuatSphericalLinearInterpolator;
typedef osgAnimation::TemplateSampler<QuatSphericalLinearInterpolator> QuatSphericalLinearSampler;
typedef osgAnimation::TemplateChannel<QuatSphericalLinearSampler> QuatSphericalLinearChannel;

%}


// include the actual headers
//%include osgAnimation/Assert
//%include osgAnimation/Vec3Packed
%include osgAnimation/Bone
%include osgAnimation/Target
%include osgAnimation/Keyframe
%include osgAnimation/Sampler
%include osgAnimation/Channel
%include osgAnimation/Animation
%include osgAnimation/Interpolator
%include osgAnimation/CubicBezier
%include osgAnimation/EaseMotion
%include osgAnimation/Skeleton
%include osgAnimation/RigGeometry
%include osgAnimation/Skinning
%include osgAnimation/UpdateCallback
%include osgAnimation/AnimationManagerBase
%include osgAnimation/BasicAnimationManager
//%include osgAnimation/Timeline
//%include osgAnimation/TimelineAnimationManager
//%include osgAnimation/Export
//%include osgAnimation/LinkVisitor

//templates
//To make definitions work
%template() std::vector<osgAnimation::TemplateKeyframe<osg::Quat> >;
%template() osgAnimation::TemplateInterpolatorBase< osg::Quat,osg::Quat >;
%template() std::map< std::string,osgAnimation::VertexInfluence >;
//To Use
%template(VertexIndexWeight) std::pair<int, float>;
%template(VertexList) std::vector<std::pair<int, float> >;
%template(QuatKeyframe) osgAnimation::TemplateKeyframe<osg::Quat>;
%template(QuatKeyframeContainer) osgAnimation::TemplateKeyframeContainer<osg::Quat>;
%template(QuatSphericalLinearInterpolator) osgAnimation::TemplateSphericalLinearInterpolator<osg::Quat, osg::Quat>;
%template(QuatSphericalLinearSampler) osgAnimation::TemplateSampler<QuatSphericalLinearInterpolator>;
%template(QuatSphericalLinearChannel) osgAnimation::TemplateChannel<QuatSphericalLinearSampler>;

%include osgAnimation/VertexInfluence


