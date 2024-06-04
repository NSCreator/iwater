#include "secrets.h"
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "WiFi.h"
const int relay = 32;
#define AWS_IOT_PUBLISH_TOPIC   "/test/topic"
#define AWS_IOT_SUBSCRIBE_TOPIC "esp32/device01"
 
WiFiClientSecure net = WiFiClientSecure();
PubSubClient client(net);
 
void connectAWS()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
 
  Serial.println("Connecting to Wi-Fi");
 
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
 
  net.setCACert(AWS_CERT_CA);
  net.setCertificate(AWS_CERT_CRT);
  net.setPrivateKey(AWS_CERT_PRIVATE);
  client.setServer(AWS_IOT_ENDPOINT, 8883);
 
  client.setCallback(messageHandler);

  Serial.println("Connecting to AWS IOT");
 
  while (!client.connect(THINGNAME))
  {
    Serial.print(".");
    delay(100);
  }
 
  if (!client.connected())
  {
    Serial.println("AWS IoT Timeout!");
    return;
  }
 
  client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
 
  Serial.println("AWS IoT Connected!");
}
 
void publishMessage(bool isPumpOn=false)
{
  StaticJsonDocument<200> doc;
  if(isPumpOn)doc["message"] ="on" ;
  else if(!isPumpOn)doc["message"] ="off" ;

  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer);
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}
 
void messageHandler(char* topic, byte* payload, unsigned int length)
{
  StaticJsonDocument<200> doc;

  deserializeJson(doc, payload);
  const char* message = doc["message"];

 if (strcmp(message, "on") == 0) { 
    digitalWrite(relay, 0); 
    Serial.println("Relay turned ON");
    publishMessage(true);
  } else if (strcmp(message, "off") == 0) {
    digitalWrite(relay, 1); 
    Serial.println("Relay turned OFF");
    publishMessage();
  } else {
    Serial.println("Invalid message received");
  }
  Serial.println(message);
  
}
 
void setup()
{
  pinMode(relay, OUTPUT);
 digitalWrite(relay, 1); 
  Serial.begin(115200);
  connectAWS();

}
 
void loop()
{
    client.loop();
    delay(1000);
}