#!/bin/sh

RUBY_CFLAGS="-I/usr/lib/ruby/1.8/i486-linux/"
OSG_CFLAGS=`pkg-config openscenegraph --cflags`

RUBY_LIBS="-lruby1.8"
OSG_LIBS=`pkg-config openscenegraph --libs`

CFLAGS="${RUBY_CFLAGS} ${OSG_CFLAGS}"
LIBS="${RUBY_LIBS} ${OSG_LIBS}"

g++ -c -fPIC osgRuby.cpp ${CFLAGS}
g++ -shared -o ../../../bin/ruby/wosg.so  ${LIBS} -fPIC osgRuby.o

g++ -c -fPIC osgRubyUtil.cpp ${CFLAGS}
g++ -shared -o ../../../bin/ruby/wosgUtil.so ${LIBS} -fPIC osgRubyUtil.o

g++ -c -fPIC osgRubyDB.cpp ${CFLAGS}
g++ -shared -o ../../../bin/ruby/wosgDB.so ${LIBS} -fPIC osgRubyDB.o

g++ -c -fPIC osgRubyProducer.cpp ${CFLAGS}
g++ -shared -o ../../../bin/ruby/wosgProducer.so  ${LIBS} -fPIC osgRubyProducer.o
