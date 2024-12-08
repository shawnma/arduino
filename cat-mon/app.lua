local my=require('my')
my.create_server(4000, function(request)
    _,_,cmd,pin,data = request:find("(%w+):(%w+):(%w+)")
    pin = tonumber(pin)
    data = tonumber(data)
    if cmd == 'low' then
        gpio.write(pin, gpio.LOW)
        tmr.stop(pin-1)
        if data > 0 then
            tmr.alarm(pin-1, data*1000, 0, function() gpio.write(pin, gpio.HIGH) end)
        end
    elseif cmd == 'high' then
        gpio.write(pin, gpio.HIGH)
    end
end)

my.set_speed(30)
my.forward()
tmr.delay(2000)
my.left_turn()
tmr.delay(2000)
my.right_turn()
tmr.delay(2000)
my.back()
tmr.delay(2000)
my.set_speed(0)