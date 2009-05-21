@echo off

set OSG_ART="%OSGART_ROOT%\include"

swig -c++ -lua -I"%OSG_ROOT%\include" -o osgLua.cpp ..\..\osg.i
swig -c++ -lua -I"%OSG_ROOT%\include" -o osgLuaUtil.cpp ..\..\osgUtil.i
swig -c++ -lua -I"%OSG_ROOT%\include" -o osgLuaProducer.cpp ..\..\osgViewer.i
swig -c++ -lua -I"%OSG_ROOT%\include" -o osgLuaDB.cpp ..\..\osgDB.i

swig -c++ -nodefaultdtor -lua -I"%OSG_ROOT%\include" -I%OSG_ART% -o osgLuaART.cpp ../../osgART.i
