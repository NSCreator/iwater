import 'dart:async';
import 'dart:convert'; // Import this for JSON encoding and decoding
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController messageController = TextEditingController();
  List receivedMessages = [];
  var latestReceivedMessage;
  late MqttServerClient client;

  @override
  void initState() {
    super.initState();
    initAWS();
  }

  Future<void> initAWS() async {
    const url = 'a28b3s8j1j5rji-ats.iot.eu-north-1.amazonaws.com';
    const port = 8883;
    const clientId = 'iotconsole-56a03faf-121d-4fba-a4b2-79a6444a4b57';

    client = MqttServerClient.withPort(url, clientId, port);

    client.secure = true;
    client.keepAlivePeriod = 20;
    client.setProtocolV311();
    client.logging(on: false);

    final context = SecurityContext.defaultContext;
    ByteData rootCA = await rootBundle.load('assets/rootCA.pem');
    ByteData DeviceCert = await rootBundle.load('assets/device.pem.crt');
    ByteData PrivateKey = await rootBundle.load('assets/private.pem.key');
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(DeviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(PrivateKey.buffer.asUint8List());
    client.securityContext = context;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(
        'iotconsole-56a03faf-121d-4fba-a4b2-79a6444a4b57')
        .startClean();
    client.connectionMessage = connMess;

    try {
      print('MQTT client connecting to AWS IoT using certificates....');
      await client.connect();
    } on Exception catch (e) {
      print('MQTT client exception - $e');
      client.disconnect();
      exit(-1);
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected to AWS IoT');

      client.subscribe('esp32/device01', MqttQos.atLeastOnce);


      client.published!.listen((MqttPublishMessage message) {
        print('Message sent successfully');
      });
      client.updates!.listen(
            (List<MqttReceivedMessage<MqttMessage>> c) {
          final recMess = c[0].payload as MqttPublishMessage;
          final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          final Map<String, dynamic> jsonMap =
          jsonDecode(pt) as Map<String, dynamic>;
          setState(() {
            receivedMessages.add(jsonMap);
            latestReceivedMessage = jsonMap;
          });
        },
      );
    } else {
      print(
          'ERROR MQTT client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }
  }

  void sendJsonMessage(String message) {
    final time = DateTime.now().toIso8601String();
    final jsonMessage = jsonEncode({'message': message, 'time': time});
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonMessage);
    const topic = 'esp32/device01';
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('MQTT Example')),
        body: Column(
          children: [
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Enter Message'),
            ),
            ElevatedButton(
              onPressed: () {
                String message = messageController.text;
                if (message.isNotEmpty) {
                  sendJsonMessage(message);
                  messageController.clear();
                }
              },
              child: const Text('Send Message'),
            ),
            const Text('Latest Received Message:'),
            if (latestReceivedMessage != null)
              ListTile(
                title: Text(latestReceivedMessage!.toString()),

              ),
            const Text('All Received Messages:'),
            Expanded(
              child: ListView.builder(
                itemCount: receivedMessages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(receivedMessages[index].toString()),

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
