import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

final greybgcolor = Color(0xFFDFE6DD);
final greenbgcolor = Color(0xFF62C42A);

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
      //   backgroundColor: greenbgcolor,
      //   title: Text('Lịch'),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: 110,
              padding: EdgeInsets.only(top: 30, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFDFE6DD),
                    Color(0xFFFFFFFF),
                  ], // Các màu của gradient
                  stops: [0.05, 1], // Các điểm dừng của gradient
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(8.0), // Padding bên trong hộp
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFCFDFC6),
                        Color(0xFFFFFFFF),
                      ], // Các màu của gradient
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius:
                        BorderRadius.circular(15.0), // Bo tròn các góc của hộp
                  ),
                  child: const Text(
                    "Lịch",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF62C42A),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              )),
          // Calendar View
          Container(
            // color: greenbgcolor,
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

                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(_selectedDay);
                  print("Selected date: $formattedDate");
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;

                  String currentMonth =
                      DateFormat('MMMM yyyy').format(_focusedDay);
                  print("Currently displaying month: $currentMonth");
                });
              },
              calendarStyle: CalendarStyle(
                weekendTextStyle: TextStyle(color: Colors.red),
                selectedDecoration: BoxDecoration(
                  color: greenbgcolor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: greenbgcolor.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                decoration: BoxDecoration(
                  color: greybgcolor, // Màu nền xám cho ngày trong tuần
                ),
                weekdayStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // locale: 'en_GB',
              daysOfWeekVisible: true,
              daysOfWeekHeight: 40,
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.white),
                decoration: BoxDecoration(
                  color: greenbgcolor, // Màu nền của thanh tiêu đề
                ),
                titleCentered: true, // Căn chỉnh tiêu đề về giữa
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
                      style: TextStyle(
                          color: income >= 0 ? greenbgcolor : Colors.red),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Chi tiêu'),
                    Text(
                      '${expense.abs().toStringAsFixed(0)}đ',
                      style: TextStyle(
                          color: expense >= 0 ? greenbgcolor : Colors.red),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Tổng'),
                    Text(
                      '${total.toStringAsFixed(0)}đ',
                      style: TextStyle(
                          color: total >= 0 ? greenbgcolor : Colors.red),
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
