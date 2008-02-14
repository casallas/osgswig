#!/usr/bin/env python

import sys

# we need to patch in our own directory
# sys.path.append('../../bin/python')

import wosg
import wosgDB


vec = wosg.Vec3f()

print vec.x()

q = wosg.Quat()

# proper return values
angle,x,y,z = q.getRotate()

print angle,x,y,z


# testing if GLenum disappears
bf = wosg.BlendFunc()

bf.setFunction(wosg.BlendFunc.DST_ALPHA,wosg.BlendFunc.DST_COLOR)

print bf.getSource()


node = wosgDB.readNodeFile('cow.osg')


