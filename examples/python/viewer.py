#!/usr/bin/env python

import sys

# import all necessary stuff
import osg
import osgDB
import osgGA
import osgViewer

# create a root node
node = osg.Group()

# needed for python
osgDB.setLibraryFilePathList(sys.path)

# open a file
node.addChild(osgDB.readNodeFile('cow.osg'))

# create a viewer
viewer = osgViewer.Viewer()

# configure
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)


# add to the scene
viewer.setSceneData(node)

# loop until done
viewer.run()





