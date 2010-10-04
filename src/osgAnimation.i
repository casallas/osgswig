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
#include <osgAnimation/RigTransform>
#include <osgAnimation/Sampler>
#include <osgAnimation/Skeleton>
#include <osgAnimation/Target>
#include <osgAnimation/Timeline>
#include <osgAnimation/TimelineAnimationManager>
#include <osgAnimation/Vec3Packed>
#include <osgAnimation/VertexInfluence>

    typedef osgAnimation::VertexInfluenceMap VertexInfluenceMap; 
    typedef osgAnimation::VertexInfluenceSet VertexInfluenceSet; 
//using namespace osg;

%}

%ignore osgAnimation::RigGeometry::setRigTransformImplementation;
%ignore osgAnimation::RigGeometry::getRigTransformImplementation;

// remove the linkage macros
%define OSG_EXPORT
%enddef
%define OSGANIMATION_EXPORT
%enddef

// ignore nested stuff

//from Macports, but commented it because it broke the skinning.py example
//%ignore osgAnimation::RigGeometry::getInfluenceMap; 
//%ignore osgAnimation::RigGeometry::setInfluenceMap; 
//%ignore osgAnimation::RigGeometry::getVertexInfluenceSet; 
//%ignore osgAnimation::RigGeometry::setVertexInfluenceSet; 
//%ignore osgAnimation::RigGeometry::getRigTransformImplementation; 
//%ignore osgAnimation::RigGeometry::setRigTransformImplementation; 

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

// typedefs
typedef std::pair<int, float>                                                   VertexIndexWeight;
typedef std::vector<VertexIndexWeight>                                          VertexList;
typedef osgAnimation::TemplateKeyframe<osg::Quat>                               QuatKeyframe;
typedef osgAnimation::TemplateKeyframeContainer<osg::Quat>                      QuatKeyframeContainer;
typedef osgAnimation::TemplateSphericalLinearInterpolator<osg::Quat, osg::Quat> QuatSphericalLinearInterpolator;
typedef osgAnimation::TemplateSampler<QuatSphericalLinearInterpolator>          QuatSphericalLinearSampler;
typedef osgAnimation::TemplateChannel<QuatSphericalLinearSampler>               QuatSphericalLinearChannel;

typedef osgAnimation::TemplateKeyframe<float>                                   FloatKeyframe;
typedef osgAnimation::TemplateKeyframeContainer<float>                          FloatKeyframeContainer;


typedef osgAnimation::TemplateKeyframe<osg::Vec3f>                                   Vec3Keyframe;
typedef osgAnimation::TemplateKeyframeContainer<osg::Vec3f>                          Vec3KeyframeContainer;


typedef osgAnimation::TemplateKeyframe<osg::Vec4f>                                   Vec4Keyframe;
typedef osgAnimation::TemplateKeyframeContainer<osg::Vec4f>                          Vec4KeyframeContainer;


%}

// include the actual headers
//%include osgAnimation/Assert
//%include osgAnimation/Export
%include osgAnimation/Vec3Packed
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
%include osgAnimation/LinkVisitor
%include osgAnimation/AnimationManagerBase
%include osgAnimation/BasicAnimationManager
//%include osgAnimation/Timeline
//%include osgAnimation/TimelineAnimationManager

// Vertex Influence stuff
%template(VertexIndexWeight)               std::pair<int, float>;
%template(VertexList)                      std::vector<VertexIndexWeight>;
%template(mapVertexInfluence)              std::map< std::string, osgAnimation::VertexInfluence >;
%include osgAnimation/VertexInfluence

// Bone Map Stuff
%template(BoneMap)                         std::map< std::string, osg::ref_ptr<osgAnimation::Bone> >;

// Quat Keyframe Stuff
%template(vectorQuatKeyframe)              std::vector< QuatKeyframe >;
%template(QuatInterpolator)                osgAnimation::TemplateInterpolatorBase< osg::Quat,osg::Quat >;
%template(QuatKeyframe)                    osgAnimation::TemplateKeyframe<osg::Quat>;
%template(QuatKeyframeContainer)           osgAnimation::TemplateKeyframeContainer<osg::Quat>;
%template(QuatSphericalLinearInterpolator) osgAnimation::TemplateSphericalLinearInterpolator<osg::Quat, osg::Quat>;
%template(QuatSphericalLinearSampler)      osgAnimation::TemplateSampler<QuatSphericalLinearInterpolator>;
%template(QuatSphericalLinearChannel)      osgAnimation::TemplateChannel<QuatSphericalLinearSampler>;


%template(vectorFloatKeyframe)             std::vector< FloatKeyframe >;
%template(FloatKeyframe)                   osgAnimation::TemplateKeyframe<float>;
%template(FloatKeyframeContainer)          osgAnimation::TemplateKeyframeContainer<float>;


%template(vectorVec3Keyframe)             std::vector< Vec3Keyframe >;
%template(Vec3Keyframe)                   osgAnimation::TemplateKeyframe<osg::Vec3f>;
%template(Vec3KeyframeContainer)          osgAnimation::TemplateKeyframeContainer<osg::Vec3f>;

%template(vectorVec4Keyframe)             std::vector< Vec4Keyframe >;
%template(Vec4Keyframe)                   osgAnimation::TemplateKeyframe<osg::Vec4f>;
%template(Vec4KeyframeContainer)          osgAnimation::TemplateKeyframeContainer<osg::Vec4f>;
