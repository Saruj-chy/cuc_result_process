import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../file/color_cuc.dart';
import '../../file/constant.dart';
import '../../layout/InitializeMethod.dart';
import 'dashboard_admin.dart';


class ResultInsertExcel extends StatefulWidget {
  const ResultInsertExcel({Key? key, required this.sess_id}) : super(key: key);
  final sess_id;

  @override
  State<ResultInsertExcel> createState() => _ResultInsertExcelState();
}

class _ResultInsertExcelState extends State<ResultInsertExcel> {
  String selectFilesName="", filesExtension="", msgFile = "" ;
  String? filePath;
  bool fileView = false, fileDetails = false, fileError = true, isProgressShow = false;
  int countFilesInsert=0, totalStuList=0;

  @override
  void initState() {
    super.initState();


  }
  void PickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile fileItem = result.files.first;
      setState(() {
        selectFilesName = fileItem.name;
        filesExtension = fileItem.extension!;
        fileDetails = true;
      });
      filePath = fileItem.path;
      try{
        var bytes = File(filePath!).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          var rowList = excel.tables[table]!.rows;
          print(rowList.length) ;

          var field = rowList[0];
          String msg="";
          fileError = false;
          print(field[0]?.value) ;
          print(field[1]?.value) ;
          print(field[2]?.value) ;
          print(field.length) ;
          for (var i=0; i<7; i++) {
            print(field[i]?.value) ;
            if(i==0 && ((field[0]?.value).toString()== "Group Subject Id")){
              msg += ' Group Subject Id : Valid  \n';
            } else if(i==1  && field[1]!.value.toString() == "Exam Id"){
              msg += ' Exam Id : Valid \n';
            } else if(i==2 && field[2]!.value.toString() == "Group Id"){
              msg += ' Group Id : Valid \n';
            } else if(i==3 && field[3]!.value.toString() == "Roll"){
              msg += ' Roll : Valid \n';
            } else if(i==4 && field[4]!.value.toString() == "CQ"){
              msg += ' CQ : Valid \n';
            } else if(i==5 && field[5]!.value.toString() == "MCQ"){
              msg += ' MCQ : Valid \n';
            } else if(i==6 && field[6]!.value.toString() == "Practical"){
              msg += ' Practical : Valid \n';
            } else{
              msg += " ${field[i]!.value} : Not Invalid \n";
              fileError= true;
            }
          }
          print(msg) ;
          setState(() {
            totalStuList = rowList.length;
            msgFile = msg;
          });

        }
      }catch(e){
        print(e);
        ToastMsg("$e");
      }

    }
  }

  Future<void> InsertStuResultFiles() async {
    isProgressShow= true;
    try{
      var bytes = File(filePath!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        var rowList = excel.tables[table]!.rows;
        totalStuList = rowList.length;
        print("--------------------------------------------------");
        print(totalStuList);
        for (var i=1; i<totalStuList; i++) {
          List<String> rowData = [] ;
          print(rowList[i].length) ;
          for (var cell in rowList[i]) {
            if (cell != null) {
              final value = cell.value;
              print("============="+value.toString());
              rowData.add(value.toString());
            }
          }
          Timer(
            const Duration(seconds: 5),
                () {
              InsertResultValue(rowData, i) ;
            },
          );
        }
      }
    }catch(e){
      ToastMsg("$e");
      print(e) ;
    }
  }
  Future<void> InsertResultValue(rowData, i) async {
    try{
      String currentDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
      var url = Uri.parse(Constant.put_insert_result_url);
      final response = await http.post(url, body: {
        "state": "4",
        "auth_token": authToken,
        "phn_num": phnNum,
        "grp_sub_id": rowData[0],
        "exam_id": rowData[1],
        "roll": rowData[3],
        "grp_id": rowData[2],
        "sess_id": widget.sess_id,
        "cq": rowData[4],
        "mcq": rowData[5],
        "practical": rowData[6],
        "current_date_time": currentDateTime,
      });
      var jsonResponse = json.decode(response.body);
      print(jsonResponse.toString()) ;
      if (response.statusCode == 200 && jsonResponse["error"] == false) {
        setState(() {
          countFilesInsert+=1;
        });
        if(i==(totalStuList-1)){
          ToastMsg("Result in files of ${countFilesInsert} data insert successfully") ;
          Navigator.of(context).pop() ;
          isProgressShow= false;
        }
      } else {
        ToastMsg(jsonResponse["msg"]);
      }

    }catch(e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(title: "Insert Excel Result",),
      body: SafeArea(
        child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: SingleChildScrollView(
                  child: !isProgressShow ? Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: const Text("This section is included to insert multiple student result based on one or more subject. Please follow the instructions in excel files, otherwise the data is not insert. ",
                          style: TextStyle(color: Colors.red, fontSize: 16,),
                          textAlign: TextAlign.justify,
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Material(
                          color: ColorCUC.purple300,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () async {
                              PickExcelFile();
                            },
                            minWidth: 800.0,
                            height: 42.0,
                            child: Text(
                              "Select Excel File",
                              style:
                              const TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 20,),
                      fileDetails?Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Files Name:  $selectFilesName "),
                          Text("Files Extension:  $filesExtension "),
                          Text("Total Student:  $totalStuList "),
                          Text("\n Verify: \n$msgFile "),
                        ],
                      ): Container(),
                      const SizedBox(
                        height: 30.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Material(
                          color: ColorCUC.purple400,
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5.0,
                          child: MaterialButton(
                              onPressed: () {
                                if(fileError){
                                  ToastMsg("The File is not valid, Please Select Valid File.");
                                }else{
                                  InsertStuResultFiles() ;
                                }

                              },
                              minWidth: 150.0,
                              height: 42.0,
                              child:const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              )
                          ),
                        ),
                      ),
                    ],
                  ): VisibilityShow(height, isProgressShow),
                ),
              ),
            ]
        ),
      ),

    );
  }

}

