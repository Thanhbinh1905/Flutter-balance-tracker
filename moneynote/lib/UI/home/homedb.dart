import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class category extends StatefulWidget {
  const category({super.key});

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
 List <Category> category = [];
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder( future: getData(),
  builder: (context,snapshot) {
      if(snapshot.hasData){
        return ListView.builder( 
          itemCount: 1 ,
          itemBuilder: (context , index){
            return Container(
              height:100,
              color: const Color.fromARGB(255, 29, 83, 110),
              child:Column(
                children: [
                  Text(
                    'UserId:${category[index].id}'
                  )
                ],
              ),
            );
          },
          
          );
      }
     else{
      return Center(child: CircularProgressIndicator(),);
     }
      }
  
    );
  }
  Future<List<Category>> getData() async {
    final response =  await http.get(Uri.parse('http://192.168.1.216:9001/category'));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode ==200){
      for (Map<String, dynamic> index in data) {
        category.add(Category.fromJson(index));
      }
      return category;
    }
    else{
      return category;
    }
  }
}


List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
        required this.uid
 
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