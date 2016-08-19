#!/bin/sh

#  XCode 7.3
#
#  Created by Pham Chi Cong on 6/8/16.
#

# Generate CPD reporter with pmd.4.2.6 library
#./scripts/build_cpd.sh 20_TTV_output/00_sprint1/00_source/01_iOS/Tickets

PROJECT_PATH=$1
LANGUAGE=$2
EXPORT_PATH=$3

if [ -z $PROJECT_PATH ]; then
    echo "Project path is not empty!"
else

if [ -z $EXPORT_PATH ]; then
    EXPORT_PATH="build/cpd/cpd.xml"
fi

#java -Xmx512m -classpath /usr/local/lib/pmd-4.2.6.jar:/usr/local/lib/ObjCLanguage-0.0.6-SNAPSHOT.jar net.sourceforge.pmd.cpd.CPD --minimum-tokens 100 --language ObjectiveC --encoding UTF-8 --format net.sourceforge.pmd.cpd.XMLRenderer --files ${PROJECT_PATH} > ${EXPORT_PATH}

#pmd 5.4.2 fix build failure when run this script on jenkins: http://stackoverflow.com/questions/22814559/how-when-does-execute-shell-mark-a-build-as-failure-in-jenkins
set +e
/bin/sh -xe /usr/local/pmd-bin-5.4.2/bin/run.sh cpd --minimum-tokens 100 --files ${PROJECT_PATH} --language ${LANGUAGE} --format xml > ${EXPORT_PATH}
set -e
fi