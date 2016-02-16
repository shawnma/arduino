local my = require('my')
function dump()
	local s=""
	for i=1,6 do
		s = s..gpio.read(i).." "
	end
	print(s)
end

function do_server()
	my.create_server(4000, function(request)
		_,_,cmd,pin,data = request:find("(%w+):(%w+):(%w+)")
		pin = tonumber(pin)
		data = tonumber(data)
		if cmd == 'low' then
			gpio.write(pin, gpio.LOW)
			tmr.stop(pin-1)
			tmr.alarm(pin-1, data*1000, 0, function() gpio.write(pin, gpio.HIGH) end)
		elseif cmd == 'high' then
			gpio.write(pin, gpio.HIGH)
		end
	end)
end

my.setup_wifi(function()
	for i=1,6 do
		gpio.mode(i, gpio.OUTPUT, gpio.PULLUP)
		--gpio.write(i, gpio.HIGH)
	end
    dump()
	do_server()
end)
