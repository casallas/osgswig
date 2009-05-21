# This module defines
# OSGART_ROOT_DIR
# OSGART_INCLUDE_DIR
# OSGART_FOUND
# OSGART_LIBRARY
#
# Created by Hartmut Seichter <http:/www.technotecture.com>
#

FIND_PATH(OSGART_ROOT_DIR include/osgART/Foundation
    $ENV{OSGART_DIR}
    $ENV{OSGARTDIR}
    $ENV{OSGARTDIR}
    $ENV{OSGART_ROOT}
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local
    /usr
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGART_ROOT]
    /usr/freeware
)

FIND_PATH(OSGART_INCLUDE_DIR osgART/Foundation
    $ENV{OSGART_DIR}/include
    $ENV{OSGART_DIR}
    $ENV{OSGARTDIR}/include
    $ENV{OSGARTDIR}
    $ENV{OSGART_ROOT}/include
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local/include
    /usr/include
    /sw/include # Fink
    /opt/local/include # DarwinPorts
    /opt/csw/include # Blastwave
    /opt/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGART_ROOT]/include
    /usr/freeware/include
)

MACRO(FIND_OSGART_LIBRARY MYLIBRARY MYLIBRARYNAME)

    FIND_LIBRARY(${MYLIBRARY}
        NAMES ${MYLIBRARYNAME}
        PATHS
        $ENV{OSGART_DIR}/lib
        $ENV{OSGART_DIR}
        $ENV{OSGARTDIR}/lib
        $ENV{OSGARTDIR}
        $ENV{OSGART_ROOT}/lib
		$ENV{OSGART_ROOT}/bin
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local/lib
        /usr/lib
        /sw/lib
        /opt/local/lib
        /opt/csw/lib
        /opt/lib
        [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGART_ROOT]/lib
        /usr/freeware/lib64
    )

ENDMACRO(FIND_OSGART_LIBRARY LIBRARY LIBRARYNAME)

MACRO   (FIND_OSGART_PLUGINS MYPLUGINS)
	FILE(GLOB MYPLUGINS "${OSGART_ROOT_DIR}/bin/osgart_*${CMAKE_SHARED_LIBRARY_SUFFIX}")
ENDMACRO(FIND_OSGART_PLUGINS MYPLUGINS)

FIND_OSGART_LIBRARY(OSGART_LIBRARY osgART)
FIND_OSGART_PLUGINS(OSGART_PLUGINS)

SET(OSGART_FOUND "NO")

IF(OSGART_LIBRARY AND OSGART_INCLUDE_DIR)
    SET(OSGART_FOUND "YES")
ENDIF(OSGART_LIBRARY AND OSGART_INCLUDE_DIR)
