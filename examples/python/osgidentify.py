#!/usr/bin/env python

"""
 osgidentify.py - a brainless python script to help in reporting system type, library versions etc.

 Gerwin de Haan, November 2008 
"""

import sys
import os
import platform

print "-"*80

#platform specifics
# see http://docs.python.org/library/platform.html
print "Platform         ",platform.platform()
print "Architecture     ",platform.architecture()
print "Machine          ",platform.machine()

print "--"

#python specifics
print "Python build     ",platform.python_build()
print "Python compiler  ",platform.python_compiler()

print "--"

#osg specifics
try:
    try:
        import osg
    except:
        print "import osg failed"
    print "osg.osgGetLibraryName                  ", osg.osgGetLibraryName()
    print "osg.osgGetVersion                      ", osg.osgGetVersion()
    print "osg.osgGetSOVersion                    ", osg.osgGetSOVersion()
    print "osg Python library location          : ", osg.__file__
    print "osg Dynamic linked library location  : ", osg._osg

except:
    print "Error accessing osg"
    pass

print "--"

#osgDB specifics
try:
    try:
        import osgDB
    except:
        print "import osgDB failed"
    print "osgDB.osgGetLibraryName                ", osgDB.osgDBGetLibraryName()
    print "osgDB.osgGetVersion                    ", osgDB.osgDBGetVersion()
    print "osgDB Python library location        : ", osgDB.__file__
    print "osgDB Dynamic linked library location: ", osgDB._osgDB
except:
    print "Error accessing osgDB"
    pass

print "-"*80

