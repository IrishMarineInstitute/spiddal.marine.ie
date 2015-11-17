#!/bin/sh
. $(dirname $0)/device_files.sh

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
