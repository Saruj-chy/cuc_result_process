import 'package:cuc_result_processing/file/color_cuc.dart';
import 'package:flutter/material.dart';

class AccountText extends StatelessWidget {
  const AccountText({Key? key, required this.title, required this.onTap}) : super(key: key);
  final String title;
  final GestureTapCallback? onTap ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
            fontFamily: 'Source Sans Pro',
            fontSize: 15,
            color: ColorCUC.purple900,
            letterSpacing: 2.5,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
