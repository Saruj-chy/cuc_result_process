import 'package:flutter/material.dart';

import '../file/color_cuc.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppbar({Key? key, required this.title, this.fontSize=25, this.actions=null, this.implyLeading=true }) : super(key: key);
  final String title;
  final double fontSize;
  final List<Widget>? actions;
  final bool implyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorCUC.purple100,
      title: Text(
        title,
        style: TextStyle(
            color: ColorCUC.purple900,
            fontWeight: FontWeight.bold,
            fontSize: fontSize),
      ),
      actions: actions,
      automaticallyImplyLeading: implyLeading,

    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

