#
#  gm_write_image_info.sh
#
#  Created by Pham Chi Cong on 08/17/16 (MM/DD/YY).
#  Copyright (c) 2016 @congpc.ios . All rights reserved.
#

# Using GraphicMagic http://www.graphicsmagick.org/
# input and run script: ./gm_write_image_info.sh filename.jpg
# output: filename_info.txt

FILE=$1
FILE_NAME="${FILE%.*}"
INFO_NAME=$FILE_NAME'_info.txt'

gm identify -verbose ${FILE} > ${INFO_NAME}