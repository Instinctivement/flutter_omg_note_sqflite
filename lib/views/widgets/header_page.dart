import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/constants/constant.dart';
import 'package:flutter_omg_note_sqflite/views/widgets/components/button.dart';
import 'package:intl/intl.dart';

class HeaderPage extends StatelessWidget {
  const HeaderPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle,
            ),
            Text(
              "Aujourd'hui",
              style: headingStyle,
            ),
          ],
        ),
        MyButton(label: "+ Tache", onTap: () {})
      ],
    );
  }
}
