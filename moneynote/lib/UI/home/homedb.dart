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
  final String uid = userMetadata?['_id'] ?? '';
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
        'CLIENT_ID': userMetadata?['_id'],
      },
    );

    if (response.statusCode == 200) {
      // Decode the entire response as a Map<String, dynamic>
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);  // This will print the full response object

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
      print(responseData);  // This will print the full response object

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
                      builder: (context) => AddCategory(),
                    ),
                  ).then((result) {
                    if (result == true) {
                      // Refresh both income and outcome categories
                      getCategoryIncome();
                      getCategoryOutcome();
                    }
                  });
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
// Replace the existing AddCategory widget with this:
Widget AddCategory() {
  return AddCategoryScreen(categoryType: KselectedIndex == 0 ? 'outcome' : 'income');
}

Widget _suaTienChiFrame() {
   final filteredCategoriesOutcome = categoriesOutcome
        .where((category) =>
            category.categoryName != 'null' && category.categoryIcon != 'null')
        .toList();
  return Scaffold(
    
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredCategoriesOutcome.length + 1,
        itemBuilder: (context, index) {
          if (index == filteredCategoriesOutcome.length) {
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
            final category = filteredCategoriesOutcome[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex2 = index;
                });
                      Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleCate(
                      categoryOutcome: category,
                    ),
                  ),
                  
                ).then((result) {
                    if (result == true) {
                      getCategoryIncome(); // Làm mới danh sách
                    }});
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
       final filteredCategoriesIncome= categoriesIncome
        .where((category) =>
            category.categoryName != 'null' && category.categoryIcon != 'null')
        .toList();

  return Scaffold(
    
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredCategoriesIncome.length + 1,
        itemBuilder: (context, index) {
          if (index == filteredCategoriesIncome.length) {
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
            final category = filteredCategoriesIncome[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex2 = index;
                });
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleCate(
                      categoryIncome: category,
                    ),
                  ),
                ).then((result) {
                    if (result == true) {
                      getCategoryIncome(); // Làm mới danh sách
                    }});
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



class AddCategoryScreen extends StatefulWidget {
  final String categoryType;

  const AddCategoryScreen({Key? key, required this.categoryType}) : super(key: key);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  String _categoryName = '';
  String _selectedIcon = 'star';
  String _selectedColor = 'blue';

  Future<void> _addCategory() async {
    if (_categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a category name')),
      );
      return;
    }

    final apiEndpoint = '${GetConstant().apiEndPoint}/category';
    try {
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'] ?? '',
        },
        body: jsonEncode({
          'category_name': _categoryName,
          'category_icon': _selectedIcon,
          'category_color': _selectedColor,
          'category_type': widget.categoryType,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.categoryType.capitalize()} Category'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _categoryName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Icon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                height: 200, // Adjust this height as needed
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Number of icons per row
                    childAspectRatio: 1, // Square shape for each item
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: IconConverter.outcomeIconMap.length,
                  itemBuilder: (context, index) {
                    String iconKey = IconConverter.outcomeIconMap.keys.elementAt(index);
                    IconData iconData = IconConverter.outcomeIconMap.values.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = iconKey;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedIcon == iconKey ? Colors.blue : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(iconData),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                height: 150, // Adjust this height as needed
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Number of colors per row
                    childAspectRatio: 1, // Square shape for each item
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: ColorConverter.colorMap.length,
                  itemBuilder: (context, index) {
                    String colorKey = ColorConverter.colorMap.keys.elementAt(index);
                    Color color = ColorConverter.colorMap.values.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = colorKey;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color: _selectedColor == colorKey ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addCategory,
                  child: Text('Add Category'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add this extension method to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}


class DeleCate extends StatelessWidget {
  final CategoryIncome? categoryIncome;
  final CategoryOutcome? categoryOutcome;

  const DeleCate({Key? key, this.categoryIncome, this.categoryOutcome}) : super(key: key);
   Future<void> _deleteCategory(BuildContext context) async {
   final categoryId = categoryIncome != null ? categoryIncome!.id : categoryOutcome!.id;
   final apiEndpoint = '${GetConstant().apiEndPoint}/category?category_id=$categoryId';
   print(apiEndpoint);
    try {
      final response = await http.delete(
        Uri.parse(apiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': userMetadata?['_id'] ?? '',
        },
      );

      if (response.statusCode == 200) {

        Navigator.pop(context);
 
      } else {

        final errorMessage = jsonDecode(response.body)['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      
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
