import stat

from machine import Pin, SoftI2C
from driver.ssd1306 import SSD1306_I2C
import fonts.helvetica11 as ft
from fonts.ezfont import ezFBfont

i2c = SoftI2C(sda=Pin(5), scl=Pin(4))
display = SSD1306_I2C(128, 64, i2c)

font = ezFBfont(display, ft, verbose=True)

text = 'Hello!\nMPy World what\n if my\n sentence is too long'
# frame
#display.rect(0, 0, 128, 64, 1)
# write
font.write(text, 0, 0)
display.show()
