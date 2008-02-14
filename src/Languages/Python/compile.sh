#!/bin/bash


items=("" "Utils")

PYTHON_CFLAGS="-I/usr/include/python2.4/"
OSG_CFLAGS=`pkg-config openscenegraph --cflags`

PYTHON_LIBS="-lpython2.4"
OSG_LIBS=`pkg-config openscenegraph --libs`

CFLAGS="-fPIC ${PYTHON_CFLAGS} ${OSG_CFLAGS} ${CFLAGS}"
LIBS="${PYTHON_LIBS} ${OSG_LIBS}"

# looping through
for i in "${items[@]}"
do
echo "Compiling osg${i}"
$(g++ ${CFLAGS} -c "osgPython${i}.cpp")

if [ "${i}" = "GA" ]; then
	FRAME_EXT="${FRAME_EXT} -losgUtil"
fi

if [ "${i}" = "FX" ]; then
	FRAME_EXT="${FRAME_EXT} -losgUtil -losgDB"
fi

if [ "${i}" = "ART" ]; then
	FRAME_EXT="${FRAME_EXT} -losgDB"
fi

echo "Linking osg${i}"

$(g++ -dynamiclib ${LIBS} -framework "osg${i}" ${FRAME_EXT} -o "../../../bin/python/_wosg${i}.so" "osgPython${i}.o")
done


#g++ -c -fPIC osgPython.cpp ${CFLAGS}
#g++ -shared -o ../../../bin/python/_wosg.so  ${LIBS} -fPIC osgPython.o

