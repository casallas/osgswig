#!/usr/bin/env python
#osgppuviewer.py

__author__  = ["Rene Molenaar"]
__url__     = ("http://code.google.com/p/osgswig/")
__version__ = "0.5.0"
__doc__     = """ This example shows to use osgViewer.Viewer with osgPPU ____Rene Molenaar 2008
                  load an .osg file and a .ppu file to render with post processing
                  todo:
                  * ResizeEventHandler
                  * osg::GraphicsContext::getWindowingSystemInterface()->getScreenResolution
                  * additional frame without preprocessing needed to prevent errors
              """

import osg, osgDB, osgViewer, osgPPU

def createRenderTexture(tex_width, tex_height, depth):
    """Create camera resulting texture"""
    # create simple 2D texture
    texture2D = osg.Texture2D()
    texture2D.setTextureSize(int(tex_width), int(tex_height))
    texture2D.setResizeNonPowerOfTwoHint(False)
    texture2D.setFilter(osg.Texture2D.MIN_FILTER,osg.Texture2D.LINEAR)
    texture2D.setFilter(osg.Texture2D.MAG_FILTER,osg.Texture2D.LINEAR)
    texture2D.setWrap(osg.Texture2D.WRAP_S,osg.Texture2D.CLAMP_TO_BORDER)
    texture2D.setWrap(osg.Texture2D.WRAP_T,osg.Texture2D.CLAMP_TO_BORDER)
    texture2D.setBorderColor(osg.Vec4d(1.0,1.0,1.0,1.0))
    #setup float format
    if not depth:
        texture2D.setInternalFormat(osg.GL_RGBA16F_ARB)
        texture2D.setSourceFormat(osg.GL_RGBA)
        texture2D.setSourceType(osg.GL_FLOAT)
    else:
        texture2D.setInternalFormat(osg.GL_DEPTH_COMPONENT)
    return texture2D


def setupCamera(camera, viewport = None):
    """Setup the camera """
    vp = viewport if viewport else camera.getViewport()

    #create texture to render to
    texture = createRenderTexture(vp.getWidth(), vp.getHeight(), False)
    depthTexture = createRenderTexture(vp.getWidth(), vp.getHeight(), True)

    #set up the background color and clear mask.
    camera.setClearColor(osg.Vec4(0.0,0.0,0.0,0.0))
    camera.setClearMask(osg.GL_COLOR_BUFFER_BIT | osg.GL_DEPTH_BUFFER_BIT)

    #set viewport
    camera.setViewport(vp)
    camera.setComputeNearFarMode(osg.CullSettings.DO_NOT_COMPUTE_NEAR_FAR)
    camera.setProjectionMatrixAsPerspective(35.0, vp.getWidth()/vp.getHeight(), 0.001, 100.0)

    #tell the camera to use OpenGL frame buffer object where supported.
    camera.setRenderTargetImplementation(osg.Camera.FRAME_BUFFER_OBJECT)

    #attach the texture and use it as the color buffer.
    camera.attach(osg.Camera.COLOR_BUFFER, texture)
    camera.attach(osg.Camera.DEPTH_BUFFER, depthTexture)


#//--------------------------------------------------------------------------
#// Event handler to react on resize events
#//--------------------------------------------------------------------------
#class ResizeEventHandler : public osgGA::GUIEventHandler
#{
#public:
#    osgPPU::Processor* _processor;
#    osg::Camera* _camera;
#
#    ResizeEventHandler(osgPPU::Processor* proc, osg::Camera* cam) : _processor(proc), _camera(cam) {}
#
#    bool handle(const osgGA::GUIEventAdapter& ea,osgGA::GUIActionAdapter&)
#    {
#        if(ea.getEventType() == osgGA::GUIEventAdapter::RESIZE)
#        {
#           osgPPU::Camera::resizeViewport(0,0, ea.getWindowWidth(), ea.getWindowHeight(), _camera);
#
#           _processor->onViewportChange();
#        }
#        return false;
#    }
#};

if __name__ == "__main__":
    # parse arguments
    #osg::ArgumentParser arguments(&argc,argv);

    # give some info in the console
    #print("Usage: viewer ppufile [osgfile]\n")

    #if (argc <= 1) return 0;

    #construct the viewer.
    viewer = osgViewer.Viewer()

    #todo get current screen width
    screenWidth = 1920
    screenHeight = 1080
    windowWidth = 640;
    windowHeight = 480;
    viewer.setUpViewInWindow((screenWidth-windowWidth)/2, (screenHeight-windowHeight)/2, windowWidth, windowHeight)

    #window = viewer.getCamera().getGraphicsContext().asGraphicsWindow()
    #if (window)
    #  window.setWindowName(".ppu file viewer")
    #else:
    #  print("No Window created")

    # setup scene
    # create a root node
    node = osg.Group()

    # open a file
    loadedmodel = osgDB.readNodeFile("cessnafire.osg")
    node.addChild(loadedmodel)

    #currently osgPPU needs an already setup viewer to work correctly
    viewer.setSceneData( node )
    viewer.frame()

    #if (argc > 2) loadedModel = osgDB::readNodeFile(arguments[2]);
    #if (argc > 2 && !loadedModel)
    #{
    #    printf("File not found %s !\n", arguments[2]);
    #    return 1;
    #}
    #if (!loadedModel) loadedModel = createTeapot()
    #node->addChild(loadedModel);

    # disable color clamping, because we want to work on real hdr values
    clamp = osg.ClampColor()
    clamp.setClampVertexColor(osg.GL_FALSE)
    clamp.setClampFragmentColor(osg.GL_FALSE)
    clamp.setClampReadColor(osg.GL_FALSE)

    # make it protected and override, so that it is done for the whole rendering pipeline
    node.getOrCreateStateSet().setAttribute(clamp, osg.StateAttribute.ON | osg.StateAttribute.OVERRIDE | osg.StateAttribute.PROTECTED)

    # load the processor from a file
    processor = osgPPU.NodeToProcessor(osgDB.readObjectFile(r"Data\hdr.ppu"))
    if not processor:
        print("File does not contain a valid pipeline")
        exit()
    
    #setup viewers camera
    setupCamera(viewer.getCamera())
    processor.setCamera(viewer.getCamera())
    
    #add processor to the scene
    node.addChild(processor)
    
    #add model to viewer.
    #viewer.addEventHandler(new ResizeEventHandler(processor, viewer->getCamera()));    
    viewer.setSceneData( node )
    viewer.frame()
    
    #run viewer
    viewer.run()

