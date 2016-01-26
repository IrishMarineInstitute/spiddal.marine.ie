local curl = require("curl")
-- add any allowable ping urls to ping_urls.lua file
local urls = require("ping_urls")
--function helper for result
--taken from luasocket page (MIT-License)
local function build_w_cb(t)
	return function(s,len)
		table.insert(t, s)
	return len,nil
	end
end

--function helper for headers
--taken from luasocket page (MIT-License)
local function h_build_w_cb(t)
	return function(s,len)
		--stores the received data in the table t
		--prepare header data
		name, value = s:match("(.-): (.+)")
		if name and value then
			t.headers[name] = value:gsub("[\n\r]", "")
		else
			code, codemessage = string.match(s, "^HTTP/.* (%d+) (.+)$")
			if code and codemessage then
				t.code = tonumber(code)
				t.codemessage = codemessage:gsub("[\n\r]", "")
			end
		end
	return len,nil
	end
end
url = urls.translate(ngx.var.uri)
response = {headers={}, code=500, content={} }
if url == nil then
  response.content = {"not found:"..ngx.var.uri}
  response.code = 404
else
  c = curl.easy_init()
  c:setopt(curl.OPT_PROXY, "http://10.0.5.55:80")
  c:setopt(curl.OPT_URL, url)
  c:setopt(curl.OPT_WRITEFUNCTION, build_w_cb(response.content))
  c:setopt(curl.OPT_HEADERFUNCTION, h_build_w_cb(response))
  c:setopt(curl.OPT_CONNECTTIMEOUT, 10 )
  c:setopt(curl.OPT_FOLLOWLOCATION, 1)
  c:setopt(curl.OPT_FOLLOWLOCATION, 1)
  c:setopt(curl.OPT_FORBID_REUSE, 1)
  c:perform()
  curl.easy_init(c)
end
ngx.header["Content-Type"] = "text/plain"
ngx.header["Access-Control-Allow-Origin"] = "*"
ngx.header["Cache-Control"] = "no-cache, no-store, must-revalidate"
ngx.header["Pragma"] = "no-cache"
ngx.header["Expires"] = "0"

ngx.status = response.code
ngx.say("{ping='pong', status="..response.code.."}")
ngx.exit(response.code)
