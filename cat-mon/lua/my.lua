local function create_server(port, line_callback)
    print("listening on port", port)
    srv=net.createServer(net.TCP, 30)
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

-- local speed = 0
local pins = {
    left = {forward=0, backward=1, speed=5},
    right = {forward=2, backward=3, speed=6},
}

-- speed 0 to 100; 0 to stop
local function set_speed(s)
    print("setting speed ", s)
    -- speed = s
    local duty = map(s, 0, 100, 0, 1023)
    pwm.setduty(pins.left.speed, duty)
    pwm.setduty(pins.right.speed, duty)
end

local function stop()
    gpio.write(pins.right.backward, gpio.LOW)
    gpio.write(pins.left.backward, gpio.LOW)
    gpio.write(pins.left.forward, gpio.LOW)
    gpio.write(pins.right.forward, gpio.LOW)
    set_speed(0)
end

local function init()
    gpio.mode(pins.left.forward, gpio.OUTPUT)
    gpio.mode(pins.right.forward, gpio.OUTPUT)
    gpio.mode(pins.left.backward, gpio.OUTPUT)
    gpio.mode(pins.right.backward, gpio.OUTPUT)
    pwm.setup(pins.left.speed, 500, 0)
    pwm.setup(pins.right.speed, 500, 0)
    pwm.start(pins.left.speed)
    pwm.start(pins.right.speed)
    stop()
end


local function set_dir(pin, forward)
    print("set dir: ", pin.forward, forward and gpio.HIGH or gpio.LOW)
    print("set dir: ", pin.backward, forward and gpio.LOW or gpio.HIGH)
    gpio.write(pin.forward, forward and gpio.HIGH or gpio.LOW)
    gpio.write(pin.backward, forward and gpio.LOW or gpio.HIGH)
end


local function forward()
    print("foward...")
    set_dir(pins.left, true)
    set_dir(pins.right, true)
end

local function left_turn()
    print("left turn")
    set_dir(pins.left, false)
    set_dir(pins.right, true)
end

local function right_turn()
    print("right turn")
    set_dir(pins.left, true)
    set_dir(pins.right, false)
end

local function back()
    print("back")
    set_dir(pins.left, false)
    set_dir(pins.right, false)
end

my = {
    stop=stop,
    init=init,
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
