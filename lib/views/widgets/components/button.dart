import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/constants/constant.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: primaryClr,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: white,
            ),
          ),
        ),
      ),
    );
  }
}
