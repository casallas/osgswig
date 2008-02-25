# This module defines
# OSGODE_ROOT_DIR
# OSGODE_INCLUDE_DIR
# OSGODE_FOUND
# OSGODE_LIBRARY
#
# Created by Hartmut Seichter <http:/www.technotecture.com>
#

FIND_PATH(OSGODE_ROOT_DIR include/osgODE/Version
    $ENV{OSGODE_DIR}
    $ENV{OSGODEDIR}
    $ENV{OSGODEDIR}
    $ENV{OSGODE_ROOT}
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local
    /usr
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGODE_ROOT]
    /usr/freeware
)

FIND_PATH(OSGODE_INCLUDE_DIR OSGODE/Foundation
    $ENV{OSGODE_DIR}/include
    $ENV{OSGODE_DIR}
    $ENV{OSGODEDIR}/include
    $ENV{OSGODEDIR}
    $ENV{OSGODE_ROOT}/include
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local/include
    /usr/include
    /sw/include # Fink
    /opt/local/include # DarwinPorts
    /opt/csw/include # Blastwave
    /opt/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGODE_ROOT]/include
    /usr/freeware/include
)

MACRO(FIND_OSGODE_LIBRARY MYLIBRARY MYLIBRARYNAME)

    FIND_LIBRARY(${MYLIBRARY}
        NAMES ${MYLIBRARYNAME}
        PATHS
        $ENV{OSGODE_DIR}/lib
        $ENV{OSGODE_DIR}
        $ENV{OSGODEDIR}/lib
        $ENV{OSGODEDIR}
        $ENV{OSGODE_ROOT}/lib
		$ENV{OSGODE_ROOT}/bin
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local/lib
        /usr/lib
        /sw/lib
        /opt/local/lib
        /opt/csw/lib
        /opt/lib
        [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGODE_ROOT]/lib
        /usr/freeware/lib64
    )

ENDMACRO(FIND_OSGODE_LIBRARY LIBRARY LIBRARYNAME)

FIND_OSGODE_LIBRARY(OSGODE_LIBRARY osgODE)

SET(OSGODE_FOUND "NO")

IF(OSGODE_LIBRARY AND OSGODE_INCLUDE_DIR)
    SET(OSGODE_FOUND "YES")
ENDIF(OSGODE_LIBRARY AND OSGODE_INCLUDE_DIR)
