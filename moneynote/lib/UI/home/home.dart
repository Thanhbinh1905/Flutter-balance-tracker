import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:moneynote/UI/report/report.dart';
import 'package:moneynote/UI/orther/orther.dart';
import 'package:moneynote/UI/calendar/calendar.dart';
import 'package:moneynote/constants/constant.dart';
import 'package:moneynote/utils/color_convert.dart';
import 'package:moneynote/utils/icon_convert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'homedb.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic>? userMetadata;

class moneynoteHome extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const moneynoteHome({super.key, required this.metadata});

  @override
  State<moneynoteHome> createState() => _moneynoteHome();
}

class _moneynoteHome extends State<moneynoteHome> {
  late final List<Widget> _tabs;

  @override
  void initState() {
    // print("Metadata hehehehe: ${widget.metadata}");
    super.initState();
    _tabs = [
      hometab(metadata: widget.metadata),
      calendar(metadata: widget.metadata),
      report(metadata: widget.metadata),
      orther(metadata: widget.metadata),
    ];
    userMetadata = widget.metadata;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const [
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
      // Decode the entire response as a Map<String, dynamic>
      final Map<String, dynamic> responseData = jsonDecode(response.body);


      // Extract the metadata field which is the list of categories
      final List<dynamic> metadata = responseData['metadata'];

      // Map the metadata list to CategoryIncome objects
      setState(() {
        categoriesIncome = metadata.map((item) => CategoryIncome.fromJson(item)).toList();
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
      Uri.parse('${GetConstant().apiEndPoint}/category?category_type=outcome'),
      headers: {
        'Content-Type': 'application/json',
        'CLIENT_ID': userMetadata?['_id'],
      },
    );

    if (response.statusCode == 200) {
      // Decode the entire response as a Map<String, dynamic>
      final Map<String, dynamic> responseData = jsonDecode(response.body);


      // Extract the metadata field which is the list of categories
      final List<dynamic> metadata = responseData['metadata'];

      // Map the metadata list to CategoryIncome objects
      setState(() {
        categoriesOutcome = metadata.map((item) => CategoryOutcome.fromJson(item)).toList();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              decoration: const BoxDecoration(
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
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ToggleSwitch(
                    minWidth: 110.0,
                    minHeight: 30,
                    cornerRadius: 10.0,
                    activeBgColors: const [
                      [Color.fromARGB(255, 64, 175, 0)],
                      [Color.fromARGB(255, 64, 175, 0)]
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: KselectedIndex,
                    totalSwitches: 2,
                    labels: const ['Tiền chi', 'Tiền thu'],
                    customTextStyles: [
                      TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                        color: KselectedIndex == 0
                            ? Colors.white
                            : Colors.green[800],
                      ),
                      TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                        color: KselectedIndex == 1
                            ? Colors.white
                            : Colors.green[800],
                      ),
                    ],
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        KselectedIndex = index!;
                      });
                    },
                  ),
                ),
              )),
          Expanded(
            child: KselectedIndex == 0
                ? _buildTienChiFrame()
                : _buildTienThuFrame(),
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
    return SingleChildScrollView(
      child: Column(
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
                        selectedDate =
                            selectedDate.add(const Duration(days: 1));
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
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                const Text(
                  "Đ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: CupertinoColors.white,
                      decoration: TextDecoration.none),
                ),
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
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
  child: GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 1.6,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
    ),
    itemCount: filteredCategoriesOutcome.length + 1, 
    itemBuilder: (context, index) {
      if (index == filteredCategoriesOutcome.length) {
      
        return GestureDetector(
          onTap: () {
           
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChinhSuaTienChi(), 
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
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
                    ? const Color.fromARGB(255, 101, 180, 104)
                    : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconConverter.getIconDataFromString(category.categoryIcon) ??
                      Icons.error,
                  color: selectedIndex2 == index
                      ? ColorConverter.getColorFromString(category.categoryColor)
                      : ColorConverter.getColorFromString(category.categoryColor),
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
)
                     ,const SizedBox(height: 8),
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
                    onPressed: () {},
                    child: const Text(
                      "Nhập tiền chi",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )))
        ],
      ),
    );
  }









  Widget _buildTienThuFrame() {
     final filteredCategoriesIncome= categoriesIncome
        .where((category) =>
            category.categoryName != 'null' && category.categoryIcon != 'null')
        .toList();

    return SingleChildScrollView(
      child: Column(
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
                        selectedDate =
                            selectedDate.add(const Duration(days: 1));
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
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                const Text(
                  "Đ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: CupertinoColors.white,
                      decoration: TextDecoration.none),
                ),
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
         
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
  child: GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
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
                builder: (context) => ChinhSuaTienChi(), 
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "Chỉnh sửa",
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
                    ? const Color.fromARGB(255, 101, 180, 104)
                    : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconConverter.getIconDataFromString(category.categoryIcon) ??
                      Icons.error,
                  color: selectedIndex2 == index
                      ? ColorConverter.getColorFromString(category.categorycolor)
                      : ColorConverter.getColorFromString(category.categorycolor),
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
)
,
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
                    onPressed: () {},
                    child: const Text(
                      "Nhập tiền thu",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )))
        ],
      ),
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
    return Scaffold(
      
      body: const CategoryScreen(),
    );
  }
}
