#!/bin/bash

cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DWITH_INCHI=ON \
      -DPYTHON_EXECUTABLE=$PYTHON \
      -DPYTHON_BINDINGS=ON \
      -DPYTHON_INCLUDE_DIR=$($PYTHON -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
      -DPYTHON_LIBRARY=$($PYTHON -c "import distutils.sysconfig as sysconfig; import os; print(os.path.join(sysconfig.get_config_var('LIBDIR'), sysconfig.get_config_var('LDLIBRARY')))") \
      -DRUN_SWIG=ON \
      .

make -j${CPU_COUNT}
make install
