import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cuc_result_processing/bloc_components/sub_code_model.dart';
import 'package:cuc_result_processing/bloc_components/transcript_model.dart';
import 'package:cuc_result_processing/layout/InitializeMethod.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../file/constant.dart';
import 'dashboard_admin.dart';

class TransPrintScreen extends StatefulWidget {
  const TransPrintScreen(
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
  State<TransPrintScreen> createState() => _TransPrintScreenState();
}

class _TransPrintScreenState extends State<TransPrintScreen> {
  late Future<TranscriptModel> transcriptModel;
  String allHtml = "";
  bool printGenerate = false;
  String? generatedPdfFilePath;
  final _flutterNativeHtmlToPdfPlugin = FlutterNativeHtmlToPdf();
  int examMarks = 0;
  List<SubCodeModel> subCodeList = [];

  @override
  void initState() {
    super.initState();
    transcriptModel = fetchTranscriptList();
    widget.exam_id == "1" ? examMarks = 50 : examMarks = 100;
  }

  Future<TranscriptModel> fetchTranscriptList() async {
    var url = Uri.parse(Constant.transcript_url);
    final response = await http.post(url, body: {
      "state": "1",
      "auth_token": authToken,
      "phn_num": phnNum,
      "grp_id": widget.grp_id,
      "exam_id": widget.exam_id,
      "sess_id": widget.sess_id,
    });
    print("${widget.grp_id} - ${widget.exam_id}  - ${widget.sess_id}");
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

  String htmlMainStart() {
    String html;
    String htmlStart = """<!DOCTYPE html>
<html>""";

    html = htmlStart + htmlHead();
    return html;
  }

  String htmlMainEnd() {
    String htmlEnd = """</html>""";
    return htmlEnd;
  }

  String htmlHead() {
    String head = """<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
    </style>
  </head>""";
    return head;
  }

  String htmlBodyStart() {
    String bodyStart =
        """<body style="display: block; justify-content: center; text-align: center">""";

    return bodyStart;
  }

  String htmlBodyEnd() {
    String bodyEnd = """</body>""";

    return bodyEnd;
  }

  String htmlBodyItem(item, index) {
    String optSubId = item.optional_sub_id;
    String roll = item.roll;
    List<SubCodeModel> tempSubCodeList = [];
    for (int i = 0; i < subCodeList.length; i++) {
      // print("----$i------------${subCodeList.length}--------------");
      final stuData = subCodeList[i];
      final code = stuData.code;
      final sub_name = stuData.title;
      final sub_name_id = stuData.sub_name_id;
      tempSubCodeList.add(SubCodeModel(code: code, sub_name_id:sub_name_id, title: sub_name));
    }
    if(widget.grp_id == "2"){
      if(optSubId=="11"){
        tempSubCodeList.removeWhere((sub) => sub.sub_name_id == "12");
      }else if(optSubId=="12"){
        tempSubCodeList.removeWhere((sub) => sub.sub_name_id == "11");
      }
    }
    //TODO::Humanities
    final stuDataList = item.stu_data;
    final length = stuDataList.length;
    if(length==7 && widget.grp_id=="3"){
      for (int i = 0; i < length; i++) {
        final stuData = stuDataList[i];
        final code = stuData.code;
        final sub_name = stuData.sub_name;
        final sub_name_id = stuData.sub_name_id;
        tempSubCodeList.add(SubCodeModel(code: code, sub_name_id:sub_name_id, title: sub_name));
      }
    }


    //---------------------------------------------------------------------------------------------

    String bodyItem = "";
    String itemStart =
        """<div style="display: block; page-break-before: always"> <div style="">""";
    String itemEnd = """</div> </div>""";

    print("$roll==========================================${tempSubCodeList.length}");
    if(tempSubCodeList.length==7){
      bodyItem = itemStart +
          htmlBodyHead(item, index, tempSubCodeList) +
          htmlBodyName(item) +
          htmlBodyTable(item, tempSubCodeList) +
          htmlBodySignature() +
          itemEnd;
    }

    return bodyItem;
  }

  String htmlBodyHead(item, index, tempSubCodeList) {
    String bodyHead = """""";
    String start = """<div style=""> <div class="container-head">""";
    String end = """</div></div>""";
    bodyHead = start +
        htmlBodyHeadGrad() +
        htmlBodyHeadTitle() +
        htmlBodyHeadSerial(item, index, tempSubCodeList) +
        end;
    return bodyHead;
  }

  String htmlBodyHeadGrad() {
    String outView = gradingSystem(examMarks);
    return outView;
  }

  String htmlBodyHeadTitle() {
    String output = """<div style="text-align: center">
              <img
                src="https://upload.wikimedia.org/wikipedia/en/thumb/8/86/University_of_Chittagong_logo.svg/1200px-University_of_Chittagong_logo.svg.png"
                alt="CU logo"
                width="60"
              />
              <h3 style="width: 500px; margin: 0px">
                CHITTAGONG UNIVERSITY LABORATORY <br />
                SCHOOL AND COLLEGE
              </h3>
              <p style="padding: 0px; margin: 0px">
                University Of Chittagong, Chattogram.
              </p>
              <p style="padding: 0px; margin: 0px">
                <b>Academic Transcript</b>
              </p>
              <p style="padding: 0px; margin: 0px">
                <b> ${widget.text2}</b>
              </p>
              <p style="padding: 0px; margin: 0px">
                ${widget.text3}
              </p>
              <p style="padding: 0px; margin: 0px">Higher Secondary</p>
            </div>""";
    return output;
  }

  String htmlBodyHeadSerial(item, index, tempSubCodeList) {
    String output = "";
    String start = """<div
              style="
                height: 100%;
                justify-content: start;
                text-align: start;
                align-items: start;
                font-size: 10px;
              "
            >
              <div>
                <table>
                  <tr>
                    <th
                      colspan="3"
                      style="justify-content: start; text-align: start"
                    >
                      <b>Serial No.  $index</b>
                    </th>
                  </tr>

                  <tr>
                    <th style="width: 80px; text-align: start">Subject code</th>
                    <th style="width: 300px; text-align: start">
                      Title of Subject
                    </th>
                    <th style="width: 40px; text-align: start">Marks</th>
                  </tr>""";
    String end = """</table>
              </div>
              <div
                style="
                  width: 50%;
                  margin-left: 50px;
                  text-align: center;
                  justify-content: center;
                "
              >
                ${examMarks == 50 ? passMark50() : passMark()}
              </div>
            </div>""";

    String rowItem = "";
    for (int i = 0; i < tempSubCodeList.length; i++) {
      final stuData = tempSubCodeList[i];
      final code = stuData.code;
      final subName = stuData.title;
      final marks = examMarks;
      rowItem += """<tr>
                    <td>$code</td>
                    <td>$subName</td>
                    <td>$marks</td>
                  </tr>""";
    }
    output = start + rowItem + end;
    return output;
  }

  String htmlBodyName(item) {
    String bodyName = """<div style="">
          <div class="container-name">
            <div style="display: inline-flex; margin-top: 5px">
              <p style="margin: 0px; padding: 0px">Name:</p>
              <p
                style="
                  margin-left: 10px;
                  margin-top: 0px;
                  margin-bottom: 0px;
                  padding: 0px;
                  font-weight: bold;
                "
              >
                ${item.name}
              </p>
            </div>
          </div>
          <div class="container-grid">
            <div style="width: 100%">
              <div style="display: inline-flex">
                <p>Roll No.:</p>
                <p style="margin-left: 10px">${item.roll}</p>
              </div>
            </div>
            <div style="width: 100%; text-align: center;">
              <div style="display: inline-flex">
                <p>Group:</p>
                <p style="margin-left: 10px">${item.grp_name}</p>
              </div>
            </div>
            <div style="width: 100%; text-align: center;">
              <div style="display: inline-flex">
                <p>Session:</p>
                <p style="margin-left: 10px">${item.sess_name}</p>
              </div>
            </div>
          </div>
        </div>""";
    return bodyName;
  }

  String htmlBodyTable(item, tempSubCodeList) {
    String bodyTable = "";
    String start =
        """<div style="display: flex; justify-content: center; text-align: center">
          <table
            style="
              width: 100%;
              border-collapse: collapse;
              border: 2px solid;
              text-align: center;
            "
          >
            <tr style="text-align: center">
              <th style="border: 1px solid; text-align: center">
                Subject Code
              </th>
              <th style="border: 1px solid; text-align: center">MCQ</th>
              <th style="border: 1px solid; text-align: center">CQ</th>
              <th style="border: 1px solid; text-align: center">Practical</th>
              <th style="border: 1px solid; text-align: center">Total Marks</th>
              <th style="border: 1px solid; text-align: center">Grade Point</th>
              <th style="border: 1px solid; text-align: center">
                Letter Grade
              </th>
              <th style="border: 1px solid; text-align: center; max-width: 100px">
                GPA (Without optional Subject)
              </th>
              <th style="border: 1px solid; text-align: center" colspan="2">
                GPA
              </th>
            </tr>""";
    String end = """</table>
        </div>""";
    bodyTable += start;

    String firstItemStr = "", othersItemStr = "", optItemStr = "";
    final optSubId = item.optional_sub_id;
    final stuDataList = item.stu_data;
    final length = stuDataList.length;
    double fullGpa = 0.00, optGpa = 0.00;
    bool isMainFail = false;

    for (int i = 0; i < tempSubCodeList.length; i++) {
      final subListData = tempSubCodeList[i];
      final code = subListData.code;
      final sub_name_id = subListData.sub_name_id;
      var cq="0", mcq="0", practical="0";
      if(length>0){
        for (int i = 0; i < length; i++) {
          final stuData = stuDataList[i];
          if(sub_name_id == stuData.sub_name_id){
            cq = stuData.cq=="-1"? "0" : stuData.cq;
            mcq = stuData.mcq=="-1"? "0" : stuData.mcq;
            practical = stuData.practical=="-1"? "0" : stuData.practical;
          }
        }
      }

      int totalMarks = int.parse(cq) + int.parse(mcq) + int.parse(practical);
      var isFail = studentFailMarksCheck(code, mcq, cq, practical, examMarks);

      var point, letter;

      if (!isFail) {
        point = gradePointMarks(totalMarks, examMarks);
        letter = letterGradeMarks(totalMarks, examMarks);
      } else {
        point = "0.00";
        letter = "F";
      }

      var subDetails = HashMap<String, String>();
      // subDetails["id"] = stuData.id;
      subDetails["code"] = code;
      subDetails["cq"] = cq;
      subDetails["mcq"] = mcq;
      subDetails["practical"] = practical;
      subDetails["total_marks"] = "$totalMarks";
      subDetails["point"] = "$point";
      subDetails["letter"] = "$letter";

      if (i == 0) {
        firstItemStr = htmlBodyTable_RowFirstItem(subDetails);
        !isMainFail &&
            (isMainFail =
                studentFailMarksCheck(code, mcq, cq, practical, examMarks));
        fullGpa += double.parse(point);
      } else if (sub_name_id == optSubId) {
        optItemStr = htmlBodyTable_RowOptItem(subDetails);
        optGpa =
            (double.parse(point) - 2 >= 0 ? (double.parse(point) - 2) : 0.00);
      } else {
        othersItemStr += htmlBodyTable_RowSameItem(subDetails);
        fullGpa += double.parse(point);
        !isMainFail &&
            (isMainFail =
                studentFailMarksCheck(code, mcq, cq, practical, examMarks));
      }
    }
    String gpaExceptOpt = "${((fullGpa) / (length - 1)).toStringAsFixed(2)}";
    var gpaValue = ((fullGpa + optGpa) / (length - 1)) > 5.00
        ? "5.00"
        : ((fullGpa + optGpa) / (length - 1)).toStringAsFixed(2);
    var remarks = "Pass";
    if (isMainFail) {
      gpaValue = "F";
      gpaExceptOpt = "F";
      remarks = "Fail";
    }

    bodyTable += firstItemStr +
        htmlBodyTable_RowFirst_SubItem(gpaExceptOpt, gpaValue, length) +
        othersItemStr;

    bodyTable += htmlBodyTable_RowOptTitle(gpaValue);
    bodyTable += optItemStr;
    bodyTable += htmlBodyTable_RowRemarks(remarks, optGpa);
    bodyTable += end;
    return bodyTable;
  }

  String htmlBodyTable_RowFirstItem(subDetails) {
    String rowFirstItem = """<tr style="text-align: center">
              <td style="border: 1px solid; text-align: center">${subDetails["code"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["mcq"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["cq"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["practical"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["total_marks"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["point"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["letter"]}</td>

              """;
    return rowFirstItem;
  }

  String htmlBodyTable_RowFirst_SubItem(gpaExceptOpt, gpa, length) {
    String rowFirstItem = """
              <td style="border: 1px solid; text-align: center" rowspan="6">
                ${gpaExceptOpt}
              </td>
              <td
                style="border: 1px solid; text-align: center"
                rowspan="6"
                colspan="2"
              >
                ${gpa}
              </td>
            </tr>""";
    return rowFirstItem;
  }

  String htmlBodyTable_RowSameItem(subDetails) {
    String rowSameItem = """<tr style="text-align: center">
              <td style="border: 1px solid; text-align: center">${subDetails["code"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["mcq"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["cq"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["practical"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["total_marks"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["point"]}</td>
              <td style="border: 1px solid; text-align: center">${subDetails["letter"]}</td>
            </tr>""";
    return rowSameItem;
  }

  String htmlBodyTable_RowOptTitle(gpa) {
    String rowOptionalItem = """<tr style="text-align: center">
              <td
                style="
                  border: 1px solid;
                  text-align: center;
                  justify-content: start;
                  text-align: start;
                  font-weight: bold;
                "
                colspan="8"
              >
                Optional Subject
              </td>
              <td style="border: 1px solid; text-align: center" rowspan="2">
                Results
              </td>
              <td style="border: 1px solid; text-align: center" rowspan="2">
                ${gpa}
              </td>
            </tr>""";
    return rowOptionalItem;
  }

  String htmlBodyTable_RowOptItem(subDetails) {
    String rowOptionalItem = """<tr style="text-align: center">
              <td style="border: 1px solid; text-align: center" rowspan="2">
                ${subDetails["code"]}
              </td>
              <td
                style="border: 1px solid; text-align: center"
                rowspan="2"
              >${subDetails["mcq"]}</td>
              <td
                style="border: 1px solid; text-align: center"
                rowspan="2"
              >${subDetails["cq"]}</td>
              <td
                style="border: 1px solid; text-align: center"
                rowspan="2"
              >${subDetails["practical"]}</td>
              <td
                style="border: 1px solid; text-align: center"
                rowspan="2"
              >${subDetails["total_marks"]}</td>
              <td
                style="border: 1px solid; text-align: center"
                rowspan="2"
              >${subDetails["point"]}</td>
              <td
                style="border: 1px solid; text-align: center"
                rowspan="2"
              >${subDetails["letter"]}</td>
              <td style="border: 1px solid; text-align: center">GP above 2</td>
            </tr>""";
    return rowOptionalItem;
  }

  String htmlBodyTable_RowRemarks(value, optGpa) {
    String rowRemarks = """<tr style="text-align: center">
              <td style="border: 1px solid; text-align: center">${(optGpa > 0.00 ? optGpa : "F")}</td>
              <td style="border: 1px solid; text-align: center" rowspan="2">
                Remarks
              </td>
              <td style="border: 1px solid; text-align: center" rowspan="2">
                $value
              </td>
            </tr>""";
    return rowRemarks;
  }

  String htmlBodySignature() {
    String bodySignature = """<div
          style="
            display: flex;
            justify-content: space-between;
            text-align: center;
            margin-top: 80px;

            margin-left: 20px;
            margin-right: 20px;
            margin-bottom: 0px;
          "
        >
          <div>
            <div style="margin-right: 100px; width: 400px">
              <h3 style="padding: 0px; margin: 0px">Convener</h3>
              <h3 style="padding: 0px; margin: 0px">Examination Committee</h3>
              <p style="padding: 0px; margin: 0px">
                Chittagong University Laboratory School and College
              </p>
            </div>
          </div>

          <div style="text-align: right">
            <div style="width: 400px; text-align: center">
              <h3 style="padding: 0px; margin: 0px">Principal</h3>
              <p style="padding: 0px; margin: 0px">
                Chittagong University Laboratory School and College
              </p>
            </div>
          </div>
        </div>""";
    return bodySignature;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(
        title: "Transcript Print Screen",
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
                      bool  resultExist = false;

                      String htmlBodyItemArray = "";
                      if(itemsArray.length>0){
                        resultExist = true;
                      }
                      for(var item in itemsArray){
                        final stuDataList = item.stu_data;
                        final length = stuDataList.length;
                        if(length>=7 && widget.grp_id!="3"){
                          for (int i = 0; i < length; i++) {
                            final stuData = stuDataList[i];
                            final code = stuData.code;
                            final sub_name = stuData.sub_name;
                            final sub_name_id = stuData.sub_name_id;
                            bool subjExist = subCodeList.any((sub) => sub.code == code);
                            if(!subjExist){
                              // print("----$subjExist------------$code----------------${subCodeList.length}-----");
                              subCodeList.add(SubCodeModel(code: code, sub_name_id:sub_name_id, title: sub_name));
                            }
                          }

                        }
                      }

                      itemsArray.asMap().forEach((index, item) {
                        htmlBodyItemArray += htmlBodyItem(item, index+1);
                      });

                      if(resultExist){
                        allHtml = htmlMainStart() +
                            htmlBodyStart() +
                            htmlBodyItemArray +
                            htmlBodyEnd() +
                            htmlMainEnd();
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
