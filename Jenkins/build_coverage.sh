#!/bin/sh

#  XCode 7.3
#
#  Created by Pham Chi Cong on 6/8/16.
#

#Run Test and gerenate junit report
PROJECT_TYPE=$1
PROJECT_PATH=$2
SCHEME_NAME=$3
HTML_REPORT_PATH=$4
COBERTURA_REPORT_PATH=$5
JUNIT_REPORT_PATH=$6
#platform=iOS Simulator,name=iPad 2
TEST_DEVICE=$7

#Build and report paths
# Default values
if [ -z $HTML_REPORT_PATH ]; then
    HTML_REPORT_PATH="build/coverage/$SCHEME_NAME/"
fi

if [ -z $COBERTURA_REPORT_PATH ]; then
    COBERTURA_REPORT_PATH="build/coverage/xml/coverage.xml"
fi

if [ -z $JUNIT_REPORT_PATH ]; then
    JUNIT_REPORT_PATH="build/junit/junit_result.xml"
fi

if [ -z $TEST_DEVICE ]; then
    echo “Used default device”
    TEST_DEVICE="platform=iOS Simulator,name=iPad Air"
fi

CURRENT_DIRECTORY=$(pwd)
BUILD_DIR=$CURRENT_DIRECTORY/coverage_build


echo "Using scheme: ${SCHEME_NAME}"
echo "Using device: ${TEST_DEVICE}"

#Run unit test
#-destination '${TEST_DEVICE}'
#-sdk iphonesimulator
if [ $PROJECT_TYPE == "workspace" ]; then
echo "Running workspace"

xcodebuild test \
-workspace $PROJECT_PATH \
-scheme ${SCHEME_NAME} \
-destination "$TEST_DEVICE" \
-configuration Debug \
CONFIGURATION_BUILD_DIR=${BUILD_DIR} \
OBJROOT=${BUILD_DIR} \
GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
GCC_GENERATE_TEST_COVERAGE_FILES=YES \
GCC_PREPROCESSOR_DEFINITIONS="\$(GCC_PREPROCESSOR_DEFINITIONS) ENABLE_GCOV_FLUSH=1" | xcpretty -c --report junit --output ${JUNIT_REPORT_PATH}

else
echo "Running project"
xcodebuild test \
-project $PROJECT_PATH \
-scheme ${SCHEME_NAME} \
-destination "$TEST_DEVICE" \
-configuration Debug \
CONFIGURATION_BUILD_DIR=${BUILD_DIR} \
OBJROOT=${BUILD_DIR} \
ENABLE_BITCODE=NO \
GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
GCC_GENERATE_TEST_COVERAGE_FILES=YES \
GCC_PREPROCESSOR_DEFINITIONS="\$(GCC_PREPROCESSOR_DEFINITIONS) ENABLE_GCOV_FLUSH=1" | xcpretty -c --report junit --output ${JUNIT_REPORT_PATH}

fi


#Run GCOVR
GCOV_FILTER=".*"
INJECTIONS_DIR=Injections
GCOV_EXCLUDE="(.*./Developer/SDKs/.*)|(.*./Developer/Toolchains/.*)|(.*TestsTests\.m)|(.*TestsTests/.*)|(${INJECTIONS_DIR}/.*)|(Libraries.*)|(.*UnitTests/.*)|(.*AcceptanceTests/.*)"

gcovr \
--filter="${GCOV_FILTER}" \
--exclude="${GCOV_EXCLUDE}" \
--object-directory=${BUILD_DIR} -x > ${COBERTURA_REPORT_PATH}

#Run lcov
LCOV_INFO=coverage.info
INJECTIONS_DIR=Injections
LCOV_EXCLUDE="*/Xcode.app/Contents/Developer/* *Tests.m *TestsTests/* *UnitTests/* *AcceptanceTests/* ${INJECTIONS_DIR}/* Libraries/* Resources/* ${BUILD_DIR}/* Scripts/* Configurations/*"
# LCOV_EXCLUDE="'*/Xcode.app/Contents/Developer/*' '*Tests.m' '*UnitTests/*' '*AcceptanceTests/*' '$(INJECTIONS_DIR)/*' 'Libraries/*' 'Resources/*' '$(BUILD_DIR)/*' '$(TEST_BUILD_DIR)/*' 'Scripts/*' 'Configurations/*'"

lcov --capture --directory ${BUILD_DIR} --output-file ${LCOV_INFO}
lcov --remove ${LCOV_INFO} ${LCOV_EXCLUDE} --output-file ${LCOV_INFO}
genhtml ${LCOV_INFO} --output-directory ${HTML_REPORT_PATH}

rm -rf coverage_build
rm -f coverage.info
