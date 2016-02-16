tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)


function map(val, s, e, ts, te)
    return math.floor((val-s)*(te-ts)/(e-s) + ts)
end

function servo(pin, duty) -- 0 - 127
    pwm.close(pin)
    local d = map(duty,0,127,26,128)
    print ("" .. pin .. "-> " .. d)
    pwm.setup(pin, 50, d)
    pwm.start(pin)
end

HEX_TAB = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'}
function tohex(n)
    return HEX_TAB[bit.rshift(n, 4)+1]..HEX_TAB[bit.band(n, 0xf)+1]
end

srv=net.createServer(net.TCP)
srv:listen(4000,function(conn)
    conn:on("receive", function(client,request)
        --for i=1, #request do
            --print(tohex(string.byte(request, i)))
        --end
        local cmd=string.byte(request,-1)
        local pin = 1
        if bit.isset(cmd, 7) then
            pin = 2
        end
        local duty = bit.band(cmd, 0x7f)
        if duty == 64 then -- full stop
            pwm.close(pin)
        else
            servo(pin, duty)
        end
        end)
end)

