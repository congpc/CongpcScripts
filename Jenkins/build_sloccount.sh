#!/bin/sh

#  XCode 7.3
#
#  Created by Pham Chi Cong on 6/8/16.
#

# Generate sloccount reporter
PROJECT_PATH=$1
EXPORT_PATH=$2

if [ -z $PROJECT_PATH ]; then
echo "Project path is not empty!"
else
if [ -z $EXPORT_PATH ]; then
EXPORT_PATH="build/sloccount/sloccount.xml"
fi
echo $PROJECT_PATH
echo $EXPORT_PATH

cloc --by-file --xml --out=$EXPORT_PATH $PROJECT_PATH
fi