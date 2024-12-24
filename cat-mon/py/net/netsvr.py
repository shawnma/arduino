import utime, socket

def do_connect():
    import network
    nic = network.WLAN(network.WLAN.IF_STA)
    if not nic.isconnected():
        print('connecting to network...')
        nic.active(True)
        f = open('key.txt')
        if f is None:
            raise Exception("No wifi key.txt present.")
        key = f.readline().strip()
        f.close()
        nic.connect('milkyway', key)
        while not nic.isconnected():
            utime.sleep_ms(50)
            print(".", end="")
    print('connected:', nic.ifconfig())

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
                if line == None or len(line) == 0:
                    break
                callback(line)
        except Exception as e:
            print(e)
            cl.close()
    