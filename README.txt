About osgSWIG
-------------

OpenSceneGraph is a comprehensive OpenGL based scene graph
library. It provides its own introspection layer for scripting
however there are various scenarios where an outside-in approach
for scripting is more appropriate.

The SWIG wrappers for OpenSceneGraph were initially developed by
Hartmut Seichter at the Human Interface Technology Laboratory New Zealand
as part of the FRST (http://frst.govt.nz/) funded project MagicBook. The
project was moved from the HITLabNZ to the community in order to get more 
involvement.
Soon after the VRmeer group contributed a vastly updated version.


Using CMake build system
------------------------

steps:

$> mkdir build
$> cd build
$> cmake ..  -DCMAKE_BUILD_TYPE=Release
$> make

(or use cmakesetup on windows)

Note: It is highly recommended to use an out-of-source build as 
it doesn't polute the source tree and facilitates multiple builds 
per source tree.

Please consult the CMake documentation (http://cmake.org) for more options.


Older Versions?
---------------
This is the new trunk of osgswig. 

http://osgswig.googlecode.com/svn/trunk
or for members: https://osgswig.googlecode.com/svn/trunk

it is a merge of the original osgswig branch and 
the branch used for the VRmeer Project (python and perl).

The merge contains new cmake files, that build the
following modules;

osg
osgDB
osgFX
osgGA
osgUtil
osgViewer

There is one (new) simple test example:
examples/python/simple/simpleosg

The default cmakesetting make these modules for python.

It is most recently tested with
swig 1.3.33
OpenSceneGraph 2.3.4

The repository also still contain all the files and documentation from the original osgswig.
check out revision 95 of:
 http://osgswig.googlecode.com/svn/
 or https://osgswig.googlecode.com/svn/ (for members)
this contains the original osgswig.

or check out the pre2.2 branch:
svn checkout http://osgswig.googlecode.com/svn/branches/pre_2.2/ osgswig-read-only
svn checkout https://osgswig.googlecode.com/svn/branches/pre_2.2/ --username myusername
