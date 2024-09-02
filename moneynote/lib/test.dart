import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Birthday Calendar')),
        body: const CalendarWithBirthday(),
      ),
    );
  }
}

class CalendarWithBirthday extends StatefulWidget {
  const CalendarWithBirthday({super.key});

  @override
  _CalendarWithBirthdayState createState() => _CalendarWithBirthdayState();
}

class _CalendarWithBirthdayState extends State<CalendarWithBirthday> {
  final Map<DateTime, List<String>> _events = {
    DateTime(DateTime.now().year, 5, 19): ['My birthday'],
  };

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      eventLoader: _getEventsForDay,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 5.0,
                height: 5.0,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.only(top: 5.0, right: 5.0),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
