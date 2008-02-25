# This module defines
# OSGVERSE_ROOT_DIR
# OSGVERSE_INCLUDE_DIR
# OSGVERSE_FOUND
# OSGVERSE_LIBRARY
#
# Created by Hartmut Seichter <http:/www.technotecture.com>
#

FIND_PATH(OSGVERSE_ROOT_DIR include/osgVerse/Version
    $ENV{OSGVERSE_DIR}
    $ENV{OSGVERSEDIR}
    $ENV{OSGVERSEDIR}
    $ENV{OSGVERSE_ROOT}
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local
    /usr
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGVERSE_ROOT]
    /usr/freeware
)

FIND_PATH(OSGVERSE_INCLUDE_DIR osgVerse/Version
    $ENV{OSGVERSE_DIR}/include
    $ENV{OSGVERSE_DIR}
    $ENV{OSGVERSEDIR}/include
    $ENV{OSGVERSEDIR}
    $ENV{OSGVERSE_ROOT}/include
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local/include
    /usr/include
    /sw/include # Fink
    /opt/local/include # DarwinPorts
    /opt/csw/include # Blastwave
    /opt/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGVERSE_ROOT]/include
    /usr/freeware/include
)

MACRO(FIND_OSGVERSE_LIBRARY MYLIBRARY MYLIBRARYNAME)

    FIND_LIBRARY(${MYLIBRARY}
        NAMES ${MYLIBRARYNAME}
        PATHS
        $ENV{OSGVERSE_DIR}/lib
        $ENV{OSGVERSE_DIR}
        $ENV{OSGVERSEDIR}/lib
        $ENV{OSGVERSEDIR}
        $ENV{OSGVERSE_ROOT}/lib
		$ENV{OSGVERSE_ROOT}/bin
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local/lib
        /usr/lib
        /sw/lib
        /opt/local/lib
        /opt/csw/lib
        /opt/lib
        [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGVERSE_ROOT]/lib
        /usr/freeware/lib64
    )

ENDMACRO(FIND_OSGVERSE_LIBRARY LIBRARY LIBRARYNAME)

FIND_OSGVERSE_LIBRARY(OSGVERSE_LIBRARY osgVerse)

SET(OSGVERSE_FOUND "NO")

IF(OSGVERSE_LIBRARY AND OSGVERSE_INCLUDE_DIR)
    SET(OSGVERSE_FOUND "YES")
ENDIF(OSGVERSE_LIBRARY AND OSGVERSE_INCLUDE_DIR)
