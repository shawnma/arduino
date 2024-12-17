Servo = {pin=1}

function Servo:new(o)
    o = o or {pin=1}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Servo:attach(pin)
    self.pin = pin
    print("pin",pin, "self.pin", self.pin)
    pwm.setup(self.pin, 50, 0)
    pwm.start(self.pin)
end

function Servo:rotate(angle)
    pwm.setduty(self.pin, angle*1024/180)
end
