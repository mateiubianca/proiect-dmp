int btn1 = 2;
int btn2 = 3;
int btn3 = 18;
int btn4 = 19;

void setup() {
  pinMode(btn1, INPUT_PULLUP);
  pinMode(btn2, INPUT_PULLUP);
  pinMode(btn3, INPUT_PULLUP);
  pinMode(btn4, INPUT_PULLUP);
  Serial.begin(9600);

  attachInterrupt(digitalPinToInterrupt(btn1), functieUp, FALLING);
  attachInterrupt(digitalPinToInterrupt(btn2), functieDown, FALLING);
  attachInterrupt(digitalPinToInterrupt(btn3), functieLeft, FALLING);
  attachInterrupt(digitalPinToInterrupt(btn4), functieRight, FALLING);
}

void loop() {
}

void functieUp() {
  Serial.print("up");
}

void functieDown() {
  Serial.print("down");
}

void functieLeft() {
  Serial.print("left");
}

void functieRight() {
  Serial.print("right");
}
