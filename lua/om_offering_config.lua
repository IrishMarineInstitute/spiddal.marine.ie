local om = {}
om.supportsVersion = function(self,version)
  local supported = { ["1.0.0"] = true }
  return supported[version] ~= nill and supported[version]
end
om.supportsRequest = function(self,request)
  return request == "GetObservation"
end
om.hasOffering = function(self,offering)
  return self:offering(offering) ~= nil
end
om.offering = function(self,wanted)
  local offerings = {}
  offerings["ie.marine.data:instrument:wetlabs.ecoflntu.3137"] = function() return require("wetlabs_ecoflntu_3137") end
  offerings["ie.marine.data:idronaut.oceanseven.304.XXXX"] = function() return require("idronaut_oceanseven_304_XXXX") end
  local func = offerings[wanted]
  if func == nil then return nil end
  return func()
end
return om 
