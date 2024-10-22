cmake_minimum_required(VERSION 3.16)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
	message(FATAL_ERROR "Do not build in-source. Please remove CMakeCache.txt and the CMakeFiles/ directory. Then build out-of-source.")
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

project(
	"trader"
		VERSION 0.0.1
		LANGUAGES CXX
)

add_definitions(-DPROJECT_LOG_PATH="${CMAKE_BINARY_DIR}/log")

find_package(Threads REQUIRED)
find_package(jsoncpp REQUIRED)

add_library(
	${PROJECT_NAME}
		SHARED
			include/invest.hpp
			src/invest.cpp
			src/main.cpp
)
target_link_libraries(
	${PROJECT_NAME}
		PUBLIC
			Threads::Threads
            curl
            jsoncpp_lib
)
target_include_directories(
	${PROJECT_NAME}
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
			$<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include>
)
set_target_properties(
	${PROJECT_NAME}
		PROPERTIES
			PREFIX "lib-"
			OUTPUT_NAME "invest"
			DEBUG_POSTFIX d
)
add_library(
	hslee::invest
		ALIAS ${PROJECT_NAME}
)

add_subdirectory(apps)
