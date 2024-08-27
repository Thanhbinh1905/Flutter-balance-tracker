import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class calendar extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const calendar({super.key, required this.metadata});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<calendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // Assuming these values might come from widget.metadata in a real scenario
    final double income = 1000000;
    final double expense = -1670000;

    // Calculate Total
    final double total = income + expense;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green,
      //   title: Text('Lịch'),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          // Calendar View
          Container(
            // color: Colors.green,
            child: TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;

                  String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDay);
                  print("Selected date: $formattedDate");
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Income, Expense, and Total Summary
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Thu nhập'),
                    Text(
                      '${income.toStringAsFixed(0)}đ',
                      style: TextStyle(color: income >= 0 ? Colors.green : Colors.red),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Chi tiêu'),
                    Text(
                      '${expense.abs().toStringAsFixed(0)}đ',
                      style: TextStyle(color: expense >= 0 ? Colors.green : Colors.red),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Tổng'),
                    Text(
                      '${total.toStringAsFixed(0)}đ',
                      style: TextStyle(color: total >= 0 ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Expense List
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.blue),
                  title: Text('Chi tiêu hàng ngày'),
                  subtitle: Text('21/08/2024 (Th 4)'),
                  trailing: Text('700.000đ'),
                ),
                ListTile(
                  leading: Icon(Icons.lightbulb, color: Colors.orange),
                  title: Text('Tiền điện nước'),
                  subtitle: Text('21/08/2024 (Th 4)'),
                  trailing: Text('300.000đ'),
                ),
                ListTile(
                  leading: Icon(Icons.spa, color: Colors.pink),
                  title: Text('Mỹ phẩm'),
                  subtitle: Text('21/08/2024 (Th 4)'),
                  trailing: Text('300.000đ'),
                ),
                // More ListTiles...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
