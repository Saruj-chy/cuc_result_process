import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cuc_result_processing/bloc_components/transcript_model.dart';
import 'package:cuc_result_processing/layout/InitializeMethod.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../bloc_components/sub_code_model.dart';
import '../../file/constant.dart';
import 'dashboard_admin.dart';

class TabuPrintScreen extends StatefulWidget {
  const TabuPrintScreen(
      {Key? key,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.sess_id,
      required this.exam_id,
      required this.grp_id})
      : super(key: key);
  final text1, text2, text3, sess_id, exam_id, grp_id;

  @override
  State<TabuPrintScreen> createState() => _TabuPrintScreenState();
}

class _TabuPrintScreenState extends State<TabuPrintScreen> {
  late Future<TranscriptModel> transcriptModel;
  String allHtml = "";
  bool printGenerate = false, isResultExist = false;
  String? generatedPdfFilePath;
  final _flutterNativeHtmlToPdfPlugin = FlutterNativeHtmlToPdf();
  int examMarks = 0;
  List<SubCodeModel> subCodeList = [];

  @override
  void initState() {
    super.initState();

    transcriptModel = fetchTabuList();
    widget.exam_id == "1" ? examMarks = 50 : examMarks = 100;
  }

  Future<TranscriptModel> fetchTabuList() async {
    var url = Uri.parse(Constant.transcript_url);
    final response = await http.post(url, body: {
      "state": "1",
      "auth_token": authToken,
      "phn_num": phnNum,
      "grp_id": widget.grp_id,
      "exam_id": widget.exam_id,
      "sess_id": widget.sess_id,
    });

    var jsonResponse = json.decode(response.body);
    print(jsonResponse.toString());
    if (response.statusCode == 200 && !jsonResponse["error"]) {
      setState(() {
        printGenerate = true;
      });
      return TranscriptModel.fromJson(jsonResponse);
    } else {
      Navigator.of(context).pop();
      throw Exception('Failed to load post');
    }
  }

  String htmlStart(itemsArray) {
    String value = """<!DOCTYPE html>
<html>
  <head>
    <meta
      name="\viewport\"
      content="\width"
      ="device-width,"
      initial-scale="1.0\"
    />
    <style>
      @page {
        size: A4 landscape;
        margin: 10mm;
      }
      body {
        display: block;
        justify-content: center;
        text-align: center;
      }
      .container-head {
        display: grid;

        grid-template-columns: repeat(3, 1fr);
      }
      .container-grid {
        display: grid;

        grid-template-columns: repeat(3, 1fr);
        text-align: start;
      }
      .container-name {
        display: grid;
        grid-template-columns: repeat(1, 1fr);

        text-align: start;
      }
      .no-margin-padding {
        margin: 0px;
        padding: 0px;
      }
      .bold {
        font-weight: bold;
      }
      .border {
        border: 1px solid;
      }
      .text-align {
        text-align: center;
      }
      .margin-padding {
        padding: 0px;
        margin: 2px;
      }
      .table-style {
        width: 100%;
        border-collapse: collapse;
        border: 1px solid;
        text-align: center;
        font-size: 12px;
      }
      .justify {
        display: flex;
        justify-content: center;
      }
      .margin-word {
        margin: 2px;
        word-spacing: 10px;
      }
      .p-style {
        font-size: 8px;
        margin: 0px;
      }
      .gpa-style {
        border: 1px solid;
        text-align: center;
        padding: 0px 10px;
      }
      .title-style {
        display: flex;
        justify-content: center;
        text-align: center;
        font-size: 14px;
      }
      .body-style {
        display: block;
        justify-content: center;
        text-align: center;
      }
      .font18 {
        font-size: 18px;
      }
    </style>
  </head>

  <body class="body-style">
    <div class="p-style">
      <div class="title-style">
        <div>
          <h4 class="margin-word">
            CHITTAGONG UNIVERSITY LABORATORY SCHOOL AND COLLEGE
          </h4>
          <p class="margin-padding font18">University Of Chittagong, Chattogram.</p>
          <p class="margin-padding">
            <b>Tabulation Sheet</b>
          </p>
          <p class="margin-padding">
            <b> ${widget.text2}</b>
          </p>
          <p class="margin-padding">${widget.text3}</p>
          <p class="margin-padding">Higher Secondary, Group: ${itemsArray[0].grp_name}</p>
          <p class="margin-padding">Session: ${itemsArray[0].sess_name}</p>
        </div>
      </div>

      <div class="justify text-align">
        <table class="table-style">
          """;
    String htmlBodyItemArray = "";
    for (var item in itemsArray) {
      htmlBodyItemArray += htmlItem(item);
    }
    value += htmlItemTitle(subCodeList) + htmlBodyItemArray + htmlEnd();

    return value;
  }

  String htmlItemTitle(subCodeList) {


    String output = "";
    String firstItem ="""<tr class="text-align">
            <th class="border text-align">Roll No</th>
            <th class="border text-align">Name</th>""";
    String lastItem = """<th class="border text-align">
              GPA <br />
              <p class="p-style">(Without optional subject)</p>
            </th>
            <th class="gpa-style">GPA</th>
          </tr>""";

    String arrayString = "";
    final length = subCodeList.length;
    var subDetails = HashMap<int, List<String>>();
    for (int i = 0; i < length; i++) {
      final stuData = subCodeList[i];
      final sub_name = stuData.title;

      final code = stuData.code ?? 0;

      var cqMcqPracTitle = tabulationTitleCheck(code)!;

      List<String> mcqCqPracList = [sub_name, cqMcqPracTitle];
      subDetails[i] = mcqCqPracList;
      arrayString += """<th class="border text-align">
              ${sub_name} <br />
              <p class="p-style">${cqMcqPracTitle}</p>
            </th>""";
    }

    output = firstItem + arrayString + lastItem ;
    return output;
  }

  String htmlItem(item) {
    final name = item.name;
    final roll = item.roll;
    final optSubId = item.optional_sub_id;
    var subItem = HashMap<int, List<String>>();
    int courseListLength = 7;


    double fullGpa = 0.00, optGpa = 0.00;
    bool isMainFail = false;

    final courseLength = item.stu_data.length;
    final courseList = item.stu_data;
    if (subCodeList.isNotEmpty) {
      for (int i = 0; i < subCodeList.length; i++) {
        final subListData = subCodeList[i];
        final code = subListData.code;
        final sub_name_id = subListData.sub_name_id;
        var cq = "0", mcq = "0", practical = "0";
        List<int> tempCourseIdList = [] ;
        List<int> sciCommIdList = [] ;

        if (courseLength > 0) {
          for (int i = 0; i < courseLength; i++) {
            final courseItem = courseList[i];
            if(widget.grp_id=="3"){
              tempCourseIdList.add(int.parse(courseItem.sub_name_id));
            }else{
              sciCommIdList.add(int.parse(courseItem.sub_name_id));
            }
            if (sub_name_id == courseItem.sub_name_id) {
              cq = courseItem.cq=="-1"? "0" : courseItem.cq;
              mcq = courseItem.mcq=="-1"? "0" : courseItem.mcq;
              practical = courseItem.practical=="-1"? "0" : courseItem.practical;
            }
          }
        }
        bool isEntry= true, isSciCommEntry=false;
        if(widget.grp_id == "2"){
          if((optSubId=="11" && sub_name_id=="12") || optSubId=="12" && sub_name_id=="11"){
            isEntry = false;
          }
        }else if(widget.grp_id == "3"){
          isEntry = tempCourseIdList.any((item) => item == int.parse(sub_name_id));
        }
        if(widget.grp_id!="3"){
          isSciCommEntry = sciCommIdList.any((item) => item == int.parse(sub_name_id));
        }


        if( (widget.grp_id=="1" && isSciCommEntry) || (widget.grp_id=="2" && isEntry && isSciCommEntry) ||( widget.grp_id=="3" && isEntry)){
          int totalMarks = int.parse(cq) + int.parse(mcq) + int.parse(practical);
          var sub_name_title = "";
          sub_name_title = tabulationNumberCheck(code, cq, mcq, practical, totalMarks)!;
          var gpaPoint;
          var isFail = studentFailMarksCheck(code, mcq, cq, practical, examMarks);
          if (!isFail) {
            gpaPoint = gradePointMarks(totalMarks, examMarks);
          } else {
            gpaPoint = "0.00";
          }
          List<String> numPointList = [sub_name_title, gpaPoint, code];
          subItem[i] = numPointList;

          if (sub_name_id == optSubId) {
            optGpa = (double.parse(gpaPoint) - 2 >= 0
                ? (double.parse(gpaPoint) - 2)
                : 0.00);
          } else {
            fullGpa += double.parse(gpaPoint);
            !isMainFail &&
                (isMainFail =
                    studentFailMarksCheck(code, mcq, cq, practical, examMarks));
          }
        }
      }
    }

    String gpaExceptOpt = "${(fullGpa / (courseListLength - 1)).toStringAsFixed(2)}";
    var gpaValue = ((fullGpa + optGpa) / (courseListLength - 1)) > 5.00
        ? "5.00"
        : ((fullGpa + optGpa) / (courseListLength - 1)).toStringAsFixed(2);
    if (isMainFail) {
      gpaValue = "F";
      gpaExceptOpt = "F";
    }

    String output = "";
    String firstItem ="""<tr class="text-align">
            <td class="border text-align bold">$roll</td>
            <td class="border text-align bold">$name</td>""";
    String lastItem = """<td class="border text-align">
              <p class="bold">${gpaExceptOpt}</p>
            </td>
            <td class="border text-align">
              <p class="bold">${gpaValue}</p>
            </td>
          </tr>""";

    String arrayString = "";
    final length = subCodeList.length;
    for (int i = 0; i < length; i++) {
      bool isExist = false;
      for(int j=0; j<subItem.length+1; j++){
        if(subCodeList[i].code == "${subItem[j]?[2]}"){
          arrayString += """<td class="border text-align">
              ${subItem[i]?[0]} <br />
              <p class="no-margin-padding bold">(${subItem[i]?[1]} )</p>
            </td>""";
          isExist=true ;
        }
      }
      if(!isExist){
        arrayString += """<td class="border text-align"></td>""";
      }

    }

    output = firstItem + arrayString + lastItem ;
    return output;

  }

  String htmlEnd() {
    String value = """ </table> </div> </div> </div> </body> </html> """;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(
        title: "Tabulation Sheet Print",
      ),
      body: printGenerate
          ? SingleChildScrollView(
              child: Container(
                height: height - 100,
                child: FutureBuilder<TranscriptModel>(
                  future: transcriptModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final itemsArray = snapshot.data!.data;
                      // if(itemsArray.length>0){
                      //   isResultExist = true;
                      // }
                      for (var item in itemsArray) {
                        final stuDataList = item.stu_data;
                        final length = stuDataList.length;
                        if(length>=7 ){
                          for (int i = 0; i < length; i++) {
                            final stuData = stuDataList[i];
                            final code = stuData.code;
                            final sub_name = stuData.sub_name;
                            final sub_name_id = stuData.sub_name_id;
                            bool subjExist = subCodeList.any((sub) => sub.code == code);
                            if(!subjExist){
                              subCodeList.add(SubCodeModel(code: code, sub_name_id:sub_name_id, title: sub_name));
                            }
                          }
                          isResultExist = true;
                        }
                      }

                      if(isResultExist){
                        allHtml = htmlStart(itemsArray);
                      }else{
                        Navigator.of(context).pop();
                      }



                      final controller = WebViewController()
                        // ..setJavaScriptMode(JavaScriptMode.disabled)
                        ..loadHtmlString(allHtml);
                      return WebViewWidget(
                        controller: controller,
                      );
                    }

                    return const SizedBox(
                      height: 5.0,
                    );
                  },
                ),
              ),
            )
          : VisibilityShow(height, !printGenerate),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.print),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _GeneratePdfFile(widget.text1, allHtml);
        },
      ),
    );
  }

  Future<void> _GeneratePdfFile(String pdfName, String htmlStr) async {
    if(pdfName==""){
      pdfName= "sample";
    }
    setState(() {
      printGenerate = false;
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    var targetFileName = pdfName;
    final generatedPdfFile =
        await _flutterNativeHtmlToPdfPlugin.convertHtmlToPdf(
      html: htmlStr,
      targetDirectory: targetPath,
      targetName: targetFileName,
    );

    generatedPdfFilePath = generatedPdfFile?.path;
    setState(() {
      printGenerate = true;
    });
    if (generatedPdfFilePath != null) {
      await Share.shareXFiles(
        [XFile(generatedPdfFilePath!)],
        text:
            Constant.SHARE_MSG,
      );
    }
  }
}
