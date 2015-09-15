#!/bin/sh
# According to this pdf 
# 
# \\galwayfs03\public\cabledObsSoftware\software\wetlabsEcofl\FLNTUS-3137_(CHL-NTU)CharSheet.pdf 
# Should be:
# 
# Chlorophyl (micrograms /litre)
# 
# = 0.0181 *(CHL Output - 49)
# 
# Nephelometric Turbidity Unit (NTU)
# 
# = 0.0483 * (NTU Output - 50)
# 
# Probably best to round to 4 decimal places to the right of the decimal point (this is what it shows on “Record ENG”)
# 
# 
# Damian Smyth
# Platform Specialist
# Marine Institute
# Rinville
# Oranmore, Galway
# Ireland

nc -d 172.16.255.5 951 | head -n 1 | python -c 'import sys,json,datetime; timestamp = datetime.datetime.utcnow().isoformat()[:-3]+"Z"; [Date,Time,Fluorescence,CHL,Turbidity,NTU,Thermistor] = sys.stdin.readline().split(); CHLCount=int(CHL); NTUCount=int(NTU); CHL = round(0.0181 * (float(CHL)-49.0),4); NTU = round(0.0483*(float(NTU) - 50.0),4); print json.dumps({"Date": Date, "Time": Time, "FluorescenceWavelength": int(Fluorescence), "CHL": CHL, "TurbidityWavelength": int(Turbidity), "NTU": NTU, "Thermistor": int(Thermistor), "CHLCount": CHLCount, "NTUCount": NTUCount, "Timestamp": timestamp})' > /home/dmuser/sites/spiddal.marine.ie/html/data/spiddal-fluorometer.json.new && mv /home/dmuser/sites/spiddal.marine.ie/html/data/spiddal-fluorometer.json.new /home/dmuser/sites/spiddal.marine.ie/html/data/spiddal-fluorometer.json
