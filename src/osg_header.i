%{

#include <osg/Array>
#include <osg/Notify>
#include <osg/ApplicationUsage>
#include <osg/Version>
#include <osg/State>
#include <osg/StateSet>
#include <osg/StateAttribute>
#include <osg/PolygonMode>
#include <osg/LineWidth>
#include <osg/LineStipple>
#include <osg/Material>
#include <osg/Depth>
#include <osg/Stencil>
#include <osg/Geometry>

#if (OSG_VERSION_MAJOR > 1)
#include <osg/View>
#include <osg/RenderInfo>
#endif



#include <osg/Drawable>
#include <osg/ShapeDrawable>
#include <osg/Node>
#include <osg/NodeCallback>
#include <osg/Group>
#include <osg/Switch>
#include <osg/Transform>
#include <osg/PositionAttitudeTransform>
#include <osg/MatrixTransform>
#include <osg/Projection>
#include <osg/CullSettings>
#include <osg/ColorMask>

#include <osg/BufferObject>
#include <osg/Image>
#include <osg/ImageStream>

#include <osg/Light>
#include <osg/LightModel>
#include <osg/LightSource>

#if (OSG_VERSION_MAJOR > 0)
#include <osg/GraphicsThread>
#include <osg/GraphicsContext>
#endif

#include <osg/AlphaFunc>
#include <osg/BlendFunc>
#include <osg/BlendColor>
#include <osg/BlendEquation>
#include <osg/TexMat>
#include <osg/TexEnv>
#include <osg/TexEnvCombine>
#include <osg/TexEnvFilter>

#include <osg/TexGen>
#include <osg/TexGenNode>

#include <osg/Texture>
#include <osg/Texture1D>
#include <osg/Texture2D>
#include <osg/Texture3D>
#include <osg/TextureCubeMap>
#include <osg/TextureRectangle>


#include <osg/VertexProgram>

#if (OSG_VERSION_MAJOR > 0)
#include <osg/AutoTransform>
#include <osg/CameraNode>
#include <osg/CameraView>
#endif

#include <osg/Timer>


%}
