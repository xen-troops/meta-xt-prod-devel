SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

VERSION="7.0.0"
VERSION_FOLDERS="7.0.0"
FOLDER_POSTFIX="70"
LIBRARY_POSTFIX="-img"

TVM_VERSION="401ffe131e207bc83fa424df3dbc14ed1c987731"
HALIDEIR_VERSION="37d3aa33059cee04d561679f9a6d25092b17c519"
DLPACK_VERSION="bee4d1dd8dc1ee4a1fd8fa6a96476c2f8b7492a3"
DMLC_VERSION="ac983092ee3b339f76a2d7e7c3b846570218200d"

SRC_URI_append = " \
    repo://github.com/xen-troops/android_manifest;protocol=https;branch=android-10.0.0_r3-master;manifest=doma.xml;scmdata=keep \
    git://git@gitpct.epam.com/epmd-aepr/pvr.git;protocol=ssh;branch=1.11/5375571-7.1.0-10.0.0_r3-xt0.1-standalone \
    https://dl.google.com/android/repository/android-ndk-r17c-linux-x86_64.zip;name=ndk \
    https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip;name=sdk; \
    http://llvm.org/releases/7.0.0/llvm-${VERSION}.src.tar.xz;name=llvm \
    http://llvm.org/releases/7.0.0/cfe-${VERSION}.src.tar.xz;name=cfe \
    https://github.com/dmlc/tvm/archive/${TVM_VERSION}.zip;name=tvm \
    https://github.com/dmlc/HalideIR/archive/${HALIDEIR_VERSION}.zip;name=hir \
    https://github.com/dmlc/dlpack/archive/${DLPACK_VERSION}.zip;name=dlpack \
    https://github.com/dmlc/dmlc-core/archive/${DMLC_VERSION}.zip;name=dmlccore \
    git://android.googlesource.com/platform/external/libunwind_llvm;protocol=https;destsuffix=ndk-bundle/apps/libunwind_llvm;branch=pie-release \
    git://android.googlesource.com/platform/external/libcxxabi;protocol=https;destsuffix=ndk-bundle/apps/libcxxabi;branch=pie-release \
    git://android.googlesource.com/platform/external/libcxx;protocol=https;destsuffix=ndk-bundle/apps/libcxx;branch=pie-release \
"
#https://cmake.org/files/v3.11/cmake-3.11.4.tar.gz;name=cmake
SRC_URI[ndk.md5sum] = "a4b6b8281e7d101efd994d31e64af746"
SRC_URI[ndk.sha256sum] = "3f541adbd0330a9205ba12697f6d04ec90752c53d6b622101a2a8a856e816589"
SRC_URI[sdk.md5sum] = "aa190cfd7299cd6a1c687355bb2764e4"
SRC_URI[sdk.sha256sum] = "92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9"
SRC_URI[llvm.md5sum] = "e0140354db83cdeb8668531b431398f0"
SRC_URI[llvm.sha256sum] = "8bc1f844e6cbde1b652c19c1edebc1864456fd9c78b8c1bea038e51b363fe222"
SRC_URI[cfe.md5sum] = "2ac5d8d78be681e31611c5e546e11174"
SRC_URI[cfe.sha256sum] = "550212711c752697d2f82c648714a7221b1207fd9441543ff4aa9e3be45bba55"
SRC_URI[tvm.md5sum] = "62d3242960f3ed2af8c99ab8103be0ec"
SRC_URI[tvm.sha256sum] = "0d2a9f43d9398136244c71f3a28cb3551cd52d004cd90dfa5be90afc35dc398b"
SRC_URI[hir.md5sum] = "ff1017550f1b85780fc396837e6d2473"
SRC_URI[hir.sha256sum] = "8daddb1d3d57ab86bccdf7ebcab18a9bcfb696357e48acba946390c6d0287f65"
SRC_URI[dlpack.md5sum] = "370aa943b4785bc6541af6a72fb296be"
SRC_URI[dlpack.sha256sum] = "18abbbb33b58883e94b343a092a61d7e77ae4ddc56dc5593f2244a06cd55e565"
SRC_URI[dmlccore.md5sum] = "06b87007fef7c636c986781aef30ae28"
SRC_URI[dmlccore.sha256sum] = "43bd268b4180edf1dbf6715b6f2d410ca7f48166872c3d00f526203ff6eb740f"
SRC_URI[cmake.md5sum] = "72e168b3bad2f9c34dcebbad7af56ff0"
SRC_URI[cmake.sha256sum] = "8f864e9f78917de3e1483e256270daabc4a321741592c5b36af028e72bff87f5"

# put it out of the source tree, so it can be reused after cleanup
ANDROID_OUT_DIR_COMMON_BASE = "${SSTATE_DIR}/../${ANDROID_PRODUCT}-${SOC_FAMILY}"
ANDROID_PRODUCT_OUT = "${ANDROID_OUT_DIR_COMMON_BASE}/target/product/${ANDROID_PRODUCT}"
ANDROID_HOST_PYTHON="$(dirname ${PYTHON})"

EXTRA_OEMAKE_append = " \
    TARGET_BOARD_PLATFORM=${SOC_FAMILY} \
    TARGET_SOC_REVISION=${SOC_REVISION} \
    OUT_DIR=${ANDROID_OUT_DIR_COMMON_BASE} \
    PRODUCT_OUT=${ANDROID_PRODUCT_OUT} \
    HOST_PYTHON=${ANDROID_HOST_PYTHON} \
"
TOOLCHAIN = "clang"
ANDROID_KERNEL_NAME ?= "kernel"
ANDROID_UNPACKED_KERNEL_NAME ?= "vmlinux"
PATCHTOOL = "git"
DEPENDS += " python-clang-native"
DEPENDS += "python-pycrypto-native"
#DEPENDS += "clang-cross-x86_64"
#DEPENDS += "clang-native"
PREFERRED_VERSION_python-clang = "6.0"

################################################################################
# Renesas R-Car
################################################################################

SOC_FAMILY_r8a7795 = "r8a7795"
SOC_FAMILY_r8a7796 = "r8a7796"
SOC_FAMILY_r8a77965 = "r8a77965"

SOC_REVISION = ""
SOC_REVISION_r8a7795-es2 = "es2"

ANDROID_VARIANT_rcar = "userdebug"
ANDROID_PRODUCT_rcar = "xenvm"

DDK_TOP="${WORKDIR}/git"

ANDROID_Q_DIR="${SSTATE_DIR}/../${ANDROID_PRODUCT}-${SOC_FAMILY}"

TVM_VERSION="401ffe131e207bc83fa424df3dbc14ed1c987731"
HALIDEIR_VERSION="37d3aa33059cee04d561679f9a6d25092b17c519"
DLPACK_VERSION="bee4d1dd8dc1ee4a1fd8fa6a96476c2f8b7492a3"
DMLC_VERSION="ac983092ee3b339f76a2d7e7c3b846570218200d"

NDK_ROOT="${WORKDIR}/ndk-bundle/"
NNVM_FOLDER_NAME="nnvm00"
NNVM_SOURCE_DIR="${NDK_ROOT}/apps/${NNVM_FOLDER_NAME}"
APP_ABI="armeabi-v7a arm64-v8a x86 x86_64"
NNVM_TOOLCHAIN_CFG="${NNVM_SOURCE_DIR}/android.toolchain.cmake"

LLVM_SOURCE_DIR="${WORKDIR}/ndk-bundle/apps/llvm${FOLDER_POSTFIX}"
CLANG_SOURCE_DIR="${WORKDIR}/ndk-bundle/apps/clang${FOLDER_POSTFIX}"
LLVM_TOOLCHAIN_CFG="${LLVM_SOURCE_DIR}/android.toolchain.cmake"
CONFIGURE_CCACHE=" -DLLVM_CCACHE_BUILD=Off "
LIBRARY_POSTFIX="-img"
FOLDER_POSTFIX="70"

CLANG_ARCHIVES="clangFrontendTool clangFrontend clangDriver clangSerialization clangCodeGen clangParse clangSema clangRewriteFrontend clangRewrite clangAnalysis clangEdit clangAST clangASTMatchers clangLex clangBasic"

LLVM_ARCHIVES="LLVMLTO LLVMPasses LLVMSymbolize LLVMDebugInfoDWARF LLVMTestingSupport LLVMLibDriver LLVMAsmPrinter LLVMCoverage LLVMTableGen LLVMOption LLVMipo LLVMVectorize LLVMLinker LLVMIRReader LLVMMIRParser LLVMAsmParser LLVMCodeGen LLVMScalarOpts LLVMInstCombine LLVMTransformUtils LLVMBitWriter LLVMTarget LLVMAnalysis LLVMProfileData LLVMObject LLVMBitReader LLVMMC LLVMCore LLVMBinaryFormat LLVMSupport LLVMDemangle"

do_configure_prepend() {
    if [ -d "${WORKDIR}/android-ndk-r17c" ]; then
       mv ${WORKDIR}/android-ndk-r17c/* ${WORKDIR}/ndk-bundle/
    fi

    cd ${WORKDIR}/git
    git submodule init
    git submodule update --remote

    ln -sf ${WORKDIR}/ndk-bundle/platforms/android-24 ${WORKDIR}/ndk-bundle/platforms/android-25

    cd ${WORKDIR}/ndk-bundle/apps/libcxx && patch -Np3 -i ${WORKDIR}/git/rogue/android/patches/Pie-LIBCXX-add-NDK-build-support.diff

    # apply llvm patch
    cd ${WORKDIR}/llvm-${VERSION}.src
    patch -sNp0 -i ${WORKDIR}/git/rogue/tools/intern/llvmufgen/patches/llvm.patch -d ./

    # apply clang patch
    cd ${WORKDIR}/cfe-${VERSION}.src
    patch -sNp0 -i ${WORKDIR}/git/rogue/tools/intern/llvmufgen/patches/clang.patch -d ./

    if [ -d "${WORKDIR}/ndk-bundle/apps/llvm${FOLDER_POSTFIX}" ]; then
       rm -Rf ${WORKDIR}/ndk-bundle/apps/llvm${FOLDER_POSTFIX}
    fi

    if [ -d "${WORKDIR}/ndk-bundle/apps/clang${FOLDER_POSTFIX}" ]; then
       rm -Rf ${WORKDIR}/ndk-bundle/apps/clang${FOLDER_POSTFIX}
    fi

    if [ -d "${WORKDIR}/llvm-${VERSION}.src" ]; then
       mv ${WORKDIR}/llvm-${VERSION}.src ${WORKDIR}/ndk-bundle/apps/llvm${FOLDER_POSTFIX}
    fi
   
    if [ -d "${WORKDIR}/cfe-${VERSION}.src" ]; then
       mv ${WORKDIR}/cfe-${VERSION}.src ${WORKDIR}/ndk-bundle/apps/clang${FOLDER_POSTFIX}
    fi

    cd ${NDK_ROOT}/apps
    mkdir -p ${NNVM_FOLDER_NAME}

    if [ -d "${WORKDIR}/incubator-tvm-${TVM_VERSION}" ]; then 
       cp -rf ${WORKDIR}/incubator-tvm-${TVM_VERSION}/* ${NNVM_FOLDER_NAME}
    fi

    if [ -d ${NNVM_FOLDER_NAME}/3rdparty/HalideIR ]; then 
       rm -rf ${NNVM_FOLDER_NAME}/3rdparty/HalideIR
    fi
    mkdir -p ${NNVM_FOLDER_NAME}/3rdparty/HalideIR
    cp -rf ${WORKDIR}/HalideIR-${HALIDEIR_VERSION}/* ${NNVM_FOLDER_NAME}/3rdparty/HalideIR

    if [ -d ${NNVM_FOLDER_NAME}/3rdparty/dlpack ]; then
       rm -rf ${NNVM_FOLDER_NAME}/3rdparty/dlpack
    fi
    mkdir -p ${NNVM_FOLDER_NAME}/3rdparty/dlpack
    cp -rf ${WORKDIR}/dlpack-${DLPACK_VERSION}/* ${NNVM_FOLDER_NAME}/3rdparty/dlpack

    if [ -d ${NNVM_FOLDER_NAME}/3rdparty/dmlc-core ]; then
       rm -rf ${NNVM_FOLDER_NAME}/3rdparty/dmlc-core
    fi
    mkdir -p ${NNVM_FOLDER_NAME}/3rdparty/dmlc-core
    cp -rf ${WORKDIR}/dmlc-core-${DMLC_VERSION}/* ${NNVM_FOLDER_NAME}/3rdparty/dmlc-core

    patch_dir="${WORKDIR}/git/rogue/cldnn/patches"

    patch -sNp1 -i ${patch_dir}/nnvm.patch -d ${NNVM_FOLDER_NAME}
    patch -sNp1 -i ${patch_dir}/toolchain.patch -d ${NNVM_FOLDER_NAME}
    patch -sNp1 -i ${patch_dir}/dmlc.patch -d ${NNVM_FOLDER_NAME}/3rdparty/dmlc-core/
}


do_compile_append() {
   
    export ANDROID_DDK_DEPS=${NDK_ROOT}
    export OUT_DIR=${ANDROID_OUT_DIR_COMMON_BASE}
    export METAG_ROOT=${WORKDIR}/repo/prebuilts/imagination/metag/2.8
    export ANDROID_PRODUCT_OUT=${ANDROID_Q_DIR}/target/product/xenvm
    export ANDROID_ROOT=${ANDROID_PRODUCT_OUT}/system 

    cd "${ANDROID_Q_DIR}/target/product/${ANDROID_PRODUCT}/system/apex"
    ln -sfn com.android.runtime.debug com.android.runtime
    cd "${ANDROID_Q_DIR}/target/product/${ANDROID_PRODUCT}/system"
    
    if [ -f lib64/libc.so ] || [ -L lib64/libc.so  ]; then
       rm lib64/libc.so
       cp -f apex/com.android.runtime/lib64/bionic/libc.so lib64/libc.so
    fi

    if [ -f lib64/libdl.so ] || [ -L lib64/libdl.so ] ; then
       rm lib64/libdl.so
       cp -f apex/com.android.runtime/lib64/bionic/libdl.so lib64/libdl.so
    fi

    if [ -f lib64/libm.so ] || [ -L lib64/libm.so ]; then
       rm lib64/libm.so
       cp -f apex/com.android.runtime/lib64/bionic/libm.so lib64/libm.so
    fi

    if [ -f lib/libc.so ] || [ -L lib/libc.so ]; then
       rm lib/libc.so
       cp -f apex/com.android.runtime/lib/bionic/libc.so lib/libc.so
    fi
    if [ -f lib/libdl.so ] || [ -L lib/libdl.so ]; then
       rm lib/libdl.so
       cp -f apex/com.android.runtime/lib/bionic/libdl.so lib/libdl.so
    fi
    if [ -f lib/libm.so ] || [ -L lib/libm.so ]; then
       rm lib/libm.so
       cp -f apex/com.android.runtime/lib/bionic/libm.so lib/libm.so
    fi

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
    
    common_llvm_flags="-DCMAKE_BUILD_TYPE=Release -DLLVM_EXTERNAL_CLANG_SOURCE_DIR=${CLANG_SOURCE_DIR} -DLLVM_BUILD_RUNTIME=Off -DLLVM_INCLUDE_TESTS=Off -DLLVM_ENABLE_BACKTRACES=Off -DLLVM_OPTIMIZED_TABLEGEN=On -DLLVM_ENABLE_ZLIB=Off -DLLVM_TARGETS_TO_BUILD= -DLLVM_ENABLE_TERMINFO=Off -DLLVM_BUILD_TOOLS=Off -DLLVM_ENABLE_LIBEDIT=Off -DLLVM_BUILD_UTILS=Off -DLLVM_BUILD_RUNTIMES=Off -DCLANG_ENABLE_OBJC_REWRITER=Off -DCLANG_ENABLE_ARCMT=Off -DCLANG_PLUGIN_SUPPORT=Off -DCLANG_ENABLE_STATIC_ANALYZER=Off -DLLVM_PARALLEL_LINK_JOBS=1 -DLLVM_TABLEGEN=${LLVM_SOURCE_DIR}/host_build/bin/llvm-tblgen${LIBRARY_POSTFIX} -DCLANG_TABLEGEN=${LLVM_SOURCE_DIR}/host_build/bin/clang-tblgen${LIBRARY_POSTFIX} ${CONFIGURE_CCACHE}"
   
    target_clang_libs=`echo "${CLANG_ARCHIVES}" | sed "s/\>/${LIBRARY_POSTFIX}.a/g" | sed "s/clang/lib\/libclang/g"`
    target_llvm_libs=`echo "${LLVM_ARCHIVES}" | sed "s/\>/${LIBRARY_POSTFIX}.a/g" | sed "s/LLVM/lib\/libLLVM/g"`

    cd ${LLVM_SOURCE_DIR}

    rm -rf host_build
    mkdir host_build
    cd host_build

    CC=clang
    CXX=clang++ 

    if [ ! -f ${LLVM_SOURCE_DIR}/host_build/.signature ]; then

        cmake ${common_llvm_flags} -DLLVM_ENABLE_ASSERTIONS=On ${LLVM_SOURCE_DIR}

        cd ${WORKDIR}/repo

        bash -c "source build/envsetup.sh && \
             lunch xenvm-userdebug && \
             make -j16 -C ${LLVM_SOURCE_DIR}/host_build clang-tblgen llvm-tblgen llvm-as llvm-link && \
             make -j16 -C ${LLVM_SOURCE_DIR}/host_build clang ${CLANG_ARCHIVES} ${LLVM_ARCHIVES} \
        "
        cd ${LLVM_SOURCE_DIR}/host_build

        # Move the created binaries into ${NDK_ROOT}/out/local/host/bin/

        bins_folder=${WORKDIR}/ndk-bundle/out/local/host/bin/

        mkdir -p ${bins_folder}
        mv bin/clang${LIBRARY_POSTFIX} bin/llvm-as${LIBRARY_POSTFIX} bin/llvm-link${LIBRARY_POSTFIX} ${bins_folder}

        # Move the created libraries into ${NDK_ROOT}/out/local/host/lib/

        libs_folder=${WORKDIR}/ndk-bundle/out/local/host/lib/llvm${LIBRARY_POSTFIX}${FOLDER_POSTFIX}/

        mkdir -p ${libs_folder}
        mv ${target_llvm_libs} ${target_clang_libs} ${libs_folder}
        
        build_signature=$(md5sum ${LLVM_SOURCE_DIR}/host_build/Makefile)
        echo ${build_signature} > ${LLVM_SOURCE_DIR}/host_build/.signature

    else
      echo "Signature exists ${LLVM_SOURCE_DIR}/host_build/.signature, no needs to build again."
    fi

    # Remove unused files, as libraries have already been moved in the NDK out folder.
    # The files in bin/ are kept as they contain llvm-tblgen and clang-tblgen and they
    # are needed for the target builds.

    rm -rf lib
    rm -rf tools/clang/lib

    cd ${LLVM_SOURCE_DIR}
    
    for android_abi in ${APP_ABI}; do
      echo "Building LLVM libraries for ${android_abi}"
      
      libs_folder=${WORKDIR}/ndk-bundle/out/local/${android_abi}/llvm${LIBRARY_POSTFIX}${FOLDER_POSTFIX}/
      
      if [ -d ${libs_folder} ]; then
        echo "${libs_folder} exists, no needs to recompile."
        continue
      fi 

      rm -rf target_build
      mkdir target_build
      cd target_build

      cmake -DCMAKE_TOOLCHAIN_FILE=${LLVM_TOOLCHAIN_CFG} \
            -DANDROID_ABI=${android_abi} \
            -DANDROID_STL="c++_shared" \
            -DCMAKE_CROSSCOMPILING=On \
            -DANDROID_PLATFORM=${android_platform} \
            -DLLVM_ENABLE_ASSERTIONS=Off \
             ${common_llvm_flags} \
             ${LLVM_SOURCE_DIR}

      cdir=$(pwd)
      cd ${WORKDIR}/repo

      bash -c "source build/envsetup.sh && \
               lunch xenvm-userdebug && \
               make -j16 -C ${cdir}  ${CLANG_ARCHIVES} ${LLVM_ARCHIVES} \
      "
      cd ${cdir}

      mkdir -p ${libs_folder}
      mv ${target_llvm_libs} ${target_clang_libs} ${libs_folder}
   
      # Remove unused files, as libraries have already been moved in the NDK out folder.
      rm -rf bin
      rm -rf lib
      rm -rf tools/clang/lib
      cd ..
   done
   
   cd "${NNVM_SOURCE_DIR}"

   for android_abi in ${APP_ABI}; do
    libs_folder="${NDK_ROOT}/out/local/${android_abi}/${NNVM_FOLDER_NAME}/"

    if [ ! -d ${libs_folder} ]; then

      mkdir -p "${libs_folder}"
      build_dir="build-${android_abi}"

      echo "Building into ${build_dir}"

      # Now build NNVM
      rm -rf "${build_dir}"
      mkdir "${build_dir}"
      
      cdir=$(pwd)
      cd "${build_dir}"

      echo "Running cmake ..."
      
      cmake -DBUILD_STATIC_TVM=ON -DBUILD_SHARED_TVM=OFF \
            -DCMAKE_C_FLAGS="-fvisibility=hidden"   \
            -DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
            -DCMAKE_TOOLCHAIN_FILE=${NNVM_TOOLCHAIN_CFG} \
            -DANDROID_ABI=${android_abi} \
            -DANDROID_STL="c++_shared" \
            -DCMAKE_CROSSCOMPILING=On \
            -DUSE_RPC=0 -DUSE_GRAPH_RUNTIME=0 \
            -DANDROID_PLATFORM=${android_platform} \
            -DCMAKE_BUILD_TYPE=Release ..

      echo "Building NNVM libraries for ${android_abi}"

      build_dir=$(pwd)

      cd ${WORKDIR}/repo

      bash -c "source build/envsetup.sh && \
               lunch xenvm-userdebug && \
               make -j16 -C ${build_dir} tvm_static nnvm_compiler_static \
      "
      cd ${build_dir}

      #make -j16 tvm_static nnvm_compiler_static
     
      mv libtvm_static.a libnnvm_compiler_static.a "${libs_folder}"
      
      # Remove unused files, as libraries have already been moved in the NDK out folder.
      cd ${cdir}
      rm -rf "${build_dir}"

    else
      echo "NNVM libraries for ${android_abi} look good. No need to rebuild."
    fi
   done

   cd ${WORKDIR}/repo

   export TARGET_PLATFORM=android-29
   export PLATFORM_RELEASE=10
   export ANDROID_TOOLCHAIN=${WORKDIR}/repo/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/
   export ANDROID_TOOLCHAIN_2ND_ARCH=${WORKDIR}/repo/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
   export ANDROID_BUILD_TOP=${WORKDIR}/repo
   export METAG_ROOT=${WORKDIR}/repo/prebuilts/imagination/metag/2.8
   export TARGET_DEVICE="xenvm"

   unset ANDROID_SDK
   unset LDFLAGS

   if [ ! -f ${DDK_TOP}/.signature ]; then

      bash -c "source build/envsetup.sh && \
                   lunch xenvm-userdebug && \
                   make all -C ${DDK_TOP} \
      "
      build_signature=$(md5sum ${DDK_TOP}/Makefile)
      echo ${build_signature} > ${DDK_TOP}/.signature

      cp -rf ${WORKDIR}/git/out/vendor/* ${WORKDIR}/repo/vendor/imagination/rogue_um
   
      #backup the prev sources
      cp -rf ${WORKDIR}/repo/vendor/imagination/rogue_km ${WORKDIR}/repo/vendor/imagination/rogue_km_origin
      # update rogue_km
      cp -rf ${WORKDIR}/git/rogue_km/* ${WORKDIR}/repo/vendor/imagination/rogue_km

      cd ${ANDROID_PRODUCT_OUT}/system
      # save the copy of the real libs (for debug)
      mv lib64/libc.so lib64/libc.so_ 
      mv lib64/libdl.so lib64/libdl.so_
      mv lib64/libm.so lib64/libm.so_
      mv lib/libc.so  lib/libc.so_
      mv lib/libdl.so lib/libdl.so_ 
      mv lib/libm.so lib/libm.so_
   else
      echo "${DDK_TOP}/.signature exists, no needs to rebuild."
   fi

   cd ${WORKDIR}/repo
   
   if [ ! -f ${WORKDIR}/repo/.gfx_signature ]; then 
       env -i HOME="$HOME" LC_CTYPE="${LC_ALL:-${LC_CTYPE:-$LANG}}" USER="$USER" \
           PATH="${USRBINPATH_NATIVE}:${PATH}" \
           OUT_DIR_COMMON_BASE="${ANDROID_OUT_DIR_COMMON_BASE}" \
           DDK_KM_PREBUILT_MODULE="${DDK_KM_PREBUILT_MODULE}" \
           TARGET_PREBUILT_KERNEL="${TARGET_PREBUILT_KERNEL}" \
           DDK_UM_PREBUILDS="${DDK_UM_PREBUILDS}" \
           bash -c "source build/envsetup.sh && \
                    lunch ${ANDROID_PRODUCT}-${ANDROID_VARIANT} && \
                    make install clean && \
                    make ${EXTRA_OEMAKE} -j16 \
           "
      build_signature=$(md5sum ${WORKDIR}/repo/Makefile)
      echo ${build_signature} > ${WORKDIR}/repo/.gfx_signature
   else
      echo "${WORKDIR}/repo/.gfx_signature exists, no needs to rebuild."
   fi
}

################################################################################
# Deploy images
################################################################################
# FIXME: if not forced and sstate cache is used then an old version of
# this package (read old DomA images) can be used from cache
# regardless of the fact that binaries may have actually changed, e.g.
# the recipe code is not changed, there is no SRC_URI with checksum
# Force install so if DomA images change we use the latest binaries
do_install[nostamp] = "1"
do_install() {
    install -d "${DEPLOY_DIR_IMAGE}"
    install -d "${XT_DIR_ABS_SHARED_BOOT_DOMA}"

    if [ -z ${TARGET_PREBUILT_KERNEL} ];then
        local FILE_TYPE=$(file ${ANDROID_PRODUCT_OUT}/${ANDROID_KERNEL_NAME} -b | awk '{ print $1 }')
        if [ ${FILE_TYPE} == "LZ4" ];then
            # uncompress lz4 packed kernel
            lz4 -d "${ANDROID_PRODUCT_OUT}/${ANDROID_KERNEL_NAME}" "${ANDROID_PRODUCT_OUT}/${ANDROID_UNPACKED_KERNEL_NAME}"
        else
            ln -sfr "${ANDROID_PRODUCT_OUT}/${ANDROID_KERNEL_NAME}" "${ANDROID_PRODUCT_OUT}/${ANDROID_UNPACKED_KERNEL_NAME}"
        fi
        # copy kernel to shared folder, so Dom0 can pick it up
        install -m 0744 "${ANDROID_PRODUCT_OUT}/${ANDROID_UNPACKED_KERNEL_NAME}" "${XT_DIR_ABS_SHARED_BOOT_DOMA}"

        # copy kernel to the deploy directory
        install -m 0744 "${ANDROID_PRODUCT_OUT}/${ANDROID_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}"
        install -m 0744 "${ANDROID_PRODUCT_OUT}/${ANDROID_UNPACKED_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}"
        find ${ANDROID_PRODUCT_OUT}obj/KERNEL_OBJ -iname "vmlinux" -exec tar -cJvf ${DEPLOY_DIR_IMAGE}/vmlinux.tar.xz {} \; || true
    else
        # copy uncompressed kernel to shared folder, so Dom0 can pick it up
        install -m 0744 "${TARGET_PREBUILT_KERNEL}" "${XT_DIR_ABS_SHARED_BOOT_DOMA}"
        # copy kernel to the deploy directory
        install -m 0744 "${TARGET_PREBUILT_KERNEL}" "${DEPLOY_DIR_IMAGE}"
    fi

    # copy images to the deploy directory
    find "${ANDROID_PRODUCT_OUT}/" -maxdepth 1 -iname '*.img' -exec \
        cp -f --no-dereference --preserve=links {} "${DEPLOY_DIR_IMAGE}" \;
    ln -sfr "${DEPLOY_DIR_IMAGE}/${ANDROID_UNPACKED_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}/Image"
    ln -sfr "${XT_DIR_ABS_SHARED_BOOT_DOMA}/${ANDROID_UNPACKED_KERNEL_NAME}" "${XT_DIR_ABS_SHARED_BOOT_DOMA}/Image"
}

