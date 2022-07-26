#!/bin/bash

# expects CBF_MAKEFILE, PLAT_OS, ARCH, LIBEXT

make Makefiles
make distclean

make -f $CBF_MAKEFILE javawrapper javatests CBFLIB_DONT_BUILD_HDF5=yes CBF_NO_REGEX=yes CBFLIB_DONT_USE_LOCAL_REGEX=yes CBFLIB_DONT_USE_PYCIFRW=yes CBFLIB_DONT_USE_PY2CIFRW=yes CBFLIB_DONT_USE_PY3CIFRW=yes NOFORTRAN=yes

JARFILE="jcbf/cbflib-*.jar"
VERSION=`basename $JARFILE | sed -e 's/cbflib-\(.*\)\.jar/\1/g'`

DEST=dist/$VERSION/$PLAT_OS/$ARCH
mkdir -p $DEST
cp $JARFILE $DEST
if [ $PLAT_OS == "win32" ]; then
    cp solib/cbf*.$LIBEXT $DEST
else
    cp solib/libcbf*.$LIBEXT $DEST
fi
cp bin/ctestcbf $DEST

