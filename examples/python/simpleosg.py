#!/usr/bin/env python
#simpleosg.py

__author__  = ["Rene Molenaar"]
__url__     = ("http://code.google.com/p/osgswig/")
__version__ = "2.0.0"
__doc__     = """ This example show the most basic use of OpenSceneGraph in Python ____Rene Molenaar 2008 """

import osgDB, osgViewer

loadedModel = osgDB.readNodeFile("cow.osg")
viewer = osgViewer.Viewer()
viewer.setSceneData(loadedModel)
viewer.addEventHandler(osgViewer.StatsHandler());
viewer.run()
