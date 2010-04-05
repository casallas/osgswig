%{
#include <sstream>
%}

// Language independent exception handler
%include exception.i       


%define VECHELPER(name,val)
%copyctor osg::## name;
    value_type __getitem__(int i)  
    { 
        if ((i>=0)&&(i<val))
        {
                return (*self)[i]; 
        }
        else
        {
                //Needs a better exception handling
                //return (osg::## name ##::value_type)0;
                PyErr_SetString(PyExc_IndexError,"Index error, type osg::name has only val elements\n");
        }
    }

    void __setitem__(int i, value_type v) 
    { 
        if ((i>=0)&&(i<val))
        {
                (*self)[i] = v; 
        }
        else
        {
                //Needs a better exception handling
                PyErr_SetString(PyExc_IndexError,"Index error, type osg::name has only val elements\n");
        }
        
    }
%enddef


%define VEC2HELPER(name)
%extend osg::## name
{
    std::string  __str__()
    {
        std::ostringstream os;
        os << '[' << self->x() << ", " << self->y() << ']';
        return os.str();
    }

    VECHELPER(name,2)
};
%enddef

%define VEC3HELPER(name)
%extend osg::## name
{
    std::string  __str__()
    {
        std::ostringstream os;
        os << '[' << self->x() << ", " << self->y() << ", " << self->z() << ']';
        return os.str();
    }

    VECHELPER(name,3)

};
%enddef

%define VEC4HELPER(name)
%extend osg::## name
{
    std::string  __str__()
    {
        std::ostringstream os;
        os << '[' << self->r() << ", " << self->g() << ", " << self->b() << ", " << self->a() << ']';
        return os.str();
    }
    VECHELPER(name,4)

};
%enddef

%copyctor osg::Quat;
%extend osg::Quat
{
    std::string  __str__()
    {
        std::ostringstream os;
        os << '[' << self->x() << ", " << self->y() << ", " << self->z() << ",w " << self->w() << ']';
        return os.str();
    }
    VECHELPER(Quat,4)
};

%define MATHELPER(name)
%copyctor osg::## name;
%extend osg::## name
{
    std::string  __str__()
    {
        std::ostringstream os;
        os << '[' << self->operator()(0,0) << ", " << self->operator()(0,1) << ", " << self->operator()(0,2) << ", " << self->operator()(0,3) << ']' << std::endl;
        os << '[' << self->operator()(1,0) << ", " << self->operator()(1,1) << ", " << self->operator()(1,2) << ", " << self->operator()(1,3) << ']' << std::endl;
        os << '[' << self->operator()(2,0) << ", " << self->operator()(2,1) << ", " << self->operator()(2,2) << ", " << self->operator()(2,3) << ']' << std::endl;
        os << '[' << self->operator()(3,0) << ", " << self->operator()(3,1) << ", " << self->operator()(3,2) << ", " << self->operator()(3,3) << ']';
        return os.str();
    }
};
%enddef

VEC2HELPER(Vec2b)
VEC2HELPER(Vec2s)
VEC2HELPER(Vec2d)
VEC2HELPER(Vec2f)

VEC3HELPER(Vec3b)
VEC3HELPER(Vec3s)
VEC3HELPER(Vec3d)
VEC3HELPER(Vec3f)

VEC4HELPER(Vec4ub)
VEC4HELPER(Vec4b)
VEC4HELPER(Vec4s)
VEC4HELPER(Vec4d)
VEC4HELPER(Vec4f)

MATHELPER(Matrixd)
MATHELPER(Matrixf)
