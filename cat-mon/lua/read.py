import serial
ser = serial.Serial(
    port='/dev/cu.usbserial-0001',
    baudrate=152000
)

ser.isOpen()


while True:
        out = []
        while ser.inWaiting() > 0:
            out.append(ser.read(1))
            
        if len(out) > 0:
            print (b''.join(out).decode('utf-8'))
