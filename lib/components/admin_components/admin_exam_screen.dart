import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/grp_model.dart';
import 'package:cuc_result_processing/components/admin_components/stu_sub_screen.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../file/color_cuc.dart';
import '../../layout/InitializeMethod.dart';
import 'dashboard_admin.dart';

class AdminExamScreen extends StatefulWidget {
  const AdminExamScreen(
      {Key? key,
      required this.sess_id,
      required this.stu_id,
      required this.year,
      required this.grp_id})
      : super(key: key);
  final year, grp_id, sess_id, stu_id;

  @override
  State<AdminExamScreen> createState() => _AdminExamScreenState();
}

class _AdminExamScreenState extends State<AdminExamScreen> {
  bool error = true;
  late Future<GrpModel> grpModel;

  @override
  void initState() {
    super.initState();
    grpModel = fetchSubsList(phnNum!,
        authToken!,
        widget.year.toString());
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
              error
                  ? VisibilityShow(height, error)
                  : _ExamVertical(context, grpModel, widget, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ExamVertical(BuildContext context, Future<GrpModel> grpModel,
      AdminExamScreen widget, double width) {
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
              final widgets = _itemExamWidget(
                  context, id, widget.grp_id.toString(), itemName);
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

  Widget _itemExamWidget(
      BuildContext context, String examId, String grpId, String itemName) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StuSubScreen(
                  stu_id: widget.stu_id,
                  exam_id: examId,
                  grp_id: grpId,
                )));
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 10, bottom: 20.0, right: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 7.0,
          child: Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            // color: Colors.deepOrange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: ColorCUC.purple900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
