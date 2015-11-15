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
        print("[IP unavailable, waiting.]") 
    else
        tmr.stop(1)
        print("[Connected, IP is "..wifi.sta.getip().."]");
    end
end)

tmr.alarm(2, 1000, 0, function()
    sk=net.createConnection(net.TCP, 0)
    sk:on("receive", function(sck, c) print(c) end )
    sk:connect(3000,"192.168.0.5")
    sk:on("connection", function(sck,c)
        -- Wait for connection before sending.
        sk:send("GET / HTTP/1.1\r\nHost: 192.168.0.5\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
        end)
end)
