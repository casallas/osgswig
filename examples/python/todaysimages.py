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

class RotateCB(osg.NodeCallback):
    """
    Rotate UpdateCallback for Transform Nodes 
    """
    def __init__(self, axis = osg.Vec3( 0.0, 0.0, 1.0 ), startangle = 0.0, speed=0.001):
        self._angle = startangle
        self._axis = axis
        self._quat = osg.Quat()
        self._speed = speed
        osg.NodeCallback.__init__(self)    
    def __call__(self, node, nv):
        """casts the transform node and rotate and increment angle"""
        # Increment the angle.        
        self._angle += self._speed;
        # regenerate the quaternion
        self._quat.makeRotate(self._angle, self._axis) 
        #call the dynamic cast function that was added to the osg module
        pot = osg.NodeToPositionAttitudeTransform(node)
        if pot:           
            pot.setAttitude(self._quat)
        # call traverse for further osg processing
        self.traverse(node,nv)

def getUrlsFromRSS(pURL,pItem=0):
    """
    Get the BBC's Day in Images URL from the RSS 

    pItem indicates which entry item one would like
    """

    print "Trying to open URL :", pURL

    try:
        url_info = urllib2.urlopen(pURL)
        xmldoc = minidom.parse(url_info)

        #we're going to return a list of items
        urllist = []

        #build-up a list
        for n in range(pItem):
            #get the n-tn item tag, from that the text of the first link tag 
            urllist+= [str(xmldoc.getElementsByTagName("item")[n].getElementsByTagName("link")[0].firstChild.wholeText)]

        #return the list
        return urllist
    except:
        print "Error getting the URL from the RSS"
        raise

def getImageListFromPage(pUrl):
    """
    Get all files from <img> tags from the URL
    """

    #prepares for non-absolute img references
    lbaseurl = pUrl
    lstuburl = ""
    lcontent = urllib2.urlopen(lbaseurl+lstuburl).read()
    lsoup = BeautifulSoup.BeautifulSoup(lcontent)
    imglisttags = lsoup.findChildren("img")
    imglistfiles = [x["src"] for x in imglisttags if x["src"].endswith("jpg")]
    return imglistfiles

def createObjectFromImageList(pNode, pImageList, pBaseUrl=""):
    """
    uses the image list to create a set of objects
    """

    box_geometry = osg.Box()
    box_drawable = osg.ShapeDrawable(box_geometry)
    # create a random function for floating points
    frandom = lambda x,y : random.randrange(x,y,int=types.FloatType)

    print "Opening %d from %d images"%(maxphotos, len(pImageList))

    for imgfile in [str(x) for x in pImageList[:maxphotos]]:
        print "osgDB.readImageFile loading:", imgfile
        image = osgDB.readImageFile(imgfile)

        #check if the image is there, and not too small (icons and such)
        if image and image.s()>100.0 and image.t()>100.0:
            t = osg.TextureRectangle()
            texmat = osg.TexMat()
            texmat.setScaleByTextureRectangleSize(True)
            t.setImage(image)
            stateset = osg.StateSet()
            stateset.setTextureAttributeAndModes(0,t,1)
            stateset.setTextureAttributeAndModes(0, texmat, osg.StateAttribute.ON)

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
            lbox_node.setPosition  (osg.Vec3d (frandom(-50,50),
                                               frandom(-50,50),
                                               frandom(-100,100)))
            pNode.addChild(lbox_node)

#setup the scene with a rotating pillar
root = osg.Group()
pillar = osg.PositionAttitudeTransform()
animatecallback = RotateCB(speed=0.001)
#pillar.setUpdateCallback(animatecallback)      #don't know why this crashes (again?)
root.addChild(pillar)

imagelist=[]

#get the BBC's "Today in images" page URL from today from the RSS
#rssaddress = 'http://newsrss.bbc.co.uk/rss/newsonline_world_edition/in_pictures/rss.xml'# 
#BBC appears to have changed their feed, instead use a flickr interesting photo feed
rssaddress = 'http://www.flourish.org/news/flickr-daily-interesting.xml'
maxphotos = 20

#generate a list of URLs from the last couple of items
urllist = getUrlsFromRSS(rssaddress,4)

#generate a list of images from the list of URLs
for urlitem in urllist:
    imagelist += getImageListFromPage(urlitem)

#create image objects from the list
createObjectFromImageList(pillar,imagelist)

# osgViewer section, see other viewer examples for these functions
viewer = osgViewer.Viewer()
viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)
viewer.addEventHandler(osgViewer.StatsHandler())
viewer.addEventHandler(osgViewer.WindowSizeHandler())
viewer.addEventHandler(osgViewer.ThreadingHandler())
viewer.addEventHandler(osgViewer.HelpHandler())
viewer.setSceneData(root)
viewer.run()
