"""
First attempt at an introspection example for osgIntrospection/osgWrappers.
See the osgintrospection C++ example what should be possible.
In future, this might be useful in generating better Swig interface definition files for all osg types based on osgIntrospection, all from a scripting language.
Currently, I still struggle with SWIG syntax and/or bugs to get the wrapping working correctly.
The C++ way is probably a better option now.
See the osgswig osgIntrospection.i file for the SWIG details.

29/8/2008 Gerwin de Haan
"""

import osg
import osgDB

#use the osgDB DynamicLibrary option to load the wrappers for the osg library of interest
osg_reflectors = osgDB.DynamicLibrary_loadLibrary("osgwrapper_osg.so")

import osgIntrospection

#create a reflection instance
reflection = osgIntrospection.Reflection()

#get all the types from the reflection instance
typemap = reflection.getTypes()

vec4type 		= reflection.getType("osg::Vec4")
transformtype 	= reflection.getType("osg::Transform")
alphafunc_comparisonfunctiontype = reflection.getType("osg::AlphaFunc::ComparisonFunction") 

#get possible EnumLabels for this entry
enumlabelmap = alphafunc_comparisonfunctiontype.getEnumLabels()

#here we see a complex/nested namespace (e.g. a nested class)
namespc = alphafunc_comparisonfunctiontype.getNamespace()

#get the methods in a methodlist
methodinfolist = vec4type.getMethods()

#try to get the first item
#methodinfo = methodinfolist[0]

#if all is well, one should have a MethodInfo* here, not the current 
#print "Methodinfo for vec4:", methodinfo

#construct a methodinfolist instance to be filled
methodinfolist = osgIntrospection.MethodInfoList_()

#insert all method information into the list
transformtype.getAllMethods(methodinfolist)

print "Transformnode has the following functions:"
for methodinfo in methodinfolist:
    print methodinfo.getName()

#construct a methodinfomap instance to be filled
methodinfomap = osgIntrospection.MethodInfoMap_()

#insert the information from a transformtype
transformtype.getMethodsMap(methodinfomap)

print "\nTransformnode is derived from:"
for datatype in methodinfomap:
    print datatype.getQualifiedName()

#lmethodinfolist = methodinfomap[datatype]      #doesn't work
#it appears the __getitem__ is broken, but one can use the .values() of the dict
#one could, in python, merge the two lists in a new map/dict
lmethodinfomap_keys   = [key for key in methodinfomap]
lmethodinfomap_values = [value for value in methodinfomap.values()]

print "Its methods are defined:"
for type_idx in range(len(lmethodinfomap_keys)):
    print "In :",lmethodinfomap_keys[type_idx].getQualifiedName()
    for methodinfo in lmethodinfomap_values[type_idx]:
        print "\t\t", methodinfo.getName()    



