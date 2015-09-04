/**
 * Flash led
 * @author Markus Bader <markus.bader@tuwien.ac.at>
 * @file flash.cpp
 */
#include <Arduino.h>

void flash(int led){
  digitalWrite(led, HIGH);  
  delay(100);              
  digitalWrite(led, LOW);   
  delay(500);             
}