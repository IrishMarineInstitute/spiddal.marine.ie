local config = {
 id = "http://data.marine.ie/ctd/Idronaut/3137/",
 cassandra = {
   cql =  "select * from ctd where instrument_id='I-OCEAN7-304-XXXX' and time > ? and time <= ? limit 5000 ALLOW FILTERING",
   cql_latest = "select * from ctd where instrument_id='I-OCEAN7-304-XXXX' order by time desc limit 1"
 },
 properties = {
  ["vocab.nerc.ac.uk/collection/P01/current/TEMPPR01/"] = {
    id = "Temp",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P01/current/TEMPPR01/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0861/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/UPAA/",
    value = function(data) return data["temp"] end
   },
   ["vocab.nerc.ac.uk/collection/P01/current/PSALCU01/"] = {
    id = "Sal",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P01/current/PSALCU01/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0861/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/UUUU/",
    value = function(data) return data["sal"] end
   },
   ["vocab.nerc.ac.uk/collection/P07/current/CFSN0330/"] = {
    id = "Press",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P07/current/CFSN0330/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0861/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/UPDB/",
    value = function(data) return data["press"] end
   },
   ["vocab.nerc.ac.uk/collection/P01/current/SVELCV01/"] = {
    id = "SoundV",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P01/current/SVELCV01/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0861/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/UVAA/",
    value = function(data) return data["soundv"] end
   },
   ["vocab.nerc.ac.uk/collection/P01/current/CNDST01/"] = {
    id = "Cond",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P01/current/CNDCST01/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0861/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/UECA/",
    value = function(data) return data["cond"] end
   }
 }
}

return config
