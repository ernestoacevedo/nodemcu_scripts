wifi.setmode(wifi.STATION)
if wifi.sta.getip() == nil then
    print("Connecting to AP...\n")
    if file.open("password.txt",r) then
        local username=file.readline();
        local password=file.readline();
        file.close();
        username=string.sub(username,1,#username-1);
        password=string.sub(password,1,#password-1);
        wifi.sta.config(username,password);
    else
        print("[Cannot open password.txt]");
    end
else
  ip, nm, gw=wifi.sta.getip()
  print("IP Address: ",ip)
  print("Netmask: ",nm)
  print("Gateway Addr: ",gw,'\n')
end


tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("[IP unavaiable, waiting.]")
    else
        tmr.stop(1)
        print("[Connected, IP is "..wifi.sta.getip().."]");
    end
end)


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
