#!/usr/bin/env python

import os,sys

# import all necessary stuff
import osg
import osgDB
import osgViewer
import osgART


def createImageBackground(video):
	layer = osgART.VideoLayer()
	layer.setSize(video)
	geode = osgART.VideoGeode(osgART.VideoGeode.USE_TEXTURE_2D, video)
	osgART.addTexturedQuad(geode,video.s(),video.t())
	layer.addChild(geode)
	return layer


# create a root node
root = osg.Group()

# only use Python path
osgDB.Registry.instance().setLibraryFilePathList(sys.path)

# create a viewer
viewer = osgViewer.Viewer()

# set the scene root
viewer.setSceneData(root)

# preload plugins
video_id = osgART.PluginManager.getInstance().load("osgart_video_artoolkit2")	
tracker_id = osgART.PluginManager.getInstance().load("osgart_tracker_artoolkit2")

# create a video source (move to settings)
video = osgART.Video.cast(osgART.PluginManager.getInstance().get(video_id))

# open the video
video.open()

# tracker
tracker = osgART.Tracker.cast(osgART.PluginManager.getInstance().get(tracker_id))	

# create a calibration object
calibration = tracker.getOrCreateCalibration()

# load camera parameter 
tracker.getOrCreateCalibration().load("data/camera_para.dat")

# initialize the tracker
tracker.setImage(video)

# add a tracker callback
osgART.TrackerCallback.addOrSet(root,tracker)

# create a marker
marker = tracker.addMarker("single;data/patt.hiro;80;0;0")

# set the marker active 
marker.setActive(True)

# create a matrix transfrom utilised through osgART
ar_transform = osg.MatrixTransform()

ar_transform.setEventCallback(osgART.MarkerTransformCallback(marker))
ar_transform.getEventCallback().setNestedCallback(osgART.MarkerVisibilityCallback(marker))
ar_transform.getEventCallback().getNestedCallback().setNestedCallback(osgART.TransformFilterCallback())

ar_transform.addChild(osgART.testCube())

ar_transform.getOrCreateStateSet().setRenderBinDetails(100, "RenderBin")

video_background = createImageBackground(video)

video_background.getOrCreateStateSet().setRenderBinDetails(0, "RenderBin");

cam = calibration.createCamera();


cam.addChild(ar_transform)
cam.addChild(video_background)

root.addChild(cam)

video.start()

viewer.run();


