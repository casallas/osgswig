import ctypes
import osgDB, osgViewer, osg, osgGA, osgAnimation

floatKeys = osgAnimation.FloatKeyframeContainer()
key0 = osgAnimation.FloatKeyframe(0.0, 1.0)
floatKeys.push_back(key0)


vec3Keys = osgAnimation.Vec3KeyframeContainer()
key0 = osgAnimation.Vec3Keyframe(0.0, osg.Vec3(1,2,3))
vec3Keys.push_back(key0)

vec4Keys = osgAnimation.Vec4KeyframeContainer()
key0 = osgAnimation.Vec4Keyframe(0.0, osg.Vec4(1,2,3,4))
vec4Keys.push_back(key0)
