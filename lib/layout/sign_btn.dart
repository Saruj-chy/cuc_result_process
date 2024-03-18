import 'package:flutter/material.dart';

import '../file/color_cuc.dart';

class SignButton extends StatelessWidget {
  const SignButton({Key? key, required this.title, required this.onPress}) : super(key: key);
  final String title;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: ColorCUC.purple300,
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 150.0,
          height: 42.0,
          child: Text(
            "$title",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
