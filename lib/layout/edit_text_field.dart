import 'package:flutter/material.dart';

class EditTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final TextInputType keyBoardType ;
  final bool isObscure;
  final bool isRead;
  const EditTextField({Key? key,
    required this.textController,
    required this.hintText,
    required this.keyBoardType,
    this.isObscure=false,
    this.isRead=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(left: 10, right: 10, top: 20),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),

          ]
      ),
      child: TextField(
        readOnly: isRead?true:false,
        obscureText: isObscure?true:false,
        keyboardType: keyBoardType,
        controller: textController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: hintText,
            //hintText,
            hintText: hintText,
            // prefixIcon
            // prefixIcon: Icon(icon, color:Colors.yellow),
            //focusedBorder
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 0.0,
                  color:Colors.white,
                )
            ),
            //enabled Border
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 0.0,
                  color:Colors.white,
                )
            ),
            // enabledBorder
            //
            // border
            border:OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),

            )
        ),
      ),
    );
  }
}