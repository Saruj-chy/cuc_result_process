import 'dart:convert';

import 'package:cuc_result_processing/components/teacher_components/dashboard_teacher.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:cuc_result_processing/layout/custom_container_box.dart';
import 'package:cuc_result_processing/layout/item_press.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../bloc_components/grp_model.dart';
import '../../layout/InitializeMethod.dart';
import '../../layout/profile_container.dart';
import 'exam_page.dart';

class GroupPage extends StatefulWidget {
  static String id = "grp_page" ;
  const GroupPage({Key? key, required this.sess_id, required this.posi}) : super(key: key);
  final sess_id, posi ;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool error = true;
  late Future<GrpModel> grpModel ;

  @override
  void initState() {
    super.initState();
    grpModel = fetchSubsList(phnNum!, authToken!) ;
  }




  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(
        title: "CUC Result Processing System"
      ),
      // backgroundColor: ColorCUC.purple50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileContainer(title: name!, phnNum: phnNum!),

              error? VisibilityShow(height, error) : _GrpVertical(context, grpModel, widget, width),


            ],
          ),
        ),
      ),
    );
  }



  Widget _GrpVertical(BuildContext context, Future<GrpModel> grpModel, GroupPage widget, double width) {
    return CustomContainerBox(child: FutureBuilder<GrpModel>(
      future: grpModel,
      builder: (context, snapshot) {
        List<Widget> textWidgets = [];
        if (snapshot.hasData) {
          final itemsArray = snapshot.data!.data;
          for (var item in itemsArray) {
            final id = item.id;
            final itemName = item.name;
            final widgets = ItemPress(onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ExamPage(
                          sess_id: widget.sess_id,
                          grp_id: id,
                          year: widget.posi.toString())));
            }, title: itemName) ;
            textWidgets.add(widgets);
          }
          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: textWidgets,
          );
        }

        return const SizedBox(
          height: 5.0,
        );
      },
    ),);


  }

}


