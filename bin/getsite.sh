#!/bin/sh
DATA_DIR="/home/dmuser/sites/spiddal.marine.ie/html/data"
FILE_DATE=$(date '+%Y%m%d')
for SITE in spidvid.cloudapp.net
do 
   FNAME="${SITE}_${FILE_DATE}.txt"
   DIR_DATE=$(date '+%Y/%m/')
   ARCHIVE="${DATA_DIR}/$SITE/$DIR_DATE"
   mkdir -p $ARCHIVE
   JSON="${DATA_DIR}/${SITE}.json"
   STATUS=$(curl -s ${SITE}/nginx_status)
   echo "$STATUS"| python -c 'import json,sys,datetime; data=sys.stdin.read(); connections=int(data.split()[2]); print json.dumps({"timestamp": datetime.datetime.utcnow().isoformat()[:-3]+"Z", "connections": connections, "data": data})' > ${JSON}.new && mv ${JSON}.new $JSON && cat $JSON >> $ARCHIVE/$FNAME
   # echo $STATUS | grep Active | awk '{"TZ=0 date +%FT%TZ"| getline date; printf "{ \"timestamp\": \"%s\", \"connections\": %s, \"status\": \"%s\" }\n", date,$3,ENVIRON["JSON_STATUS"]}' > ${JSON}.new && mv ${JSON}.new $JSON && cat $JSON >> $ARCHIVE/$FNAME
done
