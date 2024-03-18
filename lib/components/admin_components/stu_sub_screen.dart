import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/topics_model.dart';
import 'package:cuc_result_processing/components/admin_components/stu_result_screen.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../file/color_cuc.dart';
import '../../layout/InitializeMethod.dart';
import 'dashboard_admin.dart';

class StuSubScreen extends StatefulWidget {
  const StuSubScreen({Key? key, required this.stu_id, required this.exam_id, required this.grp_id}) : super(key: key);
  final grp_id, exam_id, stu_id ;

  @override
  State<StuSubScreen> createState() => _StuSubScreenState();
}

class _StuSubScreenState extends State<StuSubScreen> {
  late Future<TopicModel> topicModel ;
  bool error = true ;

  @override
  void initState() {
    super.initState();

    topicModel = fetchTopicList(phnNum!, authToken!, widget.grp_id.toString(), widget.stu_id.toString()) ;
  }

  Future<TopicModel> fetchTopicList(String phnNum, String authToken, String grpId, String stuId) async {
    var url = Uri.parse(Constant.stu_sub_url);
    var jsonResponse ;
    final response = await http
        .post(url,
        body: {
          "auth_token": authToken,
          "phn_num": phnNum,
          "grp_id": grpId,
          "stu_id": stuId
        });
    // print(response.body.toString());
    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200 && !jsonResponse["error"]) {
      setState(() {
        error = jsonResponse["error"] ;
      });
      return TopicModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(title: "Student's Subject",),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              error? VisibilityShow(height, error) : _TopicVertical(context, topicModel, widget, width),



            ],
          ),
        ),
      ),
    );
  }

  Widget _TopicVertical(BuildContext context, Future<TopicModel> topicModel, StuSubScreen widget, double width) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
      width: width,
      height: MediaQuery.of(context).size.height-10,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [BoxShadow(blurRadius: 2.0, color: Colors.grey)]),
      child: FutureBuilder<TopicModel>(
        future: topicModel,
        builder: (context, snapshot) {
          List<Widget> textWidgets = [];
          if (snapshot.hasData) {
            final itemsArray = snapshot.data!.data;
            for (var item in itemsArray) {
              final name = item.name;
              final title = item.title;
              final grpId = item.grp_id;
              final grpSubId = item.grp_sub_id;
              final widgets = _itemTopicWidget(context,
                  widget.stu_id,
                  grpId,
                  grpSubId,
                  widget.exam_id,
                  "$name $title" ) ;
              textWidgets.add(widgets);
            }
            return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              children: textWidgets,
            );
          }

          return const SizedBox(
            height: 5.0,
          );
        },
      ),
    );
  }

  Widget _itemTopicWidget(
      BuildContext context, String stuId, String grpId, String grpSubId, String examId, String itemName ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                StudentResultScreen(
                    stu_id: stuId,
                    grp_sub_id: grpSubId,
                    exam_id: examId)));

      },
      child: Padding(
        padding:
        const EdgeInsets.only(top: 10.0, left: 10, bottom: 10.0, right: 10),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 7.0,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            // color: Colors.deepOrange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Flexible(
                  child: Text(
                    itemName,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: ColorCUC.purple900,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


