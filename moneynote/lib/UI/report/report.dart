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
        ],
      ),
    );
  }
}
