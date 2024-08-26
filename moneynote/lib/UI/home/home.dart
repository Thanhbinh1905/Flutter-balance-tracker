import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneynote/UI/report/report.dart';
import 'package:moneynote/UI/other/other.dart';
import 'package:moneynote/UI/calendar/calendar.dart';

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
    print("Metadata hehehehe: ${widget.metadata}");
    super.initState();
    _tabs = [
      hometab(metadata: widget.metadata),
      lich(metadata: widget.metadata),
      Bcao(metadata: widget.metadata), // Truyền metadata vào Bcao
      khac(metadata: widget.metadata),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Nhập vào'),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Lịch'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Báo cáo'),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Khác')
              ],
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
  List<bool> isSelected = [true, false];
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
    final userMetadata = widget.metadata['metadata'];//Lấy dữ liệu từ metadata
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30.0),
        // Text('Username: ${userMetadata["username"]}'),  // Ví dụ sử dụng metadata
        // Text('Username: ${userMetadata["_id"]}'),  // Ví dụ sử dụng metadata
        ToggleButtons(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          fillColor: Colors.green,
          selectedColor: Colors.white,
          color: Colors.green,
          selectedBorderColor: Colors.green,
          borderColor: Colors.green,
          constraints: const BoxConstraints(minHeight: 30.0, minWidth: 100.0),
          isSelected: isSelected,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = i == index;
              }
            });
          },
          children: const [
            Text('Tiền chi'),
            Text('Tiền thu'),
          ],
        ),
        const SizedBox(height: 20.0),
        Container(
          color: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
