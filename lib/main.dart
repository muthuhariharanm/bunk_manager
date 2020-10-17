import 'package:bunk_manager/myhomepage.dart';
import 'package:bunk_manager/startPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isuser = false;
  String email;
  getStorage() async {
    SharedPreferences st = await SharedPreferences.getInstance();
    email = st.getString('user');
    if (email != null) {
      setState(() {
        isuser = true;
      });
    } else {
      setState(() {
        isuser = false;
      });
    }
  }

  _MyAppState() {
    getStorage();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: isuser ? MyHomePage(this.email) : StartPage(),
      //home: isuser ? Prac() : StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
