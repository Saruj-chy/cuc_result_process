import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/sess_model.dart';
import 'package:cuc_result_processing/components/admin_components/result_sheet_print_screen.dart';
import 'package:cuc_result_processing/layout/InitializeMethod.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../bloc_components/grp_model.dart';
import '../../file/color_cuc.dart';
import '../../file/constant.dart';
import '../../layout/edit_text_field.dart';
import 'dashboard_admin.dart';

class ResultSheetFieldScreen extends StatefulWidget {
  const ResultSheetFieldScreen(
      {Key? key,

      })
      : super(key: key);

  @override
  State<ResultSheetFieldScreen> createState() => _ResultSheetFieldScreenState();
}

class _ResultSheetFieldScreenState extends State<ResultSheetFieldScreen> {
  String sessName="Select Session",    examName="Select Exam";
  int sessId=0, examId=0, sess_id=0 ;
  late Future<SessModel> sessModel;
  late Future<GrpModel> examModel ;

  var textCont1 = TextEditingController();
  var textCont2 = TextEditingController();
  var textCont3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    sessModel = fetchSessList();
  }

  Future<void> _PrintTabulationSheet() async{
    String text1=textCont1.text.trim();
    String text2=textCont2.text.trim();
    String text3=textCont3.text.trim();

    if(sess_id>0 && examId>0){
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ResultSheetPrintScreen(
                  text1: text1,
                  text2: text2,
                  text3: text3,
                  sess_id: sess_id.toString(),
                  exam_id: examId.toString(),
                  sess_name: sessName
              )
      ));

      // if(examId==1){
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) =>
      //           ResultSheetPrintScreen(
      //             text1: text1,
      //             text2: text2,
      //             text3: text3,
      //             sess_id: sess_id.toString(),
      //             exam_id: examId.toString(),
      //               sess_name: sessName
      //           )
      //   ));
      // }else{
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) =>
      //           ResultSheetPrintScreen(
      //             text1: text1,
      //             text2: text2,
      //             text3: text3,
      //             sess_id: sessId.toString(),
      //             exam_id: examId.toString(),
      //             sess_name: sessName
      //           )
      //   ));
      // }

    }else{
      ToastMsg("Please fill up all fields") ;
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title:"Result Sheet Details",),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100,),
                Material(
                  color: ColorCUC.purple300,
                  borderRadius:
                  const BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      _showSessDialog();
                    },
                    minWidth: 800.0,
                    height: 42.0,
                    child: Text(
                      sessName,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Material(
                  color: ColorCUC.purple300,
                  borderRadius:
                  const BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      if(sessId>0){
                        examModel = fetchExamsList(sessId) ;
                        _showExamDialog(sessId);
                      }else{
                        ToastMsg("Select the session");
                      }

                    },
                    minWidth: 800.0,
                    height: 42.0,
                    child: Text(
                      examName,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),


                EditTextField(
                  textController: textCont1,
                  hintText: "Enter Pdf Name",
                  keyBoardType: TextInputType.text,
                ),
                EditTextField(
                  textController: textCont2,
                  hintText: "Enter Exam Name",
                  keyBoardType: TextInputType.text,
                ),
                EditTextField(
                  textController: textCont3,
                  hintText: "Enter Exam Date",
                  keyBoardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: ColorCUC.purple300,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        _PrintTabulationSheet();
                      },
                      minWidth: 150.0,
                      height: 42.0,
                      child: const Text(
                        'Print',
                        style: TextStyle(color: Colors.white),
                      ),
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
  Future<void> _showSessDialog() async {
    var width = MediaQuery.of(context).size.width;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Session's Name",
            style: TextStyle(fontSize: 22, color: ColorCUC.purple900,),),
          actions: <Widget>[
            SizedBox(
              width: width,
              height: 200,
              child: FutureBuilder<SessModel>(
                future: sessModel,
                builder: (context, snapshot) {
                  List<String> sessList = [];
                  List<int> sessIdList = [];
                  if (snapshot.hasData) {
                    final sessArray = snapshot.data!.data;
                    for (var sess in sessArray) {
                      final name = sess.name;
                      sessList.add(name) ;
                      sessIdList.add(int.parse(sess.id)) ;
                    }
                    return ListView.builder(
                        itemCount: sessList.length,
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                              child:
                              Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: ColorCUC.purple300,
                                    color: ColorCUC.purple300,
                                    elevation: 7.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                      child: Center(
                                        child: Text(
                                          sessList[i],
                                          style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat',),
                                        ),
                                      ),
                                    ),
                                  )),
                              onTap: () {
                                setState(() {
                                  sessName = sessList[i];
                                  sessId = i+1;
                                  sess_id = sessIdList[i] ;
                                  Navigator.of(context).pop() ;
                                });
                              }
                          );
                        });
                  }

                  return Container();
                },

              ),
            ),

          ],
        );
      },
    );
  }
  Future<void> _showExamDialog(int sessId) async {
    var width = MediaQuery.of(context).size.width;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exam's Name",
            style: TextStyle(fontSize: 22, color: ColorCUC.purple900,),),
          actions: <Widget>[
            SizedBox(
              width: width,
              height: 200,
              child: FutureBuilder<GrpModel>(
                future: examModel,
                builder: (context, snapshot) {
                  List<String> examList = [];
                  if (snapshot.hasData) {
                    final examsArray = snapshot.data!.data;
                    for (var exam in examsArray) {
                      final name = exam.name;
                      examList.add(name) ;
                    }
                    return ListView.builder(
                        itemCount: examList.length,
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                              child:
                              Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: ColorCUC.purple300,
                                    color: ColorCUC.purple300,
                                    elevation: 7.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                      child: Center(
                                        child: Text(
                                          examList[i],
                                          style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat',),
                                        ),
                                      ),
                                    ),
                                  )),
                              onTap: () {
                                setState(() {
                                  examName = examList[i];
                                  sessId!=2? examId = i+1 : examId = i+3;
                                  Navigator.of(context).pop() ;
                                });
                              }
                          );
                        });
                  }

                  return Container();
                },

              ),
            ),

          ],
        );
      },
    );
  }

}

