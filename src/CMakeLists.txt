OPTION(BUILD_OSGPYTHON "Enable to build python bindings (see http://code.google.com/p/osgswig/)" ON)
OPTION(BUILD_OSGPERL "Enable to build perl bindings " OFF)
OPTION(BUILD_OSGJAVA "Enable to build Java bindings " OFF)


IF   (BUILD_OSGPYTHON)
    ADD_SUBDIRECTORY(python)
ENDIF(BUILD_OSGPYTHON)
IF   (BUILD_OSGPERL)
    ADD_SUBDIRECTORY(perl)
ENDIF(BUILD_OSGPERL)
IF   (BUILD_OSGJAVA)
    ADD_SUBDIRECTORY(java)
ENDIF(BUILD_OSGJAVA)

