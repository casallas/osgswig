#!/bin/bash

PYTHON_PATH=""

PYTHON_CFLAGS="`python-config --cflags`"
OSG_CFLAGS=""

PYTHON_LDFLAGS="`python-config --ldflags`"

PYTHON_LIBS="-framework Python"
OSG_LIBS="-framework osg -framework OpenThreads -framework OpenGL"

FRAME_EXT=""

CFLAGS="${CFLAGS} ${PYTHON_CFLAGS} ${OSG_CFLAGS}"
LIBS="`python-config --ldflags` ${OSG_LIBS}"

items=( "" "Util" "DB" "GA" "FX" "Manipulator" "Particle" "Sim" "Shadow" "Terrain" "Text" "Viewer" "ART" )
# items=( "" "Util" "DB" "GA" "FX" "ART")
# items=( "FX" "ART")
# items=( "DB" )

# looping through
for i in "${items[@]}"
do
echo "Compiling osg${i}"
$(g++ -fno-common ${CFLAGS} -c "osgPython${i}.cpp")

if [ "${i}" = "GA" ]; then
	FRAME_EXT="${FRAME_EXT} -framework osgUtil"
fi

if [ "${i}" = "FX" ]; then
	FRAME_EXT="${FRAME_EXT} -framework osgUtil -framework osgDB"
fi

if [ "${i}" = "Manipulator" ]; then
	FRAME_EXT="${FRAME_EXT} -framework osgText -framework osgGA"
fi

if [ "${i}" = "Sim" ]; then
	FRAME_EXT="${FRAME_EXT} -framework osgText"
fi

if [ "${i}" = "Shadow" ]; then
	FRAME_EXT="${FRAME_EXT} -framework osgText -framework osgGA"
fi

if [ "${i}" = "Terrain" ]; then
	FRAME_EXT="${FRAME_EXT} -framework osgFX"
fi

if [ "${i}" = "ART" ]; then
	FRAME_EXT="${FRAME_EXT} -framework osgDB"
fi

if [ "${i}" = "Viewer" ]; then
	FRAME_EXT="${FRAME_EXT} -framework osgGA -framework osgText"
fi

echo "Linking osg${i}"

echo $(g++ -dynamiclib ${LIBS} -framework "osg${i}" ${FRAME_EXT} -o "../../../bin/python/osg-2.0-mac/_osg${i}.so" "osgPython${i}.o")

done
