#!/bin/sh

#  Export ipa file by AdHoc
#  XCode 7.3
#
#  Created by Pham Chi Cong on 6/8/16.
#

PROJECT_TYPE=$1
TARGET_NAME=$2
PROJECT_PATH=$3
INFOPLIST_PATH=$4
#adhoc or enterprise (In-House)
EXPORT_TYPE=$5
MESSAGE_ERROR="Params include: Param 1- Project type,Param 2- Scheme name, Param 3- Project path, Param 4- Info.plist path.\nEx:./scripts/export_adhoc_file_from_project.sh HouseCard HouseCard/HouseCard.xcodeproj HouseCard/HouseCard/Info.plist"

if [ -z $PROJECT_TYPE ]; then
    echo "[Error] Param 1- Project type is empty!"
    echo $MESSAGE_ERROR
elif [ -z $TARGET_NAME ]; then
    echo "[Error] Param 2- Scheme name is empty!"
    echo $MESSAGE_ERROR
elif [ -z $PROJECT_PATH ]; then
    echo "[Error] Param 3- Project path is empty!"
    echo $MESSAGE_ERROR
elif [ -z $INFOPLIST_PATH ]; then
    echo "[Error] Param 4- Info.plist path is empty!"
    echo $MESSAGE_ERROR
else
EXPORT_PATH="build/app"
#echo $TARGET_NAME
NOW="$(date +'%Y-%m-%d')"
#echo $NOW
VERSION_STRING=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${INFOPLIST_PATH}")
#PRODUCT_NAME=$(/usr/libexec/PlistBuddy -c "Print :CFBundleName" "${INFOPLIST_PATH}")
PRODUCT_NAME=$TARGET_NAME
if [ ${PRODUCT_NAME} == "\$(PRODUCT_NAME)" ]; then
    PRODUCT_NAME=${TARGET_NAME}
fi
echo "${EXPORT_PATH}/${PRODUCT_NAME}_${VERSION_STRING}_${NOW}"

if [ $PROJECT_TYPE == "workspace" ]; then
    xcodebuild clean -workspace ${PROJECT_PATH} -scheme ${TARGET_NAME} -configuration Release
    xcodebuild archive -workspace ${PROJECT_PATH} -scheme ${TARGET_NAME} -configuration Release -archivePath "${EXPORT_PATH}/${PRODUCT_NAME}.xcarchive"
else
    xcodebuild clean -project ${PROJECT_PATH} -scheme ${TARGET_NAME} -configuration Release
    xcodebuild archive -project ${PROJECT_PATH} -scheme ${TARGET_NAME} -configuration Release -archivePath "${EXPORT_PATH}/${PRODUCT_NAME}.xcarchive"
fi

#!/bin/bash --login
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
#rvm use system
FULL_EXPORT_PATH="${EXPORT_PATH}/${PRODUCT_NAME}_${VERSION_STRING}_${NOW}"
if [ ${EXPORT_TYPE} == "adhoc" ]; then
    echo "Export IPA by Ad-Hoc"
    xcodebuild -exportArchive -archivePath "${EXPORT_PATH}/${PRODUCT_NAME}.xcarchive" -exportOptionsPlist "/usr/local/bin/exportAdhocPlist.plist" -exportPath $FULL_EXPORT_PATH
else
    echo "Export IPA by In-House"
    xcodebuild -exportArchive -archivePath "${EXPORT_PATH}/${PRODUCT_NAME}.xcarchive" -exportOptionsPlist "/usr/local/bin/exportInHousePlist.plist" -exportPath $FULL_EXPORT_PATH
fi

#copy ipa folder into folder of xampp server
cp -R $FULL_EXPORT_PATH "/Applications/XAMPP/htdocs/iosbuilds"

fi
