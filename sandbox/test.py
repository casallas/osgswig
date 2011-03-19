import ctypes
import osgDB, osgViewer, osg
group = osg.Group()
image = osgDB.readImageFile("/home/trigrou/Pictures/backgrounds/games/Another_World_by_Orioto.jpg")
loadedModel = osg.Group()

corner = osg.Vec3(0,0,0);
width = osg.Vec3(1,0,0);
height = osg.Vec3(0,1,0);
geom = osg.createTexturedQuadGeometry(corner, width, height, 0.0, 0.0, 1.0, 1.0);
geom.getOrCreateStateSet().setTextureAttributeAndModes(0, osg.Texture2D(image))
geom.getOrCreateStateSet().setTextureAttributeAndModes(1, osg.Texture2D(osgDB.readImageFile("/home/trigrou/Pictures/backgrounds/games/Big_Blue_by_Orioto.jpg")))

vertProg = """
void main()
	{	
		gl_Position = ftransform();
                gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	}
"""
fragProg = """
uniform float test;
uniform int index;
uniform sampler2D tex0;
uniform sampler2D tex1;
	void main()
	{
                vec4 color;
                if (index == 0.0)
	           color = texture2D(tex0,gl_TexCoord[0].st);
                if (index != 0.0)
	           color = vec4(0,1,0,1); //texture2D(tex1,gl_TexCoord[0].st);
	        color *= test;
                gl_FragColor = color;
	}
"""

vert = osg.Shader(osg.Shader.VERTEX, vertProg)
frag = osg.Shader(osg.Shader.FRAGMENT, fragProg)
prog = osg.Program()
prog.addShader(vert)
prog.addShader(frag)
geom.getOrCreateStateSet().setTextureAttributeAndModes(0, osg.Texture2D(image))
geom.getOrCreateStateSet().setAttributeAndModes(prog)
ind = osg.Uniform(osg.Uniform.INT, "index")
ind.set(ctypes.c_int(1))
uniform = osg.Uniform(osg.Uniform.FLOAT, "test")
uniform.set(4.0)
tex = osg.Uniform(osg.Uniform.SAMPLER_2D, "tex0")
tex.set(ctypes.c_uint(0))
tex2 = osg.Uniform(osg.Uniform.SAMPLER_2D, "tex1")
tex2.set(ctypes.c_uint(1))

geom.getOrCreateStateSet().addUniform(uniform);
geom.getOrCreateStateSet().addUniform(ind);
geom.getOrCreateStateSet().addUniform(tex);
geom.getOrCreateStateSet().addUniform(tex2);


geode = osg.Geode()
geode.addDrawable(geom)
group.addChild(geode)
group.addChild(loadedModel)

viewer = osgViewer.Viewer()
viewer.setSceneData(group)
viewer.addEventHandler(osgViewer.StatsHandler());
viewer.run()
