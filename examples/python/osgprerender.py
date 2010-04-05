#!/usr/bin/env python

__author__  = ["Gerwin de Haan"]
__doc__     = """ Python version from the osgprerender.cpp example"""

# conversion from cpp to python
# search replace helps : 
# comments:  //  #
# namespaces: ::  .
# pointer refs: ->  .
# ; delimiters might be kept
#
# remove type definitions before declarations
# remove new statements
# change if, while loops
# remove the trailing f with floating point numbers 
# change constructors     osg.Vec3 origin(0.0f,0.0f,0.0f); -> origin = osg.Vec3(0,0,0)
# change Vec3 accessors top.z() -> top[2]
# change Vec3 assignment a=osg.Vec3(b) -> a= osg.Vec3(b[0],b[1],b[2])
# change inline if/then/else constructions a?1:0 to regular
# change boolean true/false to python boolean True/False
# watch out for reserved Python words, e.g. type

# when overloading a class:
#   make the class properties initialise in the init function if not done so by the constructor already
#   define an __init__(self, param1, param2) etc.
#   explicitely call the __init__ functions of the base class(es) with self as an argument
#   extend all methods with self as the first parameter
#   change references to "this" into "self"

#import the needed modules
import osg, osgDB, osgGA, osgViewer, osgUtil
import os, sys

# call back which creates a deformation field to oscillate the model.
# NOTE, this Callback is not yet fully functional (the attributefunctor part is broken)
class MyGeometryCallback (osg.Drawable.UpdateCallback,osg.Drawable.AttributeFunctor):
        def __init__ (self,o,x,y,z,period,xphase,amplitude):
            self._firstCall = True
            self._startTime = 0.0
            self._time =0.0
            self._period =period
            self._xphase = xphase 
            self._amplitude =amplitude
            self._origin =o
            self._xAxis =x 
            self._yAxis =y
            self._zAxis =z
            osg.Drawable.UpdateCallback.__init__(self)
            osg.Drawable.AttributeFunctor.__init__(self)
    
        def update(self,nv,drawable):
            fs = nv.getFrameStamp()
            simulationTime = fs.getSimulationTime()
            if self._firstCall:
                self._firstCall = False
                self._startTime = simulationTime
            
            self._time = simulationTime-self._startTime
            
            #drawable.accept(self) #this one bugs
            drawable.dirtyBound()
            
            #geometry = dynamic_cast<osg::Geometry*>(drawable);
            #if (geometry)
            #{
            #   osgUtil::SmoothingVisitor::smooth(*geometry);
            #}
        
        def apply(self,ptype,count,begin):
            if ptype == osg.Drawable.VERTICES:
                TwoPI=2.0*osg.PI
                phase = -self._time/self._period
                
                end = begin+count
                #for (osg::Vec3* itr=begin;itr<end;++itr)
                #{
                    #osg::Vec3 dv(*itr-_origin);
                    #osg::Vec3 local(dv*_xAxis,dv*_yAxis,dv*_zAxis);
                    
                    #local.z() = local.x()*_amplitude*
                                #sinf(TwoPI*(phase+local.x()*_xphase)); 
                    
                    #(*itr) = _origin + 
                             #_xAxis*local.x()+
                             #_yAxis*local.y()+
                             #_zAxis*local.z();


def createPreRenderSubGraph(subgraph, tex_width, tex_height, renderImplementation, \
                                                useImage, useTextureRectangle, useHDR, \
                                                samples, colorSamples):
    if not subgraph:
        return 0

    # create a group to contain the flag and the pre rendering camera.
    parent = osg.Group()

    #texture to render to and to use for rendering of flag.
    texture = 0
    if (useTextureRectangle):
        textureRect = osg.TextureRectangle()
        textureRect.setTextureSize(tex_width, tex_height)
        textureRect.setInternalFormat(osg.GL_RGBA)
        textureRect.setFilter(osg.Texture2D.MIN_FILTER,osg.Texture2D.LINEAR)
        textureRect.setFilter(osg.Texture2D.MAG_FILTER,osg.Texture2D.LINEAR)
        texture = textureRect
    else:
        texture2D = osg.Texture2D()
        texture2D.setTextureSize(tex_width, tex_height)
        texture2D.setInternalFormat(osg.GL_RGBA)
        texture2D.setFilter(osg.Texture2D.MIN_FILTER,osg.Texture2D.LINEAR)
        texture2D.setFilter(osg.Texture2D.MAG_FILTER,osg.Texture2D.LINEAR)
        texture = texture2D

    if useHDR:
        texture.setInternalFormat(osg.GL_RGBA16F_ARB)
        texture.setSourceFormat(osg.GL_RGBA)
        texture.setSourceType(osg.GL_FLOAT)

    #first create the geometry of the flag of which to view.

    if True:
        # create the to visualize.
        polyGeom = osg.Geometry()

        polyGeom.setName( "PolyGeom" )

        polyGeom.setDataVariance( osg.Object.DYNAMIC )
        polyGeom.setSupportsDisplayList(False)

        origin= osg.Vec3 (0.0,0.0,0.0);
        xAxis= osg.Vec3 (1.0,0.0,0.0);
        yAxis= osg.Vec3 (0.0,0.0,1.0);
        zAxis= osg.Vec3 (0.0,-1.0,0.0);
        height = 100.0;
        width = 200.0;
        noSteps = 20;

        vertices = osg.Vec3Array()
        bottom = osg.Vec3 (origin[0],origin[1],origin[2])
        top = osg.Vec3 (origin[0],origin[1],origin[2])
        top[2]+= height
        dv = xAxis*(width/(float(noSteps-1)))

        texcoords = osg.Vec2Array()
        
        # note, when we use TextureRectangle we have to scale the tex coords up to compensate.
        bottom_texcoord=osg.Vec2 (0.0,0.0)
        
        if useTextureRectangle:
            ltex_height = tex_height
            ltex_width = tex_width
        else:
            ltex_height = 1.0
            ltex_width = 1.0

        top_texcoord = osg.Vec2 (0.0, ltex_height)
        dv_texcoord = osg.Vec2 (ltex_width/float((noSteps-1)),0.0)

        for i in range (noSteps):
            vertices.push_back(top)
            vertices.push_back(bottom)
            top+=dv
            bottom+=dv

            texcoords.push_back(top_texcoord)
            texcoords.push_back(bottom_texcoord)
            top_texcoord+=dv_texcoord
            bottom_texcoord+=dv_texcoord


        # pass the created vertex array to the points geometry object.
        polyGeom.setVertexArray(vertices)

        polyGeom.setTexCoordArray(0,texcoords)

        colors = osg.Vec4Array()
        colors.push_back(osg.Vec4(1.0,1.0,1.0,1.0))
        polyGeom.setColorArray(colors)
        polyGeom.setColorBinding(osg.Geometry.BIND_OVERALL)

        polyGeom.addPrimitiveSet(osg.DrawArrays(osg.PrimitiveSet.QUAD_STRIP,0,vertices.size()))

        # new we need to add the texture to the Drawable, we do so by creating a 
        # StateSet to contain the Texture StateAttribute.
        stateset = osg.StateSet()

        stateset.setTextureAttributeAndModes(0, texture,osg.StateAttribute.ON)

        polyGeom.setStateSet(stateset)

        #changes to the geometry
        polyGeom.setUpdateCallback(MyGeometryCallback(origin,xAxis,yAxis,zAxis,1.0,1.0/width,0.2).__disown__())

        geode = osg.Geode()
        geode.addDrawable(polyGeom)
        
        parent.addChild(geode)

    # then create the camera node to do the render to texture
    if True:    
        camera = osg.Camera()

        # set up the background color and clear mask.
        camera.setClearColor(osg.Vec4(0.1,0.1,0.3,1.0))
        camera.setClearMask(osg.GL_COLOR_BUFFER_BIT | osg.GL_DEPTH_BUFFER_BIT)

        bs = subgraph.getBound()
        if not bs.valid():
            return subgraph

        znear = 1.0*bs.radius()
        zfar  = 3.0*bs.radius()

        # 2:1 aspect ratio as per flag geometry below.
        proj_top   = 0.25*znear
        proj_right = 0.5*znear

        znear *= 0.9;
        zfar *= 1.1;

        # set up projection.
        camera.setProjectionMatrixAsFrustum(-proj_right,proj_right,-proj_top,proj_top,znear,zfar)

        # set view
        camera.setReferenceFrame(osg.Transform.ABSOLUTE_RF)
        camera.setViewMatrixAsLookAt(osg.Vec3d(bs.center())-osg.Vec3d(0.0,2.0,0.0)*bs.radius(), \
                                                          osg.Vec3d(bs.center()),\
                                                        osg.Vec3d(0.0,0.0,1.0))

        # set viewport
        camera.setViewport(0,0,tex_width,tex_height)

        # set the camera to render before the main camera.
        camera.setRenderOrder(osg.Camera.PRE_RENDER)

        # tell the camera to use OpenGL frame buffer object where supported.
        camera.setRenderTargetImplementation(renderImplementation)
        
        if useImage:
            image = osg.Image()
            #image.allocateImage(tex_width, tex_height, 1, GL_RGBA, GL_UNSIGNED_BYTE);
            image.allocateImage(tex_width, tex_height, 1, osg.GL_RGBA, osg.GL_FLOAT)

            # attach the image so its copied on each frame.
            camera.attach(osg.Camera.COLOR_BUFFER, image, samples, colorSamples)
            
            camera.setPostDrawCallback( MyCameraPostDrawCallback(image))
            
            # Rather than attach the texture directly to illustrate the texture's ability to
            # detect an image update and to subload the image onto the texture.  You needn't
            # do this when using an Image for copying to, as a separate camera.attach(..)
            # would suffice as well, but we'll do it the long way round here just for demonstration
            # purposes (long way round meaning we'll need to copy image to main memory, then
            # copy it back to the graphics card to the texture in one frame).
            # The long way round allows us to manually modify the copied image via the callback
            # and then let this modified image by reloaded back.
            texture.setImage(0, image)
        
        else:
            # attach the texture and use it as the color buffer.
            camera.attach(osg.Camera.COLOR_BUFFER, texture, 0, 0, False, samples, colorSamples)

        # add subgraph to render
        camera.addChild(subgraph)

        parent.addChild(camera)

    return parent

def main():

   # use an ArgumentParser object to manage the program arguments.
    #arguments = osg.ArgumentParser()

    #construct the viewer.
    viewer = osgViewer.Viewer()

    #need to use singlethreaded mode 
    viewer.setThreadingModel(viewer.SingleThreaded)
   
    # add the stats
    viewer.addEventHandler (osgViewer.StatsHandler())

    # add the record camera path handler
    viewer.addEventHandler(osgViewer.RecordCameraPathHandler())

    #add the threading handler
    viewer.addEventHandler(osgViewer.ThreadingHandler())

    #if user request help write it out to cout.
    #if (arguments.read("-h") or arguments.read("--help")):
    #   arguments.getApplicationUsage().write(sys.stdout)
    #   return 1

    tex_width = 1024;
    tex_height = 512;
    samples = 0;
    colorSamples = 0;

    renderImplementation = osg.Camera.FRAME_BUFFER_OBJECT

    useImage = False;
    useTextureRectangle = False;
    useHDR = False;

    # if not loaded assume no arguments passed in, try use default mode instead.
    loadedModel = osgDB.readNodeFile("cessna.osg")

    # create a transform to spin the model.
    loadedModelTransform = osg.MatrixTransform()
    loadedModelTransform.addChild(loadedModel)

    nc = osg.AnimationPathCallback(osg.Vec3d(loadedModelTransform.getBound().center()),osg.Vec3d(0.0,0.0,1.0),osg.inDegrees(45.0))
    loadedModelTransform.setUpdateCallback(nc);
    
    rootNode = osg.Group()
    rootNode.addChild(createPreRenderSubGraph(loadedModelTransform,\
                                                                            tex_width,tex_height, \
                                                                            renderImplementation, \
                                                                            useImage, useTextureRectangle, \
                                                                            useHDR, samples, colorSamples))
    
    osgDB.writeNodeFile(rootNode, "test.ive")

    # add model to the viewer.
    viewer.setSceneData( rootNode );
 
    viewer.run()

if __name__=="__main__":
    main()




