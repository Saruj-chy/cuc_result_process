import 'package:flutter/material.dart';

import '../file/color_cuc.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(top: 0.0, left: 0, bottom: 0.0, right: 0),
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 7.0,
        child: Container(
          margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20, right: 20),
          // color: Colors.deepOrange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: ColorCUC.purple900,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
