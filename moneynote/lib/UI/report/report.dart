import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:moneynote/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneynote/utils/color_convert.dart';
import 'package:moneynote/utils/icon_convert.dart';

Map<String, dynamic>? userMetadata;
const greybgcolor = Color(0xFFDFE6DD);
const greenbgcolor = Color(0xFF62C42A);

class report extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const report({super.key, required this.metadata});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<report> {
  late List<Map<String, dynamic>> dataTransaction = [];
  int touchedIndex = -1;
  List<int> years =
      List<int>.generate(100, (int index) => DateTime.now().year - 50 + index);
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  bool isExpenseSelected = true; // hoặc false tùy vào trạng thái

  int kSelectedIndex = 0;
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, 1);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // print(years);
    userMetadata = widget.metadata;
    getMonthlyTransactionByCategory(
            selectedDate.month.toString(), selectedDate.year.toString())
        .then((data) {
      setState(() {
        dataTransaction = data; // Cập nhật dataTransaction với dữ liệu mới
      });
    }).catchError((error) {
      print('Error fetching transaction data: $error');
    });
  }

  void _showMonthYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Row(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem:
                          months.indexOf(months[selectedDate.month - 1])),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) async {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, index + 1);
                    });
                    try {
                      dataTransaction = await getMonthlyTransactionByCategory(
                          selectedDate.month.toString(),
                          selectedDate.year.toString());
                      setState(() {});
                    } catch (e) {
                      print('Error fetching transaction data: $e');
                    }
                  },
                  children: List<Widget>.generate(
                    months.length,
                    (int index) => Center(child: Text(months[index])),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: years.indexOf(selectedDate.year)),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) async {
                    setState(() {
                      selectedDate = DateTime(years[index], selectedDate.month);
                    });
                    try {
                      dataTransaction = await getMonthlyTransactionByCategory(
                          selectedDate.month.toString(),
                          selectedDate.year.toString());
                      setState(() {});
                    } catch (e) {
                      print('Error fetching transaction data: $e');
                    }
                  },
                  children: List<Widget>.generate(
                    years.length,
                    (int index) => Center(child: Text(years[index].toString())),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Row(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: years.indexOf(selectedDate.year)),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) async {
                    setState(() {
                      selectedDate = DateTime(years[index], selectedDate.month);
                    });
                    try {
                      dataTransaction = await getMonthlyTransactionByCategory(
                          selectedDate.month.toString(),
                          selectedDate.year.toString());
                      setState(() {});
                    } catch (e) {
                      print('Error fetching transaction data: $e');
                    }
                  },
                  children: List<Widget>.generate(
                    years.length,
                    (int index) => Center(child: Text(years[index].toString())),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getMonthlyTransactionByCategory(
      String month, String year) async {
    final url = Uri.parse(
        '${GetConstant().apiEndPoint}/transaction/cate?month=$month&year=$year');
    try {
      // print(userMetadata?['_id']);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['metadata'];
        // Trả về dữ liệu
        // print(data);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error occurred while fetching data1');
    }
  }

  Future<List<Map<String, dynamic>>> getYearlyTransactionByCategory(
      String year) async {
    final url =
        Uri.parse('${GetConstant().apiEndPoint}/transaction/cate?year=$year');
    try {
      // print(userMetadata?['_id']);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['metadata'];
        // Trả về dữ liệu
        // print(data);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error occurred while fetching data1');
    }
  }

  Future<Map<String, double>> getTotalMonthly(String month, String year) async {
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
        final List<dynamic> data = json.decode(response.body)['metadata'];

        // Tính tổng số tiền theo loại giao dịch
        double totalIncome = 0;
        double totalOutcome = 0;

        for (var transaction in data) {
          if (transaction['transaction_type'] == 'income') {
            totalIncome += transaction['transaction_amount'];
          } else if (transaction['transaction_type'] == 'outcome') {
            totalOutcome += transaction['transaction_amount'];
          }
        }

        // Trả về tổng số tiền theo từng loại
        return {
          'totalIncome': totalIncome,
          'totalOutcome': totalOutcome,
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error occurred while fetching data');
    }
  }

  Future<Map<String, double>> getTotalYearly(String year) async {
    final url =
        Uri.parse('${GetConstant().apiEndPoint}/transaction?year=$year');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['metadata'];

        // Tính tổng số tiền theo loại giao dịch
        double totalIncome = 0;
        double totalOutcome = 0;

        for (var transaction in data) {
          if (transaction['transaction_type'] == 'income') {
            totalIncome += transaction['transaction_amount'];
          } else if (transaction['transaction_type'] == 'outcome') {
            totalOutcome += transaction['transaction_amount'];
          }
        }

        // Trả về tổng số tiền theo từng loại
        return {
          'totalIncome': totalIncome,
          'totalOutcome': totalOutcome,
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error occurred while fetching data');
    }
  }

  List<PieChartSectionData> showingSections(bool isExpenseSelected) {
    final String transactionType = isExpenseSelected ? 'outcome' : 'income';
    final Map<String, double> totals = {};

    // Tính tổng số tiền cho từng loại category
    for (var category in dataTransaction) {
      String categoryName = category['category_name'];

      if (!totals.containsKey(categoryName)) {
        totals[categoryName] = 0; // Khởi tạo giá trị banầu nếu chưa có
      }

      for (var transaction in category['transactions']) {
        //úng tên là 'transactions'
        if (transaction['transaction_type'] == transactionType) {
          // Kiểm tra loại giao dịch
          totals[categoryName] = totals[categoryName]! +
              (transaction['transaction_amount'] as num)
                  .toDouble(); // Lấy từ transaction
        }
      }
    }

    // Tính tổng số tiền của tất cả các giao dịch
    final totalAmount =
        totals.isNotEmpty ? totals.values.reduce((a, b) => a + b) : 0.0;

    final List<PieChartSectionData> sections = [];
    int index = 0;

    if (dataTransaction.isEmpty || totalAmount == 0.0) {
      sections.add(
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          radius: 90.0,
          title: "",
        ),
      );
    } else {
      // Tạo danh sách các phần cho biểuồ tròn
      for (var category in dataTransaction) {
        if (totals[category['category_name']] != null &&
            totals[category['category_name']]! > 0) {
          final isTouched = index == touchedIndex;
          final fontSize = isTouched ? 16.0 : 12.0;
          final radius = isTouched ? 100.0 : 90.0;
          const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

          // Chuyểnổi màu từ chuỗi sang Color
          String color = category['category_color'];
          Color? colorData = ColorConverter.getColorFromString(color);

          String categoryName = category['category_name'];
          sections.add(
            PieChartSectionData(
              color: colorData,
              value:
                  totals[categoryName]!, // Tổng số tiền cho từng category_name
              title: isTouched
                  ? '$categoryName\n${totals[categoryName]!.toStringAsFixed(0)}' // Hiển thị cả tên và value khiược chạm
                  : categoryName, // Chỉ hiển thị tên khi không chạm,
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            ),
          );
          index++;
        }
      }
    }
    return sections;
  }

  Widget get _monthlyReportFrame {
    return Column(
      children: [
        Container(
          //Date picker
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 77, 199, 89),
          ),
          height: 45,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(255, 98, 196, 42),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedDate =
                          DateTime(selectedDate.year, selectedDate.month - 1);
                    });
                    try {
                      dataTransaction = await getMonthlyTransactionByCategory(
                          selectedDate.month.toString(),
                          selectedDate.year.toString());
                      setState(() {});
                    } catch (e) {
                      print('Error fetching transaction data: $e');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showMonthYearPicker(context),
                  child: Text(
                    "${selectedDate.month}/${selectedDate.year}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedDate =
                          DateTime(selectedDate.year, selectedDate.month + 1);
                    });
                    try {
                      dataTransaction = await getMonthlyTransactionByCategory(
                          selectedDate.month.toString(),
                          selectedDate.year.toString());
                      setState(() {});
                    } catch (e) {
                      print('Error fetching transaction data: $e');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 16, right: 8, bottom: 8),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: const Color(0xFFCFDFC6)),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Flexible(
                                // flex:
                                //     1, // Cung cấp nhiều không gian hơn cho phần "Chi tiêu"
                                child: Text(
                                  'Chi tiêu',
                                  overflow: TextOverflow
                                      .ellipsis, // Cắt bớt nếu quá dài
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors
                                          .grey), //ảm bảo văn bản chỉ hiển thị trên một dòng
                                ),
                              ),
                              Flexible(
                                flex:
                                    2, // Cung cấp nhiều không gian hơn cho số tiền
                                child: FutureBuilder<Map<String, double>>(
                                  future: getTotalMonthly(
                                      selectedDate.month.toString(),
                                      selectedDate.year
                                          .toString()), // Gọi hàm khôngồng bộ
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text('Error: ${snapshot.error}',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu quá dài
                                            maxLines: 1,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      );
                                    } else if (snapshot.hasData) {
                                      final totalOutcome =
                                          snapshot.data?['totalOutcome'] ??
                                              0; // Lấy tổng chi tiêu
                                      return Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text(
                                          '$totalOutcomeđ', // Hiển thị tổng chi tiêu
                                          overflow: TextOverflow
                                              .ellipsis, // Cắt bớt nếu quá dài
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    } else {
                                      return const Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text('No data',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu quá dài
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 12)),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, top: 16, right: 16, bottom: 8),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: const Color(0xFFCFDFC6)),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Flexible(
                                child: Text(
                                  'Thu nhập',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ),
                              Flexible(
                                flex:
                                    2, // Cung cấp nhiều không gian hơn cho số tiền
                                child: FutureBuilder<Map<String, double>>(
                                  future: getTotalMonthly(
                                      selectedDate.month.toString(),
                                      selectedDate.year
                                          .toString()), // Gọi hàm không đồng bộ
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text('Error: ${snapshot.error}',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu quá dài
                                            maxLines: 1,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      );
                                    } else if (snapshot.hasData) {
                                      final totalOutcome =
                                          snapshot.data?['totalIncome'] ??
                                              0; // Lấy tổng chi tiêu
                                      return Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text(
                                          '$totalOutcomeđ', // Hiển thị tổng chi tiêu
                                          overflow: TextOverflow
                                              .ellipsis, // Cắt bớt nếu quá dài
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    } else {
                                      return const Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text('No data',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu quá dài
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 12)),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xFFCFDFC6)),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Tổng',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<Map<String, double>>(
                            future: getTotalMonthly(
                                selectedDate.month.toString(),
                                selectedDate.year
                                    .toString()), // Gọi hàm không đồng bộ
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}',
                                    textAlign:
                                        TextAlign.end); // Hiển thị khi có lỗi
                              } else if (snapshot.hasData) {
                                // Đảm bảo totalIncome và totalOutcome không null
                                final totalIncome =
                                    snapshot.data?['totalIncome'] ?? 0;
                                final totalOutcome =
                                    snapshot.data?['totalOutcome'] ?? 0;
                                final total = totalIncome - totalOutcome;

                                return Text(
                                  '$totalđ', // Hiển thị tổng thu nhập và chi tiêu
                                  textAlign: TextAlign.end,
                                );
                              } else {
                                return const Text(
                                  'No data',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 12),
                                ); // Hiển thị nếu không có dữ liệu
                              }
                            },
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
        Container(
          // decoration: BoxDecoration(border: Border.all(width: 2)),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpenseSelected = true;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Chi tiêu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isExpenseSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        width: isExpenseSelected ? 150 : 0,
                        color: isExpenseSelected
                            ? Colors.green
                            : const Color(0xFFCFDFC6),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpenseSelected = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Thu nhập',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              !isExpenseSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 2,
                          width: !isExpenseSelected ? 150 : 0,
                          color: isExpenseSelected
                              ? const Color(0xFFCFDFC6)
                              : Colors.green),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Flexible(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: showingSections(isExpenseSelected),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _yearlyReportFrame {
    return Column(
      children: [
        Container(
          //Date picker
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 77, 199, 89),
          ),
          height: 45,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(255, 98, 196, 42),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedDate =
                          DateTime(selectedDate.year - 1, selectedDate.month);
                    });
                    try {
                      dataTransaction = await getYearlyTransactionByCategory(
                          selectedDate.year.toString());
                      setState(() {});
                    } catch (e) {
                      print('Error fetching transaction data: $e');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showYearPicker(context),
                  child: Text(
                    "${selectedDate.year}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedDate =
                          DateTime(selectedDate.year + 1, selectedDate.month);
                    });
                    try {
                      dataTransaction = await getYearlyTransactionByCategory(
                          selectedDate.year.toString());
                      setState(() {});
                    } catch (e) {
                      print('Error fetching transaction data: $e');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 16, right: 8, bottom: 8),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: const Color(0xFFCFDFC6)),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Flexible(
                                // flex:
                                //     1, // Cung cấp nhiều không gian hơn cho phần "Chi tiêu"
                                child: Text(
                                  'Chi tiêu',
                                  overflow: TextOverflow
                                      .ellipsis, // Cắt bớt nếu quá dài
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors
                                          .grey), //ảm bảo văn bản chỉ hiển thị trên một dòng
                                ),
                              ),
                              Flexible(
                                flex:
                                    2, // Cung cấp nhiều không gian hơn cho số tiền
                                child: FutureBuilder<Map<String, double>>(
                                  future: getTotalMonthly(
                                      selectedDate.month.toString(),
                                      selectedDate.year
                                          .toString()), // Gọi hàm khôngồng bộ
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text('Error: ${snapshot.error}',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu quá dài
                                            maxLines: 1,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      );
                                    } else if (snapshot.hasData) {
                                      final totalOutcome =
                                          snapshot.data?['totalOutcome'] ??
                                              0; // Lấy tổng chi tiêu
                                      return Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text(
                                          '$totalOutcomeđ', // Hiển thị tổng chi tiêu
                                          overflow: TextOverflow
                                              .ellipsis, // Cắt bớt nếu quá dài
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    } else {
                                      return const Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text('No data',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu quá dài
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 12)),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, top: 16, right: 16, bottom: 8),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: const Color(0xFFCFDFC6)),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Flexible(
                                child: Text(
                                  'Thu nhập',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ),
                              Flexible(
                                flex:
                                    2, // Cung cấp nhiều không gian hơn cho số tiền
                                child: FutureBuilder<Map<String, double>>(
                                  future: getTotalMonthly(
                                      selectedDate.month.toString(),
                                      selectedDate.year
                                          .toString()), // Gọi hàm không đồng bộ
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text('Error: ${snapshot.error}',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu quá dài
                                            maxLines: 1,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      );
                                    } else if (snapshot.hasData) {
                                      final totalOutcome =
                                          snapshot.data?['totalIncome'] ??
                                              0; // Lấy tổng chi tiêu
                                      return Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text(
                                          '$totalOutcomeđ', // Hiển thị tổng chi tiêu
                                          overflow: TextOverflow
                                              .ellipsis, // Cắt bớt nếu quá dài
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    } else {
                                      return const Align(
                                        alignment: Alignment
                                            .centerRight, // Căn chỉnh nội dung bên phải
                                        child: Text('No data',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu quá dài
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 12)),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xFFCFDFC6)),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Tổng',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<Map<String, double>>(
                            future: getTotalMonthly(
                                selectedDate.month.toString(),
                                selectedDate.year
                                    .toString()), // Gọi hàm không đồng bộ
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}',
                                    textAlign:
                                        TextAlign.end); // Hiển thị khi có lỗi
                              } else if (snapshot.hasData) {
                                // Đảm bảo totalIncome và totalOutcome không null
                                final totalIncome =
                                    snapshot.data?['totalIncome'] ?? 0;
                                final totalOutcome =
                                    snapshot.data?['totalOutcome'] ?? 0;
                                final total = totalIncome - totalOutcome;

                                return Text(
                                  '$totalđ', // Hiển thị tổng thu nhập và chi tiêu
                                  textAlign: TextAlign.end,
                                );
                              } else {
                                return const Text(
                                  'No data',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 12),
                                ); // Hiển thị nếu không có dữ liệu
                              }
                            },
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
        Container(
          // decoration: BoxDecoration(border: Border.all(width: 2)),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpenseSelected = true;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Chi tiêu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isExpenseSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        width: isExpenseSelected ? 150 : 0,
                        color: isExpenseSelected
                            ? Colors.green
                            : const Color(0xFFCFDFC6),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpenseSelected = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Thu nhập',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              !isExpenseSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 2,
                          width: !isExpenseSelected ? 150 : 0,
                          color: isExpenseSelected
                              ? const Color(0xFFCFDFC6)
                              : Colors.green),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Flexible(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: showingSections(isExpenseSelected),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final srcHeight = MediaQuery.of(context).size.height;
    final srcWidth = MediaQuery.of(context).size.width;

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
              child: ToggleSwitch(
                minWidth: 110.0,
                minHeight: 30,
                cornerRadius: 10.0,
                activeBgColors: const [
                  [Color.fromARGB(255, 64, 175, 0)],
                  [Color.fromARGB(255, 64, 175, 0)]
                ],
                // activeFgColor: Colors.white,
                inactiveBgColor: Colors.white,
                // inactiveFgColor: Colors.white,
                initialLabelIndex: kSelectedIndex,
                totalSwitches: 2,
                labels: const ['Hàng tháng', 'Hàng năm'],
                customTextStyles: [
                  TextStyle(
                    fontSize: 12.0,
                    decoration: TextDecoration.none,
                    color: kSelectedIndex == 0
                        ? Colors.white
                        : const Color(0xff62C42A),
                  ),
                  TextStyle(
                    fontSize: 12.0,
                    decoration: TextDecoration.none,
                    color: kSelectedIndex == 1
                        ? Colors.white
                        : const Color(0xff62C42A),
                  ),
                ],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    kSelectedIndex = index!;
                    if (kSelectedIndex == 0) {
                      // Cập nhật futureData cho hàng tháng
                      getMonthlyTransactionByCategory(
                              selectedDate.month.toString(),
                              selectedDate.year.toString())
                          .then((data) {
                        setState(() {
                          dataTransaction =
                              data; // Cập nhật dataTransaction với dữ liệu mới
                        });
                      }).catchError((error) {
                        print('Error fetching transaction data: $error');
                      });
                    } else if (kSelectedIndex == 1) {
                      // Cập nhật futureData cho hàng năm
                      getYearlyTransactionByCategory(
                              selectedDate.year.toString())
                          .then((data) {
                        setState(() {
                          dataTransaction =
                              data; // Cập nhật dataTransaction với dữ liệu mới
                        });
                      }).catchError((error) {
                        print('Error fetching transaction data: $error');
                      });
                    }
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: kSelectedIndex == 0
                ? _monthlyReportFrame
                : _yearlyReportFrame, // Hiển thị widget tương ứng dựa trên chỉ sốược chọn
          ),
        ],
      ),
    );
  }
}
