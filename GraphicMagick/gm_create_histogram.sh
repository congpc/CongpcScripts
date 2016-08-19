#
#  gm_create_histogram.sh
#
#  Created by Pham Chi Cong on 08/18/16 (MM/DD/YY).
#  Copyright (c) 2016 @congpc.ios . All rights reserved.
#

# Using GraphicMagic http://www.graphicsmagick.org/
# input and run script: ./gm_create_histogram.sh filename.jpg
# output: filename_info.txt

FILE=$1
FILE_NAME="${FILE%.*}"
TEXT_OUTPUT_NAME=$FILE_NAME'_histogram.txt'
IMAGE_OUTPUT_NAME=$FILE_NAME'_histogram.gif'

# convert to output by text
gm convert ${FILE} -define histogram:unique-colors=false histogram:$TEXT_OUTPUT_NAME

# convert to output by image
gm convert ${FILE} -define histogram:unique-colors=false histogram:histogram.gif
gm convert histogram.gif -strip $IMAGE_OUTPUT_NAME

# remove temp file
rm -rf histogram.gif