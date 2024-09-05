import 'dart:async';
import 'dart:convert';
import 'package:moneynote/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moneynote/UI/home/home.dart';
import 'package:moneynote/utils/color_convert.dart';
import 'package:moneynote/utils/icon_convert.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryIncome> categoriesIncome = [];

  List<CategoryOutcome> categoriesOutcome = [];
int selectedIndex2 = 0;
int selectedIndex = 0;
  int KselectedIndex = 0;
  @override
  void initState() {
    super.initState();
    getCategoryIncome();
    getCategoryOutcome();
  }

   Future<void> getCategoryIncome() async {
    try {
      final response = await http.get(
        Uri.parse('${GetConstant().apiEndPoint}/category?category_type=income'),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id']
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
            print(responseData);
        setState(() {
          categoriesIncome = categoryIncomeFromJson(response.body);
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
          'CLIENT_ID': userMetadata?['_id']
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          categoriesOutcome = categoryOutcomeFromJson(response.body);
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
              ],
              stops: [0.05, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          height: 90,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // Navigates back to the previous screen
                },
              ),
              SizedBox(
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
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCategory (), // Replace with your target page
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: KselectedIndex == 0 ? _suaTienChiFrame() : _suaTienThuFrame(),
        ),
      ],
    ),
  );
}
Widget AddCategory() {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Another Page'),
   
    
    ),
    body: Center(
      child: Text(
        'This is Another Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget _suaTienChiFrame() {
  return Scaffold(
    
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: categoriesOutcome.length + 1,
        itemBuilder: (context, index) {
          if (index == categoriesOutcome.length) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCategory(), 
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                    "Thêm danh mục",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          } else {
            final category = categoriesOutcome[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex2 = index;
                });
                      Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCate(
                      categoryOutcome: category,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        IconConverter.getIconDataFromString(category.categoryIcon) ??
                            Icons.error,
                        color: ColorConverter.getColorFromString(category.categoryColor),
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        category.categoryName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: selectedIndex2 == index
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.black,
                          fontSize: 16,
                        ),
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
  );
}


 
Widget _suaTienThuFrame() {
  return Scaffold(
    
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: categoriesIncome.length + 1,
        itemBuilder: (context, index) {
          if (index == categoriesIncome.length) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCategory(), 
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                    "Thêm danh mục",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          } else {
            final category = categoriesIncome[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex2 = index;
                });
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCate(
                      categoryIncome: category,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        IconConverter.getIconDataFromString(category.categoryIcon) ??
                            Icons.error,
                        color: ColorConverter.getColorFromString(category.categorycolor),
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        category.categoryName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: selectedIndex2 == index
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.black,
                          fontSize: 16,
                        ),
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
  );
}

}

class EditCate extends StatelessWidget {
  final CategoryIncome? categoryIncome;
  final CategoryOutcome? categoryOutcome;

  const EditCate({Key? key, this.categoryIncome, this.categoryOutcome}) : super(key: key);
   Future<void> _deleteCategory(BuildContext context) async {
    final categoryId = categoryIncome != null ? categoryIncome!.id : categoryOutcome!.id;

    try {
      final response = await http.delete(
        Uri.parse('${GetConstant().apiEndPoint}/category/${categoryId}'),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id']
        },
      );

      if (response.statusCode == 200) {
        // Successfully deleted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category deleted successfully')),
        );
        Navigator.pop(context); // Navigate back after deletion
      } else {
        // Error occurred
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryIncome != null ? categoryIncome!.categoryName : 
                      categoryOutcome != null ? categoryOutcome!.categoryName : 
                      'Add Category'),
                      actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteCategory(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          categoryIncome != null 
            ? 'Category Income: ${categoryIncome!.categoryName}' 
            : categoryOutcome != null 
              ? 'Category Outcome: ${categoryOutcome!.categoryName}' 
              : 'No Category Selected',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

  

List<CategoryIncome> categoryIncomeFromJson(String str) =>
    List<CategoryIncome>.from(
        json.decode(str).map((x) => CategoryIncome.fromJson(x)));

class CategoryIncome {
  String id;
  String categoryName;
  String categoryIcon;
  String categoryType;
  String uid;
  String categorycolor;

  CategoryIncome(
      {required this.id,
      required this.categoryName,
      required this.categoryIcon,
      required this.categoryType,
      required this.uid,
      required this.categorycolor});

  factory CategoryIncome.fromJson(Map<String, dynamic> json) => CategoryIncome(
      id: json["_id"],
      categoryName: json["category_name"],
      categoryIcon: json["category_icon"],
      categoryType: json["category_type"],
      uid: json["uid"],
      categorycolor: json["category_color"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category_name": categoryName,
        "category_icon": categoryIcon,
        "category_type": categoryType,
        "uid": uid,
        "category": categorycolor
      };
}

List<CategoryOutcome> categoryOutcomeFromJson(String str) =>
    List<CategoryOutcome>.from(
        json.decode(str).map((x) => CategoryOutcome.fromJson(x)));

String categoryOutcomeToJson(List<CategoryOutcome> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryOutcome {
  String id;
  String categoryName;
  String categoryIcon;
  String categoryType;
  String uid;
  String categoryColor;

  CategoryOutcome(
      {required this.id,
      required this.categoryName,
      required this.categoryIcon,
      required this.categoryType,
      required this.uid,
      required this.categoryColor});

  factory CategoryOutcome.fromJson(Map<String, dynamic> json) =>
      CategoryOutcome(
        id: json["_id"],
        categoryName: json["category_name"],
        categoryIcon: json["category_icon"],
        categoryType: json["category_type"],
        uid: json["uid"],
        categoryColor: json["category_color"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category_name": categoryName,
        "category_icon": categoryIcon,
        "category_type": categoryType,
        "uid": uid,
        "category_color": categoryColor,
      };
}
