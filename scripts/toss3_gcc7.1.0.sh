#!/bin/bash

##
## Copyright (c) 2017, Lawrence Livermore National Security, LLC.
##
## Produced at the Lawrence Livermore National Laboratory.
##
## LLNL-CODE-738930
##
## All rights reserved.
## 
## This file is part of the RAJA Performance Suite.
##
## For details about use and distribution, please read raja-perfsuite/LICENSE.
##

rm -rf build_toss3-gcc-7.1.0 2>/dev/null
mkdir build_toss3-gcc-7.1.0 && cd build_toss3-gcc-7.1.0

module load cmake/3.5.2

cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -C ../host-configs/toss3/gcc_7_1_0.cmake \
  -DENABLE_OPENMP=On \
  -DENABLE_ALL_WARNINGS=Off \
  -DCMAKE_INSTALL_PREFIX=../install_toss3-gcc-7.1.0 \
  "$@" \
  .. 
