#import stat

from machine import Pin, SoftI2C
from .driver.ssd1306 import SSD1306_I2C
from .fonts import helvetica11 as ft
from .fonts.ezfont import ezFBfont

i2c = SoftI2C(sda=Pin(5), scl=Pin(4))
#i2c = SoftI2C(sda=Pin(13), scl=Pin(12))

display = SSD1306_I2C(128, 64, i2c)

screen = ezFBfont(display, ft, verbose=True)
buf = []

def print_text(*text, same_line=False):
    display.fill(0)
    line = ""
    for t in text:
        line += " "
        line += str(t)
    global buf
    if same_line:
        buf[-1] += line
    else:
        buf.append(line)
    buf = buf[-4:]
    for i,s in enumerate(buf):
        screen.write(s, 0, 16*i)
    display.show()
