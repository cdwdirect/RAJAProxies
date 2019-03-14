###############################################################################
#
# Copyright (c) 2017, Lawrence Livermore National Security, LLC.
#
# Produced at the Lawrence Livermore National Laboratory
#
# All rights reserved.
#
# This file is part of the RAJA Proxy App Suite
#
###############################################################################

set (lulesh_sources
  lulesh.cpp
  lulesh-comm.cpp
  lulesh-init.cpp
  lulesh-util.cpp
  lulesh-viz.cpp)

set (lulesh_depends
  RAJA
  apollo)

if (ENABLE_OPENMP)
  set (lulesh_depends
    ${lulesh_depends}
    openmp)
endif ()

if (ENABLE_CUDA)
  set (lulesh_depends
    ${lulesh_depends}
    cuda)
endif ()

blt_add_executable(
  NAME lulesh-apollo
  SOURCES ${lulesh_sources}
  DEPENDS_ON ${lulesh_depends})

target_compile_options(
  lulesh-apollo
  PRIVATE
  -Wno-unknown-pragmas)

target_compile_definitions(
  lulesh-apollo
  PRIVATE 
  -DUSE_MPI=0)

target_compile_definitions(
  lulesh-apollo
  PRIVATE
  -DUSE_CASE=1)

target_compile_definitions(
  lulesh-apollo
  PUBLIC
  -DLULESH_DEVICE= 
)

if (ENABLE_OPENMP)
  blt_add_executable(
    NAME lulesh-omp-apollo
    SOURCES ${lulesh_sources}
    DEPENDS_ON ${lulesh_depends})

  target_compile_definitions(
    lulesh-omp-apollo
    PRIVATE 
    -DUSE_MPI=0)

  target_compile_definitions(
    lulesh-omp-apollo
    PUBLIC
    -DLULESH_DEVICE= 
  )
endif ()

if (ENABLE_CUDA)
  configure_file(
    lulesh.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-cuda.cpp COPYONLY)

  configure_file(
    lulesh-comm.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-comm-cuda.cpp COPYONLY)
  configure_file(
    lulesh-init.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-init-cuda.cpp COPYONLY)
  configure_file(
    lulesh-util.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-util-cuda.cpp COPYONLY)
  configure_file(
    lulesh-viz.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-viz-cuda.cpp COPYONLY)

  blt_add_executable(
    NAME lulesh-cuda-apollo
    SOURCES 
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-cuda.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-comm-cuda.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-init-cuda.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-util-cuda.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lulesh-viz-cuda.cpp
    DEPENDS_ON ${lulesh_depends})

  target_compile_definitions(
    lulesh-cuda-apollo
    PRIVATE
    -DUSE_CASE=9)

  target_compile_definitions(
    lulesh-cuda-apollo
    PRIVATE 
    -DUSE_MPI=0)

  target_compile_definitions(
    lulesh-cuda-apollo
    PUBLIC
    -DLULESH_DEVICE=__device__
  )

  target_include_directories(
    lulesh-cuda-apollo
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR})
endif ()
