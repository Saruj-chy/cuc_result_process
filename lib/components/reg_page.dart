import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/subs_model.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/InitializeMethod.dart';
import 'package:cuc_result_processing/layout/account_text.dart';
import 'package:cuc_result_processing/layout/item_show.dart';
import 'package:cuc_result_processing/layout/logo_text.dart';
import 'package:cuc_result_processing/layout/sign_btn.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../file/color_cuc.dart';
import '../layout/edit_text_field.dart';
import 'login_page.dart';

String sub_name = "";
String subName = "Select a Subject";

class RegistrationPage extends StatefulWidget {
  static String id = "registration";
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool error = true;
  late Future<SubsModel> subsModel;
  bool showProgress = true;
  var nameController = TextEditingController();
  var phnNumController = TextEditingController();
  var passController = TextEditingController();
  var confirmPassController = TextEditingController();
  String grpId = "0";
  String grpValue = "Select Group Name";
  late String name, phnNum, pass, confirmPass;
  var arraySubsList;



  @override
  void initState() {
    super.initState();
    subsModel = fetchSubsList();
    subName = "Select a Subject";
    sub_name = "Select a Subject";
  }

  String getCategoryList(arraySubsList, String grpId, String name) {
    for (var value in arraySubsList) {
      String temp = value.name + " " + value.title;
      if (temp == name && value.grp_id == grpId) {
        return value.id;
      }
    }
    return "0";
  }

  Future<void> NewRegClick() async {
    name = nameController.text.trim();
    phnNum = phnNumController.text.trim();
    pass = passController.text.trim();
    confirmPass = confirmPassController.text.trim();
    String grpSubId = "0";
    if (arraySubsList != null) {
      grpSubId = getCategoryList(arraySubsList, grpId, sub_name);
    }
    if (name != "") {
      if (await ValidateMobile(phnNum) && phnNum.length==11) {
        if (pass.length > 7) {
          if(pass == confirmPass){
            if (int.parse(grpSubId) > 0) {
              setState(() {
                showProgress = true;
              });

            } else {
              ToastMsg("Please select the subject");
            }
          }else{
            ToastMsg("Password and Confirm Password not match");
          }
        } else {
          ToastMsg("password at least 8 characters");
        }
      }else{
        ToastMsg("Please correct the phone number");
      }
    } else {
      ToastMsg("Please fill up the name");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50,),
                  LogoText(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  EditTextField(
                    textController: nameController,
                    hintText: "Enter teacher's name",
                    keyBoardType: TextInputType.text,
                  ),
                  EditTextField(
                    textController: phnNumController,
                    hintText: "Enter phone number",
                    keyBoardType: TextInputType.phone,
                  ),
                  EditTextField(
                      textController: passController,
                      hintText: "Enter password",
                      keyBoardType: TextInputType.text,
                      isObscure: true),
                  EditTextField(
                      textController: confirmPassController,
                      hintText: "Enter confirm password",
                      keyBoardType: TextInputType.text,
                      isObscure: true),
                  DropdownButton(
                    alignment: AlignmentDirectional.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    iconSize: 30.0,
                    hint: const Text("Select a Group"),
                    style: const TextStyle(
                      color: ColorCUC.purple900,
                      fontSize: 20,
                    ),
                    isExpanded: true,
                    value: grpValue,
                    items: grp_items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      subName = "Select a Subject";
                      sub_name = "Select a Subject";
                      setState(() {
                        grpValue = newValue.toString();

                        if (newValue == grp_items[1]) {
                          grpId = "1";
                        } else if (newValue == grp_items[2]) {
                          grpId = "2";
                        } else if (newValue == grp_items[3]) {
                          grpId = "3";
                        }else{
                          grpId = "0";
                        }
                      });

                    },
                  ),
                  if (!error) ...[
                    FutureBuilder<SubsModel>(
                      future: subsModel,
                      builder: (context, snapshot) {
                        List<ItemShow> textWidgets = [];
                        if (snapshot.hasData) {
                          final subsArray = snapshot.data!.data;
                          arraySubsList = subsArray;
                          for (var subs in subsArray) {
                            final name = subs.name;
                            final title = subs.title;
                            if (grpId == subs.grp_id) {
                              final textView = ItemShow(
                                title: "$name $title",
                                onTap: (){
                                  sub_name = "$name $title";
                                  Navigator.of(context).pop(false);
                                },
                              );
                              textWidgets.add(textView);
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              color: ColorCUC.purple300,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30.0)),
                              elevation: 5.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  _showMyDialog(textWidgets);
                                },
                                minWidth: 800.0,
                                height: 42.0,
                                child: Text(
                                  subName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 22),
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          // return Text('${snapshot.error}');
                        }

                        // By default, show a loading spinner.
                        return const SizedBox(
                          height: 5.0,
                        );
                      },
                    ),
                  ],

                  const SizedBox(
                    height: 50.0,
                  ),
                  SignButton(title: "Sign Up", onPress: () {
                    NewRegClick();
                  }),

                  AccountText(
                      title: "Already have an account?",
                      onTap: () {
                        Navigator.pushNamed(context, LoginPage.id);
                      }),
                  const SizedBox(height: 50,),
                ],
              ),
            ),
          ),
          VisibilityShow(MediaQuery.of(context).size.height, showProgress),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(List<ItemShow> widgets) async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Subject's Name",
            style: TextStyle(fontSize: 22, color: ColorCUC.purple900,),),
          actions: <Widget>[
            SizedBox(
              width: width,
              height: height - 300,
              child: ListView(
                // reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                children: widgets,
              ),
            ),
          ],
        );
      },
    )..then((val) {
        setState(() {
          subName = sub_name;
        });
      });
  }
}
