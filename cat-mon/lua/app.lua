local my=require('my')
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
function initDisplay()
    local sda = 5 -- GPIO14
    local scl = 7 -- GPIO12
    print("doing setup")
    i2c.setup(0, sda, scl, i2c.SLOW)
    local sla = 0x3c
    print("init display")
    disp = u8g2.ssd1306_i2c_128x64_noname(0, sla)
    --disp:setRot180() 
 end
 initDisplay()
 disp:drawStr( 0, 0, "drawBox")
 disp:drawBox(5,10,20,10)
 disp:drawBox(10+a,15,30,7)
 disp:drawStr( 0, 30, "drawFrame")