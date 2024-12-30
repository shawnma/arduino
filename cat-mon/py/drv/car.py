from machine import Timer
import utime
from drv.motor import Motor


class FullSpeedCar:
    dummy_pin: int = 19

    def __init__(self, left_pin1: int, left_pin2: int, right_pin1: int, right_pin2: int):
        print("init full")
        self.left: Motor = Motor(left_pin1, left_pin2, FullSpeedCar.dummy_pin)
        self.right: Motor = Motor(right_pin1, right_pin2, FullSpeedCar.dummy_pin)
        self.last_action = 0
        self.timer = Timer(0)
        print("ready for init")
        self.timer.init(mode=Timer.PERIODIC, period=500, callback=lambda t:self.timer_callback())
        self.stopped = True

    def timer_callback(self):
        tm = utime.ticks_ms()
        if tm - self.last_action > 1000 and not self.stopped:
            self.stopped = True
            self.stop()

    def update(self):
        self.last_action = utime.ticks_ms()
        self.stopped = False

    def forward(self):
        self.update()
        self.left.forward(100)
        self.right.forward(100)

    def back(self):
        self.update()
        self.left.backward(100)
        self.left.backward(100)

    def leftTurn(self, degree=6):
        self.update()
        self.left.stop()
        self.right.forward(100)
        if degree > 90:
            degree = 90
        utime.sleep_ms(100*degree/6) # 100 ms is 90/15 = 6 degree
        self.stop()

    def rightTurn(self, degree=6):
        self.update()
        self.left.forward(100)
        self.right.stop()
        if degree > 90:
            degree = 90
        utime.sleep_ms(100*degree/6) # 100 ms is 90/15 = 6 degree
        self.stop()

    def stop(self):
        self.left.stop()
        self.right.stop()
