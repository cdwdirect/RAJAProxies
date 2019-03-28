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


add_definitions("-DENABLE_APOLLO=Yes")
add_definitions("-DRAJA_ENABLE_APOLLO=Yes")

add_subdirectory(baseline)
add_subdirectory(RAJA)

