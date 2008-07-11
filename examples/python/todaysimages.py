#! /usr/bin/env python

""" 
BBC's "Today in images" in an osgviewer,
 2008 - Gerwin de Haan

 grown by cutty-pasty in about an hour or two,
 intended to demonstrate python-esque mashups with OSG

 currently uses BeautifulSoup library for HTML parsing
  get it at http://www.crummy.com/software/BeautifulSoup/
  or the python-beautifulsoup package in ubuntu
"""

import sys
import math
import random    
import urllib2
import types
from   xml.dom import minidom, Node
import BeautifulSoup

import osg
import osgDB
import osgGA
import osgViewer

#Create a callback function for a transform node
class RotateCB(osg.NodeCallback):
    """Rotate UpdateCallback for Transform Nodes """
    base_class = osg.NodeCallback
    def __init__(self, axis = osg.Vec3( 0.0, 0.0, 1.0 ), startangle = 0.0, speed=0.001):
        self._angle = startangle
        self._axis = axis
        self._quat = osg.Quat()
        self._speed = speed
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
        self._angle += self._speed;
        # call traverse
        self.traverse(node,nv)

def getUrlFromRSS(pURL,pItem=0):
    """ Get the BBC's Day in Images URL from the RSS 

    pItem indicates which entry item one would like
    """
    try:
        url_info = urllib2.urlopen(pURL)
        xmldoc = minidom.parse(url_info)
        return str(xmldoc.getElementsByTagName("item")[pItem].getElementsByTagName("link")[0].firstChild.wholeText)
    except:
        print "Error getting the URL from the RSS"
        raise

def getImageListFromPage(pUrl):
    """ Get all files from <img> tags from the URL"""

    #prepares for non-absolute img references
    lbaseurl = pUrl
    lstuburl = ""
    lcontent = urllib2.urlopen(lbaseurl+lstuburl).read()
    lsoup = BeautifulSoup.BeautifulSoup(lcontent)
    imglisttags = lsoup.findChildren("img")
    imglistfiles = [x["src"] for x in imglisttags]
    return imglistfiles

def createObjectFromImageList(pNode, pImageList, pBaseUrl=""):
    """uses the image list to create a set of objects"""

    box_geometry = osg.Box()
    box_drawable = osg.ShapeDrawable(box_geometry)
    # create a random function for floating points
    frandom = lambda x,y : random.randrange(x,y,int=types.FloatType)

    for imgfile in [str(x) for x in pImageList ]:
        print "Loading:", imgfile
        image = osgDB.readImageFile(imgfile)

        #check if the image is there, and not too small (icons and such)
        if image and image.s()>100.0 and image.t()>100.0:
            t = osg.Texture2D()
            t.setImage(image)
            stateset = osg.StateSet()
            stateset.setTextureAttributeAndModes(0,t,1)
            lbox_geode = osg.Geode()
            lbox_geode.addDrawable(box_drawable)
            lbox_geode.setStateSet(stateset)
            lbox_node = osg.PositionAttitudeTransform()
            lbox_node.addChild(lbox_geode)
            rscale = frandom(5,10)
            lbox_node.setScale(osg.Vec3d(image.s()/rscale,0.5,image.t()/rscale))
            #set vertical
            q = osg.Quat()
            q.makeRotate(frandom(0,2*math.pi),0,0,1)
            lbox_node.setAttitude(q)   
            lbox_node.setPosition  (osg.Vec3d(frandom(-50,50),
                                               frandom(-50,50),
                                               frandom(-100,100)
                                               )   
                                    )

            pNode.addChild(lbox_node)

#setup the scene with a rotating pillar
root = osg.Group()
pillar = osg.PositionAttitudeTransform()
pillar.setUpdateCallback(RotateCB(speed=0.001).__disown__())
root.addChild(pillar)

#get the BBC's "Today in images" page URL from today from the RSS
rssaddress = 'http://newsrss.bbc.co.uk/rss/newsonline_world_edition/in_pictures/rss.xml'

imagelist=[]
#pick the last two days
for i in range(2):
    url = getUrlFromRSS(rssaddress,i)
    #generate a list of images from the URL
    imagelist += getImageListFromPage(url)

#create image objects from the list
createObjectFromImageList(pillar,imagelist)

# create a viewer
viewer = osgViewer.Viewer()
# configure
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)

# convenience handlers
viewer.addEventHandler(osgViewer.StatsHandler())
viewer.addEventHandler(osgViewer.WindowSizeHandler())
viewer.addEventHandler(osgViewer.ThreadingHandler())
viewer.addEventHandler(osgViewer.HelpHandler())

# add to the scene
viewer.setSceneData(root)
# loop until done
viewer.run()
