const float h[9] = {
  0.11755705f,
  0.19021130f,
  0.19021130f,
  0.11755705f,
  0.0f,
 -0.11755705f,
 -0.19021130f,
 -0.19021130f,
 -0.11755705f
};

const float hB[8] = {
  0.0381966f,
  0.1000000f,
  0.1618034f,
  0.2000000f,
  0.2000000f,
  0.1618034f,
  0.1000000f,
  0.0381966f
};

const int butterworthPin = A1;   // analog filter output
const int pulsePin = A0;
float x_hist[9] = {0.0f};
float xB_hist[8] = {0.0f};
int idx = 0;

const unsigned long Ts_us = 10000;   // 10 ms -> Fs = 100 Hz
unsigned long next_sample_time;

void setup() {
  Serial.begin(115200);
  next_sample_time = micros();
}

void loop() {
  unsigned long now = micros();
  if ((long)(now - next_sample_time) < 0) {
    return;   // not time yet
  }
  next_sample_time += Ts_us;

  // 1) Sample analog filter output
  int sq = analogRead(pulsePin);
  int raw = analogRead(butterworthPin);    // 0..1023
  float x = (float)raw;                    // you can DC-center if desired

  // 2) Push into circular buffer
  xB_hist[idx] = x;

  // 3) FIR: modified comb filter
  float y = 0.0f;
  int j = idx;
  for (int k = 0; k < 8; ++k) {
    y += hB[k] * xB_hist[j];
    if (--j < 0) j = 7;
  }
  idx = (idx + 1) % 8;

  // 4) y is your “cleaned” 10 Hz sine
  Serial.print(sq);
  Serial.print(";");
  Serial.print(raw);   // analog filter output
  Serial.print(';');
  Serial.println(y);   // comb-filtered output
}
