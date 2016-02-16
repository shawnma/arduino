#define EI_ARDUINO_INTERRUPTED_PIN
#include <EnableInterrupt.h>
#include <Servo.h>

class Transformer {
  public:
    Transformer(uint8_t in, int out): _in(in) {
      pinMode(in, INPUT_PULLUP);
      servo.attach(out);
      Serial.println(String("Attach ") + in + "/" + out);
    }
  private:
    volatile uint16_t start;
    uint8_t _in;
    volatile uint16_t current;
    //volatile bool _refresh;
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
        if (abs(length - current) > 20) {
          current = length;
          int ms = map_input(current);
          servo.writeMicroseconds(ms);
          Serial.println(String("->") + _in + " -->" + ms);
        }
      }
    }
  protected:
    // map input from 1000 -> 2000, to it's expected value.
    virtual int map_input(int input) = 0;
};

class EscTransformer: public Transformer {
  public:
    EscTransformer(uint8_t in, uint8_t out): Transformer(in, out) {}
  protected:
    virtual int map_input(int input) {
      int out = map(input, 1156, 1788, 2500, 1800);
      if (out < 1300 || out > 3000) {
        out = 2200;
      }
      return out;
    }
};

class RotationTransformer: public Transformer {
  public:
    RotationTransformer(): Transformer(9, 11) {}
    RotationTransformer(uint8_t in, uint8_t out): Transformer(in, out) {}
  protected:
    virtual int map_input(int input) {
      return map(input, 1144, 1896, 500, 2500);
    }
};

#define COUNT  3
Transformer* transformers[COUNT];

EscTransformer *esc;
RotationTransformer *rotation;

void int_func() {
  for (int i = 0; i < COUNT; i++) {
    if (arduinoInterruptedPin == transformers[i]->getIn()) {
      transformers[i]->interrupt();
    }
  }
}

void setup() {
  Serial.begin(115200);
  transformers[0] = new RotationTransformer(2, 3);
  transformers[1] = new EscTransformer(4, 5);
  transformers[2] = new RotationTransformer(6, 7);
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

