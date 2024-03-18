import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/topics_model.dart';
import 'package:cuc_result_processing/components/teacher_components/stu_page.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:cuc_result_processing/layout/item_press.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../layout/InitializeMethod.dart';
import 'dashboard_teacher.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key, required this.sess_id, required this.exam_id, required this.grp_id}) : super(key: key);
  final grp_id, exam_id, sess_id ;

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  late Future<TopicModel> topicModel ;
  bool error = true ;

  @override
  void initState() {
    super.initState();

    topicModel = fetchTopicList(phnNum!, authToken!, widget.grp_id.toString()) ;
  }

  Future<TopicModel> fetchTopicList(String phnNum, String authToken, String grpId) async {
    var url = Uri.parse(Constant.teacher_sub_url);
    final response = await http
        .post(url,
        body: {
          "auth_token": authToken,
          "phn_num": phnNum,
          "grp_id": grpId
        });
    var jsonResponse = json.decode(response.body);
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
      appBar: CustomAppbar(title: "Teacher's Subject",),
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

  Widget _TopicVertical(BuildContext context, Future<TopicModel> topicModel, TopicPage widget, double width) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
      width: width,
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

              final widgets = ItemPress(title: "$name $title",onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        StudentPage(
                            sess_id: widget.sess_id,
                            grp_sub_id: grpSubId,
                            exam_id: widget.exam_id,
                            grp_id: grpId )));

              }) ;
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
}


