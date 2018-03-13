import datetime
import os
import sys
import json
from threading import Thread
from time import time as now, sleep
from BaseHTTPServer import HTTPServer
from BaseHTTPServer import BaseHTTPRequestHandler

class WebServer(Thread):

    def __init__(self,http_port):
        super(WebServer,self).__init__()
        self.status = "No messages yet"
        self.http_port = http_port
        self.last_update = 0

    def update(self,status):
        self.status = status
        self.last_update = now()

    def run(self):
        ws = self
        class ShowLineRequestHandler (BaseHTTPRequestHandler) :
            def do_GET(self) :
                result = {"message": ws.status, "seconds_since_updated": now() - ws.last_update}
                self.send_response(200)
                self.send_header("Access-Control-Allow-Origin", "*")
                self.send_header("Content-type", "text/plain")
                self.wfile.write("\n")
                #self.wfile.write(ws.status)
                self.wfile.write(json.dumps(result))
                self.wfile.write("\n")

        server = HTTPServer(("", self.http_port), ShowLineRequestHandler)
        server.serve_forever()


class KillerMonitor(Thread):
    def __init__(self,timeout):
        super(KillerMonitor,self).__init__()
        self.timeout = int(timeout)
        self.expected = now() + self.timeout

    def ping(self):
        self.expected = now() + self.timeout

    def run(self):
        while 1:
            sleep(self.expected - now())
            if now() > self.expected:
                message = "WARNING: Message not processed for {0} seconds, giving up\n".format(self.timeout)
                sys.stderr.write(message)
                os.kill(os.getpid(),9)

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

