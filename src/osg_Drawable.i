/*
osg_Drawable.i - defines "global" versions of nested class(es) in osg::Drawable
*/

%feature("director") UpdateCallback;
%feature("director") AttributeFunctor;

//osg::Drawable, list of ignored Nested Classes
%ignore osg::Drawable::ComputeBoundingBoxCallback;
%ignore osg::Drawable::UpdateCallback;
%ignore osg::Drawable::EventCallback;
%ignore osg::Drawable::CullCallback;
%ignore osg::Drawable::DrawCallback;
%ignore osg::Drawable::AttributeFunctor;
%ignore osg::Drawable::ConstAttributeFunctor;
%ignore osg::Drawable::Extensions;

//osg::Drawable, ignore functions that handle ignored Nested Classes
%ignore osg::Drawable::getComputeBoundingBoxCallback;
%ignore osg::Drawable::setComputeBoundingBoxCallback;
%ignore osg::Drawable::getEventCallback;
%ignore osg::Drawable::setEventCallback;
%ignore osg::Drawable::getDrawCallback;
%ignore osg::Drawable::setDrawCallback;
%ignore osg::Drawable::getCullCallback;
%ignore osg::Drawable::setCullCallback;
%ignore osg::Drawable::supports;
//%ignore osg::Drawable::accept;
%ignore osg::Drawable::getExtensions;
%ignore osg::Drawable::setExtensions;

%include osg/Drawable

%{
using namespace osg;
%}

struct UpdateCallback : public virtual osg::Object
{
    UpdateCallback() {}

    UpdateCallback(const UpdateCallback&,const CopyOp&) {}

    META_Object(osg,UpdateCallback);

    /** do customized update code.*/
    virtual void update(osg::NodeVisitor*, osg::Drawable*) {}
};

class AttributeFunctor
{
public:
    virtual ~AttributeFunctor() {}

    virtual void apply(Drawable::AttributeType,unsigned int,GLbyte*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,GLshort*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,GLint*) {}

    virtual void apply(Drawable::AttributeType,unsigned int,GLubyte*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,GLushort*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,GLuint*) {}

    virtual void apply(Drawable::AttributeType,unsigned int,float*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,Vec2*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,Vec3*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,Vec4*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,Vec4ub*) {}

    virtual void apply(Drawable::AttributeType,unsigned int,double*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,Vec2d*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,Vec3d*) {}
    virtual void apply(Drawable::AttributeType,unsigned int,Vec4d*) {}
};

#ifdef SWIGPYTHON
%pythoncode %{
#get the original definitions back into their classes
Drawable.UpdateCallback = UpdateCallback
Drawable.AttributeFunctor = AttributeFunctor
%}
#endif
