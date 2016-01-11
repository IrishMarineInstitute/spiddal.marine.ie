local om_member_measurement = {}

function om_member_measurement.om_member_measurement(id,value,uom,procedure,obsProp,timestamp)
	local measurement = {}
	measurement['id'] = id
	measurement['type'] = 'Measurement'
	measurement['resultTime'] = timestamp
	measurement['result'] = {}
	measurement['result']['value'] = value
	measurement['result']['uom'] = uom
	measurement['procedure'] = {}
	measurement['procedure']['href'] = procedure
	measurement['observedProperty'] = {}
	measurement['observedProperty']['href'] = obsProp
	return measurement
end

return om_member_measurement