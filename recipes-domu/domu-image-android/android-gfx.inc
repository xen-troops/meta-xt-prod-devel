VERSION="7.0.0"
VERSION_FOLDERS="7.0.0"
FOLDER_POSTFIX="70"
LIBRARY_POSTFIX="-img"

ANDROID_VARIANT_rcar = "userdebug"
ANDROID_PRODUCT_rcar = "xenvm"

# put it out of the source tree, so it can be reused after cleanup
ANDROID_OUT_DIR_COMMON_BASE = "${S}/out"
#${SSTATE_DIR}/../${ANDROID_PRODUCT}-${SOC_FAMILY}
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
PREFERRED_VERSION_python-clang = "6.0"
PREFERRED_VERSION_cmake = "3.11.4"

DDK_TOP="${WORKDIR}/git"
ANDROID_Q_DIR="${ANDROID_OUT_DIR_COMMON_BASE}"
#"${SSTATE_DIR}/../${ANDROID_PRODUCT}-${SOC_FAMILY}"

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



