-- local my=require('my')
-- require('servo')
-- local servo = Servo:new{pin=1}
-- servo:attach(1)

my.create_server(4000, function(request)
    print("received ", request)
    angle = tonumber(request)
    print("angle",angle)
    servo:rotate(angle)
    --_,_,cmd,pin,data = request:find("(%w+):(%w+):(%w+)")
    --pin = tonumber(pin)
    --data = tonumber(data)
end)

-- my.init()
-- my.set_speed(100)
-- my.forward()
