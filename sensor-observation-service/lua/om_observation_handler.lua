local omts = require("om_offering_config")

ngx.header["Content-Type"] = "text/plain"
--ngx.header.content_type = 'application/json'
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
local query = offering["cassandra"]["cql_latest"]

local cassandra = require "cassandra"
local cassandra_session = cassandra.new({host="172.17.1.113", keyspace="das"})
cassandra_session:settimeout(5000) -- 5 second timeout
local connected, err = cassandra_session:connect();


local rows, err = cassandra_session:execute(query) 
if err then
  ngx.say(err.message)
  ngx.exit(500)
end
local data = rows[1]
local t = os.date("!%Y-%m-%dT%T",data['time']/1000)
local s = string.format("%03d",data['time']%1000)
local timestamp =  t .. "." .. s .. "Z"

local om = {}
om['id'] = offering['id'] .. string.gsub(timestamp,'[^0-9]','')
om['featureOfInterest'] = {}
om['featureOfInterest']['href'] = 'http://example.marine.ie/feature/galwayBayCableObservatory'
om['phenomenonTime'] = {}
om['phenomenonTime']['instant'] = timestamp
om['member'] = {}

for k,property in pairs(offering["properties"]) do
    local measurement = {}
    measurement['id'] = property.id
    measurement['type'] = 'Measurement'
    measurement['resultTime'] = timestamp
    measurement['result'] = {}
    measurement['result']['value'] = property.value(data)
    measurement['result']['uom'] = property.uom
    measurement['procedure'] = {}
    measurement['procedure']['href'] = property.procedure
    measurement['observedProperty'] = {}
    measurement['observedProperty']['href'] = property.observedProperty
    table.insert(om['member'],measurement)
end
cassandra_session:close()

local JSON = require('JSON')
ngx.print(JSON:encode_pretty(om))

