LIC_FILES_CHKSUM = "file://LICENSE;md5=22d47a47bf252ca3ed7f71273b53612e"

# Important note: tarballs for all patchsets within a version are deleted when
# a new pachset is created. To avoid multiple patches for each patchset, try to
# update to the last pachset of a version
PATCHSET = "10"
SRC_URI = "http://www.imagemagick.org/download/releases/ImageMagick-${PV}-${PATCHSET}.tar.xz \
"
SRC_URI[md5sum] = "d3b361617d147d1a8f58a77930db3d0d"
SRC_URI[sha256sum] = "da2f6fba43d69f20ddb11783f13f77782b0b57783dde9cda39c9e5e733c2013c"
