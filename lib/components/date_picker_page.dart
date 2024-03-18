import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../file/color_cuc.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({Key? key}) : super(key: key);

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  @override
  Widget build(BuildContext context) {
    return const HomeCalendarPage();
  }
}

class HomeCalendarPage extends StatefulWidget {
  const HomeCalendarPage({Key? key}) : super(key: key);

  @override
  State<HomeCalendarPage> createState() => _HomeCalendarPageState();
}

class _HomeCalendarPageState extends State<HomeCalendarPage> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 10000));
    _lastDay = DateTime.now().add(const Duration(days: 10000));

    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TableCalendar(
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

            });
          },

          // headerVisible: true,
          // daysOfWeekVisible: true,
          // sixWeekMonthsEnforced: true,
          // shouldFillViewport: false,
          // headerStyle: HeaderStyle(titleTextStyle: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.w800)),
          // calendarStyle: CalendarStyle(
          //   selectedTextStyle: TextStyle(fontSize:25, color: ColorCUC.purple900,  fontWeight: FontWeight.bold ),
          //     todayTextStyle: TextStyle(fontSize:25, color: ColorCUC.purple900,  fontWeight: FontWeight.bold )),
          //
          // onDaySelected: (date, events) {
          // },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: ColorCUC.purple900),

          ),
        ),
      ),
    );
  }
}
