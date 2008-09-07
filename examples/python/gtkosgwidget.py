#!/usr/bin/env python

"""
 gtkosgwidget.py - OpenGL-capable gtk drawingarea widget with osg viewer embedded 

 2008 - Gerwin de Haan
 After simple.c in PyGtkGLExt, Alif Wahid, March 2003. Rewritten in object-oriented style, Naofumi
"""

import sys
import pygtk
pygtk.require('2.0')
import gtk
import gtk.gtkgl
from   OpenGL.GL import *

import osg
import osgDB
import osgUtil
import osgViewer
import osgGA

# Create OpenGL-capable gtk.DrawingArea by subclassing
# gtk.gtkgl.Widget mixin.

class SimpleDrawingArea(gtk.DrawingArea, gtk.gtkgl.Widget):
    """OpenGL drawing area for simple demo."""

    def __init__(self, glconfig,viewer=None,window=None):
        gtk.DrawingArea.__init__(self)

        # Set OpenGL-capability to the drawing area
        self.set_gl_capability(glconfig)

        # Connect the relevant signals.
        self.connect_after('realize',   self._on_realize)
        self.connect('configure_event', self._on_configure_event)
        self.connect('expose_event',    self._on_expose_event)
        self.connect("key_press_event", self._on_key_press_event)
        
        self.add_events(gtk.gdk.BUTTON_PRESS_MASK   |
                        gtk.gdk.BUTTON_RELEASE_MASK)

        self.__motion_events=0
        self.__motion_events |= gtk.gdk.BUTTON_MOTION_MASK
        self.__motion_events |= gtk.gdk.POINTER_MOTION_MASK
        self.add_events(self.__motion_events)
        self.connect('motion_notify_event', self._on_mouse_event)
        self.connect("button_press_event", self._on_mouse_event)
        self.connect("button_release_event", self._on_mouse_event)

        #experimental: Stereo in a window
        #self.ds = osg.DisplaySettings_instance()
        #self.ds.setStereo(True)
        #self.ds.setStereoMode(osg.DisplaySettings.QUAD_BUFFER)

        if viewer is None:
            self.viewer = osgViewer.Viewer()
        else:
            self.viewer = viewer
        self.osgwindow = self.viewer.setUpViewerAsEmbeddedInWindow(0,0,200,200)
        self.viewer.setCameraManipulator(osgGA.TrackballManipulator())

        self.viewer.addEventHandler(osgViewer.StatsHandler())
        self.viewer.addEventHandler(osgViewer.HelpHandler())

        self.rootnode = osg.MatrixTransformRef(osg.MatrixTransform())

        self.load_file("cow.osg")

        self.viewer.setSceneData(self.rootnode.get())

        
        self._x,self._y =0,0

    def load_file (self,pFileName):
        print "Opening file ", pFileName
        if self.rootnode.getNumChildren>0:
            self.rootnode.removeChild(0)
        self.objnode = osgDB.readNodeFile(pFileName)
        self.rootnode.addChild(self.objnode)

    def register_key_events(self, focus_window):
        # Add key events to focus_window
        focus_window.connect('key_press_event',   self._on_key_press_event)
        focus_window.connect('key_release_event', self._on_key_press_event)
        focus_window.add_events(gtk.gdk.KEY_PRESS_MASK   |
                                gtk.gdk.KEY_RELEASE_MASK)

    def _on_realize(self, *args):
        # Obtain a reference to the OpenGL drawable
        # and rendering context.
        gldrawable = self.get_gl_drawable()
        glcontext = self.get_gl_context()

        # OpenGL begin.
        if not gldrawable.gl_begin(glcontext):
            return
    
        gldrawable.gl_end()

    def _on_configure_event(self, *args):
        self.osgwindow.resized(0,0,self.allocation.width,self.allocation.height)
        return False

    def _on_expose_event(self, *args):
        # Obtain a reference to the OpenGL drawable
        # and rendering context.
        gldrawable = self.get_gl_drawable()
        self.viewer.frame()

        if gldrawable.is_double_buffered():
            gldrawable.swap_buffers()
        else:
            glFlush()
        return False

    def update (self,*args):
        #print "Update ", self.window
        self.window.invalidate_rect(self.allocation, False)
        #self.window.process_updates(False)
        return True

    def _on_key_press_event (self,widget,event):
        #print "_on_key_press_event", widget, event,event.type
        if event.type== gtk.gdk.KEY_PRESS:
            q = self.viewer.getEventQueue()
            q.keyPress(event.keyval)
        return False

    def _on_mouse_event(self,widget,event):
        #print "_on_mouse_event", widget, event
        q = self.viewer.getEventQueue()
        if event.type==gtk.gdk.BUTTON_PRESS:
            q.mouseButtonPress(self._x, self._y, event.button)
        elif event.type==gtk.gdk.BUTTON_RELEASE:
            q.mouseButtonRelease(self._x, self._y, event.button)
        elif event.type==gtk.gdk.MOTION_NOTIFY:
            self._x = event.x
            self._y = event.y
            q.mouseMotion(self._x,self._y)
        return False
