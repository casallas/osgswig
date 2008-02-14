#!/usr/bin/env python

import os,sys

# import all necessary stuff
import osg
import osgDB
import osgViewer
import osgART

# only use Python path
osgDB.Registry.instance().setLibraryFilePathList(sys.path)

# create a viewer
viewer = osgViewer.Viewer()

# preload plugins
if not osgART.PluginManager.instance().load("osgart_video_artoolkit"):
	exit(-1)
	
if not osgART.PluginManager.instance().load("osgart_tracker_artoolkit"):
	exit(-1)

# create a video source (move to settings)
video = osgART.GenericVideo.cast(osgART.PluginManager.instance().get("video_artoolkit"))

# open the video
video.open()

# tracker
tracker = osgART.GenericTracker.cast(osgART.PluginManager.instance().get("tracker_artoolkit"))	

# init the actual tracker
tracker.init(video.getWidth(),video.getHeight(),
	os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])),"Data/markers_list.dat"))

# create a new group
foreground = osg.Group()

# create a video background
videobackground = osgART.VideoLayer(video,0)

# init that one
videobackground.init()

# add the videobackground to the scene
foreground.addChild(videobackground)

# set the render bin details correctly
foreground.getOrCreateStateSet().setRenderBinDetails(2, "RenderBin")

# set the projection matrix
projection = osg.Projection(osg.Matrixd(tracker.getProjectionMatrix()))

# get the marker
marker = tracker.getMarker(0)
# marker = None

if marker:
	
	# set the marker active
	marker.setActive(True)

	# get the marker transform
	markertrans = osgART.ARTTransform(marker)

	# add a scene
	markertrans.addChild(osgDB.readNodeFile('cow.osg'))	
	
	# 
	markertrans.getOrCreateStateSet().setRenderBinDetails(5, "RenderBin")
	
	foreground.addChild(markertrans)


# create new transform node
modelview = osg.MatrixTransform()

modelview.addChild(foreground)

projection.addChild(modelview)

scaler = osg.AutoTransform()

scaler.setScale(10.0)

# create a root node
root = osg.Group()

root.addChild(projection)

# add to the scene
viewer.setSceneData(root)

tracker.setImageSource(video)

# show the viewer
viewer.realize()

video.start()


# loop until done
while not viewer.done():

	video.update()

	tracker.update()

	# render
	viewer.frame()


