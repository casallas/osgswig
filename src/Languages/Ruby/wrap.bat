@echo off

set OSG_ART="D:\Development\OSGART\include"

swig -c++ -ruby -I"%OSG_ROOT%\include" -o osgRuby.cpp ../../osg.i
swig -c++ -ruby -I"%OSG_ROOT%\include" -o osgRubyUtil.cpp ../../osgUtil.i
swig -c++ -ruby -I"%OSG_ROOT%\include" -o osgRubyDB.cpp ../../osgDB.i
swig -c++ -ruby -I"%OSG_ROOT%\include" -o osgRubyGA.cpp ../../osgGA.i
swig -c++ -ruby -I"%OSG_ROOT%\include" -o osgRubyProducer.cpp ../../osgProducer.i
swig -c++ -ruby -I"%OSG_ROOT%\include" -o osgRubyVRPN.cpp ../../osgVRPN.i

swig -c++ -ruby -I"%OSG_ROOT%\include" -I%OSG_ART% -o osgRubyART.cpp ../../osgART.i
