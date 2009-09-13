#!/usr/bin/env python
import osg
import osgDB
import osgAnimation
import osgViewer
import osgUtil
import osgGA
import sys
import os

PI_2 = 1.5707963267948966

def createAxis():
    geode = osg.Geode()
    geometry = osg.Geometry()
    
    vertices = osg.Vec3Array()
    vertices.push_back(osg.Vec3( 0.0, 0.0, 0.0))
    vertices.push_back(osg.Vec3( 1.0, 0.0, 0.0))
    vertices.push_back(osg.Vec3( 0.0, 0.0, 0.0))
    vertices.push_back(osg.Vec3( 0.0, 1.0, 0.0))
    vertices.push_back(osg.Vec3( 0.0, 0.0, 0.0))
    vertices.push_back(osg.Vec3( 0.0, 0.0, 1.0))
    geometry.setVertexArray(vertices)
    
    colors = osg.Vec4Array()
    colors.push_back(osg.Vec4(1.0, 0.0, 0.0, 1.0))
    colors.push_back(osg.Vec4(1.0, 0.0, 0.0, 1.0))
    colors.push_back(osg.Vec4(0.0, 1.0, 0.0, 1.0))
    colors.push_back(osg.Vec4(0.0, 1.0, 0.0, 1.0))
    colors.push_back(osg.Vec4(0.0, 0.0, 1.0, 1.0))
    colors.push_back(osg.Vec4(0.0, 0.0, 1.0, 1.0))
    geometry.setColorArray(colors)
    
    geometry.setColorBinding(osg.Geometry.BIND_PER_VERTEX)
    geometry.addPrimitiveSet(osg.DrawArrays(osg.PrimitiveSet.LINES,0,6))
    
    geode.addDrawable(geometry)
    return geode
    
def createTesselatedBox(nsplit, size):
    geometry = osgAnimation.RigGeometry()
    vertices = osg.Vec3Array()
    colors = osg.Vec3Array()
    geometry.setVertexArray(vertices)
    geometry.setColorArray(colors)
    geometry.setColorBinding(osg.Geometry.BIND_PER_VERTEX)
    
    step = size / nsplit
    s = 0.5/4.0
    for i in range(nsplit):
        x = -1 + i * step
        vertices.push_back (osg.Vec3 ( x, s, s))
        vertices.push_back (osg.Vec3 ( x, -s, s))
        vertices.push_back (osg.Vec3 ( x, -s, -s))
        vertices.push_back (osg.Vec3 ( x, s, -s))
        c = osg.Vec3(0,0,0)
        c[i%3] = 1
        colors.push_back (c)
        colors.push_back (c)
        colors.push_back (c)
        colors.push_back (c)

    faces = osg.DrawElementsUInt(osg.PrimitiveSet.TRIANGLES, 0)
    for i in range(nsplit - 1):
        base = i * 4;
        faces.push_back(base)
        faces.push_back(base+1)
        faces.push_back(base+4)
        faces.push_back(base+1)
        faces.push_back(base+5)
        faces.push_back(base+4)

        faces.push_back(base+3)
        faces.push_back(base)
        faces.push_back(base+4)
        faces.push_back(base+7)
        faces.push_back(base+3)
        faces.push_back(base+4)

        faces.push_back(base+5)
        faces.push_back(base+1)
        faces.push_back(base+2)
        faces.push_back(base+2)
        faces.push_back(base+6)
        faces.push_back(base+5)

        faces.push_back(base+2)
        faces.push_back(base+3)
        faces.push_back(base+7)
        faces.push_back(base+6)
        faces.push_back(base+2)
        faces.push_back(base+7)
  
    geometry.addPrimitiveSet(faces)
    geometry.setUseDisplayList(False)
    return geometry

def initVertexMap(b0, b1, b2, geom, array):
    
    vim = osgAnimation.VertexInfluenceMap()
    b0Inf = osgAnimation.VertexInfluence()
    b1Inf = osgAnimation.VertexInfluence()
    b2Inf = osgAnimation.VertexInfluence()
    b0Inf.setName(b0.getName())
    b1Inf.setName(b1.getName())
    b2Inf.setName(b2.getName())
    
    for i in range(array.size()):
        val = array.asVector()[i][0]
        if val >= -1 and val <= 0:
            b0Inf.push_back(osgAnimation.VertexIndexWeight(i,1))
        elif val > 0 and val <= 1:
            b1Inf.push_back(osgAnimation.VertexIndexWeight(i,1))
        elif val > 1 :
            b2Inf.push_back(osgAnimation.VertexIndexWeight(i,1))
    
    vim[b0.getName()] = b0Inf
    vim[b1.getName()] = b1Inf
    vim[b2.getName()] = b2Inf
    geom.setInfluenceMap(vim)


def main():

    #arguments = osg.ArgumentParses(len(sys.argv),sys.argv)
    viewer = osgViewer.Viewer()#arguments)

    viewer.setCameraManipulator(osgGA.TrackballManipulator())

    skelroot = osgAnimation.Skeleton()
    skelroot.setDefaultUpdateCallback()
    root = osgAnimation.Bone()
    root.setBindMatrixInBoneSpace(osg.Matrixd_identity())
    root.setBindMatrixInBoneSpace(osg.Matrixd_translate(-1,0,0))
    root.setName("root")
    root.setDefaultUpdateCallback()
    
    right0 = osgAnimation.Bone()
    right0.setBindMatrixInBoneSpace(osg.Matrixd_translate(1,0,0))
    right0.setName("right0")
    right0.setDefaultUpdateCallback("right0")

    right1 = osgAnimation.Bone()
    right1.setBindMatrixInBoneSpace(osg.Matrixd_translate(1,0,0));
    right1.setName("right1");
    right1.setDefaultUpdateCallback("right1");

    root.addChild(right0)
    right0.addChild(right1)
    skelroot.addChild(root)

    scene = osg.Group()
    manager = osgAnimation.BasicAnimationManager()
    scene.setUpdateCallback(manager)

    anim = osgAnimation.Animation()
    keys0 = osgAnimation.QuatKeyframeContainer()
    keys1 = osgAnimation.QuatKeyframeContainer()
    pKeys0 = int(keys0.this)
    pKeys1 = int(keys1.this)
    rotate = osg.Quat()
    rotate.makeRotate(PI_2, osg.Vec3(0,0,1))
    keys0.push_back(osgAnimation.QuatKeyframe(0,osg.Quat(0,0,0,1)));
    keys0.push_back(osgAnimation.QuatKeyframe(3,rotate));
    keys0.push_back(osgAnimation.QuatKeyframe(6,rotate));
    keys1.push_back(osgAnimation.QuatKeyframe(0,osg.Quat(0,0,0,1)));
    keys1.push_back(osgAnimation.QuatKeyframe(3,osg.Quat(0,0,0,1)));
    keys1.push_back(osgAnimation.QuatKeyframe(6,rotate));
    
    sampler0 = osgAnimation.QuatSphericalLinearSampler()
    sampler0.setKeyframeContainer(keys0)
    channel0 = osgAnimation.QuatSphericalLinearChannel(sampler0)
    channel0.setName("quaternion")
    channel0.setTargetName("right0")
    anim.addChannel(channel0)
    sampler1 = osgAnimation.QuatSphericalLinearSampler()
    sampler1.setKeyframeContainer(keys1)
    channel1 = osgAnimation.QuatSphericalLinearChannel(sampler1)
    channel1.setName("quaternion")
    channel1.setTargetName("right1")
    anim.addChannel(channel1)
    manager.registerAnimation(anim)
    manager.buildTargetReference()
  
    # let's start !
    manager.playAnimation(anim)

    # we will use local data from the skeleton
    rootTransform = osg.MatrixTransform()
    rootTransform.setMatrix(osg.Matrixd_rotate(PI_2,osg.Vec3(1,0,0)))
    right0.addChild(createAxis())
    right0.setDataVariance(osg.Object.DYNAMIC)
    right1.addChild(createAxis())
    right1.setDataVariance(osg.Object.DYNAMIC)
    trueroot = osg.MatrixTransform()
    trueroot.setMatrix(osg.Matrixd(root.getMatrixInBoneSpace()))
    trueroot.addChild(createAxis())
    trueroot.addChild(skelroot)
    trueroot.setDataVariance(osg.Object.DYNAMIC)
    rootTransform.addChild(trueroot)
    scene.addChild(rootTransform)
  
    geom = createTesselatedBox(4, 4.0)
    geode = osg.Geode()
    geode.addDrawable(geom)
    skelroot.addChild(geode)
    src = geom.getVertexArray().asVec3Array()
    geom.getOrCreateStateSet().setMode(osg.GL_LIGHTING, False)
    geom.setDataVariance(osg.Object.DYNAMIC)

    initVertexMap(root, right0, right1, geom, src)

    #let's run !
    viewer.setSceneData( scene )
    viewer.realize()

    while not viewer.done():
        viewer.frame()

#Run the program
main()


