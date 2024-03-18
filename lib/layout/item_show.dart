import 'package:cuc_result_processing/file/color_cuc.dart';
import 'package:flutter/material.dart';

class ItemShow extends StatelessWidget {
  const ItemShow({Key? key, required this.title, required this.onTap}) : super(key: key);
  final String title;
  final GestureTapCallback? onTap ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10),
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: ColorCUC.purple300,
            color: ColorCUC.purple300,
            elevation: 7.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat',),
                ),
              ),
            ),
          )),
    );
  }
}