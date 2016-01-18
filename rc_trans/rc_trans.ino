// EnableInterrupt Simple example sketch. Demonstrates operation on a single pin of your choice.
// See https://github.com/GreyGnome/EnableInterrupt and the README.md for more information.
#include <EnableInterrupt.h>
#include <Servo.h>

class Transformer {
  public:
    Transformer(uint8_t in, int out): _in(in), _refresh(false) {
      pinMode(in, INPUT_PULLUP);
      servo.attach(out);
      Serial.println(String("Attach ") + in + "/" + out);
    }
  private:
    volatile uint16_t start;
    uint8_t _in;
    volatile uint16_t current;
    volatile bool _refresh;
    Servo servo;
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
        //Serial.println(length);
        setCurrent(length);
      }
    }

    inline void setCurrent(uint16_t length) {
      if (abs(length - current) > 20) {
        current = length;
        _refresh = true;
      }
    }

    void refresh() {
      if (!_refresh) return;
      _refresh = false;
      int ms = map_input(current);
      servo.writeMicroseconds(ms);
      Serial.println(String("->") + _in + " " + ms + "<-" + current);
    }
  protected:
    // map input from 1000 -> 2000, to it's expected value.
    virtual int map_input(int input) = 0;
};

class EscTransformer: public Transformer {
  public:
    EscTransformer(): Transformer(8, 10) {}
  protected:
    virtual int map_input(int input) {
      return map(input, 1156, 1788, 2500, 1800);
    }
};

class RotationTransformer: public Transformer {
  public:
    RotationTransformer(): Transformer(9, 11) {}
  protected:
    virtual int map_input(int input) {
      return map(input, 1144, 1896, 500, 2500);
    }
};

EscTransformer *esc;
RotationTransformer *rotation;

void rot_int() {
  rotation->interrupt();
}

void esc_int() {
  esc->interrupt();
}

void setup() {
  Serial.begin(152000);
  rotation = new RotationTransformer();
  esc = new EscTransformer();
  enableInterrupt(rotation->getIn(), rot_int, CHANGE);
  enableInterrupt(esc->getIn(), esc_int, CHANGE);
  //interrupts();
}

// In the loop we just display interruptCount. The value is updated by the interrupt routine.
void loop() {
  rotation->refresh();
  esc->refresh();
  delay(1);
}

