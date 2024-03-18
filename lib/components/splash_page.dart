import 'dart:async';
import 'package:cuc_result_processing/file/color_cuc.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 5),
          () {
        Navigator.pushNamed(context, LoginPage.id) ;
      },
    );

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorCUC.purple50,
        body: SafeArea(

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 25,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

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

                    const SizedBox(height: 50,),
                    const Text(
                      "CUC",
                      style: TextStyle(
                          fontFamily: 'Source Sans Pro',
                          fontSize: 40,
                          color: ColorCUC.purple900,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10,),

                    const Text(
                      "Result Processing System",
                      style: TextStyle(
                          fontFamily: 'Source Sans Pro',
                          fontSize: 18,
                          color: ColorCUC.purple900,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),

                  ],
                ),),

                const Expanded(
                  flex: 1,
                  child: Text(
                    "©Powered by ICT cell, University of Chittagong",
                    style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 14,
                        color: ColorCUC.purple900,
                        letterSpacing: 1,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
