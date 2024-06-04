// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert'; // Import this for JSON encoding and decoding
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iwater/auth_pages/logIn_page.dart';
import 'package:iwater/settings/settings_page.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'HomePage/home_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(  debugShowCheckedModeBanner: false,
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BottomNavigationPage();
        } else {
          return LoginPage();
        }
      },
    ),));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if(_selectedIndex==0)HomePage(),
          if(_selectedIndex==1)SettingsPage(),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BottomIcon(Icons.home_filled, "Home", 0),
                        BottomIcon(Icons.manage_accounts, "Account", 1),

                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // _pageController.animateToPage(
      //   index,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.ease,
      // );
    });
  }

  Widget BottomIcon(IconData icon, String heading, int index) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: index == _selectedIndex ? 30 : 25,
            color: index == _selectedIndex ? Colors.black : Colors.black54,
          ),
          Text(
            heading,
            style: TextStyle(
                color:
                index == _selectedIndex ? Colors.black87 : Colors.black54,
                fontSize: index == _selectedIndex ? 12 : 10),
          )
        ],
      ),
    );
  }
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
        .withClientIdentifier('iotconsole-56a03faf-121d-4fba-a4b2-79a6444a4b57')
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

      client.subscribe('/test/topic', MqttQos.atLeastOnce);

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

            if (jsonMap["message"] == "on") {
              isPumpOn = true;
            } else if (jsonMap["message"] == "off") {
              isPumpOn = false;
            }
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

  bool isPumpOn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Water Pump",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    sendJsonMessage(isPumpOn ? "off" : "on");
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        color: isPumpOn ? Colors.greenAccent : Colors.black12,
                        borderRadius: BorderRadius.circular(100)),
                    alignment: Alignment.center,
                    child: Text(
                      "On & Off",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
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
      ),
    );
  }
}
