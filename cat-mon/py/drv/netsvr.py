import utime, socket

def do_connect():
    import network
    sta_if = network.WLAN(network.WLAN.IF_STA)
    if not sta_if.isconnected():
        print('connecting to network...')
        sta_if.active(True)
        f = open('key.txt')
        key = f.readline().strip()
        f.close()
        sta_if.connect('milkyway', key)
        while not sta_if.isconnected():
            utime.sleep_ms(50)
            print(".", end="")
    print('connected:', sta_if.ipconfig('addr4'))

def create_server(port, callback):
    s = socket.socket()
    s.bind(('0.0.0.0', port))
    s.listen(1)
    print("listening...")
    while True:
        cl, addr = s.accept()
        try:
            print('client connected from', addr)
            cl_file = cl.makefile('rwb', 0)
            while True:
                line = cl_file.readline().strip()
                callback(line)
        except Exception as e:
            print(e)
            cl.close()
    