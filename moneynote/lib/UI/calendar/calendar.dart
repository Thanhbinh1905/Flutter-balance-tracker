import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneynote/UI/home/homedb.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneynote/utils/color_convert.dart';
import 'package:moneynote/utils/icon_convert.dart';

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
  late String currentMonth;
  late String currentYear;
  late List<Map<String, dynamic>> dataTransaction = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    userMetadata = widget.metadata['metadata'];
    currentMonth = DateFormat('MM').format(_focusedDay);
    currentYear = DateFormat('yyyy').format(_focusedDay);

    // Fetch transaction data and update UI
    getTransaction(currentMonth, currentYear).then((data) {
      setState(() {
        dataTransaction = data; // Cập nhật dataTransaction với dữ liệu mới
      });
    }).catchError((error) {
      print('Error fetching transaction data: $error');
    });
  }

  Future<List<Map<String, dynamic>>> getTransaction(
      String month, String year) async {
    final url = Uri.parse(
        'http://192.168.1.9:9001/transaction?month=$month&year=$year');

    try {
      // print(
      //     'User Metadata: ${userMetadata?['_id']}'); // In metadata để kiểm tra
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );

      // print(
      //    'Status Code: ${response.statusCode}'); // In mã trạng thái để kiểm tra
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Data: $data'); // In dữ liệu trả về để kiểm tra

        // Trả về dữ liệu
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error occurred while fetching data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final srcHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            // height: srcHeight / 8,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDFE6DD), Color(0xFFFFFFFF)],
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
                    colors: [Color(0xFFCFDFC6), Color(0xFFFFFFFF)],
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
            ),
          ),
          // Calendar View
          TableCalendar(
            // rowHeight: srcHeight / 16,
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
              });
            },
            onPageChanged: (focusedDay) async {
              setState(() {
                _focusedDay = focusedDay;
                currentMonth = DateFormat('MM').format(_focusedDay);
                currentYear = DateFormat('yyyy').format(_focusedDay);
              });
              try {
                dataTransaction =
                    await getTransaction(currentMonth, currentYear);
                setState(() {});
              } catch (e) {
                print('Error fetching transaction data: $e');
              }
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
              decoration: BoxDecoration(color: greybgcolor),
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
              decoration: BoxDecoration(color: greenbgcolor),
              titleCentered: true,
            ),
          ),
          // Income, Expense, and Total Summary
          Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: _buildBalanceContainer(),
          ),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.only(top: 0),
              physics:
                  const BouncingScrollPhysics(), // Hoặc AlwaysScrollableScrollPhysics()
              children: _buildExpansionTileList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceContainer() {
    double totalIncome = 0.0;
    double totalOutcome = 0.0;

    for (var transaction in dataTransaction) {
      if (transaction['transaction_type'] == 'income') {
        totalIncome += transaction['transaction_amount'];
      } else if (transaction['transaction_type'] == 'outcome') {
        totalOutcome -= transaction['transaction_amount'];
      }
    }
    double total = totalIncome + totalOutcome;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('Thu nhập'),
            Text(
              '${totalIncome.toStringAsFixed(0)}đ',
              style: const TextStyle(color: greenbgcolor),
            ),
          ],
        ),
        Column(
          children: [
            const Text('Chi tiêu'),
            Text(
              '${totalOutcome.toStringAsFixed(0)}đ',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        Column(
          children: [
            const Text('Tổng'),
            Text(
              '${total.toStringAsFixed(0)}đ',
              style: TextStyle(
                color: total >= 0 ? greenbgcolor : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildExpansionTileList() {
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    if (dataTransaction.isNotEmpty) {
      for (var transaction in dataTransaction) {
        String date = transaction['transaction_date'];
        if (groupedTransactions.containsKey(date)) {
          groupedTransactions[date]!.add(transaction);
        } else {
          groupedTransactions[date] = [transaction];
        }
      }
    }

    return groupedTransactions.entries.map((entry) {
      String date = entry.key;
      List<Map<String, dynamic>> transactionsForDate = entry.value;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Giảm padding xung quanh Card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12.0, // Có thể giảm kích thước chữ nếu cần
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...transactionsForDate.map((transaction) {
                String icon = transaction['category']['category_icon'];
                IconData? iconData = IconConverter.getIconDataFromString(icon);
                String color = transaction['category']['category_color'];
                Color? colorData = ColorConverter.getColorFromString(color);
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0.0), // Giảm padding trong ListTile
                  leading: Icon(
                    iconData ?? Icons.error,
                    color: colorData,
                  ),
                  title: Text(
                    transaction['transaction_type'] == 'income'
                        ? '${transaction['transaction_amount']}đ'
                        : '-${transaction['transaction_amount']}đ',
                    style: TextStyle(
                      color: transaction['transaction_type'] == 'income'
                          ? greenbgcolor
                          : Colors.red,
                      fontSize:
                          12.0, // Có thể điều chỉnh kích thước chữ nếu cần
                    ),
                  ),
                  subtitle: Text(
                    transaction['transaction_description'],
                    style: const TextStyle(
                      fontSize: 12.0, // Kích thước chữ nhỏ hơn cho subtitle
                    ),
                  ),
                  trailing: Text(
                    transaction['transaction_date'],
                    style: const TextStyle(
                      fontSize: 12.0, // Kích thước chữ cho trailing
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    }).toList();
  }
}
