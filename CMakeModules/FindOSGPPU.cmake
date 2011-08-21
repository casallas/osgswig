# - Try to find OSGPPU
# Once done this will define 
# OSGPPU_INCLUDE_DIR - the include directory 
# OSGPPU_LIBRARY - Link these to use OSGPPU
#
# Created by René Molenaar
#

FIND_PATH(OSGPPU_INCLUDE_DIR OSGPPU/Export.h
    $ENV{OSGPPU_DIR}/include
    $ENV{OSGPPU_DIR}
    $ENV{OSGPPUDIR}/include
    $ENV{OSGPPUDIR}
    $ENV{OSGPPU_ROOT}/include
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local/include
    /usr/include
    /sw/include # Fink
    /opt/local/include # DarwinPorts
    /opt/csw/include # Blastwave
    /opt/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGPPU_ROOT]/include
    /usr/freeware/include
)

MACRO(FIND_OSGPPU_LIBRARY MYLIBRARY MYLIBRARYNAME)

    FIND_LIBRARY(${MYLIBRARY}
        NAMES ${MYLIBRARYNAME}
        PATHS
        $ENV{OSGPPU_DIR}/lib
        $ENV{OSGPPU_DIR}/lib64
        $ENV{OSGPPU_DIR}
        $ENV{OSGPPUDIR}/lib
        $ENV{OSGPPUDIR}/lib64
        $ENV{OSGPPUDIR}
        $ENV{OSGPPU_ROOT}/lib
        $ENV{OSGPPU_ROOT}/lib64
		$ENV{OSGPPU_ROOT}/bin
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local/lib
        /usr/lib
        /sw/lib
        /opt/local/lib
        /opt/csw/lib
        /opt/lib
        [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSGPPU_ROOT]/lib
        /usr/freeware/lib64
    )

ENDMACRO(FIND_OSGPPU_LIBRARY LIBRARY LIBRARYNAME)

FIND_OSGPPU_LIBRARY(OSGPPU_LIBRARY osgPPU)

SET(OSGPPU_FOUND "NO")

IF(OSGPPU_LIBRARY AND OSGPPU_INCLUDE_DIR)
    SET(OSGPPU_FOUND "YES")
ENDIF(OSGPPU_LIBRARY AND OSGPPU_INCLUDE_DIR)
