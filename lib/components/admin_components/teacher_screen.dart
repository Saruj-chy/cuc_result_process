import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/teacher_model.dart';
import 'package:cuc_result_processing/components/admin_components/dashboard_admin.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../file/color_cuc.dart';
import '../../file/constant.dart';
import '../../layout/InitializeMethod.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  bool visibility = false;
  late Future<TeacherModel> teacherModel;
  bool updateUser = false ;

  @override
  void initState() {
    super.initState();
    teacherModel = fetchSubsList() ;
  }
  Future<TeacherModel> fetchSubsList() async {
    var url = Uri.parse(Constant.put_teacher_url);
    var jsonResponse;
    final response = await http
        .post(url, body: {
          "auth_token": authToken,
      "phn_num": phnNum,
      "state": "1"
        });
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        visibility = true;
      });
      return TeacherModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(title: "Teacher's Details",),

      body: SafeArea(
        child: visibility
            ? SingleChildScrollView(
          child: Container(
            height: height - 100,
            child: FutureBuilder<TeacherModel>(
              future: teacherModel,
              builder: (context, snapshot) {
                List<Widget> textWidgets = [];
                if (snapshot.hasData) {
                  final itemsArray = snapshot.data!.data;
                  for (var item in itemsArray) {
                    final userId = item.id;
                    final roleId = item.role_id;
                    final roleName = item.role_name;
                    final teacherName = item.teacher_name;
                    final phnNum = item.phn_num;
                    final textView = _itemWidget(context, userId, roleId, roleName, teacherName, phnNum);
                    textWidgets.add(textView);
                  }
                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    children: textWidgets,
                  );
                }

                return const SizedBox(
                  height: 5.0,
                );
              },
            ),
          ),
        )
            : Visibility(
          visible: visibility,
          child: Container(
            color: Colors.grey.withOpacity(0.5),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            updateUser = !updateUser;
            if(updateUser){
              ToastMsg("You can now update the user");
            }
          });
        },
        child: const Icon(Icons.update, color: Colors.white,size: 40,),
        backgroundColor: ColorCUC.purple900,
      ),
    );
  }

  Widget _itemWidget(BuildContext context, String userId, String roleId, String roleName, String teacherName, String phnNum) {
    Future<void> _showMyDialog(String roleName) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return MyAlertDialog(user_id:userId, role_id:roleId, role_name: roleName,);

        },
      );
    }
    return GestureDetector(
      onTap: () {
        if(updateUser){
          _showMyDialog(roleName);
        }
      },
      onLongPress: (){
        showAlertDialog(context, userId);
      },
      child: Padding(
        padding:
        const EdgeInsets.only(top: 10.0, left: 10, bottom: 10.0, right: 10),
        child: Card(
          color: updateUser ? ColorCUC.green200 : ColorCUC.purple50,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 7.0,
          child: Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Expanded(
                      flex: 1,
                      child: Container(
                    height: 90.0,
                    width: 90.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        // color: Colors.green,
                        image: const DecorationImage(
                            image: AssetImage("images/user.png")
                        )
                    ),
                  )),
                  Expanded(
                      flex: 2,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacherName,
                        style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: ColorCUC.purple900),
                      ),
                      Text(
                        roleName,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                            color: ColorCUC.purple700
                        ),
                      ),
                      Text(
                        phnNum,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                            color: ColorCUC.purple700
                        ),
                      ),
                    ],
                  )),
                ]),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
showAlertDialog(BuildContext context, String userId) {
  Widget noButton = TextButton(
    child: const Text("No"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget yesButton = TextButton(
    child: const Text("Yes"),
    onPressed:  () async {
      var url = Uri.parse(Constant.put_teacher_url);
      var jsonResponse ;
      final response = await http.post(url, body: {
        "state": "3",
        "phn_num": phnNum,
        "auth_token": authToken,
        "user_id": userId,
      });
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        ToastMsg(jsonResponse["msg"]);
      } else {
        ToastMsg(jsonResponse["msg"]);
      }
      Navigator.pushNamed(context, DashboardAdmin.id);

    },
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Delete User"),
    content: const Text("Are you sure to want to delete this user?"),
    actions: [
      noButton,
      yesButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class MyAlertDialog extends StatefulWidget {
  final role_name, role_id, user_id;

  const MyAlertDialog({Key? key, required this.user_id, required this.role_id, required this.role_name}) : super(key: key);


  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  bool _adminBG = false;
  int role_id=0;

  Future<void> RoleUpdate(int roleId) async {
    if(roleId.toString() != widget.role_id && roleId>0){
      var url = Uri.parse(Constant.put_teacher_url);
      var jsonResponse ;
      final response = await http.post(url, body: {
        "state": "2",
        "phn_num": phnNum,
        "auth_token": authToken,
        "user_id": widget.user_id,
        "role_id": roleId.toString(),
      });
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        ToastMsg(jsonResponse["msg"]);
        Navigator.of(context).pop();
      } else {
        ToastMsg(jsonResponse["msg"]);
        throw Exception('Failed to load post');
      }
    }else{
      Navigator.of(context).pop();
    }

  }

  @override
  Widget build(BuildContext context) {
    if(widget.role_name =="Teacher" && role_id ==0){
      _adminBG = false;
    }else if(widget.role_name =="Admin" && role_id ==0){
      _adminBG = true;
    }
    return AlertDialog(
      title: const Text("Role's Update",style: TextStyle(
          fontSize: 22,
          color: ColorCUC.purple900,
          fontWeight: FontWeight.bold),),
      actions: [
        GestureDetector(
            child:
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: ColorCUC.purple300,
                  color: _adminBG ? Colors.green :Colors.white ,
                  elevation: 7.0,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Center(
                      child: Text(
                        "Admin",
                        style: TextStyle(color: Colors.black87, fontSize: 18, fontFamily: 'Montserrat',),
                      ),
                    ),
                  ),
                )),
            onTap: () {
              setState(() {
                _adminBG=true;
                role_id = 1;
              });
            }
        ),
        const SizedBox(
          height: 20,
        ),

        GestureDetector(
            child:
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: ColorCUC.purple300,
                  color: _adminBG ? Colors.white :Colors.green,
                  elevation: 7.0,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Center(
                      child: Text(
                        "Teacher",
                        style: TextStyle(color: Colors.black87, fontSize: 18, fontFamily: 'Montserrat',),
                      ),
                    ),
                  ),
                )),
            onTap: () {
              setState(() {
                _adminBG = false;
                role_id = 2 ;
              });
            }
        ),
        const SizedBox(
          height: 50,
        ),

        ElevatedButton(onPressed: (){
          RoleUpdate(role_id) ;
        },
            child: const Text("Update")
        ),


      ],
    );
  }
}




