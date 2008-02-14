#!/bin/bash

rm -f *.cpp
rm -f *.o

WRAP_INCLUDE="include"

items=( "" "Util" "DB" "GA" "FX" "Manipulator" "Particle" "Sim" "Shadow" "Terrain" "Text" "Viewer" "ART" )
# items=( "" "Util" "DB" "GA" "FX" "ART" )
# items=( "" "FX" )
# items=( "" "DB")

rm -rf ${WRAP_INCLUDE}
mkdir ${WRAP_INCLUDE}

# generate a standard include directory for OpenSceneGraph
for i in "${items[@]}"
do
echo Working on linking "osg${i} to ${WRAP_INCLUDE}"
ln -s "/Library/Frameworks/osg${i}.framework/Headers" "${WRAP_INCLUDE}/osg${i}"
done

# wrap all packages
for i in "${items[@]}"
do
echo Working on wrapping "osg${i}"
swig -c++ -python -I${WRAP_INCLUDE} -o "osgPython${i}.cpp" "../../osg${i}.i"
done

# here all .cpp need to be fixed for the MacPython framework
for file in `find . -name \*.cpp`
do
echo "Fixing ${file} for python bundle"
sed -e 's/<Python.h>/<Python\/Python.h>/gp' $file > $file.tmp
mv -f $file.tmp $file
done

# move the Python
mv -f *.py ../../../bin/python
