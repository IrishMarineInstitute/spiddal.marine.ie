#!/bin/sh
DATA_DIR="/home/dmuser/sites/spiddal.marine.ie/html/data"
TYPES="hydrophones"
hydrophones="SBF1323"
DIR_DATE=$(date -d "yesterday 13:00 " '+%Y/%m/%d')
FILE_DATE=$(date -d "yesterday 13:00 " '+%Y%m%d')
for TYPE in $(echo $TYPES);
  do for DEVICE in $(eval echo \$${TYPE});
   do FNAME=${DEVICE}_${FILE_DATE};
     cd $DATA_DIR/$TYPE/$DEVICE/$DIR_DATE && tar cfz ${FNAME}.tgz *.txt && zip  -q ${FNAME}  *.txt
  done
done
