local socket = require("socket")
local helpers = {
  ["isodate"] = function(self,time)
    local t = os.date("!%Y-%m-%dT%T",time/1000)
    local s = string.format("%03d",time%1000)
    return t .. "." .. s .. "Z"
  end,
  ["now"] = function()
         return socket.gettime()*1000
  end,
  ["makeTimeStamp"] =  function(self,dateString, mode)
    local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%p])(%d*)%:?(%d*)";
    local xyear, xmonth, xday, xhour, xminute, xseconds, xoffset, xoffsethour, xoffsetmin
    local monthLookup = {Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12}
    local convertedTimestamp
    local offset = 0
    if mode and mode == "ctime" then
        pattern = "%w+%s+(%w+)%s+(%d+)%s+(%d+)%:(%d+)%:(%d+)%s+(%w+)%s+(%d+)"
        local monthName, TZName
        monthName, xday, xhour, xminute, xseconds, TZName, xyear = string.match(dateString,pattern)
        xmonth = monthLookup[monthName]
        convertedTimestamp = os.time({year = xyear, month = xmonth,
        day = xday, hour = xhour, min = xminute, sec = xseconds})
    else
        xyear, xmonth, xday, xhour, xminute, xseconds, xoffset, xoffsethour, xoffsetmin = string.match(dateString,pattern)
        convertedTimestamp = os.time({year = xyear, month = xmonth,
        day = xday, hour = xhour, min = xminute, sec = xseconds})
        if xoffsetHour then
            offset = xoffsethour * 60 + xoffsetmin
            if xoffset == "-" then
                offset = offset * -1
            end
        end
    end
    -- todo support parsing millis?
    return (convertedTimestamp + offset) * 1000 + (xseconds % 1)* 1000
  end,
 ["say_json_point"] = function(this,d,property,sep)
  local comma = sep
  local start_time = nil
  local end_time = nil
  for i = 1, #d do
    local t = os.date("!%Y-%m-%dT%T",d[i].time/1000)
    local s = string.format("%03d",d[i].time%1000)
    local ts = t .. "." .. s .. "Z"
    ngx.say(comma..'{"time":{"instant":"'
            ..ts..'" },"value":'
            ..property.value(d[i])..'}')
    comma = ','
    start_time = start_time or ts
    end_time = ts
  end
  return { start_time = start_time, end_time = end_time }
  end,
  ["splitEventTime"] =  function(self,eventtime,default_start,default_end)
    local pattern = "(.*)/(.*)"
    local a,b =  string.match(eventtime,pattern)
    if (a == nil or a == '') then
       a = default_start
    end
    if (b == nil or b == '') then
       b = default_end
    end
    return a,b
  end,

  ["say_json_top"] = function(self,offering,property)
   local now = self:isodate(socket.gettime()*1000)
   ngx.say([===[{
  "id":"]===]..offering.id..[===[",
  "type" : "http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_DiscreteTimeSeriesObservation",
  "observedProperty": {"href":"]===]..property.observedProperty..[===["},
  "procedure": {"href":"]===]..property.procedure..[===["},
  "featureOfInterest": {"href":"http://example.marine.ie/feature/galwayBayCableObservatory"},
  "resultTime": "]===]..now..[===[",
  "result": {
    "metadata": {
    },
    "defaultPointMetadata": {
      "interpolationType": {
        "href": "http://www.opengis.net/def/waterml/2.0/interpolationType/Continuous"
      },
      "quality": {
        "href": "http://www.opengis.net/def/waterml/2.0/quality/unchecked"
      },
      "uom" : "]===]..property.uom..[===["
    },
    "points": [
]===])
  end,
 ["say_json_bottom"] = function(self,start_time,end_time)
ngx.say([===[    ]
  },
  "phenomenonTime": { "begin":"]===]..start_time..[===[", "end":"]===]..end_time..[===[" }
}]===])
end
}
 return helpers
