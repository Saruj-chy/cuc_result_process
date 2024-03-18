import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/grp_model.dart';
import 'package:cuc_result_processing/components/teacher_components/dashboard_teacher.dart';
import 'package:cuc_result_processing/components/teacher_components/topic_page.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:cuc_result_processing/layout/item_press.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../layout/InitializeMethod.dart';
import '../../layout/profile_container.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key, required this.sess_id, required this.year, required this.grp_id}) : super(key: key);
  final year, grp_id, sess_id;

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  bool error = true;
  late Future<GrpModel> grpModel ;

  @override
  void initState() {
    super.initState();

    grpModel = fetchExamsList(phnNum!, authToken!, widget.year.toString()) ;
  }



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(
        title: "CUC Result Processing System",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileContainer(title: name!, phnNum: phnNum!),
              error? VisibilityShow(height, error) : _ExamVertical(context, grpModel, widget, width),
            ],
          ),
        ),
      ),
    );



  }



  Widget _ExamVertical(BuildContext context, Future<GrpModel> grpModel, ExamPage widget, double width) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [BoxShadow(blurRadius: 2.0, color: Colors.grey)]),
      child: FutureBuilder<GrpModel>(
        future: grpModel,
        builder: (context, snapshot) {
          List<Widget> textWidgets = [];
          if (snapshot.hasData) {
            final itemsArray = snapshot.data!.data;
            for (var item in itemsArray) {
              final id = item.id;
              final itemName = item.name;
              final widgets = ItemPress(onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TopicPage(
                          sess_id: widget.sess_id,
                          exam_id: id,
                          grp_id: widget.grp_id,)));

              }, title: itemName) ;
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
