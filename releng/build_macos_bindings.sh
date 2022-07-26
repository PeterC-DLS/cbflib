#!/bin/bash
set -e -x

export JDKDIR=$JAVA_HOME_11_X64

PLAT_OS=macos
LIBEXT=dylib
CBF_MAKEFILE=Makefile_OSX

CBF_DYLIB=libcbf.$LIBEXT
CBF_DYLIB_WRAP=solib/libcbf_wrap.$LIBEXT

ARCH=x86_64
export CC="clang -arch $ARCH"
export MACOSX_DEPLOYMENT_TARGET=10.8

source releng/build_java_bindings.sh
install_name_tool -change solib/$CBF_DYLIB "@loader_path/$CBF_DYLIB" $CBF_DYLIB_WRAP
mv solib solib-$ARCH
X86_DEST=$DEST

# Repeat for -arch arm64 (just build wrapper)
ARCH=arm64
export CC="clang -arch $ARCH"
export MACOSX_DEPLOYMENT_TARGET=11.0

source releng/build_java_bindings.sh
install_name_tool -change solib/$CBF_DYLIB "@loader_path/$CBF_DYLIB" $CBF_DYLIB_WRAP
mv solib solib-$ARCH

# Create universal2 versions
UNI_DEST=dist/$VERSION/$PLAT_OS/universal2
mkdir -p $UNI_DEST
for l in $DEST/*.$LIBEXT; do
    dlib=$(basename $l)
    lipo -create $l $X86_DEST/$dlib -output $UNI_DEST/$dlib
done

