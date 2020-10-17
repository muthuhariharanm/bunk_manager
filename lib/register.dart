import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _userName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confPassword = TextEditingController();
  final databaseReference = Firestore.instance;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _userName.dispose();
    _email.dispose();
    _password.dispose();
    _confPassword.dispose();
    super.dispose();
  }

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
    //username field
    final userField = Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextFormField(
        controller: _userName,
        obscureText: false,
        style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0), //for box
          hintText: "Username",
          labelText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (username) {
          if (username.isEmpty) {
            return 'UserName cannot be empty';
          }
          return null;
        },
      ),
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
          } else if (!(RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(email))) {
            return 'Invalid Email Address';
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
          } else if (!(RegExp(
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
              .hasMatch(password))) {
            return "Password must have atleast 8 characters including a uppercase \nletter, a lowercase letter, a special character and a number";
          }
          return null;
        },
      ),
    );
    //Confirm Password Field
    final confPasswordField = Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextFormField(
        controller: _confPassword,
        obscureText: true,
        style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Confirm Password",
          labelText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (confPassword) {
          if (confPassword.isEmpty) {
            return 'Confirmed Password cannot be empty';
          } else if (confPassword != _password.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
    final registerButton = Row(
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
                      .then(
                    (DocumentSnapshot ds) {
                      if (ds.exists) {
                        if (ds['email'] == _email.text) {
                          st.setBool('emailFound', false);
                        } else {
                          st.setBool('emailFound', true);
                        }
                      } else {
                        st.setBool('emailFound', true);
                      }
                      if (st.getBool('emailFound')) {
                        databaseReference
                            .collection("users")
                            .document(_email.text)
                            .setData(
                          {
                            'username': _userName.text,
                            'email': _email.text,
                            'password': _password.text,
                          },
                        );
                        _showDialog('Bravo!', 'Registration Success', context);
                      } else {
                        _showDialog('Sorry!', 'User or EmailId already exists',
                            context);
                      }
                    },
                  );
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
                  "Register",
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
            child: Text('Register Your Details'),
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
                userField,
                SizedBox(height: 30.0),
                emailField,
                SizedBox(height: 30.0),
                passwordField,
                SizedBox(height: 30.0),
                confPasswordField,
                SizedBox(height: 30.0),
                registerButton,
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
  final c = context;

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
            child: new Text("Close"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(c);
            },
          ),
        ],
      );
    },
  );
}
