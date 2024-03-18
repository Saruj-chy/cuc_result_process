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

class ResultSheetPrintScreen extends StatefulWidget {
  const ResultSheetPrintScreen(
      {Key? key,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.sess_id,
      required this.sess_name,
      required this.exam_id})
      : super(key: key);
  final String text1, text2, text3, sess_id, exam_id, sess_name;

  @override
  State<ResultSheetPrintScreen> createState() => _ResultSheetPrintScreenState();
}

class _ResultSheetPrintScreenState extends State<ResultSheetPrintScreen> {
  late Future<TranscriptModel> transcriptModel;
  String allHtml = "";
  bool printGenerate = false;
  String? generatedPdfFilePath;
  final _flutterNativeHtmlToPdfPlugin = FlutterNativeHtmlToPdf();
  List<SubCodeModel> subCodeList = [];
  int examMarks = 0;

  @override
  void initState() {
    super.initState();
    transcriptModel = fetchResultSheetList();
    widget.exam_id == "1" ? examMarks = 50 : examMarks = 100;
  }


  String htmlStart(itemsArray) {
    List<String> sciMeritList = [];
    List<String> businessMeritList = [];
    List<String> humanitiesMeritList = [];
    List<String> scienceFailedList = [];
    List<String> businessFailedList = [];
    List<String> humanitiesFailedList = [];
    List<String> scienceAbsentList = [];
    List<String> businessAbsentList = [];
    List<String> humanitiesAbsentList = [];

    for (var item in itemsArray) {
      final roll = item.roll;
      final grp_id = item.grp_id;
      final optSubId = item.optional_sub_id;
      print("--------------------- $roll");

      double fullGpa = 0.00, optGpa = 0.00;
      int passCount = 0;
      bool isMainFail = false;
      final stuDataList = item.stu_data;
      int length = stuDataList.length;
      // print("$roll    ---    $length");
      if(int.parse(grp_id) == 3){
        var cq="0", mcq="0", practical="0";
        for (int i = 0; i < length; i++) {
          final stuData = stuDataList[i];
          cq = stuData.cq;
          mcq = stuData.mcq;
          practical = stuData.practical;
          if(cq=="-1" || mcq == "-1" || practical=="-1"){
            length-=1;
          }
        }
      }
      if (length > 0) {
        for (int i = 0; i < 7; i++) {
          var code = "0",
              sub_name_id = "0",
              cq = "0",
              mcq = "0",
              practical = "0";
          if (i < length) {
            final stuData = stuDataList[i];
            code = stuData.code;
            sub_name_id = stuData.sub_name_id;
            cq = stuData.cq;
            mcq = stuData.mcq;
            practical = stuData.practical;
          }

          int totalMarks =
              int.parse(cq) + int.parse(mcq) + int.parse(practical);
          // print("----$cq-------------$mcq-------------$practical----------==$totalMarks------------------");

          var gpaPoint="0.00";
          var isFail = studentFailCheckMethod(code, mcq, cq, practical);
          if (!isFail) {
            gpaPoint = gradePoint(totalMarks);
          } else {
            gpaPoint = "0.00";
          }
          // print("------$gpaPoint------------$isFail");

          if (sub_name_id == optSubId) {
            optGpa = (double.parse(gpaPoint) - 2 >= 0
                ? (double.parse(gpaPoint) - 2)
                : 0.00);
          } else {
            fullGpa += double.parse(gpaPoint);
            !isMainFail &&
                (isMainFail = studentFailCheckMethod(code, mcq, cq, practical));
            if (!studentFailCheckMethod(code, mcq, cq, practical)) {
              passCount += 1;
            }
          }
        }

        //-------------------------------------------
        //-------------------------------------------
        // if(length>=7 && subCodeList.length==0){
        //   for (int i = 0; i < length; i++) {
        //     final stuData = stuDataList[i];
        //     final code = stuData.code;
        //     final sub_name = stuData.sub_name;
        //     final sub_name_id = stuData.sub_name_id;
        //     subCodeList.add(SubCodeModel(code: code, sub_name_id:sub_name_id, title: sub_name));
        //     // resultExist = true;
        //   }
        // }
        // var subDetails = HashMap<int, List<String>>();
        // for (int i = 0; i < subCodeList.length; i++) {
        //   final subListData = subCodeList[i];
        //   final code = subListData.code;
        //   final sub_name = subListData.title;
        //   final sub_name_id = subListData.sub_name_id;
        //   var cq = "0",
        //       mcq = "0",
        //       practical = "0";
        //   if (length > 0) {
        //     for (int i = 0; i < length; i++) {
        //       final stuData = stuDataList[i];
        //       if (sub_name_id == stuData.sub_name_id) {
        //         cq = stuData.cq;
        //         mcq = stuData.mcq;
        //         practical = stuData.practical;
        //       }
        //     }
        //   }
        //
        //   int totalMarks = int.parse(cq) + int.parse(mcq) + int.parse(practical);
        //   print("$cq  -   $mcq  -   $practical   =    $totalMarks") ;
        //   // var sub_name_title = "";
        //   // sub_name_title = tabulationNumberCheck(code, cq, mcq, practical, totalMarks)!;
        //   var gpaPoint;
        //   var isFail = studentFailMarksCheck(code, mcq, cq, practical, examMarks);
        //   if (!isFail) {
        //     gpaPoint = gradePointMarks(totalMarks, examMarks);
        //   } else {
        //     gpaPoint = "0.00";
        //   }
        //   // List<String> numPointList = [sub_name_title, gpaPoint];
        //   // subItem[i] = numPointList;
        //
        //   if (sub_name_id == optSubId) {
        //     optGpa = (double.parse(gpaPoint) - 2 >= 0
        //         ? (double.parse(gpaPoint) - 2)
        //         : 0.00);
        //   } else {
        //     fullGpa += double.parse(gpaPoint);
        //     !isMainFail &&
        //         (isMainFail =
        //             studentFailMarksCheck(code, mcq, cq, practical, examMarks));
        //     if (studentFailCheckMethod(code, mcq, cq, practical)) {
        //       failCount += 1;
        //     }
        //   }
        // }
        //------------------------------------------
        // for (int i = 0; i < length; i++) {
        //   final stuData = stuDataList[i];
        //   final code = stuData.code;
        //   final cq = stuData.cq;
        //   final mcq = stuData.mcq;
        //   final practical = stuData.practical;
        //   int totalMarks = int.parse(cq) + int.parse(mcq) + int.parse(practical);
        //
        //   var gpaPoint;
        //   var isFail = studentFailCheckMethod(code, mcq, cq, practical);
        //   if (!isFail) {
        //     gpaPoint = gradePoint(totalMarks);
        //   } else {
        //     gpaPoint = "0.00";
        //   }
        //
        //   if (stuData.sub_name_id == stuData.optional_sub_id) {
        //     optGpa = (double.parse(gpaPoint) - 2 >= 0
        //         ? (double.parse(gpaPoint) - 2)
        //         : 0.00);
        //   } else {
        //     fullGpa += double.parse(gpaPoint);
        //     !isMainFail &&
        //         (isMainFail = studentFailCheckMethod(code, mcq, cq, practical));
        //     if (studentFailCheckMethod(code, mcq, cq, practical)) {
        //       failCount += 1;
        //     }
        //   }
        // }
        var gpaValue = ((fullGpa + optGpa) / (length - 1)) > 5.00
            ? "5.00"
            : ((fullGpa + optGpa) / (length - 1)).toStringAsFixed(2);
        if (isMainFail) {
          gpaValue = "F";
        }

        if (grp_id == "1") {
          if (gpaValue == "F") {
            String result = "$roll[F${6 - passCount}];";
            scienceFailedList.add(result);
          } else {
            String result = "$roll[$gpaValue];";
            sciMeritList.add(result);
          }
        } else if (grp_id == "2") {
          if (gpaValue == "F") {
            String result = "$roll[F${6 - passCount}];";
            businessFailedList.add(result);
          } else {
            String result = "$roll[$gpaValue];";
            businessMeritList.add(result);
          }
        } else if (grp_id == "3") {
          if (gpaValue == "F") {
            String result = "$roll[F${6 - passCount}];";
            humanitiesFailedList.add(result);
          } else {
            String result = "$roll[$gpaValue];";
            humanitiesMeritList.add(result);
          }
        }
      } else {
        if (grp_id == "1") {
          scienceAbsentList.add("$roll");
        } else if (grp_id == "2") {
          businessAbsentList.add("$roll");
        } else if (grp_id == "3") {
          humanitiesAbsentList.add("$roll");
        }
      }
    }
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

      .border {
        border: 1px solid;
      }
      .text-align {
        text-align: center;
      }
      .font18 {
        font-size: 18px;
      }
      .margin-padding {
        padding: 0px;
        margin: 2px;
      }
      .mtb {
        padding-top: 2px;
        padding-bottom: 2px;
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
      table {
        border-collapse: collapse;
      }
    </style>
  </head>

  <body class="body-style">
    <div class="p-style">""";
    value += htmlBodyTitle() +
        htmlBodyMerit(
            sciMeritList,
            businessMeritList,
            humanitiesMeritList,
            scienceFailedList,
            businessFailedList,
            humanitiesFailedList,
            scienceAbsentList,
            businessAbsentList,
            humanitiesAbsentList) +
        htmlEnd();
    return value;
  }

  String htmlBodyTitle() {
    String value = """<div class="title-style">
        <div>
          <h4 class="margin-word">
            CHITTAGONG UNIVERSITY LABORATORY SCHOOL AND COLLEGE
          </h4>
          <p class="margin-padding font18">
            University Of Chittagong, Chattogram.
          </p>
          <p class="margin-padding">
            <b>RESULT</b>
          </p>
          <p class="margin-padding">
            <b> ${widget.text2}</b>
          </p>
          <p class="margin-padding mtb">${widget.text3}</p>
          <p class="margin-padding mtb">Higher Secondary</p>
          <p class="margin-padding mtb">Session: ${widget.sess_name}</p>
        </div>
      </div><div>""";
    return value;
  }

  String htmlBodyMerit(
      sciMeritList,
      businessMeritList,
      humanitiesMeritList,
      scienceFailedList,
      businessFailedList,
      humanitiesFailedList,
      scienceAbsentList,
      businessAbsentList,
      humanitiesAbsentList) {
    String value = """<div>
        <!-- merit -->
        <div style="width: 100%">
          <p style="font-size: 14px; margin-top: 50px; font-weight: bold;">MERIT LIST [PROMOTED]</p>
          <div>
            <!-- merit_science -->
            ${htmlMeritScience("Science Group", sciMeritList)}
            <!-- merit_business_studies -->
            ${htmlMeritScience("Business Studies", businessMeritList)}
            <!-- merit_humanities -->
            ${htmlMeritScience("HUMANITIES", humanitiesMeritList)}
          </div>
        </div>

        <!-- failed -->
        <div style="width: 100%; margin-top: 50px">
          <p style="font-size: 14px; font-weight: bold;">FAILED STUDENTS</p>

          <div>
            ${htmlMeritScience("Science Group", scienceFailedList)}
            <!-- merit_business_studies -->
            ${htmlMeritScience("Business Studies", businessFailedList)}
            <!-- merit_humanities -->
            ${htmlMeritScience("HUMANITIES", humanitiesFailedList)}
           
          </div>
        </div>
        
        <!-- absent -->
        <div style="width: 100%; margin-top: 50px">
          <p style="font-size: 14px; font-weight: bold;">ABSENT STUDENTS</p>

          <div>
            ${htmlMeritScience("Science Group", scienceAbsentList)}
            <!-- merit_business_studies -->
            ${htmlMeritScience("Business Studies", businessAbsentList)}
            <!-- merit_humanities -->
            ${htmlMeritScience("HUMANITIES", humanitiesAbsentList)}
           
          </div>
        </div>
        
        <!-- html end -->
      </div>""";
    return value;
  }

  String htmlMeritScience(name, list) {
    String start =
        """<div style="display: flex; font-size: 14px; width: 100%; margin-top: 10px;">
              <p style="width: 20%; text-align: start">$name:</p>
              <div
                style="
                  display: flex;
                  font-size: 14px;
                  width: 80%;
                  text-align: center;
                "
              >
                <table width="100%">""";
    String end = """</table>
              </div>
            </div>""";

    String rowArray = "";
    for (var i = 0; i < list.length; i += 8) {
      String rowStart = """<tr>""";
      String rowEield = "";
      String rowEnd = """</tr>""";
      print("------------------------------------------$i");
      for (var j = i; j < i + 8; j++) {
        if (list.length > j) {
          rowEield += """<td width="12%">${list[j]}</td>""";
        } else {
          rowEield += """<td width="12%"></td>""";
        }
      }
      rowArray += rowStart + rowEield + rowEnd;
    }
    String value = start + rowArray + end;

    return value;
  }

  String htmlEnd() {
    String value = """ </div>  </body> </html>""";
    return value;
  }

  bool studentFailCheckMethod(code, mcq, cq, practical) {
    bool isFail = true;
    if (widget.exam_id == 1) {
      isFail = studentFailCheck50(code, mcq, cq);
    } else {
      isFail = studentFailCheck(code, mcq, cq, practical);
    }
    return isFail;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(
        title: "Result Sheet Print",
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

                      allHtml = htmlStart(itemsArray);
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
    if (pdfName == "") {
      pdfName = "sample";
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
        text: Constant.SHARE_MSG,
      );
    }
  }
}
