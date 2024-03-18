import 'dart:convert';

import 'package:cuc_result_processing/components/reg_page.dart';
import 'package:cuc_result_processing/layout/account_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../file/constant.dart';
import '../layout/InitializeMethod.dart';
import '../layout/edit_text_field.dart';
import '../layout/logo_text.dart';
import '../layout/sign_btn.dart';

class LoginPage extends StatefulWidget {
  static String id = "login" ;
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  var phnNumController = TextEditingController();
  var passController = TextEditingController();
  var phnNum, pass;
  bool showProgress = false;
  var jsonResponse ;


  Future<void> isLoggedUser() async {
    phnNum = phnNumController.text.trim() ;
    pass = passController.text.trim() ;

    if(await ValidateMobile(phnNum)){
      if(pass.toString().length>7){
        setState(() {
          showProgress = true;
        });

      }else{
        ToastMsg("Password at least 8 characters");
      }
    }


  }
  void sharedLoginDataSaved(jsonResponse) {
    sharedSaveData("name", jsonResponse["data"]["name"]);
    sharedSaveData("phn_num", jsonResponse["data"]["phn_num"]);
    sharedSaveData("auth_token", jsonResponse["auth_token"]);
    sharedSaveData("user_id", jsonResponse["data"]["id"]);
    sharedSaveData("role_id", jsonResponse["data"]["role_id"]);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      onPopInvoked: (didPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      LogoText(),
                      const SizedBox(
                        height: 100,
                      ),
                      EditTextField(textController: phnNumController, hintText: "Enter your phone number", keyBoardType: TextInputType.phone,),
                      EditTextField(textController: passController, hintText: "Enter your password", keyBoardType: TextInputType.text, isObscure: true,),
                      const SizedBox(
                        height: 50,
                      ),
                      SignButton(title: "Sign In", onPress: ()  {
                        isLoggedUser() ;
                      }),
                      AccountText(
                          title: "create a new account?",
                          onTap: () {
                            Navigator.pushNamed(context, RegistrationPage.id) ;
                          }),
                    ],
                  ),
                ),
              ),
              VisibilityShow(MediaQuery.of(context).size.height, showProgress)
            ],
          ),
        ),
      ),
    );
  }
}




