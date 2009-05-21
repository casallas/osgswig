FIND_PACKAGE(Boost)

SET(Boost_VERSION 1_34 CACHE STRING "Boost Version")

FIND_LIBRARY(BoostPython_LIBRARY 
    NAMES boost_python boost_python-vc71-mt-${Boost_VERSION} boost_python-vc80-mt-${Boost_VERSION}
    PATHS
	${Boost_LIBRARY_DIRS}
)

MARK_AS_ADVANCED(BoostPython_LIBRARY)

FIND_LIBRARY(BoostPython_LIBRARY_DEBUG
    NAMES boost_python boost_python-vc71-mt-gd-${Boost_VERSION} boost_python-vc80-mt-gd-${Boost_VERSION}
    PATHS
	${Boost_LIBRARY_DIRS}
)

MARK_AS_ADVANCED(BoostPython_LIBRARY_DEBUG)

IF(BoostPython_LIBRARY)
  IF(NOT BoostPython_LIBRARY_DEBUG)
     SET(BoostPython_LIBRARY_DEBUG "${BoostPython_LIBRARY}" CACHE FILEPATH "Debug version of boost_python Library (use regular version if not available)" FORCE)
  ENDIF(NOT BoostPython_LIBRARY_DEBUG)
ENDIF(BoostPython_LIBRARY)
    
SET(BoostPython_FOUND "NO")
IF(BoostPython_LIBRARY)
  SET(BoostPython_FOUND "YES")
ENDIF(BoostPython_LIBRARY)

