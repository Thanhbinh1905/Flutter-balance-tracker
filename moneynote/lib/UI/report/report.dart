import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  int KselectedIndex = 0;
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
        print(selectedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _selectedDay = DateTime.now();
    // _focusedDay = DateTime.now();
    userMetadata = widget.metadata["metadata"];
    // currentMonth = DateFormat('MM').format(_focusedDay);
    // currentYear = DateFormat('yyyy').format(_focusedDay);
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
                labels: const ['Hàng tháng', 'Hàng năm'],
                customTextStyles: [
                  TextStyle(
                    fontSize: 16.0,
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
                  });
                },
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
