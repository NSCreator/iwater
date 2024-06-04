// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iwater/Functions/TextField.dart';
import 'package:iwater/HomePage/home_page.dart';
import 'package:iwater/controllers/iwater/iwater_v1.dart';
import 'package:iwater/functions.dart';
import 'package:iwater/text_properties.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddDevice extends StatefulWidget {
  String collectionName;

  AddDevice({required this.collectionName});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  IWaterConvertor? data;
  bool _isLoading = true;
  String? _errorMessage;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();

    if (controller != null) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    } else {
      print("Controller is null");
    }
  }

  @override
  void initState() {
    super.initState();

  }

  bool isQRCodeReading = true;
  bool isSuccess = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController updatePasswordController =
      TextEditingController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            backButton(isColorBlack: true),
            if (isQRCodeReading)
              Container(
                padding: EdgeInsets.all(5),
                height: 300,
                width: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
            if (!isQRCodeReading)
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isQRCodeReading = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          H2Heading(heading: "Reload"),
                        ],
                      ),
                    ),
                  ),
                  if (data == null)
                    Center(child: CircularProgressIndicator())
                  else
                    Column(
                      children: [
                        Center(
                          child: Text('Document Data: ${data!.toJson()}'),
                        ),
                        Stepper(
                          currentStep: _index,
                          steps: <Step>[
                            Step(
                              title: const Text('Device Conformation'),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextFieldContainer(
                                      heading:
                                      data?.deviceDetails.updatedPassword.isEmpty ??
                                          true
                                          ? "Initial Password"
                                          : "Password",
                                      controller: passwordController,
                                      hintText: 'Enter Password',
                                      obscureText: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              title: Text('Device Details'),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Name : ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        TextSpan(
                                          text: data!.deviceDetails.name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Model : ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        TextSpan(
                                          text: data!.deviceDetails.model,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Date of Manufacturing : ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        TextSpan(
                                          text: data!.deviceDetails.dom,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                                title: Text('Update Password'),
                                content: Row(
                                  children: [
                                    Expanded(
                                      child: TextFieldContainer(
                                        heading: "Update Password",
                                        controller: updatePasswordController,
                                        hintText: 'Enter Password',
                                        obscureText: false,
                                      ),
                                    ),
                                  ],
                                )),
                            Step(
                                title: Text('Final Step'),
                                content: Text("Successfully Completed")),
                          ],
                          controlsBuilder: (BuildContext context, ControlsDetails details) {
                            if (_index == 0) {
                              return Row(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      if (data != null &&
                                          (data!.deviceDetails.updatedPassword ==
                                              passwordController.text ||
                                              data!.deviceDetails.initialPassword ==
                                                  passwordController.text)) {
                                        setState(() {
                                          isSuccess = true;
                                        });
                                      } else {
                                        showToastText("Wrong Password");
                                      }
                                      if (isSuccess)
                                        setState(() {
                                          _index += 1;
                                        });
                                    },
                                    child: const Text('Next'),
                                  ),
                                ],
                              );
                            } else if (_index == 1) {
                              return Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _index += 1;
                                      });
                                    },
                                    child: TextButton(
                                      onPressed: details.onStepContinue,
                                      child: const Text('NEXT'),
                                    ),
                                  ),
                                ],
                              );
                            } else if(_index==2){
                              return Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      if (data != null) {
                                        final updatedPassword =
                                            updatePasswordController.text;
                                        data!.deviceDetails.updatedPassword =
                                            updatedPassword;

                                        try {
                                          await _firestore
                                              .collection(widget.collectionName)
                                              .doc(data!.id)
                                              .update({
                                            'deviceDetails':data!.deviceDetails.toJson()
                                          });
                                          print('Password updated successfully');
                                        } catch (e) {
                                          print('Error updating password: $e');
                                        }
                                      }
                                      setState(() {
                                        _index += 1;
                                      });
                                    },
                                    child: TextButton(
                                      onPressed: details.onStepContinue,
                                      child: const Text('Submit'),
                                    ),
                                  ),
                                ],
                              );
                            }else{
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),

                ],
              ),


          ],
        ),
      ),
    );
  }

  Future<void> _fetchDocument({required String docName}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(widget.collectionName).doc(docName).get();
      if (documentSnapshot.exists) {
        final docData = documentSnapshot.data() as Map<String, dynamic>;
        print(docData);
        setState(() {
          data = IWaterConvertor.fromJson(docData);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Document does not exist';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching document: $e';
        _isLoading = false;
      });
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        isQRCodeReading = false;
        _fetchDocument(docName: result!.code.toString());
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
