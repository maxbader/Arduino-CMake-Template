
#include <Arduino.h>

void flash(int led){
  digitalWrite(led, HIGH);  
  delay(100);              
  digitalWrite(led, LOW);   
  delay(500);             
}