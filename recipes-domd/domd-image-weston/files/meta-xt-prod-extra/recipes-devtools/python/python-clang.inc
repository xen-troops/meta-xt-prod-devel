SUMMARY = "Clang Python Bindings."

DESCRIPTION = "This is the python bindings subdir of llvm clang repository. \
               https://github.com/llvm-mirror/clang/tree/master/bindings/python \
               This is a non-official fork. Mainly for Pypi packaging purposes. \
               The pypi package is not official either."

HOMEPAGE = "http://clang.llvm.org/"
SECTION = "devel/python"
LICENSE = "NCSA"
LIC_FILES_CHKSUM = "file://PKG-INFO;md5=4d988f5f6d4fbc155861011db6de9182"

SRC_URI[md5sum] = "7161729f47c84c629fdd11eed693ac04"
SRC_URI[sha256sum] = "485985daf0a301e01b924db49ecb3e8b05ea40d6ab404f1778b8bfd5e4c89391"

inherit native pypi

PYPI_PACKAGE = "clang-5"
RDEPENDS = "python-native"
BBCLASSEXTEND = "native"
