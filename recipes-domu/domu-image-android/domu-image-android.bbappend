inherit build-layout
require android-gfx.inc 

# Most functionality and settings are defiend in xt-images.
# Only some minimal tuning is required by environment variables.

# In most cases we can use default source of android's repo, provided in xt-images
#SRC_URI = " \
#    repo://... \
#"

# For proper build of graphics we need to set proper SOC. This info is available
# for us from local.conf and we do not need to run do_domd_install_machine_overrides.
# H3 ES3
SOC_FAMILY_r8a7795 = "r8a7795"
SOC_FAMILY_r8a7795-es3 = "r8a7795"
# M3
#SOC_FAMILY_r8a7796 = "r8a7796"
# M3N
#SOC_FAMILY_r8a77965 = "r8a77965"

# If SOC_REVISION is not set, then ES3 is used as default.
# Pay atention that ES2 is not supported anymore.
SOC_REVISION_r8a7795-es3 = ""
#SOC_REVISION_r8a7795-es2 = "es2"

TVM_VERSION="401ffe131e207bc83fa424df3dbc14ed1c987731"
HALIDEIR_VERSION="37d3aa33059cee04d561679f9a6d25092b17c519"
DLPACK_VERSION="bee4d1dd8dc1ee4a1fd8fa6a96476c2f8b7492a3"
DMLC_VERSION="ac983092ee3b339f76a2d7e7c3b846570218200d"

SRCREV = "${AUTOREV}"

SRC_URI = " \
    repo://github.com/xen-troops/android_manifest;protocol=https;branch=android-10.0.0_r3-master;manifest=doma.xml;scmdata=keep;;directpath=1 \
    git://git@gitpct.epam.com/epmd-aepr/pvr.git;protocol=ssh;branch=1.11/5375571-7.1.0-10.0.0_r3-xt0.1-standalone \
    https://dl.google.com/android/repository/android-ndk-r17c-linux-x86_64.zip;subdir=android-sdk_tmp;builddir=ndk-bundle/android-ndk-r17c;name=ndk \
    http://llvm.org/releases/7.0.0/llvm-${VERSION}.src.tar.xz;subdir=llvm_tmp;builddir=ndk-bundle/apps/llvm${FOLDER_POSTFIX};name=llvm \
    http://llvm.org/releases/7.0.0/cfe-${VERSION}.src.tar.xz;subdir=cfe_tmp;builddir=ndk-bundle/apps/clang${FOLDER_POSTFIX};name=cfe \
    https://github.com/dmlc/tvm/archive/${TVM_VERSION}.zip;subdir=tvm_tmp;builddir=ndk-bundle/apps/nnvm00;name=tvm \
    https://github.com/dmlc/HalideIR/archive/${HALIDEIR_VERSION}.zip;subdir=halider_tmp;builddir=ndk-bundle/apps/nnvm00/3rdparty/HalideIR;name=hir \
    https://github.com/dmlc/dlpack/archive/${DLPACK_VERSION}.zip;subdir=dlpack_tmp;builddir=ndk-bundle/apps/nnvm00/3rdparty/dlpack;name=dlpack \
    https://github.com/dmlc/dmlc-core/archive/${DMLC_VERSION}.zip;subdir=dmlc-core_tmp;builddir=ndk-bundle/apps/nnvm00/3rdparty/dmlc-core;name=dmlccore \
    git://android.googlesource.com/platform/external/libunwind_llvm;protocol=https;destsuffix=ndk-bundle/apps/libunwind_llvm;branch=pie-release \
    git://android.googlesource.com/platform/external/libcxxabi;protocol=https;destsuffix=ndk-bundle/apps/libcxxabi;branch=pie-release \
    git://android.googlesource.com/platform/external/libcxx;protocol=https;destsuffix=ndk-bundle/apps/libcxx;branch=pie-release \
"

do_unpack_append(){
    build_layout(d)
}

do_configure_prepend() {
    #bb.build.exec_func("configure_layout", d)
    configure_layout
}

configure_layout() {
   cd ${WORKDIR}/git
   git submodule init
   git submodule update --remote
    
   ln -s ${WORKDIR}/ndk-bundle/android-ndk-r17c/platforms/android-24 ${WORKDIR}/ndk-bundle/android-ndk-r17c/platforms/android-25
   cd ${WORKDIR}/ndk-bundle/apps/libcxx && patch -Np3 -i ${WORKDIR}/git/rogue/android/patches/Pie-LIBCXX-add-NDK-build-support.diff
 
    # apply llvm patch
   cd ${WORKDIR}/ndk-bundle/apps/llvm${FOLDER_POSTFIX}
   patch -sNp0 -i ${WORKDIR}/git/rogue/tools/intern/llvmufgen/patches/llvm.patch -d ./
   # apply clang patch
   cd ${WORKDIR}/ndk-bundle/apps/clang${FOLDER_POSTFIX}
   patch -sNp0 -i ${WORKDIR}/git/rogue/tools/intern/llvmufgen/patches/clang.patch -d ./

   cd ${NDK_ROOT}/apps
   patch_dir="${WORKDIR}/git/rogue/cldnn/patches"
   patch -sNp1 -i ${patch_dir}/nnvm.patch -d ${NNVM_FOLDER_NAME}
   patch -sNp1 -i ${patch_dir}/toolchain.patch -d ${NNVM_FOLDER_NAME}
   patch -sNp1 -i ${patch_dir}/dmlc.patch -d ${NNVM_FOLDER_NAME}/3rdparty/dmlc-core/
}

do_compile_append() {
    cd "${ANDROID_Q_DIR}/target/product/${ANDROID_PRODUCT}/system/apex"
    ln -sfn com.android.runtime.debug com.android.runtime
    # go to "${ANDROID_Q_DIR}/target/product/${ANDROID_PRODUCT}/system"
    cd .. 

    for f in {"libc.so","libdl.so","libm.so"}; do
        if [ -f "apex/com.android.runtime/lib64/bionic/$f" ] || [ -L "lib64/$f"  ]; then
            rm "$dst/$f"
        fi
        cp -f "apex/com.android.runtime/lib64/bionic/$f" "lib64/$f"
    
        if [ -f "apex/com.android.runtime/lib/bionic/$f" ] || [ -L "lib/$f"  ]; then
            rm "$dst/$f"
        fi
        cp -f "apex/com.android.runtime/lib/bionic/$f" "lib/$f"
    done

    cd "${ANDROID_Q_DIR}/target/product/${ANDROID_PRODUCT}/system/lib64"
    ln -sfn vndk-29 vndk-
    ln -sfn vndk-sp-29 vndk-sp-
    cd ../lib
    ln -sfn vndk-29 vndk-
    ln -sfn vndk-sp-29 vndk-sp-

    local cdir=$(pwd)
    android_platform="android-28"

    cd ${WORKDIR}/ndk-bundle && NDK_APPLICATION_MK=apps/libcxx/Application.mk NDK_PROJECT_PATH=null NDK_OUT=out NDK_LIBS_OUT=libs ./ndk-build -j16 APP_ABI="${APP_ABI}"

    cd `dirname ${WORKDIR}/git/rogue/android/patches/Pie-LIBCXX-add-NDK-build-support.diff`

    build_signature=$(md5sum Pie-LIBCXX-add-NDK-build-support.diff)

    echo ${build_signature} > ${WORKDIR}/ndk-bundle/apps/libcxx/.signature
    
}
