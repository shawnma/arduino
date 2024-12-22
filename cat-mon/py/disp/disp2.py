from machine import Pin, I2C
from driver.lcd2 import I2cLcd
#from lcd import LCD
import time

i2c = I2C(sda=Pin(5), scl=Pin(4))
addr = 0x27
lcd = I2cLcd(i2c, addr, (20,4))
#lcd = LCD(i2c)
#lcd.puts("hello world this is a very long sentence")
#lcd.set_display(backl=False)
lcd.write("Hello, World this is a very long sentence great smart.")