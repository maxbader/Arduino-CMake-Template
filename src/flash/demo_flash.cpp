/*
  sketch Demo
  @author Markus Bader
 */
#include <Arduino.h>
#include "flash.h"

int led = 13;
// the setup function runs once when you press reset or power the board
void setup() {
  init();
  // initialize digital pin 13 as an output.
  pinMode(led, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  flash(led);            
}