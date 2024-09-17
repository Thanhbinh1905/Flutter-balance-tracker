import 'package:BalanceTracker/UI/report/report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BalanceTracker/UI/home/homedb.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:BalanceTracker/UI/calendar/edit_transaction_page.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:BalanceTracker/utils/color_convert.dart';
import 'package:BalanceTracker/utils/icon_convert.dart';
import 'package:BalanceTracker/constants/constant.dart';
import 'package:BalanceTracker/utils/currency_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Map<String, dynamic>? userMetadata;
const greybgcolor = Color(0xFFDFE6DD);
const greenbgcolor = Color(0xFF62C42A);

class calendar extends StatefulWidget {
  final Map<String, dynamic> metadata;
  final VoidCallback onRefresh;
  const calendar({super.key, required this.metadata, required this.onRefresh});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<calendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late String currentMonth;
  late String currentYear;
  late List<Map<String, dynamic>> dataTransaction = [];

  bool _isEditDeleteFrameVisible = false;
  Map<String, dynamic>? _selectedTransaction;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    userMetadata = widget.metadata;
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
        '${GetConstant().apiEndPoint}/transaction?month=$month&year=$year');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );
      if (response.statusCode == 200) {
        // print(json.decode(response.body)['metadata']);
        final List<dynamic> data = json.decode(response.body)['metadata'];
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

  Future<void> deleteTransaction(String transactionId) async {
    final url = Uri.parse(
        '${GetConstant().apiEndPoint}/transaction?transaction_id=$transactionId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );
      if (response.statusCode == 200) {
        // Successfully deleted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted successfully')),
        );
        // Refresh the transaction list
        refreshTransactions();
      } else {
        throw Exception('Failed to delete transaction');
      }
    } catch (e) {
      print('Error deleting transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete transaction')),
      );
    }
  }

  Future<void> editTransaction(String transactionId) async {
    final url = Uri.parse(
        '${GetConstant().apiEndPoint}/transaction?transaction_id=$transactionId');
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
        body: jsonEncode({
          "transaction_amount": 1000,
          "transaction_description": "hihiii",
          "category": "66cb81fadcee3a1d4e15a5a7"
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction edited successfully')),
        );
        // Refresh the transaction list
        refreshTransactions();
      } else {
        throw Exception('Failed to edit transaction');
      }
    } catch (e) {
      // print('Error deleting transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to edit transaction')),
      );
    }
  }

  void refreshTransactions() {
    getTransaction(currentMonth, currentYear).then((data) {
      setState(() {
        dataTransaction = data;
        _isEditDeleteFrameVisible = false;
      });
    }).catchError((error) {
      print('Error fetching transaction data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final srcHeight = MediaQuery.of(context).size.height;
    final srcWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: srcHeight / 12,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                padding: const EdgeInsets.all(5.0),
                width: srcWidth / 5,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCFDFC6), Color(0xFFFFFFFF)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  l10n?.calendar ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF62C42A),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          // Calendar View
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey
                      .withOpacity(0.5), // Màu và độ mờ của viền dưới
                  width: 0.5, // Độ dày của viền dưới
                ),
              ),
            ),
            child: TableCalendar(
              rowHeight: srcHeight / 18,
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
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
                defaultTextStyle: const TextStyle(fontSize: 12),
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
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              daysOfWeekVisible: true,
              daysOfWeekHeight: srcHeight / 20,
              headerStyle: const HeaderStyle(
                headerPadding: EdgeInsets.only(top: 0, bottom: 0),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.white),
                decoration: BoxDecoration(color: greenbgcolor),
                titleCentered: true,
              ),
            ),
          ),
          // Income, Expense, and Total Summary

          Flexible(
            child: ListView(
              padding: const EdgeInsets.only(top: 0),
              physics:
                  const BouncingScrollPhysics(), // Hoặc AlwaysScrollableScrollPhysics()
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey
                            .withOpacity(0.5), // Màu và độ mờ của viền dưới
                        width: 0.5, // Độ dày của viền dưới
                      ),
                      top: BorderSide(
                        color: Colors.grey
                            .withOpacity(0.5), // Màu và độ mờ của viền trên
                        width: 0.5, // Độ dày của viền trên
                      ),
                    ),
                  ),
                  child: _buildBalanceContainer(),
                ),
                ..._buildExpansionTileList(),
              ],
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
            FutureBuilder<String>(
              future: CurrencySettings
                  .getCurrencySymbol(), // Hàm lấy ký hiệu tiền tệ
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Hiển thị khi đang chờ
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Hiển thị thu nhập và ký hiệu tiền tệ khi dữ liệu đã sẵn sàng
                  return Text(
                    '${totalIncome.toStringAsFixed(0)} ${snapshot.data ?? ''}',
                    style: const TextStyle(color: greenbgcolor),
                  );
                }
              },
            )
          ],
        ),
        Column(
          children: [
            const Text('Chi tiêu'),
            FutureBuilder<String>(
              future: CurrencySettings
                  .getCurrencySymbol(), // Hàm lấy ký hiệu tiền tệ
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Hiển thị khi đang chờ
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Hiển thị thu nhập và ký hiệu tiền tệ khi dữ liệu đã sẵn sàng
                  return Text(
                    '${totalOutcome.toStringAsFixed(0)} ${snapshot.data ?? ''}',
                    style: TextStyle(
                      color: totalOutcome >= 0 ? greenbgcolor : Colors.red,
                    ),
                  );
                }
              },
            )
          ],
        ),
        Column(
          children: [
            const Text('Tổng'),
            FutureBuilder<String>(
              future: CurrencySettings
                  .getCurrencySymbol(), // Hàm lấy ký hiệu tiền tệ
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Hiển thị khi đang chờ
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Hiển thị thu nhập và ký hiệu tiền tệ khi dữ liệu đã sẵn sàng
                  return Text(
                    '${total.toStringAsFixed(0)} ${snapshot.data ?? ''}',
                    style: TextStyle(
                      color: total >= 0 ? greenbgcolor : Colors.red,
                    ),
                  );
                }
              },
            )
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

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5, left: 8, bottom: 5),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...transactionsForDate.map((transaction) {
              String icon = transaction['category']['category_icon'];
              IconData? iconData = IconConverter.getIconDataFromString(icon);
              String color = transaction['category']['category_color'];
              Color? colorData = ColorConverter.getColorFromString(color);
              String tranDes = transaction['transaction_description'];
              return InkWell(
                onTap: () {
                  setState(() {
                    _isEditDeleteFrameVisible = !_isEditDeleteFrameVisible;
                    _selectedTransaction = transaction;
                  });
                },
                splashColor: Colors.grey.withOpacity(0.3), // Màu gợn sóng
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 12, top: 8, bottom: 8),
                          child: Icon(
                            iconData ?? Icons.error,
                            color: colorData,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: transaction['category']
                                            ['category_name'],
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: ' ($tranDes)',
                                        style: const TextStyle(
                                            fontSize: 10.0, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  transaction['transaction_date'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            child: FutureBuilder<String>(
                              future: CurrencySettings
                                  .getCurrencySymbol(), // Hàm lấy ký hiệu tiền tệ
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Hiển thị khi đang chờ
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // Hiển thị thu nhập và ký hiệu tiền tệ khi dữ liệu đã sẵn sàng
                                  return Text(
                                    transaction['transaction_type'] == 'income'
                                        ? '${transaction['transaction_amount']} ${snapshot.data ?? ''}'
                                        : '-${transaction['transaction_amount']} ${snapshot.data ?? ''}',
                                    style: TextStyle(
                                      color: transaction['transaction_type'] ==
                                              'income'
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12.0,
                                    ),
                                  );
                                }
                              },
                            )),
                        Container(
                          padding: const EdgeInsets.only(right: 12),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        )
                      ],
                    ),
                    if (_isEditDeleteFrameVisible &&
                        _selectedTransaction == transaction)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Show a confirmation dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text(
                                        'Are you sure you want to delete this transaction?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteTransaction(transaction['_id']);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTransactionPage(
                                    transaction: transaction,
                                    clientId: userMetadata?['_id'] ?? '',
                                    refreshTransactions: refreshTransactions,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }).toList();
  }
}
