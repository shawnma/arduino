from machine import Pin, PWM

class Servo:
    def __init__(self, pin):
        self.pwm = PWM(Pin(pin), freq=50, duty=0)

    def turn(self, angle):
        # angle / 180（ * 2（0°-180°） + 0.5（）/ 20ms * 1023
        self.pwm.duty(int(((angle)/180 *2 + 0.5) / 20 * 1023))    
