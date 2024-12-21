import netsvr
from autostop import AutoStopMotor
from machine import Pin

motor = AutoStopMotor(Pin(1), Pin(2), Pin(3))

def handle_network(line):
    line = line.decode()
    print("network line", line)
    if line == 'f':
        motor.forward(100)
    elif line == 'b':
        motor.backward(100)
    elif line == 's':
        motor.stop()

netsvr.do_connect()
netsvr.create_server(4000, handle_network)