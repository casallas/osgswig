#!/usr/bin/env python
# coding=utf-8
__author__  = ["Sébastien Barthélemy"]
__url__     = ("http://code.google.com/p/osgswig/")
__doc__ = """Example showing how to use an osg.NodeVisitor from python.

This NodeVisitor will create a properly idented description of the tree.

Usage:

    >>> root = create_test_graph()
    >>> nv = TreePrinterVisitor()
    >>> root.accept(nv)
    >>> nv.display()
    root
      child0
        grandchild00
        grandchild01
      child1
        grandchild10

or:

    $ python nodevisitor.py
    root
      child0
        grandchild00
        grandchild01
      child1
        grandchild10

"""

import osg

class TreePrinterVisitor(osg.NodeVisitor):
    def __init__(self):
        osg.NodeVisitor.__init__(self, osg.NodeVisitor.NODE_VISITOR,
                                 osg.NodeVisitor.TRAVERSE_ALL_CHILDREN)
        self._indent = 0
        self._rows = []

    def apply_Node(self, node):
        self._rows.append(' '*self._indent + node.getName())
        self._indent += 2
        self.traverse(node)
        self._indent -= 2

    def display(self):
        print '\n'.join(self._rows)

def create_test_graph():
    """Create a simple test graph, with no geode.
    """
    root = osg.Group()
    root.setName('root')
    child0 = osg.Group()
    child0.setName('child0')
    root.addChild(child0)
    grandchild00 = osg.Group()
    grandchild00.setName('grandchild00')
    child0.addChild(grandchild00)
    grandchild01 = osg.Group()
    grandchild01.setName('grandchild01')
    child0.addChild(grandchild01)
    child1 = osg.Group()
    child1.setName('child1')
    root.addChild(child1)
    grandchild10 = osg.Group()
    grandchild10.setName('grandchild10')
    child1.addChild(grandchild10)
    return root

def main():
    root = create_test_graph()
    nv = TreePrinterVisitor()
    root.accept(nv)
    nv.display()

main()
