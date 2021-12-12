import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/constants/constant.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Get.isDarkMode ? white : grey,
          ),
        ),
        title: Text(
          label.toString().split("|")[0],
          style: TextStyle(
            color: Get.isDarkMode ? white : black,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 350,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Get.isDarkMode ? white : Colors.grey[400],
          ),
          child: Center(
            child: Text(
              label.toString().split("|")[1],
              style: TextStyle(
                  color: Get.isDarkMode ? black : white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
