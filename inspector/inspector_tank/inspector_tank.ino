#define EI_ARDUINO_INTERRUPTED_PIN
#include <EnableInterrupt.h>
#include <AFMotor.h>

class Transformer {
  public:
    Transformer(uint8_t in, int out): _in(in), motor(out), dir(0) {
      pinMode(in, INPUT_PULLUP);

      Serial.println(String("Attach ") + in + "/" + out);
    }
  private:
    volatile uint16_t start;
    uint8_t _in;
    volatile uint16_t current;
    AF_DCMotor motor;
    int8_t dir;
  public:
    inline int getIn() {
      return _in;
    }
    virtual void interrupt() {
      if (digitalRead(_in) == HIGH) {
        start = micros();
        //Serial.println("interrupt");
      } else {
        uint16_t length = (uint16_t)(micros() - start);
        if (abs(length - current) > 20) {
          current = length;
          //servo.writeMicroseconds(ms);
          setSpeed();
        }
      }
    }

    void setSpeed() {
      if (current > 1550) {
        //int speed = map(current, 1520, 2000, 128, 255);
        int speed = 255;
        if (dir != 1) {
          dir = 1;
          motor.run(FORWARD);
        }
        set(speed);
      } else if (current < 1450) {
        //int speed = map(current, 1480, 1000, 128, 255);
        int speed = 255;
        if (dir != -1) {
          dir = -1;
          motor.run(BACKWARD);
        }
        set(speed);
      } else {
        if (dir != 0) {
          dir = 0;
          motor.run(RELEASE);
        }
      }
    }

    void set(uint16_t speed) {
      //Serial.println(String("::") + _in + "|"+ current + " -->" + speed);
      motor.setSpeed(speed);
    }

};

#define COUNT  2
Transformer* transformers[COUNT];

void int_func() {
  for (int i = 0; i < COUNT; i++) {
    if (arduinoInterruptedPin == transformers[i]->getIn()) {
      transformers[i]->interrupt();
    }
  }
}

void setup() {
  Serial.begin(115200);
  transformers[0] = new Transformer(9, 1);
  transformers[1] = new Transformer(10, 2);
  for (int i = 0; i < COUNT; i++) {
    enableInterrupt(transformers[i]->getIn(), int_func, CHANGE);
  }
}

// In the loop we just display interruptCount. The value is updated by the interrupt routine.
void loop() {
  //rotation->refresh();
  //esc->refresh();
  delay(1);
}

