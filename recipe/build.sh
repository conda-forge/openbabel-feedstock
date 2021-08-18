#!/bin/bash

cmake ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DWITH_INCHI=ON \
      -DPYTHON_EXECUTABLE=$PYTHON \
      -DPYTHON_BINDINGS=ON \
      -DRUN_SWIG=ON \
      .

make -j${CPU_COUNT}
make install
