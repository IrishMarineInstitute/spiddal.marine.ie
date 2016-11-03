local ping_urls = {}
function ping_urls.translate(path)
  local wanted = path:gsub("%/ping/","")
  local map = {
    thredds = "http://milas.marine.ie/thredds/",
    cluster = "http://10.11.0.74/"
 }
 return map[wanted]
end
return ping_urls
