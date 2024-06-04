import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
Future<void> showToastText(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      fontSize: 18,
      timeInSecForIosWeb: 3
  );
}

class backButton extends StatelessWidget {
  String text;
  bool isColorBlack;

  backButton({super.key, this.text = "", this.isColorBlack=false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color:isColorBlack? Colors.black:Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 20,
                    color:isColorBlack? Colors.white:Colors.black87,
                  ),
                  Text(
                    "back ",
                    style: TextStyle(fontSize: 16, color:isColorBlack? Colors.white:Colors.black87,),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
