#!/usr/bin/env sh

function helper(){
  echo "usage:`basename $0` project configuration CODE_SIGN_IDENTITY PROVISIONING_PROFILE clean"
  echo "  configuration:Debug|Release"
  echo "  clean:true|false"
  echo "  export-target:app-store|ad-hoc|enterprise|development"
  echo "  CODE_SIGN_IDENTITY:common name exp: iPhone Developer: xiehui xie (T673VPKMTZ)"
  echo "  PROVISIONING_PROFILE:uuid exp:6214a5d0-dc01-4bf8-a86d-480da817c2bf"
}

if [[ $# < 2 ]]; then
  echo "please see below"
  helper
  exit 1
fi

helper

PROJECT_NAME=$1
CONFIGURATION=$2
CODE_SIGN_IDENTITY=$3
PROVISIONING_PROFILE=$4
CLEAN=$5
DERIVED_PATH=$PWD/build2

OUTPUT_PATH=$PWD/archives
OUTPUT_SUFFIX=`date +"%Y%m%d-%H%M%S"`
OUTPUT_NAME=${PROJECT_NAME}-${OUTPUT_SUFFIX}-${CONFIGURATION}

if [[ $CLEAN == "true" ]]; then
  echo "clean derived data"
  rm -rf "${DERIVED_PATH}"
  exit
  xcodebuild -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" -configuration ${CONFIGURATION} clean
fi

if [[ -z "$CODE_SIGN_IDENTITY"  ]]; then
  CODE_SIGN_IDENTITY="iPhone Developer: xiehui xie (T673VPKMTZ)"
fi
if [[ -z "$PROVISIONING_PROFILE" ]]; then
  PROVISIONING_PROFILE="6214a5d0-dc01-4bf8-a86d-480da817c2bf"
fi

# update build number
if [[ $BUILD_NUMBER != "" ]]; then
  /usr/libexec/PlistBuddy -c "Set CFBundleVersion ${BUILD_NUMBER}" ./${PROJECT_NAME}/Info.plist # -c "Print"
fi
BUILD_NUMBER=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ./${PROJECT_NAME}/Info.plist`
BUILD_VESION=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ./${PROJECT_NAME}/Info.plist`
# build
xcodebuild -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" -configuration ${CONFIGURATION} -derivedDataPath ${DERIVED_PATH} build DEBUG_INFORMATION_FORMAT=dwarf-with-dsym CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" PROVISIONING_PROFILE="$PROVISIONING_PROFILE"
# crate fake xcarchive
XCARCHIVE_PATH=${OUTPUT_PATH}/${OUTPUT_NAME}.xcarchive
mkdir -p ${XCARCHIVE_PATH}
mkdir -p ${XCARCHIVE_PATH}/Products/Applications
mkdir -p ${XCARCHIVE_PATH}/dSYMS

cp -rf ${DERIVED_PATH}/Build/Products/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.app ${XCARCHIVE_PATH}/Products/Applications
cp -rf ${DERIVED_PATH}/Build/Products/${CONFIGURATION}-iphoneos/*.dSYM ${XCARCHIVE_PATH}/dSYMs

INFO_PATH="/tmp/${OUTPUT_NAME}"
if [[ ! -e $INFO_PATH  ]]; then
   mkdir -p $INFO_PATH
fi
touch ${INFO_PATH}/Info.plist
cat > ${INFO_PATH}/Info.plist <<- EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>ApplicationProperties</key>
  <dict>
    <key>ApplicationPath</key>
    <string>Applications/${PROJECT_NAME}.app</string>
    <key>CFBundleIdentifier</key>
    <string>com.ibestv.app.sarrs</string>
    <key>CFBundleShortVersionString</key>
    <string>$BUILD_VESION</string>
    <key>CFBundleVersion</key>
    <string>$BUILD_NUMBER</string>
    <key>SigningIdentity</key>
    <string>iPhone Developer: xiehui xie (T673VPKMTZ)</string>
  </dict>
  <key>ArchiveVersion</key>
  <integer>2</integer>
  <key>CreationDate</key>
  <date>`date +"%Y-%m-%dT%H:%m:%SZ"`</date>
  <key>DefaultToolchainInfo</key>
  <dict>
    <key>DisplayName</key>
    <string>Xcode 7.3 Default</string>
    <key>Identifier</key>
    <string>com.apple.dt.toolchain.XcodeDefault</string>
  </dict>
  <key>Name</key>
  <string>${PROJECT_NAME}</string>
  <key>SchemeName</key>
  <string>${PROJECT_NAME}</string>
</dict>
</plist>
EOM

mv ${INFO_PATH}/Info.plist ${XCARCHIVE_PATH}


pushd ${OUTPUT_PATH}
zip -r ${OUTPUT_NAME}.xcarchive.zip ${OUTPUT_NAME}.xcarchive
rm -rf ${OUTPUT_NAME}.xcarchive
popd

# package
xcrun -sdk iphoneos PackageApplication -v ${DERIVED_PATH}/Build/Products/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.app -o ${OUTPUT_PATH}/${OUTPUT_NAME}.ipa