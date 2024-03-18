// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cuc_result_processing/layout/InitializeMethod.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../bloc_components/unique_sub_model.dart';
import '../../file/color_cuc.dart';
import '../../file/constant.dart';
import '../../layout/edit_text_field.dart';
import 'dashboard_admin.dart';

String sub_name = "";
String subName = "Select Optional subject";
int subNameId = 0;

class InsertStudentScreen extends StatefulWidget {
  final sess_id, stu_id, updateState;

  const InsertStudentScreen(
      {Key? key,
      required this.sess_id,
      this.stu_id = "",
      required this.updateState})
      : super(key: key);

  @override
  State<InsertStudentScreen> createState() => _InsertStudentScreenState();
}

class _InsertStudentScreenState extends State<InsertStudentScreen> {
  var nameController = TextEditingController();
  var rollController = TextEditingController();
  String? name, roll;
  bool fileView = false, fileDetails = false, fileError = true, isProgressShow = false;

  String grpValue = "Select Group Name";
  var grp_items = ['Select Group Name', 'Science', 'Commerce', 'Arts'];
  String grpId = "1";
  late Future<UniqueSubsModel> subsModel;
  var arraySubsList;
  String? subId;
  String selectFilesName="", filesExtension="", msgFile = "" ;
  String? filePath;
  int countFilesInsert=0, totalStuList=0;

  @override
  void initState() {
    super.initState();
    subsModel = fetchSubsList();
    subNameId = 0;
    subName = "Select Optional subject";
    sub_name = "Select Optional subject";

    if (widget.updateState) {
      fetchStudentData();
    }

    // nameController.text = widget.sess_id ;
  }

  Future<UniqueSubsModel> fetchSubsList() async {
    var url = Uri.parse(Constant.put_sub_list_url);
    final response = await http.post(url, body: {
      "auth_token": authToken,
      "phn_num": phnNum,
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      return UniqueSubsModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> fetchStudentData() async {
    var url = Uri.parse(Constant.put_new_stu_url);
    final response = await http.post(url, body: {
      "state": "2",
      "auth_token": authToken,
      "phn_num": phnNum,
      "stu_id": widget.stu_id,
      "sess_id": widget.sess_id,
    });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200 && jsonResponse["error"] == false) {
      setState(() {
        nameController.text = jsonResponse["data"]["name"];
        rollController.text = jsonResponse["data"]["roll"];
        grpId = jsonResponse["data"]["grp_id"];
        grpValue = grp_items[int.parse(grpId)];
        subNameId = int.parse(jsonResponse["data"]["optional_sub_id"]);

        if (subNameId != 0) {
          sub_name = jsonResponse["op_sub"]["name"];
          subName = jsonResponse["op_sub"]["name"];
        }
      });
    } else {
      ToastMsg('Failed to load');
    }
  }

  Future<void> NewInsertStudent() async {
    name = nameController.text.trim();
    roll = rollController.text.trim();

    if (subNameId > 0) {
      if (name != "" && roll != "") {
        var url = Uri.parse(Constant.put_new_stu_url);
        final response = await http.post(url, body: {
          "state": "1",
          "auth_token": authToken,
          "phn_num": phnNum,
          "name": name,
          "roll": roll,
          "sess_id": widget.sess_id,
          "grp_id": grpId,
          "optional_sub_id": subNameId.toString(),
        });
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse["error"] == false) {
          ToastMsg(jsonResponse["msg"]);
          Navigator.of(context).pop() ;
        } else {
          ToastMsg(jsonResponse["msg"]);
          throw Exception('Failed to load post');
        }
      } else {
        ToastMsg("Please fill up the empty field...");
      }
    } else {
      ToastMsg("Select Optional subject");
    }
  }


  Future<void> UpdateNewStudent() async {
    if (subNameId > 0) {
      var url = Uri.parse(Constant.put_new_stu_url);
      final response = await http.post(url, body: {
        "state": "3",
        "auth_token": authToken,
        "phn_num": phnNum,
        "stu_id": widget.stu_id,
        "sess_id": widget.sess_id,
        "optional_sub_id": subNameId.toString(),
      });
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse["error"] == false) {
        ToastMsg("Update Student Successfully");
        Navigator.of(context).pop() ;
      } else {
        ToastMsg("Update Student Failed");
        throw Exception('Failed to load post');
      }
    } else {
      ToastMsg("Select Optional subject");
    }
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
          var field = rowList[0];
          String msg="";
          fileError = false;
          print(rowList.length) ;
          for (var i=0; i<field.length; i++) {
            print(field[i]!.value.toString());
            if(i==0 && ((field[0]?.value).toString()== "Sl.")){
              msg += ' Sl. : Valid  \n';
            } else if(i==1  && field[1]!.value.toString() == "Name"){
              msg += ' Name : Valid \n';
            } else if(i==2 && field[2]!.value.toString() == "Roll"){
              msg += ' Roll : Valid \n';
            } else if(i==3 && field[3]!.value.toString() == "Group Id"){
              msg += ' Group Id : Valid \n';
            } else if(i==4 && field[4]!.value.toString() == "Optional Subject Id"){
              msg += ' Optional Subject Id : Valid \n';
            } else{
              msg += " ${field[i]!.value} : Not Invalid \n";
              fileError= true;
            }
          }
          setState(() {
            totalStuList = rowList.length;
            msgFile = msg;
          });
        }
      }catch(e){
        ToastMsg("$e");
      }
    }
  }
  Future<void> InsertStuFiles() async {
    isProgressShow= true;
    try{
      var bytes = File(filePath!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        var rowList = excel.tables[table]!.rows;
        totalStuList = rowList.length;
        for (var i=0; i<totalStuList; i++) {
          List<String> rowData = [] ;
          for (var cell in rowList[i]) {
            final value = cell!.value;
            rowData.add(value.toString());
          }
          Timer(
            const Duration(seconds: 5),
                () {
                  InsertOneStudent(rowData, i) ;
            },
          );

        }
      }
    }catch(e){
      ToastMsg("$e");
    }
    
  }
  Future<void> InsertOneStudent(rowData, i) async {
    try{
      var url = Uri.parse(Constant.put_new_stu_url);
      final response = await http.post(url, body: {
        "state": "1",
        "auth_token": authToken,
        "phn_num": phnNum,
        "name": rowData[1],
        "roll": rowData[2],
        "sess_id": widget.sess_id,
        "grp_id": rowData[3],
        "optional_sub_id": rowData[4],
      });
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse["error"] == false) {
        setState(() {
          countFilesInsert+=1;
        });
        if(i==(totalStuList-1)){
          ToastMsg("All student data in files insert successfully") ;
          Navigator.of(context).pop() ;
          isProgressShow= false;
        }

      } else {
        ToastMsg(jsonResponse["msg"]);
      }
    }catch(e){
      print('Failed to insert student: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.updateState ? "Update Student" : "New Student Insert",
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_drive_file, color: ColorCUC.purple900, size: 40,),
            onPressed: () {
              setState(() {
                fileView = !fileView;
                filePath = "";
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: !isProgressShow? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: !fileView?
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                EditTextField(
                  textController: nameController,
                  hintText: "Enter Student's Name",
                  keyBoardType: TextInputType.text,
                  isRead: widget.updateState,
                ),
                EditTextField(
                  textController: rollController,
                  hintText: "Enter Roll Number",
                  keyBoardType: TextInputType.number,
                  isRead: widget.updateState,
                ),
                DropdownButton(
                  alignment: AlignmentDirectional.center,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  iconSize: 30.0,
                  // focusColor: Colors.red,
                  // dropdownColor: Colors.green,
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
                  onChanged: widget.updateState
                      ? null
                      : (String? newValue) {
                    setState(() {
                      grpValue = newValue.toString();
                    });
                    subNameId = 0;
                    subName = "Select Optional subject";
                    sub_name = "Select Optional subject";

                    if (newValue.toString() == grp_items[1]) {
                      setState(() {
                        grpId = "1";
                      });
                      // subsmodel = fetchSubsList();
                    } else if (newValue.toString() == grp_items[2]) {
                      setState(() {
                        grpId = "2";
                      });
                      // subsmodel = fetchSubsList(grpId);
                    } else if (newValue.toString() == grp_items[3]) {
                      setState(() {
                        grpId = "3";
                      });
                      // subsmodel = fetchSubsList(grpId);
                    } else {
                      grpId = "1";
                    }
                  },
                ),
                FutureBuilder<UniqueSubsModel>(
                  future: subsModel,
                  builder: (context, snapshot) {
                    List<TextView> textWidgets = [];
                    if (snapshot.hasData) {
                      final subsArray = snapshot.data!.data;
                      arraySubsList = subsArray;
                      for (var subs in subsArray) {
                        final id = subs.id;
                        final name = subs.name;
                        if (grpId == subs.grp_id) {
                          final textView = TextView(
                            id: id,
                            name: name,
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
                              style:
                              const TextStyle(color: Colors.white, fontSize: 22),
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
                const SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: ColorCUC.purple500,
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        widget.updateState
                            ? UpdateNewStudent()
                            : NewInsertStudent();
                      },
                      minWidth: 150.0,
                      height: 42.0,
                      child: Text(
                        widget.updateState ? "Update" : 'Submit',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            )
                :
            Container(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Text("This section is included to insert multiple student data from an Excel file. This excel file belongs these fields serially such as Sl., Name, Roll, Group Id, Optional Subject Id. If any of the item missing or serially break, then the system will not accept the data from the excel file.",
                      style: TextStyle(color: Colors.red, fontSize: 16,),
                      textAlign: TextAlign.justify,
                    ),
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
                          PickExcelFile();
                        },
                        minWidth: 800.0,
                        height: 42.0,
                        child: const Text(
                          "Select Excel File",
                          style:
                          TextStyle(color: Colors.white, fontSize: 22),
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
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      color: ColorCUC.purple500,
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: ()  {
                          if(fileError){
                            ToastMsg("The File is not valid, Please Select Valid File.");
                          }else{
                            InsertStuFiles();
                          }
                        },
                        minWidth: 150.0,
                        height: 42.0,
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ):
          VisibilityShow(height, isProgressShow),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(List<TextView> widgets) async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Subject's Name",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColorCUC.purple900,
            ),
          ),
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

class TextView extends StatefulWidget {
  const TextView({Key? key, required this.name, required this.id})
      : super(key: key);
  final String id, name;

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        sub_name = widget.name;
        subNameId = int.parse(widget.id);
        Navigator.of(context).pop(false);
      },
      child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10),
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: ColorCUC.purple300,
            color: ColorCUC.purple300,
            elevation: 7.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Center(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
