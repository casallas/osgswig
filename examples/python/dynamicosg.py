#!/usr/bin/env python
#dynamicosg.py

__author__  = ["Rene Molenaar"]
__url__     = ("http://code.google.com/p/osgswig/")
__version__ = "2.0.0"
__doc__     = """ This OpenSceneGraph in Python example shows creating a\
                 rotation callback for a transform node \
                 ____Rene Molenaar 2008 """

#import the needed modules
import osg,  osgDB, osgGA, osgViewer

#Create a callback function for a transform node
class RotateCB(osg.NodeCallback):
    """Simple Rotate UpdateCallback for Transform Nodes """
    base_class = osg.NodeCallback
    def __init__(self, axis = osg.Vec3( 0.0, 0.0, 1.0 ), startangle = 0.0):
        self._angle = startangle
        self._axis = axis
        self._quat = osg.Quat()
        osg.NodeCallback.__init__(self)    
    def __call__(self, node, nv):
        """casts the transform node and rotate and increment angle"""
        self._quat.makeRotate(self._angle, self._axis) 
        #call the dynamic cast function that was added to the osg module
        mt = osg.NodeToMatrixTransform(node)        
        if mt:
            mt.setMatrix(osg.Matrixd_rotate(self._quat))
        else:            
            pot = osg.NodeToPositionAttitudeTransform(node)
            if pot:           
                pot.setAttitude(self._quat)
        
        # Increment the angle.        
        self._angle += 0.01;
        # call traverse
        self.traverse(node,nv)


#load the model
loadedModel = osgDB.readNodeFile("cow.osg")

#create a dynamic transformation node, we can use a MatrixTransform 
dynamicTransform = osg.MatrixTransform()
#or we can use a PositionAttitudeTransform: dynamic = osg.PositionAttitudeTransform()


#add the loaded model to the transform node
dynamicTransform.addChild(loadedModel)


#to prevent direct destruction you can create a variable for the callback
rotcb = RotateCB()
dynamicTransform.setUpdateCallback(rotcb.__disown__())
#or call the disown function: dynamicTransform.setUpdateCallback(RotateCB().__disown__())


#create the viewer, set the scene and run
viewer = osgViewer.Viewer()
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)

#set the scene data
viewer.setSceneData(dynamicTransform.__disown__())

#add the stats event handler
viewer.addEventHandler(osgViewer.StatsHandler());

#run the viewer
viewer.run()
#or call the following functions
#viewer.realize()
#viewer.setCameraManipulator(osgGA.TrackballManipulator())
#while not viewer.done():
#    viewer.frame()
           
#set an empty node for clean-up step
viewer.setSceneData(None)

