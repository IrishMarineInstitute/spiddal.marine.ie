#!/bin/sh
DATA_DIR="/home/dmuser/sites/spiddal.marine.ie/html/data"
TAR_TYPES="hydrophones"
CAT_TYPES="ctds fluorometers acoustic_telemetry"
hydrophones="SBF1323"
ctds="I-OCEAN7-304-XXXX"
fluorometers="WL-ECO-FLNTU-3137"
accoustic_telemetry="VMVR2C450117"
DIR_DATE=$(date -d "yesterday 13:00 " '+%Y/%m/%d')
FILE_DATE=$(date -d "yesterday 13:00 " '+%Y%m%d')
for TYPE in $(echo $TAR_TYPES);
  do for DEVICE in $(eval echo \$${TYPE});
   do FNAME=${DEVICE}_${FILE_DATE};
     cd $DATA_DIR/$TYPE/$DEVICE/$DIR_DATE && tar cfz ${FNAME}.tgz *.txt && zip  -q ${FNAME}  *.txt
  done
done
for TYPE in $(echo $CAT_TYPES);
  do for DEVICE in $(eval echo \$${TYPE});
   do FNAME=${DEVICE}_${FILE_DATE};
     cd $DATA_DIR/$TYPE/$DEVICE/$DIR_DATE && rm -f ${FNAME}.txt && cat *.txt > ${FNAME}.txt
  done
done
