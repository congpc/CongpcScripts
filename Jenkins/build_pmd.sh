#!/bin/sh

#  XCode 7.3
#
#  Created by Pham Chi Cong on 6/8/16.
#

# Generate PMD reporter using OCLint 0.10.2 and Xcpretty
PROJECT_TYPE=$1
PROJECT_PATH=$2
SCHEME_NAME=$3
REPORT_NAME=$4
REPORT_PATH=$5

#Get current directory
CURRENT_DIRECTORY=$(pwd)

if [ -z $REPORT_NAME ]; then
    if [ $PROJECT_TYPE == "swift" ]; then
        REPORT_NAME="pmd.html"
    else
        REPORT_NAME="pmd.xml"
    fi
fi

if [ -z $REPORT_PATH ]; then
    REPORT_PATH="$CURRENT_DIRECTORY/build/pmd/"
fi

if [ $PROJECT_TYPE == "swift" ]; then
    echo "Running tailor"
    tailor -f html ${PROJECT_PATH} > "$REPORT_PATH$REPORT_NAME"
elif [ $PROJECT_TYPE == "workspace" ]; then
    echo "Running workspace"
    xcodebuild clean -workspace ${PROJECT_PATH} -scheme ${SCHEME_NAME} -configuration Debug ENABLE_BITCODE=NO
    # Step 1: Create xcodebuild.log
    #set -o pipefail &&
    xcodebuild build -workspace ${PROJECT_PATH} -scheme ${SCHEME_NAME} -configuration Debug CLANG_ENABLE_MODULE_DEBUGGING=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO ENABLE_BITCODE=NO | tee xcodebuild.log | xcpretty -r json-compilation-database --output compile_commands.json

    # Step 2: Create pmd_oclint.xml
    oclint-json-compilation-database -- -max-priority-1 '10' -max-priority-2 '2000' -max-priority-3 '5000' -report-type pmd -o ${REPORT_NAME}
    #Move file "pmd.xml" to expected folder
    mv ${REPORT_NAME} ${REPORT_PATH}
    #Remove build files
    rm -f xcodebuild.log
    rm -f compile_commands.json

else
    echo "Running project"
    xcodebuild clean -project ${PROJECT_PATH} -scheme ${SCHEME_NAME} -configuration Debug ENABLE_BITCODE=NO
    # Step 1: Create xcodebuild.log
    #set -o pipefail &&
    xcodebuild build -project ${PROJECT_PATH} -scheme ${SCHEME_NAME} -configuration Debug CLANG_ENABLE_MODULE_DEBUGGING=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO ENABLE_BITCODE=NO | tee xcodebuild.log | xcpretty -r json-compilation-database --output compile_commands.json

    # Step 2: Create pmd_oclint.xml
    oclint-json-compilation-database -- -max-priority-1 '10' -max-priority-2 '2000' -max-priority-3 '5000' -report-type pmd -o ${REPORT_NAME}
    #Move file "pmd.xml" to expected folder
    mv ${REPORT_NAME} ${REPORT_PATH}
    #Remove build files
    rm -f xcodebuild.log
    rm -f compile_commands.json
fi

