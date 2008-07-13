#!/usr/bin/env python

"""
 gtkosg.py - a simple gtk window with an osg viewport embedded in an gtk drawingarea widget

 Gerwin de Haan, July 2008 
 After simple.c in PyGtkGLExt, Alif Wahid, March 2003. Rewritten in object-oriented style, Naofumi
"""

import sys
import pygtk
pygtk.require('2.0')
import gtk
from   OpenGL.GL import *
import gobject
import gtkosgwidget

class SimpleDemo(gtk.Window):
    """Simple demo application."""

    def __init__(self):
        gtk.Window.__init__(self)

        self.set_title('simple')
        if sys.platform != 'win32':
            self.set_resize_mode(gtk.RESIZE_IMMEDIATE)
        self.set_reallocate_redraws(True)
        self.connect('delete_event', gtk.main_quit)

        # VBox to hold everything.
        vbox = gtk.VBox()
        self.add(vbox)

        # Query the OpenGL extension version.
        print "OpenGL extension version - %d.%d\n" % gtk.gdkgl.query_version()

        # Configure OpenGL framebuffer.
        # Try to get a double-buffered framebuffer configuration,
        # if not successful then try to get a single-buffered one.
        display_mode = (gtk.gdkgl.MODE_RGB    |
                        gtk.gdkgl.MODE_DEPTH  |
                        gtk.gdkgl.MODE_DOUBLE)
        try:
            glconfig = gtk.gdkgl.Config(mode=display_mode)
        except gtk.gdkgl.NoMatches:
            display_mode &= ~gtk.gdkgl.MODE_DOUBLE
            glconfig = gtk.gdkgl.Config(mode=display_mode)

        print "is RGBA:",                 glconfig.is_rgba()
        print "is double-buffered:",      glconfig.is_double_buffered()
        print "is stereo:",               glconfig.is_stereo()
        print "has alpha:",               glconfig.has_alpha()
        print "has depth buffer:",        glconfig.has_depth_buffer()
        print "has stencil buffer:",      glconfig.has_stencil_buffer()
        print "has accumulation buffer:", glconfig.has_accum_buffer()

        # An open button.
        button_open = gtk.Button('Open')
        button_open.connect('clicked', self.do_open)
        vbox.pack_start(button_open, expand=False)

        # SimpleDrawingArea
        self.drawing_area = gtkosgwidget.SimpleDrawingArea(glconfig)
        self.drawing_area.set_size_request(640, 480)
        vbox.pack_start(self.drawing_area)

        # A quit button.
        button_quit = gtk.Button('Quit')
        button_quit.connect('clicked', gtk.main_quit)
        vbox.pack_start(button_quit, expand=False)

        #register the key callbacks to the drawing area
        self.drawing_area.register_key_events(self)

        self.init_draw_update()

    def init_draw_update(self, *args):
        #a simplistic 30Hz timed update for the osg area
        #self.timeout = gobject.timeout_add(int(1000.0/30.0),drawing_area.update)

        #an idle update for the osg area
        self.timeout = gobject.idle_add(self.drawing_area.update)

    def do_open (self,*args):
        """Open dialog, and load the model"""
        file_open = gtk.FileChooserDialog(title="Select Model File"
                , action=gtk.FILE_CHOOSER_ACTION_OPEN
                , buttons=(gtk.STOCK_CANCEL
                            , gtk.RESPONSE_CANCEL
                            , gtk.STOCK_OPEN
                            , gtk.RESPONSE_OK))
        file_open.set_default_response(gtk.RESPONSE_OK)

        #disable the "on_idle" graphics update
        gobject.source_remove(self.timeout)

        """Create and add the 'all files' filter"""
        filter = gtk.FileFilter()
        filter.set_name("All files")
        filter.add_pattern("*")
        file_open.add_filter(filter)
        #file_open.set_current_folder("/home/gerwin")

        """Init the return value"""
        result = ""
        if file_open.run() == gtk.RESPONSE_OK:
            result = file_open.get_filename()
            self.drawing_area.load_file(result)
        file_open.destroy()

        #restart the graphics updates
        self.init_draw_update()

        return False


class _Main(object):
    """Simple application driver."""

    def __init__(self, app):
        self.app = app

    def run(self):
        self.app.show_all()
        gtk.main()


if __name__ == '__main__':
    _Main(SimpleDemo()).run()
