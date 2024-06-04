import 'package:flutter/material.dart';

Widget H1Heading({required String heading,} ){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      heading,
      style: TextStyle(fontSize: 25, ),
    ),
  );
}
Widget H2Heading({required String heading}){
  return Padding(
    padding: const EdgeInsets.only(left: 10.0,top: 10,bottom: 2),
    child: Text(
      heading,
      style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
    ),
  );
}
Widget H3Heading({required String heading} ){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      heading,
      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
    ),
  );
}