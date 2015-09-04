/**
 * Blink demo
 * @author Markus Bader <markus.bader@tuwien.ac.at>
 */

#include <Arduino.h>

int led = 13;

void setup() {
  // initialize digital pin 13 as an output.
  pinMode(led, OUTPUT);
}

void loop() {
  digitalWrite(led, HIGH);  
  delay(1000);         
  digitalWrite(led, LOW);   
  delay(1000);
}