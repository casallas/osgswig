#!/usr/bin/env python
#pickosgdirector.py

__author__  = ["Rene Molenaar"]
__url__     = ("http://code.google.com/p/osgswig/")
__version__ = "2.0.0"
__doc__     = """ This OpenSceneGraph in Python example shows creating a\
                 pickhandler that adds a wirebox and a callback to \
                 a selected node, added overloading of Node classes (Gerwin de Haan) \
                 ____Rene Molenaar 2008 """

#import the needed modules
import osg,  osgDB
import osgGA, osgViewer, osgUtil

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
#    stateset.thisown = 0   

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
    box = osg.Box(center, lx, ly, lz)
    shape = osg.ShapeDrawable(box)
    #shape.setColor(osg.Vec4(1.0, 0.0, 0.0, 1.0))
    
    #add the drawable to the wirebox geode
    wbgeode.addDrawable(shape)

    for pointer in [stateset, box, polyModeObj, lw, shape]:
        pointer.thisown = False

    #return the wirebox geode
    print "returning geode"
    return wbgeode

#castdict contains a mapping of classnames to convertor functions
# it is used in the objectUpcast function to upcast "plain" nodes back to their original class
# in C++ this is done through <dynamic_cast>
# in your director classes you might want to add mappings in the class definition, e.g.
#
# class myPose(osg.PositionAttitudeTransform):
#   global castdict
#   castdict["PositionAttitudeTransform"]=osg.NodeToPositionAttitudeTransform
#   def __init__(self):
#        osg.PositionAttitudeTransform.__init__(self)
#   ...    
    
castdict = {"MatrixTransform": osg.NodeToMatrixTransform}
            
def objectUpcast (pObject):
    """
    Helper function for Callbacks that route through C++
     Normally the C++ function downcasts the objects (e.g. osg.Node ).
     We need this to upcast again, e.g. to the original Python overloaded (director) class
    """
    lClassname = pObject.className()
    castfunc = None
    #print "objectUpcast:",pObject,"(",lClassname,")"
    if lClassname:
        # currently, abuse the className function to transport an instancename 
        # if there is one, evaluate its name to get the correct Python instance
        # this is ugly, so other options might be used (hints are welcome!) 
        if lClassname.startswith("instance_"):
            return eval(lClassname[len("instance_"):])
        try:
            castfunc = castdict[lClassname]
        except KeyError:
            castfunc = None
    
    if castfunc:
        return castfunc(pObject)
    else:
        return pObject
    
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

        #cast the node to the appropriate class type
        node = objectUpcast(node)
        
        #determine which main class is needed here
        if isinstance(node,osg.MatrixTransform):
            node.setMatrix(osg.Matrixd_rotate(self._quat))
        elif isinstance(node,osg.PositionAttitudeTransform):           
            node.setAttitude(self._quat)
        
        #special feature for special classes
        if isinstance(node,myPose):
            self._angle += node.customCallback()

        # Increment the angle.        
        self._angle += 0.01;
        # call traverse
        self.traverse(node,nv)

class myPose(osg.PositionAttitudeTransform):
    """
    Overloaded osg.PositionAttitudeTransform class
     use of objectUpcast to add special features that come with swig directors
    """
    #add the function to "upcast" nodes to osg.PositionAttitudeTransform instances in visitor/callbacks
    global castdict
    castdict["PositionAttitudeTransform"]=osg.NodeToPositionAttitudeTransform
    def __init__(self):
        osg.PositionAttitudeTransform.__init__(self)
        self._instancename = None
    def accept(self,nv):
        osg.PositionAttitudeTransform.accept(self,nv)
    def setInstanceName(self,pName):
        self._instancename = pName
    def className(self):
        """returns className, if director overloaded class, 
        return own instance"""
        if self._instancename:
            return "instance_" + self._instancename       
        else:
            return osg.PositionAttitudeTransform.className(self)
    def customCallback(self):
        "myPose customCallback, update angle faster"
        return -0.02

class PickHandler(osgGA.GUIEventHandler): 
    """
    PickHandler -- A GUIEventHandler that implements picking.
    """
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
                mt = node.asTransform()        
                if mt:            
                    #if there is a previous selected node, 'deselect' it
                    if self._selectedNode:
                        self._selectedNode.setUpdateCallback(None)
                        #remove the wirebox of the previous selection
                        if self.wb:
                            self._selectedNode.removeChild(self.wb)
                    self._selectedNode = mt
                    #show that the node is selected
                    mt.setUpdateCallback(RotateCB().__disown__())
                else:
                    geode = osg.NodeToGeode(node)
                    if geode:
                        #create a wirebox and save it, the wire box 
                        #will be attached to the parental transform node
                        self.wb = createWireBox(geode)
                        if self._selectedNode:
                            self._selectedNode.addChild(self.wb)
                        return True
            print "---"
            return False                            
        else:
            print "No Intersection Found"            
        return False       

#load the model
loadedModel = osgDB.readNodeFile("cow.osg")

root = osg.Group()

#create some dynamic transformation nodes of varying types
dynamicTransform1 = osg.PositionAttitudeTransform()
dynamicTransform1.setName("CowOne")
dynamicTransform2 = myPose()
dynamicTransform2.setName("CowTwo")
dynamicTransform3 = myPose()
dynamicTransform3.setInstanceName("dynamicTransform3")
dynamicTransform3.setName("CowThree")
dynamicTransform4 = osg.PositionAttitudeTransform()
dynamicTransform4.setName("CowFour")

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
root.addChild(dynamicTransform1)
root.addChild(dynamicTransform2)
root.addChild(dynamicTransform3)
root.addChild(dynamicTransform4)

#to prevent direct destruction you can create a variable for the callback
#rotcb = RotateCB()
#dynamicTransform.setUpdateCallback(rotcb.__disown__())
#or call the disown function: dynamicTransform.setUpdateCallback(RotateCB().__disown__())

#create the viewer, set the scene and run
viewer = osgViewer.Viewer()
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)

#set the scene data
viewer.setSceneData(root)

#add the stats event handler
viewer.addEventHandler(osgViewer.StatsHandler())
viewer.addEventHandler(osgViewer.WindowSizeHandler())
pickhandler = PickHandler()
viewer.addEventHandler(pickhandler);

#run the viewer
viewer.run()

#set an empty node for clean-up step
viewer.setSceneData(None)
