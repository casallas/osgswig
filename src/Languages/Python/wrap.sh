#!/bin/bash

rm -f *.cpp
rm -f *.o

# OSG_ART="D:\Development\OSGART\include"
OSG_ROOT="/usr"

WRAP_INCLUDE="include"

items=( "" "Util" "DB" "GA" "FX" "ART" )
# items=( "" "FX" )


# wrap all packages
for i in "${items[@]}"
do
echo Working on wrapping "osg${i}"
swig -c++ -python -I${OSG_ROOT}/include -o "osgPython${i}.cpp" "../../osg${i}.i"
done

# move the Python
mv -f *.py ../../../bin/python
