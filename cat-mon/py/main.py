from drv.car import FullSpeedCar
import net.netsvr as netsvr
from servo.servo import Servo
import disp.disp as display

display.print_text("Starting...")
car = FullSpeedCar(9,18,19,10)
base = Servo(21)
up = Servo(22)

def handle_network(line):
    line = line.decode()
    display.print_text("network line", line)
    if line == 'f':
        car.forward()
    elif line == 'b':
        car.back()
    elif line == 'l':
        car.leftTurn()
    elif line == 'r':
        car.rightTurn()
    elif line == 'ld':
        car.leftTurn(int(line[2:]))
    elif line == 'rd':
        car.rightTurn(int(line[2:]))
    elif line == 'lf':
        car.left.forward(100)
    elif line == 'lb':
        car.left.backward(100)
    elif line == 'rf':
        car.right.forward(100)
    elif line == 'rb':
        car.right.backward(100)
    elif line.startswith('bt'):
        base.turn(int(line[2:]))
    elif line.startswith('ut'):
        up.turn(int(line[2:]))
    elif line == 's':
        car.stop()

netsvr.do_connect()
netsvr.create_server(4000, handle_network)