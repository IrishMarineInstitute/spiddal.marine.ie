#!/bin/env python
from datetime import datetime, timedelta
import dateutil.parser
from pykafka import KafkaClient
from pykafka.cli.kafka_tools import fetch_offsets
import os
import re
import shutil
import json
import sys
if len(sys.argv) != 2:
   sys.exit("Usage:{0} <TOPIC-NAME>".format(sys.argv[0]))
   
topic_name=sys.argv[1]
sample_seconds = 60*60*24;
topic_file =  '/data/{0}-sample.json'.format(topic_name)
topic_file_tmp =  '/data/{0}-sample.json.tmp'.format(topic_name)
pattern = re.compile("^\s*\d.*$")
yesterday_timestamp = (datetime.utcnow() - timedelta(days=2)).isoformat()[:-7]
client = KafkaClient(hosts="kafka01:9092,kafka02:9092,kafka03:9092")
topic = client.topics[topic_name];
consumer = topic.get_simple_consumer()

yesterday = dateutil.parser.parse(yesterday_timestamp+"Z")
epoch = dateutil.parser.parse("1970-01-01T00:00:00.000Z")
offsets = fetch_offsets(client,topic,yesterday_timestamp)
reset_offsets = [(topic.partitions[i], offsets[i].offset[0]) for i in offsets];
consumer.reset_offsets(reset_offsets);
wanted = []
latest_ts = yesterday
for message in consumer:
  if message is not None:
      (ts,dev,data) = message.value.split('|',3)
      if not pattern.match(data):
         continue
      try:
        ts = dateutil.parser.parse(ts)
      except:
        continue
      delta = ts-latest_ts;
      if (ts.minute == 0 and ((ts.second == 0 and delta.total_seconds() >= 1) or delta.total_seconds() > 60))  or delta.total_seconds() >= 600:
        latest_ts = ts
        wanted.append(message.value)
        (ts,dev,data) = wanted[0].split('|',3)
        ts = dateutil.parser.parse(ts)
        delta = latest_ts - ts;
        #purge old data
        while delta.total_seconds() > sample_seconds:
           wanted = wanted[1:]
           (ts,dev,data) = wanted[0].split('|',3)
           ts = dateutil.parser.parse(ts)
           delta = latest_ts - ts;

        with open(topic_file_tmp, 'w') as outfile:
           json.dump({"data": wanted}, outfile)
        shutil.move(topic_file_tmp, topic_file)
        os.chmod(topic_file,420)
           
