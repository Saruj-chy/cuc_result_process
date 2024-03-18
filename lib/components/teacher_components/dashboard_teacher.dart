import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/sess_model.dart';
import 'package:cuc_result_processing/components/login_page.dart';
import 'package:cuc_result_processing/components/teacher_components/add_sub_page.dart';
import 'package:cuc_result_processing/components/teacher_components/group_page.dart';
import 'package:cuc_result_processing/file/constant.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../file/color_cuc.dart';
import '../../layout/InitializeMethod.dart';
import '../../layout/profile_container.dart';

String? name, phnNum, authToken, userID;

class DashboardTeacher extends StatefulWidget {
  static String id = "dashboard_teacher";
  const DashboardTeacher({Key? key}) : super(key: key);

  @override
  State<DashboardTeacher> createState() => _DashboardTeacherState();
}

class _DashboardTeacherState extends State<DashboardTeacher> {
  bool error = true, visibility = false;
  late Future<SessModel> sesModel;

  @override
  void initState() {
    super.initState();
    getSaveData();
  }

  void getSaveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("name");
      phnNum = pref.getString("phn_num");
      authToken = pref.getString("auth_token");
      userID = pref.getString("user_id");

      sesModel = fetchSessList(phnNum!, authToken!);
    });
  }

  Future<SessModel> fetchSessList(String phnNum, String authToken) async {
    var url = Uri.parse(Constant.put_sess_url);
    final response = await http.post(url,
        body: {"state": "1", "auth_token": authToken, "phn_num": phnNum});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      setState(() {
        visibility = true;
      });
      return SessModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<bool> _onWillPop() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit from the App?'),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                {pref.clear(), Navigator.pushNamed(context, LoginPage.id)},
            child: const Text('Signout'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes'),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        _onWillPop();
      },
      child: Scaffold(
        appBar: CustomAppbar(title: "CUC Result Processing System",
          implyLeading: false,
        fontSize: 22.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: ColorCUC.purple900,size: 30,),
            onPressed: () {
              ShowAboutDialog(context);
            },
          ),
        ],),
        // backgroundColor: Colors.green,
        body: SafeArea(
          child: visibility
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ProfileContainer(title: name!, phnNum: phnNum!),
                      _SubHorizentalList(context, sesModel),
                      _SessVertical(context, sesModel, width),
                    ],
                  ),
                )
              : VisibilityShow(height, !visibility),
        ),
      ),
    );
  }
}

Widget _SubHorizentalList(BuildContext context, Future<SessModel> sessModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Your Subject ",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.normal,
                fontSize: 22.0,
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddSubPage()));
              },
              icon: const Icon(
                Icons.add_circle,
                size: 40,
              ),
              color: ColorCUC.purple300,
            )
          ],
        ),
      ),
      Container(
        height: 250.0,
        child: FutureBuilder<SessModel>(
          future: sessModel,
          builder: (context, snapshot) {
            List<Widget> textWidgets = [];
            if (snapshot.hasData) {
              final itemsArray = snapshot.data!.subs;
              int posi = 0;
              for (var item in itemsArray) {
                posi = posi + 1;
                final name = item.name;
                final grpName = item.grp_name;
                final title = item.title;
                final code = item.code;
                final grpSubId = item.grp_sub_id;
                final textView = _SubsWidget(
                    context, grpName, "$name $title", code, grpSubId);
                textWidgets.add(textView);
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                children: textWidgets,
              );
            }
            return const SizedBox(
              height: 5.0,
            );
          },
        ),
      ),
    ],
  );
}

Widget _SessVertical(
    BuildContext context, Future<SessModel> sesModel, double width) {
  return Container(
    margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
    width: width,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(blurRadius: 2.0, color: Colors.grey)]),
    child: FutureBuilder<SessModel>(
      future: sesModel,
      builder: (context, snapshot) {
        List<Widget> textWidgets = [];
        if (snapshot.hasData) {
          final itemsArray = snapshot.data!.data;
          int posi = 0;
          for (var item in itemsArray) {
            posi = posi + 1;
            final id = item.id;
            final itemName = item.name;
            final textView =
                _itemSessWidget(context, width, id, itemName, posi);
            textWidgets.add(textView);
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

Widget _SubsWidget(BuildContext context, String grpName, String subName,
    String code, String grpSubId) {
  return GestureDetector(
    onLongPress: () {
      showDeleteUserDialog(context, grpSubId);
    },
    child: Padding(
      padding:
          const EdgeInsets.only(top: 0.0, left: 20, bottom: 0.0, right: 10),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 7.0,
        child: Container(
          margin: const EdgeInsets.only(
              top: 20.0, left: 20.0, bottom: 20.0, right: 20),
          // color: Colors.deepOrange,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text(
                    "Group: ",
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    grpName,
                    style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Text(
                    "Subject: ",
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    subName,
                    style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Text(
                    "Code: ",
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    code,
                    style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.black),
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

Widget _itemSessWidget(
    BuildContext context, double width, String id, String itemName, int posi) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GroupPage(sess_id: id, posi: posi)));
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
              Container(
                height: 90.0,
                width: 90.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    // color: Colors.green,
                    image: const DecorationImage(
                      image: AssetImage("images/cuc_logo.png"),
                    )),
              ),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  posi == 1
                      ? const Text(
                          "1st Year",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0,
                          ),
                        )
                      : const Text(
                          "2nd Year ",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0,
                          ),
                        ),
                  const Text(
                    "Session ",
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  FDottedLine(
                    color: const Color(0xFF512DA8),
                    width: 150.0,
                    strokeWidth: 5.0,
                    dottedLength: 15.0,
                    space: 5.0,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    itemName,
                    style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.black),
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

showDeleteUserDialog(BuildContext context, String grpSubId) {
  Widget noButton = TextButton(
    child: const Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget yesButton = TextButton(
    child: const Text("Yes"),
    onPressed: () async {

    },
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Delete user subject"),
    content: const Text("Are you sure to want to delete this subject?"),
    actions: [
      noButton,
      yesButton,
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

