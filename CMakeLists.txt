cmake_minimum_required(VERSION 3.4)

project(RajaProxies LANGUAGES CXX)
set (CMAKE_CXX_FLAGS "-std=c++1y ${CMAKE_CXX_FLAGS}")

option(ENABLE_LULESH_ONE "Build LULESH v1.0" Off)
option(ENABLE_LULESH_TWO "Build LULESH v2.0" On)
option(ENABLE_LULESH_APOLLO "Build LULESH v2.0 w/Apollo" On)
option(ENABLE_KRIPKE "Build Kripke" Off)

if(ENABLE_LULESH_APOLLO)
  set(ENABLE_APOLLO On)
endif(ENABLE_LULESH_APOLLO)

set (ENABLE_EXAMPLES Off CACHE Bool "Don't build examples")

if (PROXIES_ENABLE_WARNINGS)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror ")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

################################
# BLT
################################
if (NOT EXISTS ${PROJECT_SOURCE_DIR}/blt/SetupBLT.cmake)
  message(FATAL_ERROR "\
  The BLT submodule is not present. \
  If in git repository run the following two commands:\n \
  git submodule init\n \
  git submodule update")
endif()
include(${PROJECT_SOURCE_DIR}/blt/SetupBLT.cmake)

add_subdirectory(tpl/RAJA)

set(CUDA_NVCC_FLAGS ${RAJA_NVCC_FLAGS})

if (ENABLE_DOCUMENTATION)
  add_subdirectory(docs)
endif ()

if (ENABLE_LULESH_ONE)
  message(STATUS "Building LULESH v1.0")
  add_subdirectory(lulesh-v1.0)
endif ()

if (ENABLE_LULESH_TWO)
  message(STATUS "Building LULESH v2.0")
  add_subdirectory(lulesh-v2.0)
endif ()


if (ENABLE_LULESH_APOLLO)
  message(STATUS "Building LULESH v2.0 w/APOLLO Support")
  find_package(APOLLO REQUIRED)
  if(APOLLO_FOUND)
    blt_register_library(
      NAME apollo
      INCLUDES ${APOLLO_INCLUDE_DIRS}
      LIBRARIES ${APOLLO_LIBRARY})
      message(STATUS "---- APOLLO:    APOLLO_INCLUDE_DIRS = ${APOLLO_INCLUDE_DIRS}")
      message(STATUS "---- APOLLO:    APOLLO_LIB_DIRS     = ${APOLLO_LIB_DIRS}")
      message(STATUS "---- APOLLO:    APOLLO_LIBRARY      = ${APOLLO_LIBRARY}")
  endif(APOLLO_FOUND)
  find_package(Caliper REQUIRED)
  if(CALIPER_FOUND)
      blt_register_library(
      NAME Caliper
      INCLUDES ${CALIPER_INCLUDE_DIRS}
      LIBRARIES ${CALIPER_LIBRARY})
    message(STATUS "---- CALIPER:  Found!")
    message(STATUS "---- CALIPER:    CALIPER_INCLUDE_DIRS = ${CALIPER_INCLUDE_DIRS}")
    message(STATUS "---- CALIPER:    CALIPER_LIB_DIRS     = ${CALIPER_LIB_DIRS}")
    message(STATUS "---- CALIPER:    CALIPER_LIBRARY      = ${CALIPER_LIBRARY}")
  else()
    message(STATUS "---- CALIPER:  ** ERROR ** Could not locate Caliper installation.")
  endif(CALIPER_FOUND)
  #
  add_subdirectory(lulesh-apollo)
endif ()

if (ENABLE_KRIPKE)
  if (ENABLE_CUDA)
    message(FATAL_ERROR "Cannot build Kripke with CUDA")
  endif()
  if (ENABLE_OPENMP)
    set(KRIPKE_ARCH "OpenMP")
  else()
    set(KRIPKE_ARCH "Sequential")
  endif()
  message(STATUS "Building Kripke")
  add_subdirectory(kripke)
endif ()
