#!/bin/sh

rm -f *.o
rm -f *.cpp

# OSG_ART="D:\Development\OSGART\include"
OSG_ROOT="/usr"

swig -c++ -lua -I${OSG_ROOT}/include -o osgLua.cpp ../../osg.i
swig -c++ -lua -I${OSG_ROOT}/include -o osgLuaUtil.cpp ../../osgUtil.i
swig -c++ -lua -I${OSG_ROOT}/include -o osgLuaProducer.cpp ../../osgProducer.i
swig -c++ -lua -I${OSG_ROOT}/include -o osgLuaDB.cpp ../../osgDB.i

#swig -c++ -lua -I"%OSG_ROOT%\include" -I%OSG_ART% -o osgLuaART.cpp ../../osgART.i
