#define EI_ARDUINO_INTERRUPTED_PIN
#include <EnableInterrupt.h>
#include <AFMotor.h>

AF_DCMotor left(3);
AF_DCMotor right(4);
#define COUNT  2
class Transformer;
Transformer* transformers[COUNT];
bool turning = false;

class Transformer {
  public:
    Transformer(uint8_t in): _in(in) {
      pinMode(in, INPUT_PULLUP);
    }
  private:
    uint8_t _in;
    volatile uint16_t start;
  public:
    inline int getIn() {
      return _in;
    }
    bool interrupt() {
      if (digitalRead(_in) == HIGH) {
        start = micros();
      } else {
        uint16_t length = (uint16_t)(micros() - start);
        if (abs(length - current) > 20) {
          current = length;
          setSpeed();
        }
      }
      return false;
    }
    volatile uint16_t current;
    virtual void setSpeed() = 0;
};

class Turner : public Transformer {
  public:
    Transformer* mover;
    Turner(uint8_t in, Transformer* mover) : Transformer(in), mover(mover) {}
    virtual void setSpeed() {
      if (current > 1550 || current < 1450) {
        turning = true;
        left.setSpeed(255);
        right.setSpeed(255);
        if (current > 1550) {
          left.run(FORWARD);
          right.run(BACKWARD);
        } else {
          left.run(BACKWARD);
          right.run(FORWARD);
        }
      } else {
        turning = false;
        mover->setSpeed(); // mover
      }
    }
};

class Mover : public Transformer {
  public:
    Mover(uint8_t in) : Transformer(in) {}
    virtual void setSpeed() {
      if (turning) {
        return;
      }
      left.setSpeed(255);
      right.setSpeed(255);
      if (current > 1550) {
        left.run(FORWARD);
        right.run(FORWARD);
      } else if (current < 1450) {
        left.run(BACKWARD);
        right.run(BACKWARD);
      } else {
        left.run(RELEASE);
        right.run(RELEASE);
      }
    }
};
//    void setSpeed() {
//      if (current > 1550) {
//        //int speed = map(current, 1520, 2000, 128, 255);
//        int speed = 255;
//        if (dir != 1) {
//          dir = 1;
//          motor.run(FORWARD);
//        }
//        set(speed);
//      } else if (current < 1450) {
//        //int speed = map(current, 1480, 1000, 128, 255);
//        int speed = 255;
//        if (dir != -1) {
//          dir = -1;
//          motor.run(BACKWARD);
//        }
//        set(speed);
//      } else {
//        if (dir != 0) {
//          dir = 0;
//          motor.run(RELEASE);
//        }
//      }
//    }
//
//    void set(uint16_t speed) {
//      //Serial.println(String("::") + _in + "|"+ current + " -->" + speed);
//      motor.setSpeed(speed);
//    }
//
//};


void int_func() {
  for (int i = 0; i < COUNT; i++) {
    if (arduinoInterruptedPin == transformers[i]->getIn()) {
      transformers[i]->interrupt();
    }
  }
}

void setup() {
  //Serial.begin(115200);
  transformers[0] = new Mover(9);
  transformers[1] = new Turner(10, transformers[0]);
  for (int i = 0; i < 2; i++) {
    enableInterrupt(transformers[i]->getIn(), int_func, CHANGE);
  }
}

void loop() {
  delay(1);
}

