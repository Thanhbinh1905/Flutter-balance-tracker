import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Learning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> data = [const HomeTab(), const ProfileTab()];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Flutter Cupertino Tabbar"),
        ),
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                label: "Profile",
              )
            ],
          ),
          tabBuilder: (context, index) {
            return CupertinoTabView(
              builder: (context) {
                return data[index];
              },
            );
          },
        ));
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.all(16.0), // Optional padding
        children: const <Widget>[
          Text(
            "This is home page",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          // Add more widgets here if needed
          // For example:
          SizedBox(height: 20), // Add space between widgets
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          // You can also add more widgets like images, buttons, etc.
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "Additional content goes here",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: const Text(
          "This is profile page",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
