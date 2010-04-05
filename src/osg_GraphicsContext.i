/*
osg_GraphicsContext.i - defines "global" versions of nested classes in osg::GraphicsContext
*/

%ignore osg::GraphicsContext::add;
%ignore osg::GraphicsContext::remove;
%ignore osg::GraphicsContext::getCurrentOperation;
%ignore osg::GraphicsContext::setCreateGraphicsContextCallback;
%ignore osg::GraphicsContext::getCreateGraphicsContextCallback;
%ignore osg::GraphicsContext::setResizedCallback;
%ignore osg::GraphicsContext::getResizedCallback;

%include osg/GraphicsContext

%{
using namespace osg;
%}

struct ScreenIdentifier
{
    ScreenIdentifier();
    ScreenIdentifier(int in_screenNum);
    ScreenIdentifier(const std::string& in_hostName,int in_displayNum, int in_screenNum);
    std::string displayName() const;
    void readDISPLAY();
    void setScreenIdentifier(const std::string& displayName);
    void setUndefinedScreenDetailsToDefaultScreen();
    std::string  hostName;
    int displayNum;
    int screenNum;
};

struct Traits : public osg::Referenced, public ScreenIdentifier
{
    Traits();
    int x;
    int y;
    int width;
    int height;
    std::string windowName;
    bool        windowDecoration;
    bool        supportsResize;
    unsigned int red;
    unsigned int blue;
    unsigned int green;
    unsigned int alpha;
    unsigned int depth;
    unsigned int stencil;
    unsigned int sampleBuffers;
    unsigned int samples;
    bool pbuffer;
    bool quadBufferStereo;
    bool doubleBuffer;
    GLenum          target;
    GLenum          format;
    unsigned int    level;
    unsigned int    face;
    unsigned int    mipMapGeneration;
    bool            vsync;
    bool            useMultiThreadedOpenGLEngine;
    bool            useCursor;
    GraphicsContext* sharedContext;
    osg::ref_ptr<osg::Referenced> inheritedWindowData;
    bool setInheritedWindowPixelFormat;
};

struct WindowingSystemInterface : public osg::Referenced
{
    virtual unsigned int getNumScreens(const ScreenIdentifier& screenIdentifier = ScreenIdentifier()) = 0;
    virtual void getScreenResolution(const ScreenIdentifier& screenIdentifier, unsigned int& width, unsigned int& height) = 0;
    virtual bool setScreenResolution(const ScreenIdentifier& /*screenIdentifier*/, unsigned int /*width*/, unsigned int /*height*/) { return false; }
    virtual bool setScreenRefreshRate(const ScreenIdentifier& /*screenIdentifier*/, double /*refreshRate*/) { return false; }
    virtual GraphicsContext* createGraphicsContext(Traits* traits) = 0;
    virtual ~WindowingSystemInterface() {};
};

%pythoncode %{
#get the original definitions back into their classes
GraphicsContext.Traits = Traits
GraphicsContext.ScreenIdentifier = ScreenIdentifier
GraphicsContext.WindowingSystemInterface = WindowingSystemInterface
%}
