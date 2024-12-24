from drv.car import FullSpeedCar
import net.netsvr as netsvr

car = FullSpeedCar(7,6,5,4)

def handle_network(line):
    line = line.decode()
    print("network line", line)
    if line == 'f':
        car.forward()
    elif line == 'b':
        car.back()
    elif line == 'l':
        car.leftTurn()
    elif line == 'r':
        car.rightTurn()
    elif line == 's':
        car.stop()

netsvr.do_connect()

netsvr.create_server(4000, handle_network)