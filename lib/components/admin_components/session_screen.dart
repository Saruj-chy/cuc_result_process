import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/grp_model.dart';
import 'package:cuc_result_processing/components/admin_components/all_stu_screen.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../file/color_cuc.dart';
import '../../layout/InitializeMethod.dart';
import '../../layout/edit_text_field.dart';
import 'dashboard_admin.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({Key? key}) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  bool visibility = true;
  bool error = true;
  late Future<GrpModel> grpModel;

  @override
  void initState() {
    super.initState();
    grpModel = fetchSessList();
  }

  Future<GrpModel> fetchSessList() async {
    var url = Uri.parse(Constant.put_sess_url);
    final response = await http.post(url,
        body: {"auth_token": authToken, "phn_num": phnNum, "state": "1"});
    if (response.statusCode == 200) {
     var jsonResponse = json.decode(response.body);
      setState(() {
        visibility = false;
        error = jsonResponse["error"];
      });
      return GrpModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Session",),
      body: SafeArea(
        child: !error
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: FutureBuilder<GrpModel>(
                        future: grpModel,
                        builder: (context, snapshot) {
                          List<Widget> textWidgets = [];
                          if (snapshot.hasData) {
                            final itemsArray = snapshot.data!.data;
                            int posi = 1;
                            for (var item in itemsArray) {
                              final id = item.id;
                              final name = item.name;
                              final textView =
                                  _itemSessWidget(context, id, name, posi);
                              textWidgets.add(textView);
                              posi += 1;
                            }
                            return ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              children: textWidgets,
                            );
                          }

                          return const SizedBox(
                            height: 5.0,
                          );
                        },
                      ),
                    ),

                  ],
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
          _showInsertSessDialog();
        },
        backgroundColor: ColorCUC.purple900,
        child: const Icon(Icons.add, color: Colors.white,size: 40,),
      ),
    );
  }

  Future<void> _showInsertSessDialog() async {
    var nameController = TextEditingController();

    Future<void> NewInsertSession() async {
      name = nameController.text.trim();
      if (name != "") {
        try{
          var url = Uri.parse(Constant.put_sess_url);
          final response = await http.post(url, body: {
            "state": "2",
            "phn_num": phnNum,
            "auth_token": authToken,
            "sess_name": name,
          });
          var jsonResponse = json.decode(response.body);
          ToastMsg(jsonResponse["msg"]);
          if(jsonResponse["error"] == false){
            Navigator.pushNamed(context, DashboardAdmin.id);
          }else{
            Navigator.of(context).pop();
          }
        }catch(e){
          Navigator.pushNamed(context, DashboardAdmin.id);
        }

      } else {
        ToastMsg("Please fillup the session name");
      }
    }
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Insert Session"),
          actions: <Widget>[
            Container(
              child:
              Column(
                children: [
                  EditTextField(
                    textController: nameController,
                    hintText: "Enter Session Name...",
                    keyBoardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      color: ColorCUC.purple900,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(30.0)),
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () async {
                          NewInsertSession();
                        },
                        minWidth: 150.0,
                        height: 42.0,
                        child: const Text(
                          'Insert',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _itemSessWidget(
      BuildContext context, String id, String itemName, int posi) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AllStuScreen(
                sess_id: id,
              year: posi
                )));
      },
      onLongPress: (){
        showAlertDialog(context, id) ;
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 10, bottom: 20.0, right: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 7.0,
          child: Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            // color: Colors.deepOrange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(

                  height: 90.0,
                  width: 90.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      // color: Colors.green,
                      image: const DecorationImage(
                        image: AssetImage("images/cuc_logo.png"),
                      )),
                ),
                const SizedBox(width: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Year - $posi",
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                      ),
                    ),

                    const Text(
                      "Session ",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FDottedLine(
                      color: const Color(0xFF512DA8),
                      width: 150.0,
                      strokeWidth: 5.0,
                      dottedLength: 15.0,
                      space: 5.0,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      itemName,
                      style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black),
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
showAlertDialog(BuildContext context, String sessId) {
  Widget noButton = TextButton(
    child: const Text("No"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget yesButton = TextButton(
    child: const Text("Yes"),
    onPressed:  () async {
      try{
        var url = Uri.parse(Constant.put_sess_url);
        final response = await http.post(url, body: {
          "state": "3",
          "phn_num": phnNum,
          "auth_token": authToken,
          "sess_id": sessId,
        });
        var jsonResponse = json.decode(response.body);
        ToastMsg(jsonResponse["msg"]);
        if(jsonResponse["error"] == false){
          Navigator.pushNamed(context, DashboardAdmin.id);
        }else{
          Navigator.of(context).pop();
        }
      }catch(e){
        Navigator.pushNamed(context, DashboardAdmin.id);
      }

    },
  );

  // set up the AlertDialog
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

