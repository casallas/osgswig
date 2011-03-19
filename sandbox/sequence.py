import ctypes
import osgDB, osgViewer, osg, osgGA


def addShader(geom):
    vertProg = """
    void main()
            {	
                    gl_Position = ftransform();
                    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
            }
    """
    fragProg = """
    uniform sampler2D tex0;
            void main()
            {
                    vec4 color;
                    color = texture2D(tex0,gl_TexCoord[0].st);
                    gl_FragColor = color;
            }
    """

    vert = osg.Shader(osg.Shader.VERTEX, vertProg)
    frag = osg.Shader(osg.Shader.FRAGMENT, fragProg)
    prog = osg.Program()
    prog.addShader(vert)
    prog.addShader(frag)
    geom.getOrCreateStateSet().setAttributeAndModes(prog)
    tex = osg.Uniform(osg.Uniform.SAMPLER_2D, "tex0")
    tex.set(ctypes.c_uint(0))
    geom.getOrCreateStateSet().addUniform(tex);



import os
imagesSrc = []
for t in os.listdir("."):
    print t
    imagesSrc.append(t)


iteration = 400
duration = 60.0

print "step " + str(duration/iteration)

images = []
for i in range(0, iteration):
    filename = imagesSrc[i%len(imagesSrc)]
    iseq = osg.ImageSequence()
    iseq.addImageFile(filename)
    iseq.setMode(osg.ImageSequence.PAGE_AND_DISCARD_USED_IMAGES)
    iseq.play()
    iseq.setLength(1e7)
    images.append(iseq)


sequence = osg.Sequence()
for i in range(0,iteration):
    corner = osg.Vec3(0,0,0);
    width = osg.Vec3(1,0,0);
    height = osg.Vec3(0,0,1);
    geom = osg.createTexturedQuadGeometry(corner, width, height, 0.0, 0.0, 1.0, 1.0);
    texture = osg.Texture2D(images[i])
    texture.setResizeNonPowerOfTwoHint(False)
    texture.setUnRefImageDataAfterApply(True)
    texture.setFilter(osg.Texture.MIN_FILTER, osg.Texture.LINEAR)
    texture.setFilter(osg.Texture.MAG_FILTER, osg.Texture.LINEAR)
    geom.getOrCreateStateSet().setTextureAttributeAndModes(0, texture)
    addShader(geom);
    geode = osg.Geode()
    geode.addDrawable(geom)
    sequence.addChild(geode, duration/iteration )

sequence.setDuration(1.0, -1)
sequence.setMode(osg.Sequence.START)

viewer = osgViewer.Viewer()
viewer.setSceneData(sequence)
viewer.addEventHandler(osgViewer.StatsHandler());

#viewer.run()
cam = osgGA.TrackballManipulator()
viewer.realize()
#GUIActionAdapterToViewer(cam)
viewer.setCameraManipulator(cam)
#viewer.setCameraManipulatorOneArg(cam)
#viewer.setCameraManipulatorAndResetView(cam, True)
#setupDefaultManipulator(viewer)
time = 0.0
for i in range(0, 1000):
    viewer.frameAtTime(time)
    time = time + 0.16666666
    print "time " + str(time)
