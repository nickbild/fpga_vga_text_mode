int ad0 = 2;
int ad1 = 3;
int ad2 = 4;
int ad3 = 5;
int ad4 = 6;
int ad5 = 7;
int ad6 = 8;
int ad7 = 9;
int ad8 = 10;
int ad9 = 11;
int ad10 = 12;

int c0 = A0;
int c1 = A1;
int c2 = A2;
int c3 = A3;
int c4 = A4;
int c5 = A5;

int interrupt = A6;

void setup() {
  pinMode(ad0, OUTPUT);
  pinMode(ad1, OUTPUT);
  pinMode(ad2, OUTPUT);
  pinMode(ad3, OUTPUT);
  pinMode(ad4, OUTPUT);
  pinMode(ad5, OUTPUT);
  pinMode(ad6, OUTPUT);
  pinMode(ad7, OUTPUT);
  pinMode(ad8, OUTPUT);
  pinMode(ad9, OUTPUT);
  pinMode(ad10, OUTPUT);

  pinMode(c0, OUTPUT);
  pinMode(c1, OUTPUT);
  pinMode(c2, OUTPUT);
  pinMode(c3, OUTPUT);
  pinMode(c4, OUTPUT);
  pinMode(c5, OUTPUT);

  pinMode(interrupt, OUTPUT);

  digitalWrite(interrupt, 0);
}

void loop() {
  // Blank out display.
  for (int i=0; i<1500; i++) {
    writeChar(i, 57);
  }

  // Add border.
  for (int i=0; i<50; i++) { // Top.
    writeChar(i, 58);
  }
  for (int i=1450; i<1500; i++) { // Bottom.
    writeChar(i, 58);
  }
  for (int i=50; i<1450; i+=50) { // Left.
    writeChar(i, 58);
  }
  for (int i=49; i<1450; i+=50) { // Right.
    writeChar(i, 58);
  }

  // MINIVGA TEXT MODE
  writeChar(67, 12);
  writeChar(68, 8);
  writeChar(69, 13);
  writeChar(70, 8);
  writeChar(71, 21);
  writeChar(72, 6);
  writeChar(73, 0);
  writeChar(74, 57);
  writeChar(75, 19);
  writeChar(76, 4);
  writeChar(77, 23);
  writeChar(78, 19);
  writeChar(79, 57);
  writeChar(80, 12);
  writeChar(81, 14);
  writeChar(82, 3);
  writeChar(83, 4);

  // FOR ARDUINO AND RETRO COMPUTERS
  writeChar(210, 5);
  writeChar(211, 14);
  writeChar(212, 17);
  writeChar(213, 57);
  writeChar(214, 0);
  writeChar(215, 17);
  writeChar(216, 3);
  writeChar(217, 20);
  writeChar(218, 8);
  writeChar(219, 13);
  writeChar(220, 14);
  writeChar(221, 57);
  writeChar(222, 0);
  writeChar(223, 13);
  writeChar(224, 3);
  writeChar(225, 57);
  writeChar(226, 17);
  writeChar(227, 4);
  writeChar(228, 19);
  writeChar(229, 17);
  writeChar(230, 14);
  writeChar(231, 57);
  writeChar(232, 2);
  writeChar(233, 14);
  writeChar(234, 12);
  writeChar(235, 15);
  writeChar(236, 20);
  writeChar(237, 19);
  writeChar(238, 4);
  writeChar(239, 17);
  writeChar(240, 18);

  // All characters.
  for (int i=0; i<48; i++) {
    writeChar(601+i, i);
  }
  for (int i=0; i<11; i++) {
    writeChar(651+i, i+48);
  }

  while(true) {}
}

void writeChar(int addr, int c) {
  digitalWrite(ad0, bitRead(addr, 0));
  digitalWrite(ad1, bitRead(addr, 1));
  digitalWrite(ad2, bitRead(addr, 2));
  digitalWrite(ad3, bitRead(addr, 3));
  digitalWrite(ad4, bitRead(addr, 4));
  digitalWrite(ad5, bitRead(addr, 5));
  digitalWrite(ad6, bitRead(addr, 6));
  digitalWrite(ad7, bitRead(addr, 7));
  digitalWrite(ad8, bitRead(addr, 8));
  digitalWrite(ad9, bitRead(addr, 9));
  digitalWrite(ad10, bitRead(addr, 10));

  digitalWrite(c0, bitRead(c, 0));
  digitalWrite(c1, bitRead(c, 1));
  digitalWrite(c2, bitRead(c, 2));
  digitalWrite(c3, bitRead(c, 3));
  digitalWrite(c4, bitRead(c, 4));
  digitalWrite(c5, bitRead(c, 5));

  digitalWrite(interrupt, 1);
  digitalWrite(interrupt, 0);
}
