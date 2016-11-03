local config = {
 id = "http://data.marine.ie/fluorometer/WetLabs-ECO-FLNTU/",
 cassandra = {
   cql =  "select * from fluorometer where instrument_id='WL-ECO-FLNTU-3137' and time > ? and time <= ? limit 5000 ALLOW FILTERING",
   cql_latest = "select * from fluorometer where instrument_id='WL-ECO-FLNTU-3137' order by time desc limit 1"
   
 },
 properties = {
  ["vocab.nerc.ac.uk/collection/P01/current/FCNTRW01/"] = {
    id = "CHLCount",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P01/current/FCNTRW01/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0215/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/UUUU/",
    value = function(data) return data["chl_count"] end
   },
   ["vocab.nerc.ac.uk/collection/P01/current/NVLTOBS1/"] = {
    id = "TurbCount",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P01/current/NVLTOBS1/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0215/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/UUUU/",
    value = function(data) return data["ntu_count"] end
   },
   ["vocab.nerc.ac.uk/collection/P01/current/CPHLPR01/"] = {
    id = "CHLConcentration",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P01/current/CPHLPR01/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0215/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/UGPL/",
    value = function(data)
          return  math.floor(0.0181 * (data["chl_count"]-49.0)*10000+0.5)/10000
    end
   },
   ["vocab.nerc.ac.uk/collection/P01/current/TURBXXXX/"] = {
    id = "Turbidity",
    observedProperty = "http://vocab.nerc.ac.uk/collection/P01/current/TURBXXXX/",
    procedure = "http://vocab.nerc.ac.uk/collection/L22/current/TOOL0215/",
    uom = "http://vocab.nerc.ac.uk/collection/P06/current/USTU/",
    value = function(data)
          return  math.floor(0.0483 * (data["ntu_count"]-50.0)*10000+0.5)/10000
    end
   }
 }
}

return config
