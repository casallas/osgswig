#!/usr/bin/ruby

#
# based on Simple Ruby/GtkGLExt example by Vincent Isambart
#

require 'gtkglext'

# extend the load path for wosg
$LOAD_PATH << '../../bin/ruby'

require 'wosg'
require 'wosgDB'
require 'wosgUtil'


sceneview = WosgUtil::SceneView.new

sceneview.setDefaults()

scene = Wosg::Transform.new

sceneview.setSceneData(scene)

scene.addChild(WosgDB::readNodeFile("cow.osg"))


def realize(w)
    glcontext = w.gl_context
    gldrawable = w.gl_drawable

    #*** OpenGL BEGIN ***
    gldrawable.gl_begin(glcontext) do

		# sceneview.setViewport(0, 0, w.allocation.width, w.allocation.height)

    end
end

# Init GTK
Gtk.init
# Init GtkGlExt
Gtk::GL.init
# Query OpenGL extension version
major, minor = Gdk::GL.query_version
puts "\nOpenGL extension version - #{major}.#{minor}\n"

# Configure OpenGL-capable visual
# Try double-buffered visual
# Note: Could be glconfig = Gdk::GLConfig.new([ Gdk::GLConfig::USE_GL, Gdk::GLConfig::RGBA, Gdk::GLConfig::DEPTH_SIZE, 16, Gdk::GLConfig::DOUBLEBUFFER ])
glconfig = Gdk::GLConfig.new(Gdk::GLConfig::MODE_RGB   |
                             Gdk::GLConfig::MODE_DEPTH |
                             Gdk::GLConfig::MODE_DOUBLE)
if !glconfig
    puts "*** Cannot find the double-buffered visual.\n"
    puts "*** Trying single-buffered visual.\n"
    # Try single-buffered visual
    glconfig = Gdk::GLConfig.new(Gdk::GLConfig::MODE_RGB  |
                                 Gdk::GLConfig::MODE_DEPTH)
    if !glconfig
        puts "*** No appropriate OpenGL-capable visual found.\n"
        exit 1
    end
end


# Top-level window
window = Gtk::Window.new
window.title = "OpenSceneGraph GTK"


# Perform the resize immediately
window.resize_mode = Gtk::RESIZE_IMMEDIATE
# Get automatically redrawn if any of their children changed allocation.
window.reallocate_redraws = true

window.signal_connect("delete_event") do
    Gtk.main_quit
    true
end

# VBox
vbox = Gtk::VBox.new
window.add(vbox)
vbox.show

# Drawing area for drawing OpenGL scene
drawing_area = Gtk::DrawingArea.new
drawing_area.set_size_request(800, 600)
# Set OpenGL-capability to the widget
drawing_area.set_gl_capability(glconfig)

drawing_area.signal_connect_after("realize") { |w| realize(w) }
drawing_area.signal_connect("configure_event") do |w, e|
    glcontext = w.gl_context
    gldrawable = w.gl_drawable

    gldrawable.gl_begin(glcontext) do
		
		# for resizing
		sceneview.setViewport(0, 0, w.allocation.width, w.allocation.height)

        true
    end
end


drawing_area.signal_connect("expose_event") do |w,e|
    glcontext = w.gl_context
    gldrawable = w.gl_drawable

    gldrawable.gl_begin(glcontext) do

		sceneview.update

		sceneview.cull

		sceneview.draw

		if gldrawable.double_buffered?
			gldrawable.swap_buffers
		end

       
		true
    end
end

vbox.pack_start(drawing_area)
drawing_area.show

# Simple quit button
button = Gtk::Button.new("Quit")
button.signal_connect("clicked") do
    Gtk.main_quit
end
vbox.pack_start(button, false, false)
button.show

# Show window
window.show

# Main loop
Gtk.main
