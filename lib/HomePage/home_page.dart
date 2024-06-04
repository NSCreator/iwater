// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iwater/add_devices/add_device.dart';
import 'package:iwater/add_devices/all_devices.dart';
import 'package:iwater/functions.dart';
import 'package:iwater/text_properties.dart';

import '../test.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "iWater",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AllDevices()));
                    },
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            H2Heading(heading: "My Devices"),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => IWater()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            "https://mlhobevaucyf.i.optimole.com/w:1200/h:742/q:mauto/f:best/ig:avif/https://novo3ds.in/wp-content/uploads/2023/06/AG281_Water_pump_3.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add some spacing between the image and the text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "OutSide Garden Pump",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Last Turn on at 4 days ago",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w300),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 5, top: 5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Text("More Analytics"),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5, top: 5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Text("Turn On"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                H2Heading(heading: "Try More Devices"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.keyboard_arrow_right),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IWater extends StatefulWidget {
  const IWater({super.key});

  @override
  State<IWater> createState() => _IWaterState();
}

class _IWaterState extends State<IWater> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(
                  isColorBlack: true,
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Aligned to the start
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.black12,
                        height: 120,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            "https://mlhobevaucyf.i.optimole.com/w:1200/h:742/q:mauto/f:best/ig:avif/https://novo3ds.in/wp-content/uploads/2023/06/AG281_Water_pump_3.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Added spacing between image and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5, top: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Text("More Analytics"),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5, top: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Text("Turn On"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                H2Heading(heading: "Graphs"),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Container(
                        color: Color.fromRGBO(6, 19, 48, 1),
                        child: LineChartSample2()),
                  ),
                ),
                H2Heading(heading: "Members"),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount: 4,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        Expanded(
                          child: Text(
                            "Sujith",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 20),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 60.0,right: 20),
                    child: SizedBox(
                      height: 5,
                      child: Divider(
                        color: Colors.black54,
                        thickness: 0.1,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
