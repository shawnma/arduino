local my = {}

function my.setup_wifi(callback)
    wifi.setmode(wifi.STATION)
    if file.open('passwd','r') then
        pw = file.readline()
        file.close()
    else
        error('no password to wifi found')
    end
    wifi.sta.config("milkyway",pw:gsub('\n',''))
--    wifi.sta.autoconnect(1)
--    wifi.sta.connect()
    tmr.alarm(0, 1000, 1, function()
        local ip, _, _ = wifi.sta.getip() 
            if ip == nil then
            print("Connecting to AP...")
            else
                print('IP: ', ip)
                tmr.stop(0)
            if callback ~= nil then callback(ip) end
        end
    end)
end

function my.create_server(port, line_callback)
    srv=net.createServer(net.TCP)
    srv:listen(port, function(conn)
        conn:on("receive", function(client,request)
            line_callback(request)
        end)
    end)
end

return my
