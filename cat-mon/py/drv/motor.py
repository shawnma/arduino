from machine import Pin, PWM


class Motor:
    # the min_duty and max_duty are defined for 15000Hz frequency
    # you can pass as arguments
    def __init__(self, pin1: int, pin2: int, enable_pin: int, min_duty=750, max_duty=1023):
        self.pin1 = Pin(pin1, Pin.OUT)
        self.pin2 = Pin(pin2, Pin.OUT)
        self.enable_pin = PWM(Pin(enable_pin))
        self.enable_pin.freq(500)
        self.stop()
        self.min_duty = min_duty
        self.max_duty = max_duty

    # speed value can be between 0 and 100
    def forward(self, speed: int):
        #print("forward...")
        self.speed = speed
        self.enable_pin.duty(self.duty_cycle())
        self.pin1.value(1)
        self.pin2.value(0)

    def backward(self, speed: int):
        #print("back...")
        self.speed = speed
        self.enable_pin.duty(self.duty_cycle())
        self.pin1.value(0)
        self.pin2.value(1)

    def stop(self):
        #print("stop")
        self.enable_pin.duty(0)
        self.pin1.value(0)
        self.pin2.value(0)

    def duty_cycle(self):
        if self.speed <= 0 or self.speed > 100:
            duty_cycle = 0
        else:
            duty_cycle = int(
                self.min_duty
                + (self.max_duty - self.min_duty) * ((self.speed - 1) / (100 - 1))
            )
        return duty_cycle
