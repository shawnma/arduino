import utime, socket
from disp.disp import print_text

def do_connect():
    import network
    nic = network.WLAN(network.WLAN.IF_STA)
    if not nic.isconnected():
        print_text('connecting to network...')
        nic.active(True)
        f = open('key.txt')
        if f is None:
            raise Exception("No wifi key.txt present.")
        key = f.readline().strip()
        f.close()
        nic.connect('milkyway', key)
        while not nic.isconnected():
            utime.sleep_ms(50)
            print_text(".", same_line=True)
    print_text('connected:', nic.ifconfig())

def threaded_server(port, callback):
    import _thread
    _thread.start_new_thread(create_server, (port, callback))

def create_server(port, callback):
    s = socket.socket()
    s.bind(('0.0.0.0', port))
    s.listen(1)
    print_text("listening...")
    while True:
        cl, addr = s.accept()
        try:
            print_text('client connected from', addr)
            cl_file = cl.makefile('rwb', 0)
            while True:
                line = cl_file.readline().strip()
                if line == None or len(line) == 0:
                    break
                callback(line)
        except Exception as e:
            import io, sys
            out = io.StringIO()
            sys.print_exception(e, out)
            print_text(out.getvalue())
            cl.write(out.getvalue())
            cl.close()
    