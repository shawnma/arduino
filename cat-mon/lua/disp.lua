function initDisplay()
    local sda = 1 -- GPIO14
    local scl = 2 -- GPIO12
    print("doing setup")
    i2c.setup(0, sda, scl, i2c.SLOW)
    local sla = 0x3c
    print("init display")
    disp = u8g2.ssd1306_i2c_128x64_noname(0, sla)
 end
 print("hi")
 initDisplay()
 disp:setFontMode(0)
 disp:setDrawColor(1)
 disp:drawStr(3, 15, "Color=1, Mode 0")
 disp:setDrawColor(0)
 disp:drawStr(3, 30, "Color=0, Mode 0")
 disp:setFontMode(1)
 disp:setDrawColor(1)
 disp:drawStr(3, 45, "Color=1, Mode 1")
 disp:setDrawColor(0)
 disp:drawStr(3, 60, "Color=0, Mode 1")