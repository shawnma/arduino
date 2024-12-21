from motor import Motor
import utime
from machine import Timer

class AutoStopMotor(Motor):
    def __init__(self, pin1, pin2, enable_pin, min_duty=750, max_duty=1023):
        super().__init__(pin1, pin2, enable_pin, min_duty, max_duty)
        self.last_action = 0
        self.timer = Timer(0)
        self.timer.init(mode=Timer.PERIODIC, period=1000, callback=lambda t:self.timer_callback())
        self.stopped = True

    def timer_callback(self):
        print("timer callback")
        tm = utime.ticks_ms()
        if tm - self.last_action > 2000 and not self.stopped:
            self.stopped = True
            self.stop()

    def forward(self, speed):
        self.last_action = utime.ticks_ms()
        self.stopped = False
        return super().forward(speed)
        
    def backward(self, speed):
        self.last_action = utime.ticks_ms()
        self.stopped = False
        return super().backward(speed)