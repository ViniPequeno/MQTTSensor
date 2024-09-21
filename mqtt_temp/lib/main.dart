import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_temp/card_sensor.dart';
import 'package:mqtt_temp/sensor.dart';

import 'graph.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Sensor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MQTT Sensor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MqttServerClient? client;

  List<Sensor> valores = List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initServer();
  }

  void initServer() async {
    print("Init server");

    client = MqttServerClient.withPort('0.0.0.0', 'flutter_client', 1883);
    client!.keepAlivePeriod = 60;
    client!.secure = false;
    client!.securityContext = SecurityContext.defaultContext;

    final connMessage = MqttConnectMessage().authenticateAs('****', '****');
    client!.connectionMessage = connMessage;

    try {
      print('Connecting');
      await client!.connect();
      print("connected");

      client!.subscribe("mqtt/temp", MqttQos.atMostOnce);

      client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        try {
          final recMessage = c![0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(
              recMessage.payload.message);
          print('YOU GOT A NEW MESSAGE:');
          print('Received message:$payload from topic: ${c[0].topic}');
          setState(() {
            var json = jsonDecode(payload);
            var sensor = Sensor.fromJson(DateTime.now(), json);
            valores.add(sensor);
          });
        } catch (e) {
          print('Exception: $e');
        }
      });
    } catch (e) {
      print('Exception: $e');
      client!.disconnect();
    }
  }

  String getTemp() {
    var value = "-";
    if (valores.isNotEmpty) {
      value = "${valores.last.temp} C°";
    }

    return value;
  }

  String getUmi() {
    var value = "-";
    if (valores.isNotEmpty) {
      value = "${valores.last.umi} %";
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardSensor(
                      iconData: Icons.cloud,
                      sensor: "Temperatua",
                      value: getTemp()),
                  CardSensor(
                      iconData: Icons.water_drop,
                      sensor: "Umidade",
                      value: getUmi())
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              LineChartSensor(
                valores: valores.length > 10
                    ? valores.skip(valores.length - 10).take(10).toList()
                    : valores,
              )
            ],
          ),
        ));
  }
}
