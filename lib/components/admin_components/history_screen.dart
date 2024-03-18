import 'dart:convert';

import 'package:cuc_result_processing/bloc_components/history_model.dart';
import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../file/color_cuc.dart';
import '../../file/constant.dart';
import 'dashboard_admin.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;

  late Future<HistoryModel> historyModel;
  bool error = true ;
  String? currentDate ;

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 10000));
    _lastDay = DateTime.now().add(const Duration(days: 10000));

    _selectedDay = DateTime.now();

    currentDate = DateFormat("yyyy-MM-dd").format(_selectedDay);
    historyModel = fetchHistoryList(currentDate!);
  }

  Future<HistoryModel> fetchHistoryList(String currentDate) async {
    var url = Uri.parse(Constant.history_url);
    final response = await http.post(url, body: {
      "auth_token": authToken,
      "phn_num": phnNum,
      "current_date": currentDate
    });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200 && !jsonResponse["error"]) {
      setState(() {
        error = jsonResponse["error"];
      });
      return HistoryModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<void> _refreshData(String currentDate) async {
    setState(() {
      historyModel = fetchHistoryList(currentDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(
        title: "CUC Result Processing System",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusedDay,
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: CalendarFormat.month,
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                ),
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    currentDate =
                        DateFormat("yyyy-MM-dd").format(_focusedDay);
                    _refreshData(currentDate!);
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: ColorCUC.purple900),
                ),
              ),
              !error ? RefreshIndicator(
                onRefresh: () => _refreshData(currentDate!),
                child: SingleChildScrollView(
                  child: Container(
                    height: 450,
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(blurRadius: 2.0, color: Colors.grey)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: FutureBuilder<HistoryModel>(
                        future: historyModel,
                        builder: (context, snapshot) {
                          List<Widget> textWidgets = [];
                          if (snapshot.hasData) {
                            final itemsArray = snapshot.data!.data;
                            for (var item in itemsArray) {
                              final msg = item.msg;

                              final textView = _itemWidget(context, msg);
                              textWidgets.add(textView);
                            }
                            return ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              children: textWidgets,
                            );
                          }

                          return const SizedBox(
                            height: 5.0,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ):Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemWidget(BuildContext context, String msg) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 0.0, left: 0, bottom: 0.0, right: 0),
      child: Card(
        color: ColorCUC.purple50,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            msg,
            style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black),
          ),
        ),
      ),
    );
  }
}
