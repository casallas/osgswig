%{
#include <sstream>
%}

%define VECHELPER(name)
    value_type __getitem__(int i) { return (*self)[i]; }
    void __setitem__(int i, value_type v) { (*self)[i] = v; }
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

    VECHELPER(name)
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

    VECHELPER(name)

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

    VECHELPER(name)

};
%enddef

%define MATHELPER(name)
%extend osg::## name
{
    std::string  __str__()
    {
        std::ostringstream os;
        os << '[' << self->operator()(0,0) << ", " << self->operator()(0,1) << ", " << self->operator()(0,2) << ", " << self->operator()(0,3) << ']';
	os << '[' << self->operator()(1,0) << ", " << self->operator()(1,1) << ", " << self->operator()(1,2) << ", " << self->operator()(1,3) << ']';
	os << '[' << self->operator()(2,0) << ", " << self->operator()(2,1) << ", " << self->operator()(2,2) << ", " << self->operator()(2,3) << ']';
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
