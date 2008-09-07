#!/usr/bin/env python

# A simple example of how to create geometry
# Pyramid geometry creation follows this tutorial:
# http://www.openscenegraph.org/documentation/NPSTutorials/osgGeometry.html

# import all necessary stuff
import sys
import osg
import osgDB
import osgGA
import osgViewer

# create a root node
node = osg.Group()

# Line Geometry
lineGeode = osg.Geode()
lineGeometry = osg.Geometry()
lineGeode.addDrawable(lineGeometry)
lineStateSet = lineGeode.getOrCreateStateSet()

lineVertices = osg.Vec3Array()
lineVertices.push_back(osg.Vec3(-10,10,0))
lineVertices.push_back(osg.Vec3(-10,-10,0))
lineGeometry.setVertexArray(lineVertices)

lineBase = osg.DrawElementsUInt(osg.PrimitiveSet.LINES,0)
lineBase.push_back(0)
lineBase.push_back(1)
lineGeometry.addPrimitiveSet(lineBase)

node.addChild(lineGeode)

# Pyramid geometry, following tutorial 
pyramidGeode = osg.Geode()
pyramidGeometry = osg.Geometry()
pyramidGeode.addDrawable(pyramidGeometry)
pyramidStateSet = pyramidGeode.getOrCreateStateSet()

pyramidVertices = osg.Vec3Array()
pyramidVertices.push_back(osg.Vec3(0,0,0))
pyramidVertices.push_back(osg.Vec3(10,0,0))
pyramidVertices.push_back(osg.Vec3(10,10,0))
pyramidVertices.push_back(osg.Vec3(0,10,0))
pyramidVertices.push_back(osg.Vec3(5,5,10))
pyramidGeometry.setVertexArray(pyramidVertices)

pyramidBase = osg.DrawElementsUInt(osg.PrimitiveSet.QUADS,0)
pyramidBase.push_back(3)
pyramidBase.push_back(2)
pyramidBase.push_back(1)
pyramidBase.push_back(0)
pyramidGeometry.addPrimitiveSet(pyramidBase)

pyramidFace1 = osg.DrawElementsUInt(osg.PrimitiveSet.TRIANGLES,0)
pyramidFace1.push_back(0)
pyramidFace1.push_back(1)
pyramidFace1.push_back(4)
pyramidGeometry.addPrimitiveSet(pyramidFace1)

pyramidFace2 = osg.DrawElementsUInt(osg.PrimitiveSet.TRIANGLES,0)
pyramidFace2.push_back(1)
pyramidFace2.push_back(2)
pyramidFace2.push_back(4)
pyramidGeometry.addPrimitiveSet(pyramidFace2)

pyramidFace3 = osg.DrawElementsUInt(osg.PrimitiveSet.TRIANGLES,0)
pyramidFace3.push_back(2)
pyramidFace3.push_back(3)
pyramidFace3.push_back(4)
pyramidGeometry.addPrimitiveSet(pyramidFace3)

pyramidFace4 = osg.DrawElementsUInt(osg.PrimitiveSet.TRIANGLES,0)
pyramidFace4.push_back(3)
pyramidFace4.push_back(0)
pyramidFace4.push_back(4)
pyramidGeometry.addPrimitiveSet(pyramidFace4)

colors= osg.Vec4Array()
colors.push_back(osg.Vec4(1,0,0,1)) #index 0 red
colors.push_back(osg.Vec4(0,1,0,1)) #index 1 green
colors.push_back(osg.Vec4(0,0,1,1)) #index 2 blue
colors.push_back(osg.Vec4(1,1,1,1)) #index 3 white

colorIndexArray = osg.UIntArray()
colorIndexArray.push_back(0)
colorIndexArray.push_back(1)
colorIndexArray.push_back(2)
colorIndexArray.push_back(3)
colorIndexArray.push_back(0)

pyramidGeometry.setColorArray(colors)
pyramidGeometry.setColorIndices(colorIndexArray)
pyramidGeometry.setColorBinding(osg.Geometry.BIND_PER_VERTEX)

# if you want to manipulate the values later on with immediate feedback, don't use a display list
pyramidGeometry.setSupportsDisplayList(False)

node.addChild(pyramidGeode)

# create a viewer
viewer = osgViewer.Viewer()

# configure
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)

# add to the scene
viewer.setSceneData(node)

# loop until done
viewer.run()
