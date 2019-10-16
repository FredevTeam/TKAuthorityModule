#!/bin/sh


target_name=TKAuthorityModule
version=1.5



# clean iphoneos
xcodebuild \
-workspace ${target_name}.xcworkspace \
-scheme ${target_name} \
-sdk iphoneos \
-configuration Debug \
SWIFT_VERSION=4.0 \
clean 

# clean iphonesimulator
xcodebuild \
-workspace ${target_name}.xcworkspace \
-scheme ${target_name} \
-sdk iphonesimulator \
-configuration Debug \
SWIFT_VERSION=4.0 \
clean 

# ONLY_ACTIVE_ARCH 			是否仅包含本机的架构 此处设置为 NO 会根据 -arch 指定的来
# CODE_SIGNING_REQUIRED   	不知道具体作用 
# CODE_SIGN_IDENTITY		代码签名标识  示例  iPhone Developer 
# CARTHAGE					这个参数是 Carthage build 的时候加的，此处无用  

# COPY_PHASE_STRIP			复制的时候是否删除调试符号，此处 debug 模式建议 No
# DYLIB_CURRENT_VERSION 	指定当前库的版本  
# GENERATE_PKGINFO_FILE 	是否生成包信息  
# PKGINFO_FILE_PATH    		包信息路径
# MACH_O_TYPE				打包二进制的类型  
# BUILD_VARIANTS			构建二进制的变体 noremal 普通； profile 配置， debug: 带有调试符的
# COMPRESS_PNG_FILES		是否压缩 png  default yes 
# CONFIGURATION_BUILD_DIR	构建路径 
# CONFIGURATION_TEMP_DIR	中间文件路径 
# DEBUG_INFORMATION_FORMAT	调试信息格式 stabs: dwarf : dwarf-with-dsym, default dwarf  
# SKIP_INSTALL				指定是否将构建后的放置在指定位置
# DEPLOYMENT_LOCATION		指定部署位置 yes: ￥DSTROOT； no: SYMROOT	
# BUILT_PRODUCTS_DIR		构建目录  
# TARGET_BUILD_DIR			

# mh_executable: Executable binary. Application, command-line tool, and kernel extension target types.
# mh_bundle: Bundle binary. Bundle and plug-in target types.
# mh_object: Relocatable object file.
# mh_dylib: Dynamic library binary. Dynamic library and framework target types.
# staticlib: Static library binary. Static library target types.


# build iphoneos 
xcodebuild \
-workspace ${target_name}.xcworkspace \
-scheme ${target_name} \
-configuration Debug \
-sdk iphoneos \
-derivedDataPath ./build/ \
ONLY_ACTIVE_ARCH=NO \
CODE_SIGNING_REQUIRED=NO \
CODE_SIGN_IDENTITY= \
COPY_PHASE_STRIP=NO \
GENERATE_PKGINFO_FILE=YES \
COPY_PHASE_STRIP=NO \
MACH_O_TYPE=mh_dylib \
BUILD_VARIANTS=debug \
BUILD_ROOT=./build/ \
BUILD_DIR=./build/ \
SWIFT_VERSION=4.0 \
DYLIB_CURRENT_VERSION=${version} \
CONFIGURATION_BUILD_DIR=./build/ \
SKIP_INSTALL=YES \
STRIP_INSTALLED_PRODUCT=NO \
GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
DEPLOYMENT_LOCATION=YES \
BUILT_PRODUCTS_DIR=./build/ \
archive -archivePath ./build/ \
GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO \
CLANG_ENABLE_CODE_COVERAGE=NO \
build



xcodebuild \
-workspace ${target_name}.xcworkspace \
-scheme ${target_name} \
-configuration Debug \
-sdk iphonesimulator \
-derivedDataPath ./build/ \
ONLY_ACTIVE_ARCH=NO \
CODE_SIGNING_REQUIRED=NO \
CODE_SIGN_IDENTITY= \
COPY_PHASE_STRIP=NO \
GENERATE_PKGINFO_FILE=YES \
COPY_PHASE_STRIP=NO \
MACH_O_TYPE=mh_dylib \
BUILD_VARIANTS=debug \
BUILD_ROOT=./build/ \
BUILD_DIR=./build/ \
SWIFT_VERSION=4.0 \
DYLIB_CURRENT_VERSION=${version} \
CONFIGURATION_BUILD_DIR=./build/ \
SKIP_INSTALL=YES \
STRIP_INSTALLED_PRODUCT=NO \
GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
DEPLOYMENT_LOCATION=YES \
BUILT_PRODUCTS_DIR=./build/ \
GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO \
CLANG_ENABLE_CODE_COVERAGE=NO \
build



# PKGINFO_FILE_PATH=./build/\
# -arch arm64 \
# -arch arm64e \
# -arch armv7 \
# -arch armv7s \
# -arch i386 \
# -arch x86_64 \



# 打包完成
# xcodebuild \
# -workspace TKAuthorityModule.xcworkspace \
# -scheme TKAuthorityModule \
# -configuration Debug \
# -sdk iphonesimulator \
# ONLY_ACTIVE_ARCH=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= CARTHAGE=YES \
# SKIP_INSTALL=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO CLANG_ENABLE_CODE_COVERAGE=NO STRIP_INSTALLED_PRODUCT=NO build MACH_O_TYPE=staticlib


# -arch 'arm64 armv7 x86_64 i386'  \
# xcodebuild \
# -workspace TKAuthorityModule.xcworkspace \
# -scheme TKAuthorityModule \
# -configuration Debug \
# -sdk iphonesimulator \
# ONLY_ACTIVE_ARCH=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= CARTHAGE=YES \
# SKIP_INSTALL=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO CLANG_ENABLE_CODE_COVERAGE=NO STRIP_INSTALLED_PRODUCT=NO \
# build -fembed-bitcode=true 
