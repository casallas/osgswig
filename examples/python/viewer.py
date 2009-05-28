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
filepath = osgDB.getLibraryFilePathList()
for item in sys.path: filepath.append(item)
osgDB.setLibraryFilePathList(filepath)

loadedmodel = osgDB.readNodeFile("cow.osg")

# open a file
node.addChild(loadedmodel)

# create a viewer
viewer = osgViewer.Viewer()

# configure default threading
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)

# add handlers
viewer.addEventHandler(osgViewer.StatsHandler())
viewer.addEventHandler(osgViewer.WindowSizeHandler())
viewer.addEventHandler(osgViewer.ThreadingHandler())
viewer.addEventHandler(osgViewer.HelpHandler())

# add to the scene
viewer.setSceneData(node)

# loop until done
viewer.run()
