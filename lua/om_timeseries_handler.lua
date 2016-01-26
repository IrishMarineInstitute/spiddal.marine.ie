local cassandra = require "cassandra"
local cassandra_session = cassandra.new()
cassandra_session:set_timeout(5000) -- 5 second timeout
local connected, err = cassandra_session:connect("172.17.1.89",9042);
cassandra_session:set_keyspace("das")

local helper = require("om_timeseries_helper")
local omts = require("om_offering_config")

ngx.header["Content-Type"] = "text/plain"
if ngx.var.arg_ACCEPTVERSIONS ~= nil and 
   not omts:supportsVersion(ngx.var.arg_ACCEPTVERSIONS) then
     ngx.say("The requested ACCEPTVERSIONS is not supported") 
     ngx.exit(412)
end
if not omts:hasOffering(ngx.var.arg_OFFERING) then
     ngx.say("Requested OFFERING not found") 
     ngx.exit(404)
end
local offering = omts:offering(ngx.var.arg_OFFERING)
if ngx.var.arg_observedProperty == nil then
     ngx.say("observedProperty parameter is required. Allowable values are:") 
     for k in pairs(offering["properties"]) do ngx.say(k) end
     ngx.exit(412)
end
local observedProperty = offering["properties"][ngx.var.arg_observedProperty]

if observedProperty == nil then
     ngx.say("Requested observedProperty not found on the OFFERING. Allowable values are:") 
     for k in pairs(offering["properties"]) do ngx.say(k) end
     ngx.exit(404)
end

local now = helper:now()
local an_hour_ago = now - (60*60*1000)

local starttime,endtime = helper:splitEventTime(ngx.var.arg_EVENTTIME,helper:isodate(an_hour_ago), helper:isodate(now))

local query = offering["cassandra"]["cql"]
local query_params = {{type="timestamp", value=helper:makeTimeStamp(starttime)},
                      {type="timestamp", value=helper:makeTimeStamp(endtime)}}

local rows, err = cassandra_session:execute(query, query_params, {page_size = 1000}) 
if err then
  ngx.say(err.message)
  ngx.exit(500)
end
helper:say_json_top(offering,observedProperty)
if rows then
  local result = helper:say_json_point(rows,observedProperty,"")
  starttime = result["start_time"] or starttime
  endtime = result["end_time"] or endtime
  while rows and rows.meta.has_more_pages do
    rows, err = cassandra_session:execute(query, query_params, {paging_state = rows.meta.paging_state})
    if rows then
      result = helper:say_json_point(rows,observedProperty,",")
      endtime = result["end_time"] or endtime
    end
  end
end

helper:say_json_bottom(starttime,endtime)
cassandra_session:set_keepalive(5000, 2)
--ecassandra_session:close()
