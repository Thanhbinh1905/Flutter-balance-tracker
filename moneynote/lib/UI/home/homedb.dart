import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moneynote/UI/home/home.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> categories = [];
  bool isLoading = true;
    List<Category> categories2 = [];
  bool isLoading2 = true;
int KselectedIndex = 0;
  @override
  void initState() {
    super.initState();
    getCategory();
        getCategory2();
    
  }

  Future<void> getCategory() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.106:9001/category?category_type=income'),
        headers: {'Content-Type': 'application/json','CLIENT_ID':userMetadata?['_id']},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          categories = categoryFromJson(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


 Future<void> getCategory2() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.106:9001/category?category_type=outcome'),
        headers: {'Content-Type': 'application/json','CLIENT_ID':userMetadata?['_id']},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          categories2 = categoryFromJson(response.body);
          isLoading2 = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading2 = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading2 = false;
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
              height: 130,
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
                ? _suaTienChiFrame()
                : _suaTienThuFrame(),
          ),
        ],
      ),
      
     
     
    );
  }
  Widget _suaTienChiFrame(){
  return Scaffold( 
 body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  height: 110,
                  color: const Color.fromARGB(255, 29, 83, 110),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  
                    
                      Text(
                        'Name: ${category.categoryName}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Icon: ${category.categoryIcon}',
                        style: TextStyle(color: Colors.white),
                      ),
                    
                    ],
                  ),
                );
              },
            ),

  );
  }
 Widget _suaTienThuFrame(){
  return Scaffold( 
 body: isLoading2
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories2.length,
              itemBuilder: (context, index) {
                final category = categories2[index];
                return Container(
                  height: 100,
                  color: const Color.fromARGB(255, 29, 83, 110),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  
                    
                      Text(
                        'Name: ${category.categoryName}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Icon: ${category.categoryIcon}',
                        style: TextStyle(color: Colors.white),
                      ),
                    
                    ],
                  ),
                );
              },
            ),

  );}
}

List<Category> categoryFromJson(String str) => List<Category>.from(
    json.decode(str).map((x) => Category.fromJson(x)));

class Category {
  String id;
  String categoryName;
  String categoryIcon;
  String categoryType;
  String uid;

  Category({
    required this.id,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryType,
    required this.uid,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        categoryName: json["category_name"],
        categoryIcon: json["category_icon"],
        categoryType: json["category_type"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category_name": categoryName,
        "category_icon": categoryIcon,
        "category_type": categoryType,
        "uid": uid,
      };
}
