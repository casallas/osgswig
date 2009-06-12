# Locate gdal
# This module defines
# OSG_LIBRARY
# OSG_FOUND, if false, do not try to link to osg 
# OSG_INCLUDE_DIR, where to find the headers
#
# $OSG_DIR is an environment variable that would
# correspond to the ./configure --prefix=$OSG_DIR
#
# Created by Robert Osfield. 
# Edited By R.C.Molenaar to include debug versions

FIND_PATH(OSG_INCLUDE_DIR osg/Node
    $ENV{OSG_DIR}/include
    $ENV{OSG_DIR}
    $ENV{OSGDIR}/include
    $ENV{OSGDIR}
    $ENV{OSG_ROOT}/include
    /usr/local/include
    /usr/include
    /sw/include # Fink
    /opt/local/include # DarwinPorts
    /opt/csw/include # Blastwave
    /opt/include
    ~/Library/Frameworks
    /Library/Frameworks
	$ENV{PROGRAMFILES}/OpenSceneGraph/include
    /cygdrive/c/Program Files/OpenSceneGraph/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]/include
    /usr/freeware/include
)

MACRO(FIND_OSG_LIBRARY MYLIBRARY MYLIBRARYNAME)

    FIND_LIBRARY(${MYLIBRARY}
        NAMES ${MYLIBRARYNAME}
        PATHS
        /usr/local/lib64
        /usr/local/lib
        /usr/lib64
        /usr/lib
        $ENV{OSG_DIR}/lib64
        $ENV{OSG_DIR}/lib
        $ENV{OSG_DIR}/bin
        $ENV{OSG_DIR}
        $ENV{OSGDIR}/lib64
        $ENV{OSGDIR}/lib
        $ENV{OSGDIR}
        $ENV{OSG_ROOT}/lib64
        $ENV{OSG_ROOT}/lib
         /sw/lib
        /opt/local/lib
        /opt/csw/lib
        /opt/lib
       ~/Library/Frameworks
        /Library/Frameworks
        /opt/lib
		$ENV{PROGRAMFILES}/OpenSceneGraph/lib
        /cygdrive/c/Program\ Files/OpenSceneGraph/lib
        /cygdrive/c/Program\ Files/OpenSceneGraph/bin
        /cygdrive/c/Projects/OpenSceneGraph/Build/lib/release
        [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]/lib
        /usr/freeware/lib64
    )

    FIND_LIBRARY(${MYLIBRARY}_DEBUG
        NAMES ${MYLIBRARYNAME}d
        PATHS
        /usr/local/lib64
        /usr/local/lib
        /usr/lib64
        /usr/lib
        $ENV{OSG_DIR}/lib64
        $ENV{OSG_DIR}/lib
        $ENV{OSG_DIR}
        $ENV{OSGDIR}/lib64
        $ENV{OSGDIR}/lib
        $ENV{OSGDIR}
        $ENV{OSG_ROOT}/lib64
        $ENV{OSG_ROOT}/lib
        /sw/lib
        /opt/local/lib
        /opt/csw/lib
        /opt/lib
        ~/Library/Frameworks
        /Library/Frameworks
		$ENV{PROGRAMFILES}/OpenSceneGraph/lib
        /cygdrive/c/Program\ Files/OpenSceneGraph/lib
        /cygdrive/c/Program\ Files/OpenSceneGraph/bin
        /cygdrive/c/Projects/OpenSceneGraph/Build/lib/release
        [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]/lib
        /usr/freeware/lib64
    )

   IF  (NOT ${MYLIBRARY})
       MESSAGE("-- Warning ${MYLIBRARYNAME} not found, ${MYLIBRARY} tring to use: ${MYLIBRARY}_DEBUG")
   ENDIF  (NOT ${MYLIBRARY})


    IF(${MYLIBRARY}_DEBUG)
        IF   (NOT ${MYLIBRARY})
            MESSAGE("-- Warning ${MYLIBRARYNAME} not found, ${MYLIBRARY} using: ${${MYLIBRARY}_DEBUG}")
            SET(${MYLIBRARY} "${${MYLIBRARY}_DEBUG}" CACHE FILEPATH "Release version of OpenSceneGraph ${MYLIBRARYNAME} Library (use debug version if not available)" FORCE)
        ENDIF(NOT ${MYLIBRARY})
    ENDIF(${MYLIBRARY}_DEBUG)    

    IF(${MYLIBRARY})
        IF   (NOT ${MYLIBRARY}_DEBUG)
            MESSAGE("-- Warning Debug ${MYLIBRARYNAME} not found, ${MYLIBRARY}_DEBUG using: ${MYLIBRARY}")
            #SET(OSG_LIBRARY_DEBUG "${OSG_LIBRARY}")
            SET(${MYLIBRARY}_DEBUG "${${MYLIBRARY}}" CACHE FILEPATH "Debug version of OpenSceneGraph ${MYLIBRARYNAME} Library (use regular version if not available)" FORCE)
        ENDIF(NOT ${MYLIBRARY}_DEBUG)
    ENDIF(${MYLIBRARY})


ENDMACRO(FIND_OSG_LIBRARY MYLIBRARY MYLIBRARYNAME)

FOREACH(MYOSGLIBRARY osg osgUtil osgDB osgText osgTerrain osgFX osgViewer osgGA osgSim osgShadow osgManipulator osgParticle )
    STRING(TOUPPER ${MYOSGLIBRARY} MYOSGUPPER )
    FIND_OSG_LIBRARY( ${MYOSGUPPER}_LIBRARY ${MYOSGLIBRARY}) 
ENDFOREACH(MYOSGLIBRARY)
 
SET(OSG_FOUND "NO")
IF(OSG_LIBRARY AND OSG_INCLUDE_DIR)
    SET(OSG_FOUND "YES")
ENDIF(OSG_LIBRARY AND OSG_INCLUDE_DIR)
