import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  const LogoText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              // color: Colors.green,
              image: const DecorationImage(
                  image: AssetImage("images/cuc_logo.png")
              )
          ),
        ),
        const SizedBox(height: 10,),
        const  Text(
          "CUC Result Processing System",
          style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 22,
              color: Color(0xFF5E35B1),
              letterSpacing: 1,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
