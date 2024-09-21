#include <WiFi.h> 
#include <PubSubClient.h>  

#include "SimpleDHT.h"

#define TOPICO_PUBLISH  "mqtt/temp"
#define ID_MQTT  "esp32_temp"
const char* BROKER_MQTT = "0.0.0.0"; 
int BROKER_PORT = 1883;

const char* SSID = "****"; 
const char* PASSWORD = "****"; 

WiFiClient espClient;
PubSubClient MQTT(espClient);

int pinDHT11 = 26;
SimpleDHT11 dht11(pinDHT11);


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.println("Hello, ESP32!");

  init_wifi();
  init_mqtt();
}

void init_wifi(void) 
{
    delay(10);
    Serial.println("------Conexao WI-FI------");
    Serial.print("Conectando-se na rede: ");
    Serial.println(SSID);
    Serial.println("Aguarde");
    reconnect_wifi();
}

void init_mqtt(void) 
{
    MQTT.setServer(BROKER_MQTT, BROKER_PORT); 
         
}

void loop() {
  
   // Wait a few seconds between measurements.
  delay(10000);
  verifica_conexoes_wifi_mqtt();
  byte temperature = 0;
  byte humidity = 0;

  int err = SimpleDHTErrSuccess;
  if ((err = dht11.read(&temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
    Serial.print("Read DHT11 failed, err="); Serial.print(SimpleDHTErrCode(err));
    Serial.print(","); Serial.println(SimpleDHTErrDuration(err)); delay(1000);
    return;
  }

  String payload = "{\"temp\": \""+(String)temperature+"\", \"umi\": \""+(String)humidity+"\"}";
  Serial.print("send -> "+ payload);

  int payloadLength = payload.length() + 1;
  char payloadChar[payloadLength];
  payload.toCharArray(payloadChar, payloadLength);  

  MQTT.publish(TOPICO_PUBLISH, payloadChar);
}


void reconnect_wifi() 
{
    if (WiFi.status() == WL_CONNECTED)
        return;
         
    WiFi.begin(SSID, PASSWORD);
     
    while (WiFi.status() != WL_CONNECTED) 
    {
        delay(100);
        Serial.print(".");
    }
   
    Serial.println();
    Serial.print("Conectado com sucesso na rede ");
    Serial.print(SSID);
    Serial.println("IP obtido: ");
    Serial.println(WiFi.localIP());
}

void reconnect_mqtt(void) 
{
    while (!MQTT.connected()) 
    {
        Serial.print("* Tentando se conectar ao Broker MQTT: ");
        Serial.println(BROKER_MQTT);
        
        
        if (MQTT.connect(ID_MQTT, "***", "****")) 
        {
            Serial.println("Conectado com sucesso ao broker MQTT!");
            
        } 
        else
        {
            Serial.println("Falha ao reconectar no broker.");
            Serial.println("Havera nova tentatica de conexao em 2s");
            Serial.println(MQTT.state());
            Serial.println(MQTT.getWriteError());
            delay(2000);
        }
    }
}
 
 void verifica_conexoes_wifi_mqtt(void)
{
    /* se não há conexão com o WiFI, a conexão é refeita */
    reconnect_wifi(); 
    /* se não há conexão com o Broker, a conexão é refeita */
    if (!MQTT.connected()) 
        reconnect_mqtt(); 
} 
