import 'dart:convert';

import 'package:cuc_result_processing/components/teacher_components/stu_result_page.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../bloc_components/stu_model.dart';
import '../../file/color_cuc.dart';
import '../../layout/InitializeMethod.dart';
import '../../layout/custom_appbar.dart';
import 'dashboard_teacher.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key, required this.sess_id, required this.grp_sub_id, required this.exam_id, required this.grp_id }) : super(key: key);
  final sess_id, grp_id, grp_sub_id, exam_id;

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late Future<StudentModel> studentModel ;
  bool error = true;

  @override
  void initState() {
    super.initState();

    studentModel = fetchStudentList(phnNum!, authToken!, widget.grp_id.toString()) ;
  }

  Future<StudentModel> fetchStudentList(String phnNum, String authToken, String grpId) async {
    var url = Uri.parse(Constant.grp_stu_url);
    final response = await http
        .post(url,
        body: {
          "auth_token": authToken,
          "phn_num": phnNum,
          "grp_id": grpId,
          "sess_id": widget.sess_id
        });
    var jsonResponse = json.decode(response.body);
    print(jsonResponse["data"]);
    if (response.statusCode == 200 && !jsonResponse["error"] ) {
      setState(() {
        error = jsonResponse["error"] ;
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
      appBar: const CustomAppbar(title: "Student Roll",),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              error? VisibilityShow(height, error) : _StuVertical(context, studentModel, widget, width),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _StuVertical(BuildContext context, Future<StudentModel> studentModel, StudentPage widget, double width) {
  return Container(
    margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
    width: width,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(blurRadius: 2.0, color: Colors.grey)]),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: FutureBuilder<StudentModel>(
        future: studentModel,
        builder: (context, snapshot) {
          List<Widget> textWidgets = [];
          if (snapshot.hasData) {
            final itemsArray = snapshot.data!.data;
            for (var item in itemsArray) {
              final id = item.id;
              final roll = item.roll;


              final widgets = _itemStuWidget(context,
                  id,
                  widget.exam_id,
                  widget.grp_sub_id,
                  roll) ;
              textWidgets.add(widgets);
            }
            return
              GridView.count(
                crossAxisCount: 3,
                primary: false,
                crossAxisSpacing: 2.0,
                // mainAxisSpacing: 4.0,
                shrinkWrap: true,
                children:textWidgets
              );

          }

          return const SizedBox(
            height: 5.0,
          );
        },
      ),
    ),
  );
}

Widget _itemStuWidget(
    BuildContext context, String id, String examId, String grpSubId, String roll) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              StudentResultPage(
                stu_id: id,
                grp_sub_id: grpSubId,
                exam_id: examId,)));

    },
    child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: ColorCUC.purple900,
          color: ColorCUC.purple100,
          elevation: 7.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
            child: Center(
              child: Text(
                roll,
                style: const TextStyle(color: ColorCUC.purple900,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontFamily: 'Montserrat',),
              ),
            ),
          ),
        )),



  );
}

