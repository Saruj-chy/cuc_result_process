import 'dart:convert';

import 'package:cuc_result_processing/layout/InitializeMethod.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../bloc_components/subs_model.dart';
import '../../file/color_cuc.dart';
import '../../file/constant.dart';
import 'dashboard_teacher.dart';


String sub_name = "";
String subName = "Select a Subject";
class AddSubPage extends StatefulWidget {
  const AddSubPage({Key? key}) : super(key: key);

  @override
  State<AddSubPage> createState() => _AddSubPageState();
}

class _AddSubPageState extends State<AddSubPage> {
  bool error = true;
  bool showProgress = false;
  late Future<SubsModel> subsModel;
  var grp_items = ['Select Group Name', 'Science', 'Commerce', 'Arts'];
  String grpId = "0";
  String grpValue = "Select Group Name";
  var arraySubsList;



  @override
  void initState() {
    super.initState();
    subsModel = fetchSubsList();
    subName = "Select a Subject";
    sub_name = "Select a Subject";
  }
  String getCategoryList(arraySubsList, String grpId, String name) {
    for (var value in arraySubsList) {
      String temp = value.name + " " + value.title;
      if (temp == name && value.grp_id == grpId) {
        return value.id;
      }
    }
    return "0";
  }

  Future<void> _NewSubAdd() async {

    String grpSubId = "0";
    if (arraySubsList != null) {
      grpSubId = getCategoryList(arraySubsList, grpId, sub_name);
    }
    if (int.parse(grpSubId) > 0) {
      setState(() {
        showProgress = true;
      });
      var url = Uri.parse(Constant.put_teac_sub_url);
      final response = await http.post(url, body: {
        "state": "1",
        "phn_num": phnNum,
        "auth_token": authToken,
        "grp_sub_id": grpSubId,
      });
      var jsonResponse = json.decode(response.body);
      setState(() {
        showProgress = false;
      });
      if (response.statusCode == 200 && !jsonResponse["error"]) {
        setState(() {
          error = jsonResponse["error"];
        });
        ToastMsg(jsonResponse["msg"]);
        Navigator.pushNamed(context, DashboardTeacher.id) ;
      } else {
        ToastMsg(jsonResponse["msg"]);
        throw Exception('Failed to load post');
      }

    } else {
      ToastMsg("Please select the subject");
    }
  }



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppbar(title: "New Subject Add", implyLeading: false,),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton(
                      alignment: AlignmentDirectional.center,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      iconSize: 30.0,
                      hint: const Text("Select a Group"),
                      style: const TextStyle(
                        color: ColorCUC.purple900,
                        fontSize: 20,
                      ),
                      isExpanded: true,
                      value: grpValue,
                      items: grp_items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        subName = "Select a Subject";
                        sub_name = "Select a Subject";
                        setState(() {
                          grpValue = newValue.toString();

                          if (newValue == grp_items[1]) {
                            grpId = "1";
                          } else if (newValue == grp_items[2]) {
                            grpId = "2";
                          } else if (newValue == grp_items[3]) {
                            grpId = "3";
                          }else{
                            grpId = "0";
                          }
                        });

                      },
                    ),

                    FutureBuilder<SubsModel>(
                      future: subsModel,
                      builder: (context, snapshot) {
                        List<String> subList = [];
                        if (snapshot.hasData) {
                          final subsArray = snapshot.data!.data;
                          arraySubsList = subsArray;
                          for (var subs in subsArray) {
                            final name = subs.name;
                            final title = subs.title;
                            if (grpId == subs.grp_id) {
                              subList.add("$name $title");
                            }
                          }


                          return Column(
                            children: [
                              if (subList.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: SizedBox(
                                    width: width,
                                    height: 500,
                                    child: ListView.builder(
                                        itemCount: subList.length,
                                        itemBuilder: (ctx, i) {
                                          return GestureDetector(
                                              child:
                                              Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only(top: 10),
                                                  child: Material(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    shadowColor: ColorCUC.purple300,
                                                    color: sub_name == subList[i]? ColorCUC.purple900: ColorCUC.purple300,
                                                    elevation: 7.0,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                                      child: Center(
                                                        child: Text(
                                                          subList[i],
                                                          style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat',),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              onTap: () {
                                                setState(() {
                                                  sub_name = subList[i];
                                                });
                                              }
                                          );
                                        })
                                  ),
                                )
                              ],
                            ],
                          );
                        }

                        return const SizedBox(
                          height: 20.0,
                        );
                      },
                    ),

                    const SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: ColorCUC.purple300,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            _NewSubAdd();
                          },
                          minWidth: 150.0,
                          height: 42.0,
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                  ],
                ),
              ),
            ),
            Visibility(
              visible: showProgress,
              child: Container(
                color: Colors.grey.withOpacity(0.5),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ColorCUC.purple900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
