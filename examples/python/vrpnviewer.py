# example to use osgVRPN

# main imports
import sys,os

# OSG
import osg
import osgDB
import osgViewer
import osgVRPN

osg.setNotifyLevel(osg.INFO)

# create a viewer
viewer = osgViewer.Viewer()

# needed for Python
osgDB.setLibraryFilePathList(sys.path)

# create a viewer
viewer = osgViewer.Viewer()

# configure
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)

# scene
scene = osg.Group()

# open a file
cow = osgDB.readNodeFile('cow.osg')

# add to the scene
viewer.setSceneData(scene)

# create a tracker - in HITLabNZ we use this one 
tracker = osgVRPN.Tracker("DTrack@HITLVSTRACKER")

# create a ref ptr for the tracker
tracker_ref = osgVRPN.TrackerRef()

# add the tracker
tracker_ref = tracker

# create a transform 
trkXform = osgVRPN.TrackerTransform()

# connect them :)
osgVRPN.setTrackerRaw(trkXform,tracker)

# add the cow as child node
trkXform.addChild(cow)

# add the tracked node with the cow into the scene
scene.addChild(trkXform )

# show the viewer
viewer.realize()

# loop until done (dont use viewer.run as it overrides the camera manipulator)
while not viewer.done():
	# render
	viewer.frame()
