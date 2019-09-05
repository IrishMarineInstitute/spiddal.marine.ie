#!/bin/sh
. $(dirname $0)/device_files.sh

# tar cvfz /tmp/fred.tgz */I-OCEAN7-304-XXXX_201510??.txt --transform 's#.*/##g'
# zip -j

MONTH_DATE=$(date -d "-1 month" '+%Y/%m')
FILE_DATE=$(date -d "-1 month" '+%Y%m')
for TYPE in $(echo $TAR_TYPES);
  do 
   EXT=$(eval echo \$ext_${TYPE})
   for DEVICE in $(ls -1 $DATA_DIR/$TYPE/);
   do FNAME=${DEVICE}_${FILE_DATE};
     cd $DATA_DIR/$TYPE/$DEVICE/ && tar cfz ${FNAME}.tgz ${MONTH_DATE}/*/*.tgz --transform 's#.*/##g' && zip  -q -j ${FNAME} ${MONTH_DATE}/*/*.zip
  done
done
for TYPE in $(echo $CAT_TYPES);
  do 
   EXT=$(eval echo \$ext_${TYPE})
   for DEVICE in $(ls -1 $DATA_DIR/$TYPE/);
   do FNAME=${DEVICE}_${FILE_DATE};
     cd $DATA_DIR/$TYPE/$DEVICE/ && tar cfz ${FNAME}.tgz ${MONTH_DATE}/*/${DEVICE}_????????${EXT} --transform 's#.*/##g' && zip -q -j ${FNAME} ${MONTH_DATE}/*/${DEVICE}_????????${EXT}
  done
done
for TYPE in $(echo $MONTHLY_CAT_TYPES);
  do 
   EXT=$(eval echo \$ext_${TYPE})
   for DEVICE in $(ls -1 $DATA_DIR/$TYPE/);
   do FNAME=${DEVICE}_${FILE_DATE};
     cd $DATA_DIR/$TYPE/$DEVICE/ && rm -f ${FNAME}${EXT} && cat ${MONTH_DATE}/*/${DEVICE}_????????${EXT} > ${FNAME}${EXT}
  done
done
