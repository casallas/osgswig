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
#include <osgAnimation/AnimationManager>
#include <osgAnimation/AnimationUpdateCallback>
#include <osgAnimation/BasicAnimationManager>

#include <osgAnimation/Export>
#include <osgAnimation/StatsHandler>
#include <osgAnimation/StatsVisitor>

#include <osgAnimation/Bone>
#include <osgAnimation/Channel>
#include <osgAnimation/CubicBezier>
#include <osgAnimation/EaseMotion>
#include <osgAnimation/Interpolator>
#include <osgAnimation/Keyframe>
#include <osgAnimation/LinkVisitor>

#include <osgAnimation/RigGeometry>

#include <osgAnimation/Sampler>
#include <osgAnimation/Skeleton>
//#include <osgAnimation/Skinning>
#include <osgAnimation/Target>
#include <osgAnimation/Timeline>
#include <osgAnimation/TimelineAnimationManager>
//#include <osgAnimation/UpdateCallback>
#include <osgAnimation/Vec3Packed>
#include <osgAnimation/VertexInfluence>

#include <osgAnimation/Action>
#include <osgAnimation/ActionAnimation>
#include <osgAnimation/ActionBlendIn>
#include <osgAnimation/ActionBlendOut>
#include <osgAnimation/ActionCallback>
#include <osgAnimation/ActionStripAnimation>
#include <osgAnimation/ActionVisitor>
#include <osgAnimation/FrameAction>


#include <osgAnimation/BoneMapVisitor>
#include <osgAnimation/MorphGeometry>
#include <osgAnimation/RigTransform>
#include <osgAnimation/RigTransformHardware>
#include <osgAnimation/RigTransformSoftware>
#include <osgAnimation/StackedMatrixElement>
#include <osgAnimation/StackedQuaternionElement>
#include <osgAnimation/StackedRotateAxisElement>
#include <osgAnimation/StackedScaleElement>
#include <osgAnimation/StackedTransform>
#include <osgAnimation/StackedTransformElement>
#include <osgAnimation/StackedTranslateElement>
#include <osgAnimation/UpdateBone>
#include <osgAnimation/UpdateMaterial>
#include <osgAnimation/UpdateMatrixTransform>

using namespace osgAnimation;
%}

class Action__Callback : public osg::Object
        {
        public:
            Action__Callback(){}
            Action__Callback(const Action__Callback& nc,const osg::CopyOp&) :
                _nestedCallback(nc._nestedCallback) {}

            META_Object(osgAnimation,Action__Callback);
        
            virtual void operator()(Action* action, osgAnimation::ActionVisitor* nv) {}
            
            Action__Callback* getNestedCallback() { return _nestedCallback.get(); } 
            void addNestedCallback(Action__Callback* callback) 
            { 
                if (callback) {
                    if (_nestedCallback.valid())
                        _nestedCallback->addNestedCallback(callback);
                    else
                        _nestedCallback = callback;
                }
            }

            void removeCallback(Action__Callback* cb)
            { 
                if (!cb)
                    return;

                if (_nestedCallback.get() == cb)
                    _nestedCallback = _nestedCallback->getNestedCallback();
                else if (_nestedCallback.valid())
                    _nestedCallback->removeCallback(cb);
            }

        protected:
            osg::ref_ptr<Action__Callback> _nestedCallback;
        };

%{
typedef Action::Callback Action__Callback;
typedef Action__Callback Callback;
%}

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

// include the actual headers
//%include osgAnimation/Assert
//%include osgAnimation/Export

%include osgAnimation/Vec3Packed
%include osgAnimation/CubicBezier
%include osgAnimation/Target
%include osgAnimation/Keyframe
%include osgAnimation/Interpolator
%include osgAnimation/Sampler
%include osgAnimation/Channel
%include osgAnimation/Animation

%include osgAnimation/FrameAction
%include osgAnimation/Action
%include osgAnimation/ActionVisitor
%include osgAnimation/ActionCallback
%include osgAnimation/ActionAnimation

%include osgAnimation/Skeleton
%include osgAnimation/BoneMapVisitor
%include osgAnimation/Bone
%include osgAnimation/EaseMotion

%include osgAnimation/LinkVisitor
%include osgAnimation/AnimationUpdateCallback
%include osgAnimation/AnimationManagerBase
//%include osgAnimation/AnimationManager
%include osgAnimation/BasicAnimationManager

// Vertex Influence stuff
//%template(VertexIndexWeight)               std::pair<int, float>;
//%template(VertexList)                               std::vector<VertexIndexWeight>;
%template(mapVertexInfluence)              std::map< std::string, osgAnimation::VertexInfluence >;
%include osgAnimation/VertexInfluence

%include osgAnimation/RigTransform
%include osgAnimation/RigTransformSoftware
%include osgAnimation/RigTransformHardware
%include osgAnimation/RigGeometry

//%include osgAnimation/Skinning
//%include osgAnimation/UpdateCallback

//warning: osg::StateAttributeCallback is not complete
%template (AnimationUpdateCallback_StateAttributeCallback) osgAnimation::AnimationUpdateCallback< osg::StateAttributeCallback >;
%template (AnimationUpdateCallback_NodeCallback) osgAnimation::AnimationUpdateCallback< osg::NodeCallback >;

%include osgAnimation/UpdateMaterial
%include osgAnimation/UpdateMatrixTransform

%include osgAnimation/UpdateBone

%include osgAnimation/Timeline
%include osgAnimation/TimelineAnimationManager
//----------------------checked till here --------

%pythoncode %{
#get the original definitions back into their classes
Action.Callback = Action__Callback
%}

