// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iwater/add_devices/add_device.dart';
import 'package:iwater/functions.dart';
import 'package:iwater/text_properties.dart';

class AllDevices extends StatefulWidget {
  const AllDevices({super.key});

  @override
  State<AllDevices> createState() => _AllDevicesState();
}

class _AllDevicesState extends State<AllDevices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(
              isColorBlack: true,
            ),
            H1Heading(heading: "Devices"),
            SizedBox(
              height: 20,
            ),
            H3Heading(heading: "i-Water Devices"),
            SizedBox(
              height: 180,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddDevice(collectionName: 'iwater',)));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(25)),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(23),
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                          "https://mlhobevaucyf.i.optimole.com/w:1200/h:742/q:mauto/f:best/ig:avif/https://novo3ds.in/wp-content/uploads/2023/06/AG281_Water_pump_3.jpg",
                                        ),fit: BoxFit.cover)),)),
                            Text("I-Water $index"),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
