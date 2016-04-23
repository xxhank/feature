#!/usr/bin/env sh

function helper(){
    echo "usage:`basename $0` project configuration export-target clean"
    echo "  configuration:Debug|Release"
    echo "  clean:true|false"
    echo "  export-target:app-store|ad-hoc|enterprise|development"
}
function die(){
  echo "$*"
  exit 1
}

if [[ $# < 2 ]]; then
    echo "please see below"
    helper
    exit 1
fi

helper

PROJECT_NAME=$1
CONFIGURATION=$2
ExportMethod=$3
CLEAN=$4
DERIVED_PATH=./build
OUTPUT_PATH=./archives
OUTPUT_SUFFIX=`date +"%H%M%S(%Y%m%d)"`
#OUTPUT_SUFFIX="20160422-162056"
OUTPUT_NAME=${PROJECT_NAME}-${OUTPUT_SUFFIX}-${CONFIGURATION}-${ExportMethod}

if [[ $ExportMethod == "enterprise" ]]; then
  if [[ -z "$CODE_SIGN_IDENTITY"  ]]; then
    CODE_SIGN_IDENTITY="iPhone Distribution: Letv Information Technology(Beijing)Co.,Ltd"
  fi
  if [[ -z "$PROVISIONING_PROFILE" ]]; then
    PROVISIONING_PROFILE="81c0d14d-752a-4aea-bd3a-67e6ce6e1a77"
  fi
  PRODUCT_BUNDLE_IDENTIFIER="com.letv.iphone.enterprise.client"
  #/usr/libexec/PlistBuddy -c "Set CFBundleName SARRS-Enterprise" ./${PROJECT_NAME}/Info.plist || die "modify bundle  name failed"
  /usr/libexec/PlistBuddy -c "Set CFBundleDisplayName 超级视频-企业版" ./${PROJECT_NAME}/Info.plist || die "modify display name failed"
else
  if [[ -z "$CODE_SIGN_IDENTITY"  ]]; then
    CODE_SIGN_IDENTITY="iPhone Developer: xiehui xie (T673VPKMTZ)"
  fi
  if [[ -z "$PROVISIONING_PROFILE" ]]; then
    PROVISIONING_PROFILE="6214a5d0-dc01-4bf8-a86d-480da817c2bf"
  fi
  PRODUCT_BUNDLE_IDENTIFIER="com.ibestv.app.sarrs"
fi

if [[ $CLEAN == "true" ]]; then
    echo "clean derived data"
    rm -rf "${DERIVED_PATH}"
    xcodebuild -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" -configuration $CONFIGURATION clean
fi

if [[ $BUILD_NUMBER != "" ]]; then
  /usr/libexec/PlistBuddy -c "Set CFBundleVersion ${BUILD_NUMBER}" ./${PROJECT_NAME}/Info.plist # -c "Print"
fi

xcodebuild archive -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" -archivePath "${OUTPUT_PATH}/${OUTPUT_NAME}.xcarchive" -configuration $CONFIGURATION -derivedDataPath ${DERIVED_PATH} archive DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" PROVISIONING_PROFILE="$PROVISIONING_PROFILE" PRODUCT_BUNDLE_IDENTIFIER="$PRODUCT_BUNDLE_IDENTIFIER"

ExportOptionsPlist=/tmp/${PROJECT_NAME}-export.plist

if [[ $ExportMethod == "app-store" ]]; then
    cat > $ExportOptionsPlist <<- EOM
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>method</key>
    <string>app-store</string>
    </dict>
    </plist>
EOM
elif [[ $ExportMethod == "ad-hoc" ]]; then
    cat > $ExportOptionsPlist <<- EOM
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>compileBitcode</key>
    <false/>
    </dict>
    </plist>
EOM
elif [[ $ExportMethod == "enterprise" ]]; then
    cat > $ExportOptionsPlist <<- EOM
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>method</key>
    <string>enterprise</string>
    <key>compileBitcode</key>
    <false/>
    </dict>
    </plist>
EOM
else #[[ $ExportMethod == "development" ]]; then
   cat > $ExportOptionsPlist <<- EOM
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
   <key>method</key>
   <string>development</string>
   <key>compileBitcode</key>
   <false/>
   </dict>
   </plist>
EOM
fi

xcodebuild -exportArchive -archivePath "${OUTPUT_PATH}/${OUTPUT_NAME}.xcarchive" -exportPath "${OUTPUT_PATH}" -exportOptionsPlist $ExportOptionsPlist  2>&1 1>/dev/null || die "export to ipa failed. $?"
mv ${OUTPUT_PATH}/$PROJECT_NAME.ipa ${OUTPUT_PATH}/${OUTPUT_NAME}.ipa || die "mv ipa failed. $?"

pushd ${OUTPUT_PATH} pushd 2>&1 1>/dev/null
zip -q -r ${OUTPUT_NAME}.xcarchive.zip ${OUTPUT_NAME}.xcarchive
rm -rf ${OUTPUT_NAME}.xcarchive
popd pushd 2>&1 1>/dev/null

