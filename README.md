## Projeto: Monitoramento de Temperatura com Flutter e Arduino via MQTT


Este projeto demonstra a integração de um dispositivo Arduino, equipado com um sensor de temperatura, com um aplicativo Flutter através do protocolo MQTT. O Arduino coleta dados de temperatura e publica esses dados em um tópico MQTT. O aplicativo Flutter, por sua vez, se inscreve nesse tópico e exibe os dados de temperatura em tempo real em sua interface.

### Tecnologias Utilizadas

* **Flutter:** Framework para desenvolvimento de aplicativos móveis multiplataforma.
* **Dart:** Linguagem de programação utilizada no Flutter.
* **Arduino:** Plataforma de prototipagem eletrônica.
* **MQTT:** Protocolo de comunicação leve para a Internet das Coisas (IoT).
* **Mosquitto**: Servidor MQTT utilizado para a comunicação entre o Arduino e o aplicativo Flutter.