@echo off


rem
rem some macros to get the actual version number
rem 
osgversion.exe --soversion-number > .osgversion.txt
set /p osgsoversion= < .osgversion.txt
del .osgversion.txt

echo %osgsoversion%

osgversion.exe --openthreads-soversion-number > .osgversion.txt
set /p openthreadssoversion= < .osgversion.txt
del .osgversion.txt

echo %openthreadssoversion%


osgversion.exe --version-number > .osgversion.txt
set /p osgversion= < .osgversion.txt
del .osgversion.txt

echo %osgversion%

osgversion.exe --openthreads-version-number > .osgversion.txt
set /p openthreadsversion= < .osgversion.txt
del .osgversion.txt

echo %openthreadsversion%


rem
rem packaging part
rem
echo osg-%osgversion%-msw > osg.pth
echo osg-%osgversion%-msw/osgPlugins-%osgversion% >> osg.pth


mkdir osg-%osgversion%-msw
mkdir osg-%osgversion%-msw\osgPlugins-%osgversion%

copy "%OSG_ROOT%\bin\osgPlugins-%osgversion%\*.dll" "osg-%osgversion%-msw\osgPlugins-%osgversion%"
copy "%OSG_ROOT%\bin\*.dll" "osg-%osgversion%-msw"


move _*.pyd osg-%osgversion%-msw
move osg*.py osg-%osgversion%-msw

rem Package GPL version of osgART
copy "%OSGART_ROOT%"\bin\osgART.dll "osg-%osgversion%-msw"
copy "%OSGART_ROOT%"\bin\osgart_*_artoolkit.dll "osg-%osgversion%-msw\osgPlugins-%osgversion%"
copy "%OSGART_ROOT%"\bin\DSVL.dll "osg-%osgversion%-msw\osgPlugins-%osgversion%"
copy "%OSGART_ROOT%"\bin\libARvideo.dll "osg-%osgversion%-msw\osgPlugins-%osgversion%"


