from machine import Pin, PWM
import utime

class Servo:
    def __init__(self, pin):
        self.pwm = PWM(Pin(pin), freq=50, duty=0)
        self.angle = None

    def turn(self, angle):
        if self.angle is not None:
            step = -3 if self.angle > angle else 3
            print("self.angle", self.angle, "angle", angle, "step", step)
            for a in range(self.angle, angle, step):
                #print("angle", a)
                self._set_angle(a)
                utime.sleep_ms(50)
        self._set_angle(angle)
        self.angle = angle

    def _set_angle(self, angle):
        # angle / 180（ * 2（0°-180°） + 0.5（）/ 20ms * 1023
        self.pwm.duty(int(((angle)/180 *2 + 0.5) / 20 * 1023))    
