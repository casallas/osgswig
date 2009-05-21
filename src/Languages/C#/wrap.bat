@echo off

del *.cpp
del *.cs

set GLINCLUDE="%INCLUDE%..\..\..\VC7\PlatformSDK\Include"
set OSG_ART="D:\Development\OSGART\include"


swig -c++ -nodefaultdtor -csharp -I"%OSG_ROOT%\include" -I%GLINCLUDE% -o osgCS.cpp -outdir "osg" ../../osg.i
REM swig -c++ -csharp -I"%OSG_ROOT%\include" -o osgCSUtil.cpp -outdir "osgUtil" ../../osgUtil.i
swig -c++ -nodefaultdtor -csharp -I"%OSG_ROOT%\include" -I%GLINCLUDE% -o osgCSDB.cpp -outdir osgDB ../../osgDB.i
REM swig -c++ -csharp -I"%OSG_ROOT%\include" -o osgCSProducer.cpp -outdir "osgProducer" ../../osgProducer.i