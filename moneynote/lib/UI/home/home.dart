import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:moneynote/UI/report/report.dart';
import 'package:moneynote/UI/orther/orther.dart';
import 'package:moneynote/UI/calendar/calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'homedb.dart';

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
    userMetadata = widget.metadata['metadata'];
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
              activeColor: Color(0xFF62C42A), // Color for the selected tab item
              // backgroundColor: Colors.green,
            ),
            tabBuilder: (BuildContext a, int index) {
              return _tabs[index];
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

  final List<String> labels = [
    'Ăn uống',
    'Chi tiêu hàng hóa',
    'Quần áo',
    'Mỹ phẩm',
    'Tiền điện nước',
    'Tiền nhà',
    'Tiền mạng',
    'Xăng xe',
    'Chỉnh sửa >'
  ];
  final List<String> labels2 = [
    'Ăn uống',
    'Chi tiêu hàng hóa',
    'Quần áo',
    'Mỹ phẩm',
    'Tiền điện nước',
    'Chỉnh sửa >'
  ];
  final List<IconData> icons = [
    Icons.fastfood,
    Icons.shopping_basket,
    Icons.shopping_bag,
    Icons.brush,
    Icons.water,
    Icons.home,
    Icons.wifi,
    Icons.local_gas_station,
    Icons.edit
  ];
  final List<IconData > icons2 = [
    Icons.fastfood,
    Icons.shopping_basket,
    Icons.shopping_bag,
    Icons.brush,
    Icons.water,
    Icons.home,
    Icons.wifi,
    Icons.local_gas_station,
    Icons.edit
  ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
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
              height: 110,
              width: double.infinity,
              padding: EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 40,
                  child: ToggleSwitch(
                    minWidth: 110.0,
                    minHeight: 30,
                    cornerRadius: 10.0,
                    activeBgColors: [
                      [const Color.fromARGB(255, 64, 175, 0)],
                      [const Color.fromARGB(255, 64, 175, 0)]
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: KselectedIndex,
                    totalSwitches: 2,
                    labels: ['Tiền chi', 'Tiền thu'],
                    customTextStyles: [
                      TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                        color: KselectedIndex == 0
                            ? Colors.white
                            : Colors.green[800],
                      ),
                      TextStyle(
                        fontSize: 12.0,
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 77, 199, 89),
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
                  placeholder: "Nhập ghi chú ${userMetadata?['username']}",
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
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 98, 196, 24),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: labels.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (labels[index] == "Chỉnh sửa >") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChinhSuaTienChi()),
                          );
                        } else {
                          setState(() {
                            selectedIndex = index;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Colors.green[50]
                              : Colors.white,
                          border: Border.all(
                            color: selectedIndex == index
                                ? Colors.green
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icons[index],
                              color: selectedIndex == index
                                  ? Colors.green
                                  : Colors.grey,
                              size: 20,
                            ),
                            SizedBox(height: 8),
                            Text(
                              labels[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selectedIndex == index
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
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
                    child: Text(
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 77, 199, 89),
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
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 98, 196, 24),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: labels2.length,
                  itemBuilder: (context, index) {
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
                                ? Colors.green
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icons[index],
                              color: selectedIndex2 == index
                                  ? Colors.green
                                  : Colors.grey,
                              size: 20,
                            ),
                            SizedBox(height: 8),
                            Text(
                              labels2[index],
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
                  })),
          SizedBox(height: 77),
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
                    child: Text(
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
      return const Scaffold(
        
body: CategoryScreen(),
      );

  }
  }


 
