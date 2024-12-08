local function create_server(port, line_callback)
    srv=net.createServer(net.TCP)
    srv:listen(port, function(conn)
        conn:on("receive", function(client,request)
            line_callback(request)
        end)
    end)
end

local function map(val, s, e, ts, te)
    return math.floor((val-s)*(te-ts)/(e-s) + ts)
end

local function servo(pin, duty) -- 0 - 127
    pwm.close(pin)
    local d = map(duty,0,127,26,128)
    print ("" .. pin .. "-> " .. d)
    pwm.setup(pin, 50, d)
    pwm.start(pin)
end

local speed = 0
local pins = {
    speed = 1,
    left = {forward=2, backward=3},
    right = {forward=4, backward=5},
}

local function init()
    gpio.mode(pins.left.forward, gpio.OUTPUT)
    gpio.mode(pins.right.forward, gpio.OUTPUT)
    gpio.mode(pins.left.backward, gpio.OUTPUT)
    gpio.mode(pins.right.backward, gpio.OUTPUT)
    pwm.setup(pins.speed, 500)
end

-- speed 0 to 100; 0 to stop
local function set_speed(s)
    speed = s
    local duty = map(s, 0, 100, 0, 1023)
    pwm.setduty(pins.speed, duty)
end

local function set_dir(pin, forward)
    gpio.write(pin.forward, forward and gpio.HIGH or gpio.LOW)
    gpio.write(pin.backward, forward and gpio.LOW or gpio.HIGH)
end

local function forward()
    set_dir(pins.left, true)
    set_dir(pins.right, true)
end

local function left_turn()
    set_dir(pins.left, false)
    set_dir(pins.right, true)
end

local function right_turn()
    set_dir(pins.left, true)
    set_dir(pins.right, false)
end

local function back()
    set_dir(pins.left, false)
    set_dir(pins.right, false)
end

my = {
    create_server = create_server,
    map=map,
    servo=servo,
    set_speed=set_speed,
    forward=forward,
    back=back,
    left_turn=left_turn,
    right_turn=right_turn
}
return my
