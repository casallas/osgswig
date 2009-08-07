#!/usr/bin/env python
import osg
import osgDB
import osgAnimation
import osgViewer
import osgUtil
import osgGA
import scipy.weave as weave
import sys
import numpy

import os
weave_include_dirs = [os.getenv("OSG_INCLUDE_DIR")]
weave_library_dirs = [os.getenv("OSG_LIB")]


def createAxis():
    geode = osg.Geode()
    geometry = osg.Geometry()
    
    # Have to do this in C++ due to problems with vectors and SWIG
    pGeom = int(geometry.this)
    buildGeomCode = """
    osg::Geometry *geometry = (osg::Geometry *)pGeom;

    osg::Vec3Array* vertices (new osg::Vec3Array());
    vertices->push_back (osg::Vec3 ( 0.0, 0.0, 0.0));
    vertices->push_back (osg::Vec3 ( 1.0, 0.0, 0.0));
    vertices->push_back (osg::Vec3 ( 0.0, 0.0, 0.0));
    vertices->push_back (osg::Vec3 ( 0.0, 1.0, 0.0));
    vertices->push_back (osg::Vec3 ( 0.0, 0.0, 0.0));
    vertices->push_back (osg::Vec3 ( 0.0, 0.0, 1.0));
    geometry->setVertexArray (vertices);

    osg::Vec4Array* colors (new osg::Vec4Array());
    colors->push_back (osg::Vec4 (1.0f, 0.0f, 0.0f, 1.0f));
    colors->push_back (osg::Vec4 (1.0f, 0.0f, 0.0f, 1.0f));
    colors->push_back (osg::Vec4 (0.0f, 1.0f, 0.0f, 1.0f));
    colors->push_back (osg::Vec4 (0.0f, 1.0f, 0.0f, 1.0f));
    colors->push_back (osg::Vec4 (0.0f, 0.0f, 1.0f, 1.0f));
    colors->push_back (osg::Vec4 (0.0f, 0.0f, 1.0f, 1.0f));
    geometry->setColorArray (colors);
"""
    weave.inline(buildGeomCode,["pGeom"],headers=["<osg/Geometry>"],libraries=["osg"],include_dirs=weave_include_dirs, library_dirs=weave_library_dirs)
    
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
    
    # Have to do this in C++ due to problems with vectors and SWIG
    pGeom = int(geometry.this)
    pVertices = int(vertices.this)
    pColors = int(colors.this)
    buildGeomCode = """
    osg::Geometry *geometry = (osg::Geometry *)pGeom;
    osg::Vec3Array *vertices = (osg::Vec3Array *)pVertices;
    osg::Vec3Array *colors = (osg::Vec3Array *)pColors; 
  
    float step = size / nsplit;
    float s = 0.5/4.0;
    for (int i = 0; i < nsplit; i++) 
    {
        float x = -1 + i * step;
        vertices->push_back (osg::Vec3 ( x, s, s));
        vertices->push_back (osg::Vec3 ( x, -s, s));
        vertices->push_back (osg::Vec3 ( x, -s, -s));
        vertices->push_back (osg::Vec3 ( x, s, -s));
        osg::Vec3 c (0,0,0);
        c[i%3] = 1;
        colors->push_back (c);
        colors->push_back (c);
        colors->push_back (c);
        colors->push_back (c);
    }

    osg::ref_ptr<osg::UIntArray> array = new osg::UIntArray;
    for (int i = 0; i < nsplit - 1; i++) 
    {
        int base = i * 4;
        array->push_back(base);
        array->push_back(base+1);
        array->push_back(base+4);
        array->push_back(base+1);
        array->push_back(base+5);
        array->push_back(base+4);

        array->push_back(base+3);
        array->push_back(base);
        array->push_back(base+4);
        array->push_back(base+7);
        array->push_back(base+3);
        array->push_back(base+4);

        array->push_back(base+5);
        array->push_back(base+1);
        array->push_back(base+2);
        array->push_back(base+2);
        array->push_back(base+6);
        array->push_back(base+5);

        array->push_back(base+2);
        array->push_back(base+3);
        array->push_back(base+7);
        array->push_back(base+6);
        array->push_back(base+2);
        array->push_back(base+7);
    }
  
    geometry->addPrimitiveSet(new osg::DrawElementsUInt(osg::PrimitiveSet::TRIANGLES, array->size(), &array->front()));
"""
    weave.inline(buildGeomCode,["pGeom","pVertices","pColors","size","nsplit"],headers=["<osg/Geometry>"],libraries=["osg"],include_dirs=weave_include_dirs, library_dirs=weave_library_dirs)
    
    geometry.setUseDisplayList(False)
    return geometry

def initVertexMap(b0, b1, b2, geom, array):
    
    vim = osgAnimation.VertexInfluenceMap()
    
    osgAnimation.fromVertexInfluenceMap(vim,b0.getName()).setName(b0.getName())
    osgAnimation.fromVertexInfluenceMap(vim,b1.getName()).setName(b1.getName())
    osgAnimation.fromVertexInfluenceMap(vim,b2.getName()).setName(b2.getName())
    
    # Have to do this in C++ due to problems with vectors and SWIG
    pVim = int(vim.this)
    pB0 = int(b0.this)
    pB1 = int(b1.this)
    pB2 = int(b2.this)
    pArray = int(array.this)
    buildVertexMapCode = """
    osgAnimation::VertexInfluenceMap* vim = (osgAnimation::VertexInfluenceMap*)pVim;
    osgAnimation::Bone* b0 = (osgAnimation::Bone*)pB0;
    osgAnimation::Bone* b1 = (osgAnimation::Bone*)pB1;
    osgAnimation::Bone* b2 = (osgAnimation::Bone*)pB2;
    osg::Vec3Array *array = (osg::Vec3Array *)pArray;

    for (int i = 0; i < (int)array->size(); i++) 
    {
        float val = (*array)[i][0];
        if (val >= -1 && val <= 0)
            (*vim)[b0->getName()].push_back(osgAnimation::VertexIndexWeight(i,1));
        else if ( val > 0 && val <= 1)
            (*vim)[b1->getName()].push_back(osgAnimation::VertexIndexWeight(i,1));
        else if ( val > 1)
            (*vim)[b2->getName()].push_back(osgAnimation::VertexIndexWeight(i,1));
    }
    
"""
    weave.inline(buildVertexMapCode,["pVim", "pB0", "pB1", "pB2", "pArray"],headers=["<osgAnimation/Skinning>"],libraries=["osg","osgAnimation"],include_dirs=weave_include_dirs, library_dirs=weave_library_dirs)
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
    buildAnimCode = """
    osgAnimation::QuatKeyframeContainer* keys0 = (osgAnimation::QuatKeyframeContainer *)pKeys0;
    osgAnimation::QuatKeyframeContainer* keys1 = (osgAnimation::QuatKeyframeContainer *)pKeys1;
    osg::Quat rotate;
    rotate.makeRotate(osg::PI_2, osg::Vec3(0,0,1));
    keys0->push_back(osgAnimation::QuatKeyframe(0,osg::Quat(0,0,0,1)));
    keys0->push_back(osgAnimation::QuatKeyframe(3,rotate));
    keys0->push_back(osgAnimation::QuatKeyframe(6,rotate));
    keys1->push_back(osgAnimation::QuatKeyframe(0,osg::Quat(0,0,0,1)));
    keys1->push_back(osgAnimation::QuatKeyframe(3,osg::Quat(0,0,0,1)));
    keys1->push_back(osgAnimation::QuatKeyframe(6,rotate));
    """
    weave.inline(buildAnimCode,["pKeys0","pKeys1"],headers=["<osgAnimation/BasicAnimationManager>"],libraries=["osg","osgAnimation"],include_dirs=weave_include_dirs, library_dirs=weave_library_dirs)

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
    rootTransform.setMatrix(osg.Matrixd_rotate(numpy.pi / 2.,osg.Vec3(1,0,0)))
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
    src = geom.getVertexArray();
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


