import 'dart:convert';

import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../file/color_cuc.dart';
import '../../layout/InitializeMethod.dart';
import '../../layout/edit_text_field.dart';
import 'dashboard_admin.dart';

class StudentResultScreen extends StatefulWidget {
  const StudentResultScreen({Key? key, required this.stu_id, required this.grp_sub_id, required this.exam_id,}) : super(key: key);
  final stu_id, grp_sub_id, exam_id;

  @override
  State<StudentResultScreen> createState() => _StudentResultScreenState();
}

class _StudentResultScreenState extends State<StudentResultScreen> {
  var cqController = TextEditingController();
  var mcqController = TextEditingController();
  var practicalController = TextEditingController();
  var res_id, update_number, cq, mcq, practical, userId, dbDateTime;

  bool showProgress = false, update= false, updateAccess = false, isRead = false;

  @override
  void initState() {
    super.initState();

    fetchResult() ;

  }
  Future<void> fetchResult() async {
    var url = Uri.parse(Constant.put_insert_result_url);
    var jsonResponse ;
    final response = await http
        .post(url,
        body: {
          "state": "2",
          "auth_token": authToken,
          "phn_num": phnNum,
          "stu_id": widget.stu_id,
          "grp_sub_id": widget.grp_sub_id,
          "exam_id": widget.exam_id
        });
    jsonResponse = json.decode(response.body);
    update = !jsonResponse["error"];
    if (response.statusCode == 200 && !update == false) {
             setState(() {
          userId = jsonResponse["data"]["user_id"];
            res_id = jsonResponse["data"]["id"];
            update_number = jsonResponse["data"]["update_number"];
            cqController.text = jsonResponse["data"]["cq"];
            mcqController.text = jsonResponse["data"]["mcq"];
            practicalController.text = jsonResponse["data"]["practical"];
            dbDateTime = jsonResponse["data"]["current_date_time"];

            dateDiffer(dbDateTime);
        });
    }
  }

  void dateDiffer(dbDateTime){
    String currentDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    DateTime date1 = DateTime.parse(dbDateTime);
    DateTime date2 = DateTime.parse(currentDateTime);

    int day = daysBetween(date1, date2);
    if(day<3 || Constant.AUTHORITY =="Admin"){
      setState(() {
        updateAccess = true;
        isRead = false;
      });
    }else{
      setState(() {
        updateAccess= false ;
        isRead = true;
      });
    }

  }
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<void> InsertResultValue(String state) async {
    String currentDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    cq = cqController.text.trim() ;
    mcq = mcqController.text.trim() ;
    practical = practicalController.text.trim() ;
    if(cq =="" && mcq=="" && practical==""){
      ToastMsg("Please enter the value") ;
    }else{
      setState(() {
        showProgress = true ;
      });
      var url = Uri.parse(Constant.put_insert_result_url);
      var jsonResponse ;
      final response = await http
          .post(url,
          body: {
            "state": state,
            "auth_token": authToken,
            "phn_num": phnNum,
            "stu_id": widget.stu_id,
            "grp_sub_id": widget.grp_sub_id,
            "exam_id": widget.exam_id,
            "cq": cq,
            "mcq": mcq,
            "practical": practical,
            "current_date_time": currentDateTime,
          });
      jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse["error"] == false) {

        setState(() {
          showProgress = false ;
        });
        ToastMsg(jsonResponse["msg"]);
        Navigator.of(context).pop() ;
        // return SubsModel.fromJson(jsonResponse);
      } else {
        ToastMsg("Insert Failed");
        throw Exception('Failed to load post');
      }
      setState(() {
        showProgress = false ;
      });
    }
  }
  Future<void> UpdateResultValue(String state) async {
    cq = cqController.text.trim() ;
    mcq = mcqController.text.trim() ;
    practical = practicalController.text.trim() ;
    int updateNumber = int.parse(update_number)+1;
    if(cq =="" && mcq=="" && practical==""){
      ToastMsg("Please enter the value") ;
    }else{
      setState(() {
        showProgress = true ;
      });
      var url = Uri.parse(Constant.put_insert_result_url);
      final response = await http
          .post(url,
          body: {
            "state": state,
            "auth_token": authToken,
            "phn_num": phnNum,
            "stu_id": widget.stu_id,
            "grp_sub_id": widget.grp_sub_id,
            "exam_id": widget.exam_id,
            "res_id": res_id,
            "update_number": "$updateNumber",
            "cq": cq,
            "mcq": mcq,
            "practical": practical,
          });

      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse["error"] == false) {

        setState(() {
          showProgress = false ;
        });
        ToastMsg(jsonResponse["msg"]);
        Navigator.of(context).pop() ;
      } else {
        ToastMsg("Update Failed");
      }
      setState(() {
        showProgress = false ;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(title: "Student Result",),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 100,
                    ),
                    EditTextField(textController: cqController, hintText: "Enter CQ number",
                      keyBoardType: TextInputType.number, isRead: isRead,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EditTextField(textController: mcqController, hintText: "Enter MCQ number",
                      keyBoardType: TextInputType.number,isRead: isRead,),
                    const SizedBox(
                      height: 20,
                    ),
                    EditTextField(textController: practicalController, hintText: "Enter Practical number",
                      keyBoardType: TextInputType.number,isRead: isRead,),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Material(
                        color: ColorCUC.purple400,
                        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            if(!update){
                              showDeleteDialog(context, update);
                            }else{
                              if(!updateAccess){
                                ToastMsg("72 hours passed. You are not allowed to update the result.");
                              }else{
                                showDeleteDialog(context, update);
                              }
                            }
                          },
                          minWidth: 150.0,
                          height: 42.0,
                          child: !update ? const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ): const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VisibilityShow(height, showProgress),
          ]
        ),
      ),

    );
  }
  showDeleteDialog(BuildContext context, bool update) {
    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed: ()  {
        Navigator.of(context).pop();
        if(!update){
          InsertResultValue("1");
        }else{
          UpdateResultValue("3");
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: update ? const Text("Update Student") : const Text("Insert Result"),
      content: const Text("Are you check the provide result?"),
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

}

