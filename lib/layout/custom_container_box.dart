import 'package:flutter/material.dart';

class CustomContainerBox extends StatelessWidget {
  const CustomContainerBox({Key? key, required this.child, this.horizontal=25.0, this.vertical=10.0}) : super(key: key);
  final Widget child;
  final double horizontal, vertical;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return  Container(
        margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [BoxShadow(blurRadius: 2.0, color: Colors.grey)]),
        child: child,
    );
  }
}
