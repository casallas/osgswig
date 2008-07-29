"""
Parse some osgIntrospection information to find "critical" SWIG sections in osg, being nested classes and templates
file generated with the regular C++ osgintrospection example: "osgintrospection >introspection_osg.txt"

29/8/2008 Gerwin de Haan
"""
import re

f = open ("introspection_osg.txt")

nestedclasses = []
templates = []

#iterate over the line of the file
while True:
    line=f.readline()
    if line=="":
        #end of file
        break
    #attempt a match at a line which precedes a class description
    if re.match("---*",line):
        #next line can be class description
        linewithclass = f.readline()
        #attempt a match at a line which contains a nested class, that is multiple ::
        if re.match(".*::.*::.*",linewithclass):
            #check if this is a <templated> type
            if re.match(".*?<{1}.*",linewithclass):
                #this must be a template
                templates+=[linewithclass]
            else:
                nextline= f.readline()
                if not nextline.startswith("["):
                    #this is just a nested class
                    nestedclasses+=[linewithclass]
                else:
                    #this is a probably an atomic/enum
                    pass

print "Nested classes:"
for entry in nestedclasses:
    print entry,

print "\nTemplates:"
for entry in templates:
    print entry,
