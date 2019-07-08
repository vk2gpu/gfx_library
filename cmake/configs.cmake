
# Custom set of build configs:
# - Debug:		Unoptimized debug build.
# - Optimized: 	Optimized debug build.
# - Release:	Optimized for release.
SET(CMAKE_CONFIGURATION_TYPES Debug Optimized Release CACHE TYPE INTERNAL FORCE)

SET_PROPERTY( DIRECTORY APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Debug>:DEBUG> $<$<CONFIG:Debug>:_DEBUG> )
SET_PROPERTY( DIRECTORY APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Optimized>:OPTIMIZED> $<$<CONFIG:Optimized>:_OPTIMIZED> $<$<CONFIG:Optimized>:NDEBUG> )
SET_PROPERTY( DIRECTORY APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Release>:RELEASE> $<$<CONFIG:Release>:_RELEASE> $<$<CONFIG:Release>:NDEBUG>)

IF(MSVC)
	# Add debug symbols to Release build. These belong in the PDB, or should be stripped as a post process.
	SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Zi")
	SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi")

	SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG")
	SET(CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS_RELEASE} /DEBUG")
	SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG")
ELSE()
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -Wno-register")

	SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g")
	SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g")
ENDIF()

# Copy Release flags over to Optimized as a baseline.
SET(CMAKE_C_FLAGS_OPTIMIZED "${CMAKE_C_FLAGS_RELEASE}")
SET(CMAKE_CXX_FLAGS_OPTIMIZED "${CMAKE_CXX_FLAGS_RELEASE}")
SET(CMAKE_EXE_LINKER_FLAGS_OPTIMIZED "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
SET(CMAKE_MODULE_LINKER_FLAGS_OPTIMIZED "${CMAKE_MODULE_LINKER_FLAGS_RELEASE}")
SET(CMAKE_SHARED_LINKER_FLAGS_OPTIMIZED "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
SET(CMAKE_STATIC_LINKER_FLAGS_OPTIMIZED "${CMAKE_STATIC_LINKER_FLAGS_RELEASE}")


IF(MSVC)
	# Incremental linking for Optimized.
	STRING (REGEX REPLACE "/INCREMENTAL:NO" "/INCREMENTAL" CMAKE_EXE_LINKER_FLAGS_OPTIMIZED "${CMAKE_EXE_LINKER_FLAGS_OPTIMIZED}")
	STRING (REGEX REPLACE "/INCREMENTAL:NO" "/INCREMENTAL" CMAKE_MODULE_LINKER_FLAGS_OPTIMIZED "${CMAKE_MODULE_LINKER_FLAGS_OPTIMIZED}")
	STRING (REGEX REPLACE "/INCREMENTAL:NO" "/INCREMENTAL" CMAKE_SHARED_LINKER_FLAGS_OPTIMIZED "${CMAKE_SHARED_LINKER_FLAGS_OPTIMIZED}")

	# Inline function expansion - only __inline
	STRING (REGEX REPLACE "/Ob2" "/Ob1" CMAKE_C_FLAGS_OPTIMIZED "${CMAKE_C_FLAGS_OPTIMIZED}")
	STRING (REGEX REPLACE "/Ob2" "/Ob1" CMAKE_CXX_FLAGS_OPTIMIZED "${CMAKE_CXX_FLAGS_OPTIMIZED}")

	# Multicore compilation.
	ADD_COMPILE_OPTIONS(/MP)
ENDIF()


IF(${VERBOSE})
	MESSAGE("Configured flags:")
	MESSAGE(" - CMAKE_C_FLAGS ${CMAKE_C_FLAGS}")
	MESSAGE(" - CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}")
	MESSAGE(" - CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS}")
	MESSAGE(" - CMAKE_MODULE_LINKER_FLAGS ${CMAKE_MODULE_LINKER_FLAGS}")
	MESSAGE(" - CMAKE_SHARED_LINKER_FLAGS ${CMAKE_SHARED_LINKER_FLAGS}")
	MESSAGE(" - CMAKE_STATIC_LINKER_FLAGS ${CMAKE_STATIC_LINKER_FLAGS}")
	MESSAGE("")
	MESSAGE(" - CMAKE_C_FLAGS_DEBUG ${CMAKE_C_FLAGS_DEBUG}")
	MESSAGE(" - CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG}")
	MESSAGE(" - CMAKE_EXE_LINKER_FLAGS_DEBUG ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
	MESSAGE(" - CMAKE_MODULE_LINKER_FLAGS_DEBUG ${CMAKE_MODULE_LINKER_FLAGS_DEBUG}")
	MESSAGE(" - CMAKE_SHARED_LINKER_FLAGS_DEBUG ${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")
	MESSAGE(" - CMAKE_STATIC_LINKER_FLAGS_DEBUG ${CMAKE_STATIC_LINKER_FLAGS_DEBUG}")
	MESSAGE("")
	MESSAGE(" - CMAKE_C_FLAGS_OPTIMIZED ${CMAKE_C_FLAGS_OPTIMIZED}")
	MESSAGE(" - CMAKE_CXX_FLAGS_OPTIMIZED ${CMAKE_CXX_FLAGS_OPTIMIZED}")
	MESSAGE(" - CMAKE_EXE_LINKER_FLAGS_OPTIMIZED ${CMAKE_EXE_LINKER_FLAGS_OPTIMIZED}")
	MESSAGE(" - CMAKE_MODULE_LINKER_FLAGS_OPTIMIZED ${CMAKE_MODULE_LINKER_FLAGS_OPTIMIZED}")
	MESSAGE(" - CMAKE_SHARED_LINKER_FLAGS_OPTIMIZED ${CMAKE_SHARED_LINKER_FLAGS_OPTIMIZED}")
	MESSAGE(" - CMAKE_STATIC_LINKER_FLAGS_OPTIMIZED ${CMAKE_STATIC_LINKER_FLAGS_OPTIMIZED}")
	MESSAGE("")
	MESSAGE(" - CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE}")
	MESSAGE(" - CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE}")
	MESSAGE(" - CMAKE_EXE_LINKER_FLAGS_RELEASE ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
	MESSAGE(" - CMAKE_MODULE_LINKER_FLAGS_RELEASE ${CMAKE_MODULE_LINKER_FLAGS_RELEASE}")
	MESSAGE(" - CMAKE_SHARED_LINKER_FLAGS_RELEASE ${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
	MESSAGE(" - CMAKE_STATIC_LINKER_FLAGS_RELEASE ${CMAKE_STATIC_LINKER_FLAGS_RELEASE}")
ENDIF()
