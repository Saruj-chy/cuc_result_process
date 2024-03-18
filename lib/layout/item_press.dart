import 'package:flutter/material.dart';

import '../file/color_cuc.dart';

class ItemPress extends StatelessWidget {
  const ItemPress({Key? key, required this.onTap, required this.title}) : super(key: key);
  final GestureTapCallback? onTap ;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, left: 10, bottom: 20.0, right: 10),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 7.0,
          child: Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: ColorCUC.purple900,),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
