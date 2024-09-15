import 'dart:convert';

import 'package:BalanceTracker/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:BalanceTracker/UI/report/report.dart';
import 'package:BalanceTracker/UI/orther/orther.dart';
import 'package:BalanceTracker/UI/calendar/calendar.dart';
import 'package:BalanceTracker/constants/constant.dart';
import 'package:BalanceTracker/utils/color_convert.dart';
import 'package:BalanceTracker/utils/icon_convert.dart';
import 'package:BalanceTracker/utils/currency_settings.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'homedb.dart';
import 'package:intl/intl.dart'; // Thêm import này
import 'package:http/http.dart' as http;

Map<String, dynamic>? userMetadata;

class BalanceTrackerHome extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const BalanceTrackerHome({super.key, required this.metadata});

  @override
  State<BalanceTrackerHome> createState() => _BalanceTrackerHome();
}

class _BalanceTrackerHome extends State<BalanceTrackerHome> {
  late final List<Widget> _tabs;
  String selectedAmount = '';
  String selectedNote = '';

  void updateTransactionDetails(Map<String, dynamic> transaction) {
    setState(() {
      selectedAmount = transaction['transaction_amount'].toString();
      selectedNote = transaction['transaction_description'];
      // Update other relevant fields
    });
  }

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginForm()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabs = [
      hometab(metadata: widget.metadata),
      calendar(metadata: widget.metadata),
      report(metadata: widget.metadata),
      orther(
        metadata: widget.metadata,
        onLogout: _handleLogout,
      ),
    ];
    userMetadata = widget.metadata;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items:  [
                BottomNavigationBarItem(
                    icon: Icon(Icons.edit), label: 'Nhập vào'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: 'Lịch'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart), label: 'Báo cáo'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz), label: 'Khác')
              ],
              activeColor:
                  const Color(0xFF62C42A), // Color for the selected tab item
              // backgroundColor: Colors.green,
            ),
            tabBuilder: (BuildContext a, int index) {
              return SafeArea(child: CupertinoTabView(
                builder: (BuildContext context) {
                  return _tabs[index];
                },
              ));
            }));
  }
}

class hometab extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const hometab({super.key, required this.metadata});

  @override
  _hometab createState() => _hometab();
}

class _hometab extends State<hometab> {
  int KselectedIndex = 0;
  int selectedIndex = 0;
  int selectedIndex2 = 0;
  List<CategoryIncome> categoriesIncome = [];
  List<CategoryOutcome> categoriesOutcome = [];
  @override
  void initState() {
    super.initState();
    getCategoryIncome();
    getCategoryOutcome();
  }

  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

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

  Future<void> getCategoryIncome() async {
    try {
      final response = await http.get(
        Uri.parse('${GetConstant().apiEndPoint}/category?category_type=income'),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final List<dynamic> metadata = responseData['metadata'];

        setState(() {
          categoriesIncome =
              metadata.map((item) => CategoryIncome.fromJson(item)).toList();
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
      setState(() {});
    }
  }

  Future<void> getCategoryOutcome() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${GetConstant().apiEndPoint}/category?category_type=outcome'),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final List<dynamic> metadata = responseData['metadata'];

        // Map the metadata list to CategoryIncome objects
        setState(() {
          categoriesOutcome =
              metadata.map((item) => CategoryOutcome.fromJson(item)).toList();
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
      setState(() {});
    }
  }

  Future<void> createTransaction() async {
    // Kiểm tra xem đã chọn danh mục chưa
    if (selectedIndex2 < 0 || selectedIndex2 >= categoriesOutcome.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn danh mục')),
      );
      return;
    }

    // Lấy danh mục đã chọn
    final selectedCategory = categoriesOutcome[selectedIndex2];

    // Lấy số tiền từ trường nhập liệu
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0 || amount > 1000000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng nhập số tiền hợp lệ (tối đa 1 tỷ)')),
      );
      return;
    }

    final transactionData = {
      'transaction_amount': amount,
      'transaction_description': noteController.text,
      'transaction_date': DateFormat('dd/MM/yyyy').format(selectedDate),
      'category': selectedCategory.id,
      'transaction_type': KselectedIndex == 0 ? 'outcome' : 'income',
    };
    // print(transactionData);
    try {
      final response = await http.post(
        Uri.parse('${GetConstant().apiEndPoint}/transaction'),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'],
        },
        body: jsonEncode(transactionData),
      );

      if (response.statusCode == 200) {
        // Giao dịch được tạo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo thành công')),
        );

        // Reset các trường nhập liệu
        setState(() {
          amountController.clear();
          noteController.clear();
          selectedIndex2 = -1; // Reset danh mục đã chọn
        });
      } else {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Lỗi: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      // Xử lý lỗi kết nối
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    }
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
                initialLabelIndex: KselectedIndex,
                totalSwitches: 2,
                labels: const ['Tiền chi', 'Tiền thu'],
                customTextStyles: [
                  TextStyle(
                    fontSize: 12.0,
                    decoration: TextDecoration.none,
                    color: KselectedIndex == 0
                        ? Colors.white
                        : const Color(0xff62C42A),
                  ),
                  TextStyle(
                    fontSize: 12.0,
                    decoration: TextDecoration.none,
                    color: KselectedIndex == 1
                        ? Colors.white
                        : const Color(0xff62C42A),
                  ),
                ],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    KselectedIndex = index!;
                    if (KselectedIndex == 0) {
                      getCategoryOutcome();
                    } else {
                      getCategoryIncome();
                    }
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  KselectedIndex == 0
                      ? _buildTienChiFrame()
                      : _buildTienThuFrame(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTienChiFrame() {
    final filteredCategoriesOutcome = categoriesOutcome
        .where((category) =>
            category.categoryName != 'null' && category.categoryIcon != 'null')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  onTap: () {
                    setState(() {
                      selectedDate =
                          selectedDate.subtract(const Duration(days: 1));
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = selectedDate.add(const Duration(days: 1));
                    });
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
        Row(
          children: [
            const SizedBox(width: 16.0),
            const Text(
              "Ghi chú",
              style: TextStyle(
                  fontSize: 14.0,
                  color: CupertinoColors.black,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: CupertinoTextField(
                controller: noteController,
                placeholder: "Nhập ghi chú",
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 98, 196, 24),
          ),
          height: 45,
          child: Row(
            children: [
              const Text(
                "Tiền chi",
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                    decoration: TextDecoration.none),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: CupertinoTextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 0.0),
                  placeholder: "0",
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: CupertinoColors.white,
                  ),
                  decoration: null,
                ),
              ),
              CurrencySettings.showCurrency()
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Danh sách",
            style: TextStyle(
                fontSize: 16.0,
                color: Color.fromARGB(255, 0, 0, 0),
                decoration: TextDecoration.none),
          ),
        ),
        SizedBox(
          height: 230, // Đặt chiều cao phù hợp cho container
          child: GridView.builder(
            shrinkWrap: false, // Thay đổi thành false
            physics: const AlwaysScrollableScrollPhysics(), // Cho phép cuộn
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: filteredCategoriesOutcome.length + 1,
            itemBuilder: (context, index) {
              if (index == filteredCategoriesOutcome.length) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChinhSuaTienChi(),
                        )).then((_) {
                      // Refresh data after adding a new category
                      getCategoryIncome();
                      getCategoryOutcome();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(
                      //   // color: Colors.grey,
                      //   width: 2,
                      // ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Chỉnh sửa >",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                final category = filteredCategoriesOutcome[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex2 = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex2 == index
                          ? Colors.green[50]
                          : Colors.white,
                      border: Border.all(
                        color: selectedIndex2 == index
                            ? const Color(0xFF40AF00)
                            : Colors.white,
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconConverter.getIconDataFromString(
                                  category.categoryIcon) ??
                              Icons.error,
                          color: selectedIndex2 == index
                              ? ColorConverter.getColorFromString(
                                  category.categoryColor)
                              : ColorConverter.getColorFromString(
                                  category.categoryColor),
                          size: 20,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.categoryName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedIndex2 == index
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
            child: SizedBox(
                width: 284,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 74, 175, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: createTransaction,
                  child: const Text(
                    "Nhập tiền chi",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )))
      ],
    );
  }

  Widget _buildTienThuFrame() {
    final filteredCategoriesIncome = categoriesIncome
        .where((category) =>
            category.categoryName != 'null' && category.categoryIcon != 'null')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  onTap: () {
                    setState(() {
                      selectedDate =
                          selectedDate.subtract(const Duration(days: 1));
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = selectedDate.add(const Duration(days: 1));
                    });
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
        Row(
          children: [
            const SizedBox(width: 16.0),
            const Text(
              "Ghi chú",
              style: TextStyle(
                  fontSize: 14.0,
                  color: CupertinoColors.black,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: CupertinoTextField(
                controller: noteController,
                placeholder: "Nhập ghi chú",
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 98, 196, 24),
          ),
          height: 45,
          child: Row(
            children: [
              const Text(
                "Tiền thu",
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                    decoration: TextDecoration.none),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: CupertinoTextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 0.0),
                  placeholder: "0",
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: CupertinoColors.white,
                  ),
                  decoration: null,
                ),
              ),
              CurrencySettings.showCurrency()
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Danh sách",
            style: TextStyle(
                fontSize: 16.0,
                color: Color.fromARGB(255, 0, 0, 0),
                decoration: TextDecoration.none),
          ),
        ),
        SizedBox(
          height: 230, // Đặt chiều cao phù hợp cho container
          child: GridView.builder(
            shrinkWrap: false, // Thay đổi thành false
            physics: const AlwaysScrollableScrollPhysics(), // Cho phép cuộn
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.6,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: filteredCategoriesIncome.length + 1,
            itemBuilder: (context, index) {
              if (index == filteredCategoriesIncome.length) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChinhSuaTienChi(),
                      ),
                    ).then((_) {
                      // Refresh data after adding a new category
                      getCategoryIncome();
                      getCategoryOutcome();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex2 == index
                          ? Colors.green[50]
                          : Colors.white,
                      border: Border.all(
                        color: selectedIndex2 == index
                            ? const Color(0xFF40AF00)
                            : Colors.white,
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Chỉnh sửa >",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                final category = filteredCategoriesIncome[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex2 = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex2 == index
                          ? Colors.green[50]
                          : Colors.white,
                      border: Border.all(
                        color: selectedIndex2 == index
                            ? const Color(0xFF40AF00)
                            : Colors.white,
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconConverter.getIconDataFromString(
                                  category.categoryIcon) ??
                              Icons.error,
                          color: selectedIndex2 == index
                              ? ColorConverter.getColorFromString(
                                  category.categorycolor)
                              : ColorConverter.getColorFromString(
                                  category.categorycolor),
                          size: 20,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.categoryName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedIndex2 == index
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
            child: SizedBox(
                width: 284,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 74, 175, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: createTransaction,
                  child: const Text(
                    "Nhập tiền thu",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )))
      ],
    );
  }
}

class ChinhSuaTienChi extends StatefulWidget {
  const ChinhSuaTienChi({super.key});

  @override
  State<ChinhSuaTienChi> createState() => _ChinhSuaTienChiState();
}

class _ChinhSuaTienChiState extends State<ChinhSuaTienChi> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CategoryScreen(),
    );
  }
}
