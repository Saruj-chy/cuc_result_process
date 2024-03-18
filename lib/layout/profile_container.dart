import 'package:flutter/material.dart';

import '../file/color_cuc.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({Key? key, required this.title, required this.phnNum}) : super(key: key);
  final String title, phnNum ;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin:
      const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
      width: width,
      decoration: BoxDecoration(
          color: ColorCUC.purple50,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
                blurRadius: 2.0, color: Colors.grey)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(
                30.0, 30.0, 10.0, 5.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: ColorCUC.purple900,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                40.0, 0.0, 10.0, 30.0),
            child: Text(
              "+880-${phnNum}",
              style: const TextStyle(
                  color: ColorCUC.purple900,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0),
            ),
          )
        ],
      ),
    );
  }
}
