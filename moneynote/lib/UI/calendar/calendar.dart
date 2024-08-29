import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String, dynamic>? userMetadata;
const greybgcolor = Color(0xFFDFE6DD);
const greenbgcolor = Color(0xFF62C42A);

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
    userMetadata = widget.metadata['metadata'];
    getTransaction();
  }

  Future<void> getTransaction() async {
    final url = Uri.parse('http://192.168.1.9:9001/transaction');

    try {
      print(
          'User Metadata: ${userMetadata?['_id']}'); // In metadata để kiểm tra
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );

      print(
          'Status Code: ${response.statusCode}'); // In mã trạng thái để kiểm tra

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data: $data'); // In dữ liệu trả về để kiểm tra

        // Xử lý dữ liệu
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final srcHeight = MediaQuery.of(context).size.height;
    // Assuming these values might come from widget.metadata in a real scenario
    const double income = 1000000;
    const double expense = -1670000;

    // Calculate Total
    const double total = income + expense;

    return Scaffold(
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: srcHeight / 8,
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFDFE6DD),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.05, 1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFCFDFC6),
                        Color(0xFFFFFFFF),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
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
          TableCalendar(
            rowHeight: srcHeight / 16,
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
                print(srcHeight);
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
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(color: Colors.red),
              selectedDecoration: const BoxDecoration(
                color: greenbgcolor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: greenbgcolor.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              decoration: BoxDecoration(
                color: greybgcolor,
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
            daysOfWeekVisible: true,
            daysOfWeekHeight: 40,
            headerStyle: const HeaderStyle(
              headerPadding: EdgeInsets.only(top: 0, bottom: 0),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              formatButtonVisible: false,
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              decoration: BoxDecoration(
                color: greenbgcolor,
              ),
              titleCentered: true,
            ),
          ),
          // Income, Expense, and Total Summary
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Thu nhập'),
                    Text(
                      '${income.toStringAsFixed(0)}đ',
                      style: const TextStyle(
                          color: income >= 0 ? greenbgcolor : Colors.red),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Chi tiêu'),
                    Text(
                      '${expense.abs().toStringAsFixed(0)}đ',
                      style: const TextStyle(
                          color: expense >= 0 ? greenbgcolor : Colors.red),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Tổng'),
                    Text(
                      '${total.toStringAsFixed(0)}đ',
                      style: const TextStyle(
                          color: total >= 0 ? greenbgcolor : Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: const [
              ExpansionTile(
                title: Text('Danh sách chi tiêu'),
                leading: Icon(Icons.monetization_on),
                children: <Widget>[
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
                ],
              ),
              ExpansionTile(
                title: Text('Danh sách chi tiêu'),
                leading: Icon(Icons.monetization_on),
                children: <Widget>[
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
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
