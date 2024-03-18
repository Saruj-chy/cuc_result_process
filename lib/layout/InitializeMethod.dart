import 'package:cuc_result_processing/file/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/admin_components/dashboard_admin.dart';
import '../components/teacher_components/dashboard_teacher.dart';
import '../file/color_cuc.dart';


var grp_items = ['Select Group Name', 'Science', 'Business Studies', 'Humanities'];

Future<bool> ValidateMobile(String value) async {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    ToastMsg("Please enter mobile number");
    return false;
  }
  else if (!regExp.hasMatch(value)) {
    ToastMsg('Please enter valid mobile number') ;
    return false;
  }
  return true;
}


Future<bool?> ToastMsg(String msg) {
  return Fluttertoast.showToast(
      msg:msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
Visibility VisibilityShow (double height, bool visibility) {
  return Visibility(
    visible: visibility,
    child: Container(
      color: ColorCUC.purple100.withOpacity(0.5),
      child: SizedBox(
        height: height,
        child: const Center(
          child: CircularProgressIndicator(
            backgroundColor: ColorCUC.purple900,
          ),
        ),
      ),
    ),
  );
}


void sharedSaveData(String key, String value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;
  sharedPreferences.setString(key, value) ;
}
Future<String> getSharedData(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;
  return sharedPreferences.getString(key)!;
}

Future<String> getDataFromSharedPref(String key) async{
  SharedPreferences? pref = await SharedPreferences.getInstance();
  String value = pref.getString(key) ?? 'null';
  return value;
}

void ShowAboutDialog(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  AlertDialog alert = AlertDialog(
    alignment: Alignment.center,
    actions: [
      Container(
        width: width,
        margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            const Text(
              "CUC Result Processing System",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: ColorCUC.purple900),
            ),
            const SizedBox(height: 30,),
            const Padding(
              padding: EdgeInsets.fromLTRB(10,0,0,0),
              child: Text(
                "This apps is belonged by University of Chittagong College, which is build for teachers for automating the systems.",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,

                    color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            const Text(
              "Developed by",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.black54),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20,0,0,0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sarose Datta",
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.black),
                  ),
                  Text(
                    "  Software Engineer",
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                  Text(
                    "  +880 1516174937",
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                  Text(
                    "  CSE, University of Chittagong",
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50,),
            const Text(
              "©Powered by ICT cell, University of Chittagong",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.grey),
            ),
            const SizedBox(height: 20,),

          ],
        ),
      ),

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

void UserCheck(String value, BuildContext context) {
  if(value== "2"){
    Navigator.pushNamed(context, DashboardTeacher.id) ;
    Constant.AUTHORITY = "Teacher";
  }else if(value == "1"){
    Navigator.pushNamed(context, DashboardAdmin.id) ;
    Constant.AUTHORITY = "Admin";
  }
}

bool studentFailMarksCheck(code, mcq, cq, practical, marks){
  List<int> mcqCqPracList = [8, 17, 8] ;
  List<int> mcqCqList = [10, 23, 0] ;
  List<int> cqList = [0, 33, 0] ;

  List<int> mcqCq50List = [7, 10, 0] ;
  List<int> cq50List = [0, 17, 0] ;
  Map<String, List<int>> subList = {
    '101': mcqCqList,
    '253': mcqCqList,
    '254': mcqCqList,
    '277': mcqCqList,
    '278': mcqCqList,
    '292': mcqCqList,
    '293': mcqCqList,
    '109': mcqCqList,
    '110': mcqCqList,
    '269': mcqCqList,
    '270': mcqCqList,
    '121': mcqCqList,
    '122': mcqCqList,
    '267': mcqCqList,
    '268': mcqCqList,

    '102': cqList,
    '107': cqList,
    '108': cqList,

    '174': mcqCqPracList,
    '175': mcqCqPracList,
    '275': mcqCqPracList,
    '176': mcqCqPracList,
    '177': mcqCqPracList,
    '178': mcqCqPracList,
    '179': mcqCqPracList,
    '265': mcqCqPracList,
    '266': mcqCqPracList,
    '129': mcqCqPracList,
    '130': mcqCqPracList,
    '123': mcqCqPracList,
    '124': mcqCqPracList,



  };
  Map<String, List<int>> sub50List = {
    '101': mcqCq50List,
    '253': mcqCq50List,
    '254': mcqCq50List,
    '277': mcqCq50List,
    '278': mcqCq50List,
    '292': mcqCq50List,
    '293': mcqCq50List,
    '109': mcqCq50List,
    '110': mcqCq50List,
    '269': mcqCq50List,
    '270': mcqCq50List,
    '121': mcqCq50List,
    '122': mcqCq50List,
    '267': mcqCq50List,
    '268': mcqCq50List,

    '102': cq50List,
    '107': cq50List,
    '108': cq50List,

    '174': mcqCq50List,
    '175': mcqCq50List,
    '275': mcqCq50List,
    '176': mcqCq50List,
    '177': mcqCq50List,
    '178': mcqCq50List,
    '179': mcqCq50List,
    '265': mcqCq50List,
    '266': mcqCq50List,
    '129': mcqCq50List,
    '130': mcqCq50List,
    '123': mcqCq50List,
    '124': mcqCq50List,

  };
  List<int>? item;
  marks == 100 ? item = subList[code]: item = sub50List[code];;

  var isFail = false;
  if (item != null) {
    if((int.parse(mcq)< item[0]) || (int.parse(cq)< item[1]) || (int.parse(practical)< item[2]) ){
      isFail = true;
    }
  }
  return isFail;
}
String gradePointMarks(marks, examMarks ){
  String grade="";

  if(examMarks==50){
    grade = gradePoint50(marks) ;
  }else{
    grade = gradePoint(marks);
  }

  return grade;
}
String letterGradeMarks(marks, examMarks ){
  String letter="";

  if(examMarks==50){
    letter = letterGrade50(marks) ;
  }else{
    letter = letterGrade(marks);
  }

  return letter;
}

bool studentFailCheck(code, mcq, cq, practical){
  List<int> mcqCqPracList = [8, 17, 8] ;
  List<int> mcqCqList = [10, 23, 0] ;
  List<int> cqList = [0, 33, 0] ;
  Map<String, List<int>> subList = {
    '101': mcqCqList,
    '253': mcqCqList,
    '254': mcqCqList,
    '277': mcqCqList,
    '278': mcqCqList,
    '292': mcqCqList,
    '293': mcqCqList,
    '109': mcqCqList,
    '110': mcqCqList,
    '269': mcqCqList,
    '270': mcqCqList,
    '121': mcqCqList,
    '122': mcqCqList,
    '267': mcqCqList,
    '268': mcqCqList,

    '102': cqList,
    '107': cqList,
    '108': cqList,

    '174': mcqCqPracList,
    '175': mcqCqPracList,
    '275': mcqCqPracList,
    '176': mcqCqPracList,
    '177': mcqCqPracList,
    '178': mcqCqPracList,
    '179': mcqCqPracList,
    '265': mcqCqPracList,
    '266': mcqCqPracList,
    '129': mcqCqPracList,
    '130': mcqCqPracList,
    '123': mcqCqPracList,
    '124': mcqCqPracList,



  };
  List<int>? item = subList[code];
  var isFail = true;
  if (item != null) {
    if((int.parse(mcq)>= item[0]) && (int.parse(cq)>= item[1]) && (int.parse(practical)>= item[2]) ){
      isFail = false;
    }
  }
  return isFail;
}
String gradePoint(int marks){
  String grade="";
  if(marks>=80){
    grade = '5.00';
  }else if (marks>=70 && marks<=79){
    grade = '4.00';
  }else if(marks>=60 && marks<=69){
    grade = '3.50';
  } else if(marks>=50 && marks<=59){
    grade = '3.00';
  } else if(marks>=40 && marks<=49){
    grade = '2.00';
  } else if(marks>=33 && marks<=39){
    grade = '1.00';
  }
  return grade;
}
String letterGrade(int marks){
  String grade="";
  if(marks>=80){
    grade = 'A+';
  }else if (marks>=70 && marks<=79){
    grade = 'A';
  }else if(marks>=60 && marks<=69){
    grade = 'A-';
  } else if(marks>=50 && marks<=59){
    grade = 'B';
  } else if(marks>=40 && marks<=49){
    grade = 'C';
  } else if(marks>=33 && marks<=39){
    grade = 'D';
  }
  return grade;
}

bool studentFailCheck50(code, mcq, cq){

  var isFail = true;
  if((int.parse(mcq)>= 7) && (int.parse(cq)>= 10) ){
    isFail = false;
  }
  return isFail;
}
String gradePoint50(int marks){
  String grade="";
  if(marks>=40){
    grade = '5.00';
  }else if (marks>=35 && marks<=39){
    grade = '4.00';
  }else if(marks>=30 && marks<=34){
    grade = '3.50';
  } else if(marks>=25 && marks<=29){
    grade = '3.00';
  } else if(marks>=20 && marks<=24){
    grade = '2.00';
  } else if(marks>=17 && marks<=19){
    grade = '1.00';
  }
  return grade;
}
String letterGrade50(int marks){
  String grade="";
  if(marks>=40){
    grade = 'A+';
  }else if (marks>=35 && marks<=39){
    grade = 'A';
  }else if(marks>=30 && marks<=34){
    grade = 'A-';
  } else if(marks>=25 && marks<=29){
    grade = 'B';
  } else if(marks>=20 && marks<=24){
    grade = 'C';
  } else if(marks>=17 && marks<=19){
    grade = 'D';
  }
  return grade;
}

String passMark(){
  String value ="""<table>
                  <tr>
                    <th style="width: 100px">Number</th>
                    <th style="width: 150px">Pass mark</th>
                  </tr>
                  <tr>
                    <td>100</td>
                    <td>33</td>
                  </tr>
                  <tr>
                    <td>70</td>
                    <td>23</td>
                  </tr>
                  <tr>
                    <td>50</td>
                    <td>17</td>
                  </tr>
                  <tr>
                    <td>30</td>
                    <td>10</td>
                  </tr>
                  <tr>
                    <td>25</td>
                    <td>8</td>
                  </tr>
                </table>""";

  return value;
}
String passMark50(){
  String value="""<table>
                  <tr>
                    <th style="width: 100px">Number</th>
                    <th style="width: 150px">Pass mark</th>
                  </tr>
                  <tr>
                    <td>50</td>
                    <td>17</td>
                  </tr>
                  <tr>
                    <td>30</td>
                    <td>10</td>
                  </tr>
                  <tr>
                    <td>20</td>
                    <td>7</td>
                  </tr>
                </table>""";

  return value;
}

String? tabulationTitleCheck(code){
  String mcqCqPracList = "(MCQ+CQ+PRACT.)" ;
  String mcqCqList = "(MCQ+CQ)" ;
  String cqList = "" ;
  Map<String, String> subList = {
    '101': mcqCqList,
    '253': mcqCqList,
    '254': mcqCqList,
    '277': mcqCqList,
    '278': mcqCqList,
    '292': mcqCqList,
    '293': mcqCqList,
    '109': mcqCqList,
    '110': mcqCqList,
    '269': mcqCqList,
    '270': mcqCqList,
    '121': mcqCqList,
    '122': mcqCqList,
    '267': mcqCqList,
    '268': mcqCqList,

    '102': cqList,
    '107': cqList,
    '108': cqList,

    '174': mcqCqPracList,
    '175': mcqCqPracList,
    '275': mcqCqPracList,
    '176': mcqCqPracList,
    '177': mcqCqPracList,
    '178': mcqCqPracList,
    '179': mcqCqPracList,
    '265': mcqCqPracList,
    '266': mcqCqPracList,
    '129': mcqCqPracList,
    '130': mcqCqPracList,
    '123': mcqCqPracList,
    '124': mcqCqPracList,



  };
  String? item = subList[code];

  return item;
}
String? tabulationNumberCheck(code, cq, mcq, practical, totalMarks){
  String mcqCqPracList = "$mcq+$cq+$practical=$totalMarks" ;
  String mcqCqList = "$mcq+$cq=$totalMarks" ;
  String cqList = "$cq" ;
  Map<String, String> subList = {
    '101': mcqCqList,
    '253': mcqCqList,
    '254': mcqCqList,
    '277': mcqCqList,
    '278': mcqCqList,
    '292': mcqCqList,
    '293': mcqCqList,
    '109': mcqCqList,
    '110': mcqCqList,
    '269': mcqCqList,
    '270': mcqCqList,
    '121': mcqCqList,
    '122': mcqCqList,
    '267': mcqCqList,
    '268': mcqCqList,

    '102': cqList,
    '107': cqList,
    '108': cqList,

    '174': mcqCqPracList,
    '175': mcqCqPracList,
    '275': mcqCqPracList,
    '176': mcqCqPracList,
    '177': mcqCqPracList,
    '178': mcqCqPracList,
    '179': mcqCqPracList,
    '265': mcqCqPracList,
    '266': mcqCqPracList,
    '129': mcqCqPracList,
    '130': mcqCqPracList,
    '123': mcqCqPracList,
    '124': mcqCqPracList,



  };
  String? item = subList[code];

  return item;
}

String gradingSystem(examMarks) {
  String output="";
  if(examMarks==100){
    output = """<div style="font-size: 10px">
              <div>
                <table style="width: 100%">
                  <tr>
                    <th
                      colspan="3"
                      style="justify-content: start; text-align: start"
                    >
                      <b>GRADING SYSTEM</b>
                    </th>
                  </tr>

                  <tr style="">
                    <th style="">NUMERICAL GRADE</th>
                    <th style="">Letter Grade</th>
                    <th style="">Grade Points</th>
                  </tr>
                  <tr>
                    <td>80-100</td>
                    <td>A+</td>
                    <td>5.00</td>
                  </tr>
                  <tr>
                    <td>70-79</td>
                    <td>A</td>
                    <td>4.00</td>
                  </tr>
                  <tr>
                    <td>60-69</td>
                    <td>A-</td>
                    <td>3.50</td>
                  </tr>
                  <tr>
                    <td>50-59</td>
                    <td>B</td>
                    <td>3.00</td>
                  </tr>
                  <tr>
                    <td>40-49</td>
                    <td>C</td>
                    <td>2.00</td>
                  </tr>
                  <tr>
                    <td>33-39</td>
                    <td>D</td>
                    <td>1.00</td>
                  </tr>
                  <tr>
                    <td>00-32</td>
                    <td>F</td>
                    <td>0.00</td>
                  </tr>
                </table>
              </div>
            </div>""";
  }else{
    output = """<div style="font-size: 10px">
              <div>
                <table style="width: 100%">
                  <tr>
                    <th
                      colspan="3"
                      style="justify-content: start; text-align: start"
                    >
                      <b>GRADING SYSTEM</b>
                    </th>
                  </tr>

                  <tr style="">
                    <th style="">NUMERICAL GRADE</th>
                    <th style="">Letter Grade</th>
                    <th style="">Grade Points</th>
                  </tr>
                  <tr>
                    <td>40-50</td>
                    <td>A+</td>
                    <td>5.00</td>
                  </tr>
                  <tr>
                    <td>35-39</td>
                    <td>A</td>
                    <td>4.00</td>
                  </tr>
                  <tr>
                    <td>30-34</td>
                    <td>A-</td>
                    <td>3.50</td>
                  </tr>
                  <tr>
                    <td>25-29</td>
                    <td>B</td>
                    <td>3.00</td>
                  </tr>
                  <tr>
                    <td>20-24</td>
                    <td>C</td>
                    <td>2.00</td>
                  </tr>
                  <tr>
                    <td>17-19</td>
                    <td>D</td>
                    <td>1.00</td>
                  </tr>
                  <tr>
                    <td>00-16</td>
                    <td>F</td>
                    <td>0.00</td>
                  </tr>
                </table>
              </div>
            </div>""";
  }

  return output;
}




