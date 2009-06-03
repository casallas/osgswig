#!/usr/bin/env python
#simpleosg.py

__author__  = ["Rene Molenaar"]
__url__     = ("http://code.google.com/p/osgswig/")
__version__ = "1.0.0"
__doc__     = """ This example shows to use osgViewer.Viewer within PyQt4 ____Rene Molenaar 2008 
                  the basics functionality is present, but there are many 'missing features'
                  for example, mouse modifiers are not adapted, mouse wheel is not adapted and 
                  non-ascii keyboard input is not adapted.
              """

# general Python
import sys,os

# import wxWidgets stuff
import PyQt4

# import OpenSceneGraph wrapper
import osg, osgDB, osgGA, osgViewer

from PyQt4 import QtOpenGL
from PyQt4 import Qt, QtGui, QtCore

mouseButtonDictionary = {
    QtCore.Qt.LeftButton: 1,
    QtCore.Qt.MidButton: 2,
    QtCore.Qt.RightButton: 3,
    QtCore.Qt.NoButton: 0,
    }

class PyQtOSGWidget(QtOpenGL.QGLWidget):
    def __init__(self, parent = 0, name = '' ,flags = 0):
        """constructor """
        QtOpenGL.QGLWidget.__init__(self, parent)
        self.setFocusPolicy(QtCore.Qt.ClickFocus)
        self.timer = Qt.QTimer()

    def initializeGL (self):
        """initializeGL the context and create the osgViewer, also set manipulator and event handler """       
        self.gw = self.createContext()
        self.viewer = self.createViewer()
        #init the default eventhandler
        self.viewer.setCameraManipulator(osgGA.TrackballManipulator())
        self.viewer.addEventHandler(osgViewer.StatsHandler())
        self.viewer.addEventHandler(osgViewer.HelpHandler())
        QtCore.QObject.connect(self.timer, QtCore.SIGNAL("timeout ()"), self.updateGL)
        self.timer.start(0)

    def embedInContext (self):
        """create a osg.GraphicsWindow for a Qt.QWidget window"""
        gw = osgViewer.GraphicsWindowEmbedded(0,0,self.width(),self.height())
        return gw

    def createContext (self):
        """create a opengl context (currently WindowData classes are not wrapped so we can not inherrit the windowdata) """
        ds = osg.DisplaySettings_instance()
        traits = osg.Traits()
        traits.readDISPLAY()
        if (traits.displayNum<0): traits.displayNum = 0

        traits.windowName = "osgViewerPyQt"
        traits.screenNum = 0
        traits.x = self.x()
        traits.y = self.y()
        traits.width = self.width()
        traits.height = self.height()
        traits.alpha = ds.getMinimumNumAlphaBits()
        traits.stencil = ds.getMinimumNumStencilBits()
        traits.windowDecoration = False
        traits.doubleBuffer = True
        traits.sampleBuffers = ds.getMultiSamples()
        traits.samples = ds.getNumMultiSamples()
        gw = osgViewer.GraphicsWindowEmbedded(traits)
        return gw

    def createViewer (self):
        """create a osgViewer.Viewer and set the viewport, camera and previously created graphical context """
        viewer = osgViewer.Viewer()
        viewer.getCamera().setViewport(osg.Viewport(0,0, self.width(), self.height()))
        viewer.getCamera().setProjectionMatrixAsPerspective(30.0,float(self.width())/float(self.height()), 1.0, 10000.0)
        if not self.gw:
            raise Exception("GraphicsWindow not yet created")
        viewer.getCamera().setGraphicsContext(self.gw)        
        return viewer

    def resizeGL( self, w, h ):
        print "GL resized ", w, h
        self.gw.resized(0,0,w,h)

    def paintGL (self):
        self.viewer.frame()

    def mousePressEvent( self, event ):
        """put the qt event in the osg event queue"""
        button = mouseButtonDictionary.get(event.button(), 0)
        self.gw.getEventQueue().mouseButtonPress(event.x(), event.y(), button)

    def mouseReleaseEvent( self, event ):
        """put the qt event in the osg event queue"""
        button = mouseButtonDictionary.get(event.button(), 0)
        self.gw.getEventQueue().mouseButtonRelease(event.x(), event.y(), button)

    def mouseMoveEvent(self, event):
        """put the qt event in the osg event queue"""
        self.gw.getEventQueue().mouseMotion(event.x(), event.y())

    def keyPressEvent(self, event):
        """ translate the qt event to an osg event (currently only ascii values) """
        print "key pressed", event.text()
        self.gw.getEventQueue().keyPress( ord(event.text().toAscii().data()) ) #

    def keyReleaseEvent(self, event):
        """ translate the qt event to an osg event (currently only ascii values) """
        print "key released", event.text()
        self.gw.getEventQueue().keyRelease( ord(event.text().toAscii().data()) )

    def timerEvent(self, timerevent):
        """periodically called (each cycle) calls updateGL (which will trigger paintGL)"""
        self.updateGL()

    def getGraphicsWindow(self):
        """returns the osg graphicswindow created by osgViewer """
        return self.gw 

class PyViewerQT():
    """ Alternative implemenation test, using EmbeddedWindow """
    def __init__(self, parent = 0, name = '' ,flags = 0):
        self.window = Qt.QWidget(parent)
        #create the viewer
        self.viewer = osgViewer.Viewer()         
        self.osgwindow = self.viewer.setUpViewerAsEmbeddedInWindow(0,0, self.window.width(), self.window.height())
        #set default manipulators and event handlers
        self.viewer.setCameraManipulator(osgGA.TrackballManipulator())
        self.viewer.addEventHandler(osgViewer.StatsHandler())
        self.viewer.addEventHandler(osgViewer.HelpHandler())

class MainWindow(QtGui.QMainWindow):
    def __init__(self):
        QtGui.QMainWindow.__init__(self)

        #set main window properties
        self.move(80, 80)
        self.resize(400, 300)
        self.setWindowTitle('PyQtOSGWidget')

        #create central viewer widget
        self.viewerWidget = PyQtOSGWidget(self)
        self.setCentralWidget(self.viewerWidget)

        #create exit action
        exit = QtGui.QAction(QtGui.QIcon('icons/exit.png'), 'Exit', self)
        exit.setShortcut('Ctrl+Q')
        exit.setStatusTip('Exit application')
        self.connect(exit, QtCore.SIGNAL('triggered()'), QtCore.SLOT('close()'))

        #create statusbar
        self.statusBar()

        #create menubar
        menubar = self.menuBar()
        file = menubar.addMenu('&File')
        file.addAction(exit)

        #optional toolbar
        #toolbar = self.addToolBar('Exit')
        #toolbar.addAction(exit)

    def setSceneData(self, node):
        """set the scenedata in the osgViewer of the widget"""
        self.viewerWidget.viewer.setSceneData(node)

if  __name__ == "__main__":
    app = QtGui.QApplication(sys.argv)
    mainwindow = MainWindow()

    #show the mainwindow
    mainwindow.show()

    # create a root node
    node = osg.Group()
    # open a file
    loadedmodel = osgDB.readNodeFile("cow.osg")
    node.addChild(loadedmodel)
    mainwindow.setSceneData(node)

    #execute the application
    sys.exit(app.exec_())
