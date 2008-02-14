#!/bin/sh

# OSG_ART="D:\Development\OSGART\include"
OSG_ROOT="/usr"

swig -c++ -ruby -I${OSG_ROOT}/include -o osgRuby.cpp ../../osg.i
swig -c++ -ruby -I${OSG_ROOT}/include -o osgRubyUtil.cpp ../../osgUtil.i
swig -c++ -ruby -I${OSG_ROOT}/include -o osgRubyProducer.cpp ../../osgProducer.i
swig -c++ -ruby -I${OSG_ROOT}/include -o osgRubyDB.cpp ../../osgDB.i

#swig -c++ -lua -I"%OSG_ROOT%\include" -I%OSG_ART% -o osgLuaART.cpp ../../osgART.i
