import machine
from machine import Pin, PWM
import utime, math
from time import sleep


# pwm
pwm = PWM(Pin(3), freq=50, duty=0)


def Servo(servo, angle):
    # angle / 180（ * 2（0°-180°） + 0.5（）/ 20ms * 1023
    pwm.duty(int(((angle)/180 *2 + 0.5) / 20 * 1023))    


def moveServo(position):
    Servo(pwm, position)
    utime.sleep(1)
    print("Servo  Angle : ",position)

for i in range(11):
    moveServo(18*i)
    sleep(1)