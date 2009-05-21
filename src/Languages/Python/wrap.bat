@echo off

set OSG_ART="D:\Development\OSGART\include"


swig -c++ -python -nodefaultdtor -I"%OSG_ROOT%\include" -o osgPython.cpp ../../osg.i
swig -c++ -python -I"%OSG_ROOT%\include" -o osgPythonUtil.cpp ../../osgUtil.i
swig -c++ -python -I"%OSG_ROOT%\include" -o osgPythonDB.cpp ../../osgDB.i
swig -c++ -python -I"%OSG_ROOT%\include" -o osgPythonProducer.cpp ../../osgProducer.i
swig -c++ -python -I"%OSG_ROOT%\include" -o osgPythonGA.cpp ../../osgGA.i
swig -c++ -python -I"%OSG_ROOT%\include" -o osgPythonVRPN.cpp ../../osgVRPN.i
swig -c++ -python -I"%OSG_ROOT%\include" -o osgPythonFX.cpp ../../osgFX.i

swig -c++ -python -I"%OSG_ROOT%\include" -I%OSG_ART% -o osgPythonART.cpp ../../osgART.i

move *.py ..\..\..\bin\python
