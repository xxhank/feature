#!/usr/bin/env sh

function helper(){
    echo "usage:`basename $0` project configuration export-target clean"
    echo "  configuration:Debug|Release"
    echo "  clean:true|false"
    echo "  export-target:app-store|ad-hoc|enterprise|development"
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
OUTPUT_SUFFIX=`date +"%Y%m%d-%H%M%S"`
OUTPUT_NAME=${PROJECT_NAME}-${OUTPUT_SUFFIX}-${CONFIGURATION}

if [[ $CLEAN == "true" ]]; then
    echo "clean derived data"
    rm -rf "${DERIVED_PATH}"
    exit
    xcodebuild -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" -configuration $CONFIGURATION clean
fi

if [[ $BUILD_NUMBER != "" ]]; then
  /usr/libexec/PlistBuddy -c "Set CFBundleVersion ${BUILD_NUMBER}" ./${PROJECT_NAME}/Info.plist # -c "Print"
fi

xcodebuild archive -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" -archivePath "${OUTPUT_PATH}/${OUTPUT_NAME}.xcarchive" -configuration $CONFIGURATION -derivedDataPath ${DERIVED_PATH} archive DEBUG_INFORMATION_FORMAT=dwarf-with-dsym CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" PROVISIONING_PROFILE="$PROVISIONING_PROFILE"

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
    <string>development</string>
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


xcodebuild -exportArchive -archivePath "${OUTPUT_PATH}/${OUTPUT_NAME}.xcarchive" -exportPath "${OUTPUT_PATH}" -exportOptionsPlist $ExportOptionsPlist
mv ${OUTPUT_PATH}/*.ipa ${OUTPUT_PATH}/${OUTPUT_NAME}.ipa

pushd ${OUTPUT_PATH}
zip -r ${OUTPUT_NAME}.xcarchive.zip ${OUTPUT_NAME}.xcarchive
rm -rf ${OUTPUT_NAME}.xcarchive
popd

