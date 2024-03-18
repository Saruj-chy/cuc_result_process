import 'package:cuc_result_processing/components/admin_components/history_screen.dart';
import 'package:cuc_result_processing/components/admin_components/result_sheet_field_screen.dart';
import 'package:cuc_result_processing/components/admin_components/session_screen.dart';
import 'package:cuc_result_processing/components/admin_components/tabulation_field_screen.dart';
import 'package:cuc_result_processing/components/admin_components/teacher_screen.dart';
import 'package:cuc_result_processing/components/admin_components/trans_field_screen.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:cuc_result_processing/layout/dashboard_widget.dart';
import 'package:cuc_result_processing/layout/profile_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../file/color_cuc.dart';
import '../../layout/InitializeMethod.dart';
import '../login_page.dart';

String? name, phnNum, authToken;
class DashboardAdmin extends StatefulWidget {
  static String id = "dashboard_admin";
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  bool error = true, visibility = false;
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
      visibility = true;
    });
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
            onPressed: () => {
              pref.clear(),
              Navigator.pushNamed(context, LoginPage.id)},
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

    return PopScope(
      canPop:false,
      onPopInvoked: (didPop) {
        _onWillPop();
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: "CUC Result Processing System",
          implyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded, color: ColorCUC.purple900,size: 30,),
              onPressed: () {
                ShowAboutDialog(context);
              },
            ),
          ],
        ),
        // backgroundColor: Colors.green,
        body: SafeArea(
          child: visibility
              ? SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ProfileContainer(title: name!, phnNum: phnNum!),
                Container(
                  margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [BoxShadow(blurRadius: 2.0, color: Colors.grey)]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: GestureDetector(
                                onTap:(){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const TeacherScreen()
                                  ));
                                },
                                child: DashboardWidget(title: "Teacher"))),
                            const SizedBox(width: 10,),
                            Expanded(child: GestureDetector(
                                onTap:(){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SessionScreen()
                                  ));
                                },
                                child: DashboardWidget(title: "Session"))),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: GestureDetector(
                                onTap:(){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryScreen()
                                  ));
                                },
                                child: DashboardWidget(title:"History"))),
                            const SizedBox(width: 10,),
                            Expanded(child: GestureDetector(
                                onTap:(){

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          // TransSessionScreen()
                                    const TransFieldScreen()
                                  ));

                                },
                                child: DashboardWidget(title: "Transcript"))),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        GestureDetector(
                            onTap:(){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                  // TransSessionScreen()
                                  const TabuFieldScreen()
                              ));

                            },
                            child: DashboardWidget(title:  "Tabulation Sheet")),
                        const SizedBox(height: 20,),
                        GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                  // TransSessionScreen()
                                  const ResultSheetFieldScreen()
                              ));
                            },
                            child: DashboardWidget(title: "Total Result")),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
              : VisibilityShow(MediaQuery.of(context).size.height, visibility),
        ),
      ),
    );
  }
}





