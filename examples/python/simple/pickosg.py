#!/usr/bin/env python
#dynamicosg.py

__author__  = ["Rene Molenaar"]
__url__     = ("http://code.google.com/p/osgswig/")
__version__ = "2.0.0"
__doc__     = """ This OpenSceneGraph in Python example shows creating a\
                 rotation callback for a transform node \
                 ____Rene Molenaar 2008 """

#import the needed modules
import osg,  osgDB, osgGA, osgViewer, osgUtil, time


selmat = osg.Material()
selmat.setDiffuse (osg.Material.FRONT_AND_BACK, osg.Vec4 (0.9, 0.1, 0.0, 1.0))
selmat.setEmission(osg.Material.FRONT_AND_BACK, osg.Vec4 (0.8, 0.1, 0.0, 1.0))
selmat.setAmbient(osg.Material.FRONT_AND_BACK, osg.Vec4(0.5, 0.5, 0.5, 1))


def createWireBox(node):
    """create a bounding box for the node """

    #create an empty bounding box
    bb = osg.BoundingBox()

    #if we have a geode, expand by the drawables bounding box, else use the bounding sphere
    geode = osg.NodeToGeode(node)
    if geode:
        print "geode found"   
        for i in range(geode.getNumDrawables()):
            dwb = geode.getDrawable(0)
            bb.expandBy(dwb.getBound());
    else:
        bb.expandBy(node.getBound())            
    
    center = node.getBound().center()
    
    #create a geode for the wirebox
    wbgeode = osg.Geode()
    wbgeode.setName("ExtentsGeode")

    #create a stateset for the wirebox
    stateset = osg.StateSet()
    wbgeode.setStateSet(stateset)

    #create a polygonmode state attribute
    polyModeObj = osg.PolygonMode()
    polyModeObj.setMode(osg.PolygonMode.FRONT_AND_BACK, osg.PolygonMode.LINE)
    stateset.setAttribute(polyModeObj)
    
    #create a linewidth state attribute
    lw = osg.LineWidth()
    lw.setWidth(2.0)
    stateset.setAttribute(lw)
    
    stateset.setAttribute(selmat)

    #create a drawablw box with the right position and size
    lx = bb._max.x() - bb._min.x()
    ly = bb._max.y() - bb._min.y()
    lz = bb._max.z() - bb._min.z()
    shape = osg.ShapeDrawable(osg.Box(center, lx, ly, lz))
    #shape.setColor(osg.Vec4(1.0, 0.0, 0.0, 1.0))
    
    #add the drawable to the wirebox geode
    wbgeode.addDrawable(shape)

    #return the wirebox geode
    return wbgeode


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


class PickHandler(osgGA.GUIEventHandler): 
    """PickHandler -- A GUIEventHandler that implements picking."""
    base_class = osgGA.GUIEventHandler
    def __init__(self):
        #Store mouse xy location for button press and move events.
        self._mX = 0
        self._mY = 0   
        self._selectedNode = 0
        self.wb = 0
        osgGA.GUIEventHandler.__init__(self)
    def handle(self, ea, aa, obj, nv):        
        vwr = osgViewer.GUIActionAdapterToViewer(aa)
        if not vwr:
            return False
        eventtype = ea.getEventType()
        if eventtype == ea.PUSH or eventtype == ea.MOVE:
            self._mX = ea.getX()
            self._mY = ea.getY()
            return False
        if eventtype == ea.RELEASE:
            print self._mX, self._mY
            #check if mouse didn't move (else let trackball manipulator handle it)
            if self._mX == ea.getX() and self._mY == ea.getY():
                if self.pick( ea.getXnormalized(), ea.getYnormalized(), vwr ):
                    return True
        return False
    def pick(self, x, y , viewer):
        print "Picking" 
        if not viewer.getSceneData():
            return False
        #create an intersector
        picker = osgUtil.LineSegmentIntersector(osgUtil.Intersector.PROJECTION, x, y )
        #create an intersectionVisitor
        iv = osgUtil.IntersectionVisitor( picker )
        #visit the sceneGraph
        viewer.getCamera().accept( iv )
        #check for intersections
        if picker.containsIntersections():
            print "Intersection Found"
            intersection = picker.getFirstIntersection()
            #find the first Transform node and make it the selected node
            for node in intersection.nodePath:
                mt = osg.NodeToMatrixTransform(node)        
                if mt:
                    #if there is a previous selected node, 'deselect' it
                    if self._selectedNode:
                        self._selectedNode.setUpdateCallback(osg.NodeCallback())
                        #remove the wirebox of the previous selection
                        if self.wb:
                            self._selectedNode.removeChild(self.wb)
                    self._selectedNode = mt
                    #show that the node is selected
                    mt.setUpdateCallback(RotateCB().__disown__())
                else:            
                    pot = osg.NodeToPositionAttitudeTransform(node)
                    if pot:           
                        #if there is a previous selected node, 'deselect' it
                        if self._selectedNode:
                            self._selectedNode.setUpdateCallback(osg.NodeCallback())
                            #remove the wirebox of the previous selection
                            if self.wb:
                                self._selectedNode.removeChild(self.wb)
                        self._selectedNode = pot
                        #show that the node is selected
                        pot.setUpdateCallback(RotateCB().__disown__())                      
                    else:
                        geode = osg.NodeToGeode(node)
                        if geode:
                            #create a wirebox and safe it, the wire box 
                            #will be attached to the parental transform node
                            self.wb = createWireBox(geode)
                            self._selectedNode.addChild(self.wb)
            return False                            
        else:
            print "No Intersection Found"            
        return False       

#load the model
loadedModel = osgDB.readNodeFile("cow.osg")

root = osg.Group()

#create some dynamic transformation nodes
dynamicTransform1 = osg.PositionAttitudeTransform()
dynamicTransform2 = osg.PositionAttitudeTransform()
dynamicTransform3 = osg.PositionAttitudeTransform()
dynamicTransform4 = osg.PositionAttitudeTransform()


#add the loaded model to the transform nodes
dynamicTransform1.addChild(loadedModel)
dynamicTransform1.setPosition(osg.Vec3d(-10,0,-10))
dynamicTransform2.addChild(loadedModel)
dynamicTransform2.setPosition(osg.Vec3d(-10,0,10))
dynamicTransform3.addChild(loadedModel)
dynamicTransform3.setPosition(osg.Vec3d(10,0,-10))
dynamicTransform4.addChild(loadedModel)
dynamicTransform4.setPosition(osg.Vec3d(10,0,10))

#add the transform nodes to the scene root
root.addChild(dynamicTransform1.__disown__())
root.addChild(dynamicTransform2.__disown__())
root.addChild(dynamicTransform3.__disown__())
root.addChild(dynamicTransform4.__disown__())


#to prevent direct destruction you can create a variable for the callback
#rotcb = RotateCB()
#dynamicTransform.setUpdateCallback(rotcb.__disown__())
#or call the disown function: dynamicTransform.setUpdateCallback(RotateCB().__disown__())


#create the viewer, set the scene and run
viewer = osgViewer.Viewer()
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)

#set the scene data
viewer.setSceneData(root.__disown__())

#add the stats event handler
viewer.addEventHandler(osgViewer.StatsHandler());
pickhandler = PickHandler()
#pickhandler = osgGA.GUIEventHandler()
viewer.addEventHandler(pickhandler.__disown__());

#run the viewer
viewer.run()
#or call the following functions
#viewer.realize()
#viewer.setCameraManipulator(osgGA.TrackballManipulator())
#while not viewer.done():
#    viewer.frame()

#set an empty node for clean-up step
viewer.setSceneData(osg.Node())
