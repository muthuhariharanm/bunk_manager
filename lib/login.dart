import 'package:bunk_manager/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    //icons
    final icons = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFF18D191), //Green
          ),
          child: Icon(
            Icons.local_offer,
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 50.0, top: 50.0),
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFFFC6A7F),
          ),
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0, top: 50.0),
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFFFFCE56),
          ),
          child: Icon(
            Icons.local_car_wash,
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 70.0, top: 5.0),
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFF45E0EC),
          ),
          child: Icon(
            Icons.place,
            color: Colors.white,
          ),
        )
      ],
    );
    //Email field
    final emailField = Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextFormField(
        controller: _email,
        obscureText: false,
        style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email Id",
          labelText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (email) {
          if (email.isEmpty) {
            return 'EmailId cannot be empty';
          }
          return null;
        },
      ),
    );
    //Password Field
    final passwordField = Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextFormField(
        controller: _password,
        obscureText: true,
        style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          labelText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (password) {
          if (password.isEmpty) {
            return 'Password cannot be empty';
          }
          return null;
        },
      ),
    );

    //Login Button
    final loginButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 20.0, bottom: 10.0),
            child: GestureDetector(
              onTap: () async {
                SharedPreferences st = await SharedPreferences.getInstance();
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  Firestore.instance
                      .collection('users')
                      .document(_email.text)
                      .get()
                      .then((DocumentSnapshot ds) {
                    if (ds.exists) {
                      if (ds['password'] == _password.text) {
                        st.setString('user', _email.text);
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(_email.text)),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        _showDialog(
                            'Sorry!',
                            'User doesnot exists or Password you have entered is incorrect',
                            context);
                      }
                    } else {
                      _showDialog(
                          'Sorry!',
                          'User doesnot exists or Password you have entered is incorrect',
                          context);
                    }
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Login to your manager'),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0),
                icons,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                      child: Text(
                        "Bunk Manager",
                        style: TextStyle(fontSize: 30.0),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30.0),
                emailField,
                SizedBox(height: 30.0),
                passwordField,
                SizedBox(height: 30.0),
                loginButton,
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

void _showDialog(msg, text, context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(msg),
        content: Text(text),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
