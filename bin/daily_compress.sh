#!/bin/sh
DATA_DIR="/home/dmuser/sites/spiddal.marine.ie/html/data"
TAR_TYPES="hydrophones"
CAT_TYPES="ctds fluorometers acoustic_telemetry adcps"
hydrophones="SBF1323"
ctds="I-OCEAN7-304-XXXX"
fluorometers="WL-ECO-FLNTU-3137"
accoustic_telemetry="VMVR2C450117"
adcps="TRDI-WHB600Hz-1323"
# file extensions
ext_hydrophones=.txt
ext_ctds=.txt
ext_fluorometers=.txt
ext_accoustic_telemetry=.txt
ext_adcps=.pd0

DIR_DATE=$(date -d "yesterday 13:00 " '+%Y/%m/%d')
FILE_DATE=$(date -d "yesterday 13:00 " '+%Y%m%d')
for TYPE in $(echo $TAR_TYPES);
  do 
   EXT=$(eval echo \$ext_${TYPE})
   for DEVICE in $(eval echo \$${TYPE});
   do FNAME=${DEVICE}_${FILE_DATE};
     cd $DATA_DIR/$TYPE/$DEVICE/$DIR_DATE && tar cfz ${FNAME}.tgz *${EXT} && zip  -q ${FNAME}  *${EXT}
  done
done
for TYPE in $(echo $CAT_TYPES);
  do 
   EXT=$(eval echo \$ext_${TYPE})
   for DEVICE in $(eval echo \$${TYPE});
   do FNAME=${DEVICE}_${FILE_DATE};
     cd $DATA_DIR/$TYPE/$DEVICE/$DIR_DATE && rm -f ${FNAME}${EXT} && cat *${EXT} > ${FNAME}${EXT}
  done
done
