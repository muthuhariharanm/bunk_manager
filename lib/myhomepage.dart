import 'package:bunk_manager/details.dart';
import 'package:bunk_manager/startPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final email;
  MyHomePage(this.email);
  @override
  _MyHomePageState createState() => _MyHomePageState(email);
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _creditController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;

  var subjects = new Set();

  String email;
  _MyHomePageState(this.email);
  bool addSubject = true;
  SharedPreferences st;

  void callSP() async {
    st = await SharedPreferences.getInstance();
  }

  void removeAddSubject() {
    setState(() {
      addSubject = false;
    });
  }

  void _onClear() {
    setState(() {
      _subjectController.text = "";
      _creditController.text = "";
    });
  }

  void addAddSubject() {
    setState(() {
      addSubject = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Subject List",
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
          actions: <Widget>[
            Row(
              children: [
                if (addSubject)
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(2, 10, 50, 10),
                        alignment: Alignment.center,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add),
                            Text(
                              "AddSubject",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        removeAddSubject();
                      },
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
                      alignment: Alignment.center,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.lock),
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      SharedPreferences st =
                          await SharedPreferences.getInstance();
                      st.remove('user');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => StartPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: Colors.deepPurple,
        ),
        body: (!addSubject)
            ? Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          labelText: "Enter a subject",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter A Subject';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _creditController,
                        decoration: InputDecoration(
                          labelText: "Enter Credits",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Credits';
                          } else if (int.tryParse(value) >= 10) {
                            return 'Please Enter only a Single Digit';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 20.0, bottom: 10.0),
                      child: GestureDetector(
                        onTap: () async {
                          SharedPreferences st =
                              await SharedPreferences.getInstance();
                          if (formKey.currentState.validate()) {
                            Firestore.instance
                                .collection('users/' +
                                    st.getString('user') +
                                    '/subjectDetails')
                                .document(_subjectController.text)
                                .get()
                                .then((DocumentSnapshot ds) {
                              if (ds.exists) {
                                if (ds['subject'] == _subjectController.text) {
                                  st.setBool('subjectFound', false);
                                } else {
                                  st.setBool('subjectFound', true);
                                }
                              } else {
                                st.setBool('subjectFound', true);
                              }
                              bool check = st.getBool('subjectFound');
                              print(check);
                              if (check) {
                                databaseReference
                                    .collection("users/" +
                                        st.getString('user') +
                                        "/subjectDetails")
                                    .document(_subjectController.text)
                                    .setData(
                                  {
                                    'subject': _subjectController.text,
                                    'credits': _creditController.text,
                                    'noOfBunks': 0,
                                    'classesAttended': 0
                                  },
                                );
                                _showDialog(
                                    'Congrats', "Subject Added", context);
                                addAddSubject();
                                _onClear();
                              } else {
                                _showDialog(
                                    'Sorry!', "Subject Already Added", context);
                                addAddSubject();
                                _onClear();
                              }
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            "Add Subject",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection(
                                "users/" + this.email + "/subjectDetails")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              '',
                            );
                          } else {
                            return Column(
                              children: <Widget>[
                                ...snapshot.data.documents
                                    .map<Widget>((document) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 40.0,
                                            right: 40.0,
                                            top: 20.0,
                                            bottom: 10.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              _subjectDetails(document, context,
                                                  this.email);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color: Colors.pinkAccent,
                                                borderRadius:
                                                    BorderRadius.circular(9.0),
                                              ),
                                              child: Text(
                                                document['subject'],
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
                                }).toList(),
                              ],
                            );
                          }
                        },
                      )
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
            child: Text("Back"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void _subjectDetails(document, context, email) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Details(document, email),
    ),
  );
}
