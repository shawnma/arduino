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

my.init()
my.set_speed(90)

function delayed_execution(sequence_table, delay_ms)
    local index = 1
    local t = tmr.create()
    local function execute_next()
      if index <= #sequence_table then
        print("running index ", index)
        local function_to_call = sequence_table[index]
        index = index + 1
        function_to_call()
      else
        t:stop()
        print("finished")
      end
    end
    t:alarm(delay_ms, tmr.ALARM_AUTO, execute_next)
end

my.forward()

local d=tmr.create()

local table = {
    my.left_turn,
    my.right_turn,
    my.back,
    function ()
        my.set_speed(0)
    end
}

delayed_execution(table, 4000)