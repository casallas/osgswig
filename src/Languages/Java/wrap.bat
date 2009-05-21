 @echo off

rmdir /Q /S com

mkdir com
mkdir com\hitlab
mkdir com\hitlab\wosg
rem mkdir com\hitlab\wosgProducer
rem mkdir com\hitlab\wosgDB

set OSG_ART="D:\Development\OSGART\include"

swig -c++ -java -I"%OSG_ROOT%\include" -o osgJava.cpp -package com.hitlab.wosg -outdir com/hitlab/wosg ../../osg.i
swig -c++ -java -I"%OSG_ROOT%\include" -o osgJavaProducer.cpp -package com.hitlab.wosg -outdir com/hitlab/wosg ../../osgProducer.i
swig -c++ -java -I"%OSG_ROOT%\include" -o osgJavaDB.cpp -package com.hitlab.wosg -outdir com/hitlab/wosg ../../osgDB.i

swig -c++ -java -I"%OSG_ROOT%\include" -I%OSG_ART% -o osgJavaART.cpp -package com.hitlab.wosg -outdir com/hitlab/wosg ../../osgART.i






