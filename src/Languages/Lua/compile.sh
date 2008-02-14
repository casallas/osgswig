#!/bin/sh

rm -f ../../../bin/lua/*.so

LUA_CFLAGS=`pkg-config lua5.1 --cflags`
OSG_CFLAGS=`pkg-config openscenegraph --cflags`

LUA_LIBS=`pkg-config lua5.1 --libs`
OSG_LIBS=`pkg-config openscenegraph --libs`

CFLAGS="${LUA_CFLAGS} ${OSG_CFLAGS}"
LIBS="${LUA_LIBS} ${OSG_LIBS}"

g++ -c -fPIC osgLua.cpp ${CFLAGS}
g++ -shared -o ../../../bin/lua/wosg.so  ${LIBS} -fPIC osgLua.o

g++ -c -fPIC osgLuaUtil.cpp ${CFLAGS}
g++ -shared -o ../../../bin/lua/wosgUtil.so  ${LIBS} -fPIC osgLuaUtil.o

g++ -c -fPIC osgLuaDB.cpp ${CFLAGS}
g++ -shared -o ../../../bin/lua/wosgDB.so ${LIBS} -fPIC osgLuaDB.o

g++ -c -fPIC osgLuaProducer.cpp ${CFLAGS}
g++ -shared -o ../../../bin/lua/wosgProducer.so  ${LIBS} -fPIC osgLuaProducer.o
