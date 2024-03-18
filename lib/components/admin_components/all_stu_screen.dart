import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/stu_model.dart';
import 'package:cuc_result_processing/components/admin_components/admin_exam_screen.dart';
import 'package:cuc_result_processing/components/admin_components/insert_student_screen.dart';
import 'package:cuc_result_processing/components/admin_components/result_insert_excel.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../file/color_cuc.dart';
import '../../file/constant.dart';
import '../../layout/InitializeMethod.dart';
import 'dashboard_admin.dart';

class AllStuScreen extends StatefulWidget {
  final sess_id, year;
  const AllStuScreen({Key? key, required this.sess_id, required this.year}) : super(key: key);

  @override
  State<AllStuScreen> createState() => _AllStuScreenState();
}

class _AllStuScreenState extends State<AllStuScreen> {
  bool visibility = true;
  bool error = true;
  late Future<StudentModel> stuModel;
  var assignGrpId = 1;
  bool updateState = false;
  @override
  void initState() {
    super.initState();
    stuModel = fetchStuList();
  }

  Future<StudentModel> fetchStuList() async {
    var url = Uri.parse(Constant.put_stu_url);
    var jsonResponse;
    final response = await http.post(url, body: {
      "auth_token": authToken,
      "phn_num": phnNum,
      "state": "1",
      "sess_id": widget.sess_id
    });
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        visibility = false;
        error = jsonResponse["error"];
      });
      return StudentModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppbar(title: "Student",),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            assignGrpId = 1;
                          });
                        },
                        child: const Text(
                          "Science",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: ColorCUC.purple900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            assignGrpId = 2;
                          });
                        },
                        child: const Text(
                          "Business Studies",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: ColorCUC.purple900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            assignGrpId = 3;
                          });
                        },
                        child: const Text(
                          "Humanities",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: ColorCUC.purple900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ResultInsertExcel(
                                sess_id: widget.sess_id,
                              )));
                        },
                        child: const Icon(
                          Icons.add,
                          color: ColorCUC.purple900,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(blurRadius: 2.0, color: Colors.grey)
                  ]),
              child: Container(
                child: !error
                    ? Container(
                  height: height-200,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: FutureBuilder<StudentModel>(
                        future: stuModel,
                        builder: (context, snapshot) {
                          List<Widget> textWidgets = [];
                          if (snapshot.hasData) {
                            final itemsArray = snapshot.data!.data;
                            for (var item in itemsArray) {
                              final roll = item.roll;
                              final grpId = item.grp_id;
                              final stuId = item.id;
                              if (grpId == assignGrpId.toString()) {
                                final textView = _itemStuWidget(
                                    context, stuId, roll, updateState);
                                textWidgets.add(textView);
                              }
                            }
                            return GridView.count(
                                crossAxisCount: 3,
                                // primary: false,
                                crossAxisSpacing: 2.0,
                                shrinkWrap: true,
                                children: textWidgets);
                          }

                          return const SizedBox(
                            height: 5.0,
                          );
                        },
                      ),
                    )
                    : Visibility(
                        visible: visibility,
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "update",
            onPressed: () {
            setState(() {
              updateState = !updateState;
            });
            },
            backgroundColor: ColorCUC.purple900,
            child: const Icon(
              Icons.update,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "add",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InsertStudentScreen(
                        sess_id: widget.sess_id,
                    updateState: false,
                      )));
            },
            backgroundColor: ColorCUC.purple900,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
  Widget _itemStuWidget(BuildContext context, String stuId, String roll, bool updateState) {
    return GestureDetector(
      onTap: () {
        updateState ?
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InsertStudentScreen(
              sess_id: widget.sess_id,
              stu_id: stuId,
              updateState: true,
            ))):
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AdminExamScreen(
              sess_id: widget.sess_id,
              year: widget.year,
              grp_id: assignGrpId,
              stu_id: stuId,
            )));
      },
      onLongPress: () {
        showDeleteDialog(context, stuId);
      },
      child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: ColorCUC.purple900,
            color: updateState? ColorCUC.red100: ColorCUC.purple100,
            elevation: 7.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5),
              child: Center(
                child: Text(
                  roll,
                  style: const TextStyle(
                    color: ColorCUC.purple900,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          )),
    );
  }

}

showDeleteDialog(BuildContext context, String stuId) {
  Widget noButton = TextButton(
    child: const Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget yesButton = TextButton(
    child: const Text("Yes"),
    onPressed: () async {
      var url = Uri.parse(Constant.put_stu_url);
      final response = await http.post(url, body: {
        "state": "2",
        "phn_num": phnNum,
        "auth_token": authToken,
        "stu_id": stuId,
      });
      var jsonResponse = json.decode(response.body);
      ToastMsg(jsonResponse["msg"]);
      if (jsonResponse["error"] == false) {
        Navigator.of(context).pop() ;

      } else {
        Navigator.of(context).pop();
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Delete Student"),
    content: const Text("Are you sure to want to delete this student?"),
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


