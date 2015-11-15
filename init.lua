if wifi.sta.getip() == nil then
  print("Connecting to AP...\n")
else
  ip, nm, gw=wifi.sta.getip()
  print("IP Address: ",ip)
  print("Netmask: ",nm)
  print("Gateway Addr: ",gw,'\n')
end

responseHeader = function(code, type)
    return "HTTP/1.1 " .. code .. "\r\nConnection: close\r\nServer: nunu-Luaweb\r\nContent-Type: " .. type .. "\r\n\r\n"
end

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive",function(conn,request)
    print(request)
    conn:send(responseHeader("200 OK","application/json"))
    conn:send(cjson.encode({status=true}))
  end)
  conn:on("sent",function(conn) conn:close() end)
end)
