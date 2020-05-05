#!/usr/bin/env python
import sys
from pykafka import KafkaClient
from pykafka.common import OffsetType
import datetime
import sys
import time
import os
from midas import WebServer, KillerMonitor, is_number
import argparse

parser = argparse.ArgumentParser(description='Stream ais data from kafka to a file.')
parser.add_argument('--timeout', type=int, default=300, help='Number of seconds to wait for messages before giving up, default=300 (5 minutes)')
parser.add_argument('--http-port', type=int, default=8082, help='HTTP web server port showing latest message, default is 8082')
parser.add_argument('--verbose', type=bool, default=False, help='Whether to write to the console')
parser.add_argument('--topic', default="ais-rinville-1", help='Name of the kafka topic containing the messages')
parser.add_argument('--group', default="ais2file_v1", help='Name of the kafka consumer group');
args = parser.parse_args()

client = KafkaClient(hosts="dmkaf01:9092,dmkaf02:9092,dmkaf03:9092")
topic = client.topics[args.topic]
consumer = topic.get_simple_consumer(auto_commit_enable=True,
                                     consumer_group=args.group,
                                     auto_offset_reset=OffsetType.EARLIEST,
                                     reset_offset_on_start=False)

sys.stderr.write("connected to kafka\n")

killer = KillerMonitor(args.timeout)
killer.setDaemon(True)
killer.start()
sys.stderr.write("Monitor will kill application if unable to process a message for %d seconds\n" % args.timeout)

webserver = WebServer(args.http_port)
webserver.setDaemon(True)
webserver.start()
sys.stderr.write("Web server running on port %d\n" % args.http_port)

if args.verbose:
    sys.stdout.write("\n")
oldtime = time.time()
file_path = None
f_all = None
for message in consumer:
   if message is not None:
        (timestamp,source,data) = message.value.split('|',3)
        if source.startswith("20"): # wrong order on some early belmullet
          tmp = timestamp
          timestamp = source
          source = tmp
        if(data.startswith("!AIVDM")):
            new_file_path = "/data/ais/{0}/{1}/{0}-{2}.txt".format(source,timestamp[:4],timestamp[:7])
            if new_file_path != file_path:
               if f_all:
                 f_all.close()
               file_path = new_file_path
               if not os.path.exists(os.path.dirname(file_path)):
                  os.mkdir(os.path.dirname(file_path))
               f_all = open(file_path,'a')
            f_all.write("{0}\n".format(message.value))
            killer.ping()
            webserver.update(message.value)
            if args.verbose:
                sys.stdout.write(message.value)
                sys.stdout.flush()
