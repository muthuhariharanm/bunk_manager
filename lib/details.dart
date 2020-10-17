import 'package:bunk_manager/startPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  final document, email;
  Details(this.document, this.email);
  @override
  _DetailsState createState() => _DetailsState(document, email);
}

class _DetailsState extends State<Details> {
  MediaQueryData queryData;

  final document, email;
  _DetailsState(this.document, this.email);

  String calculate(int a, int b) {
    if (a == 0 && b == 0) {
      return "0";
    }
    if (b == 0) {
      return "100";
    }
    return (a / (a + b) * 100).round().toString();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              this.document['subject'] + " Details",
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(right: 20),
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
                  SharedPreferences st = await SharedPreferences.getInstance();
                  st.remove('user');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => StartPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: queryData.size.width,
                    height: queryData.size.height / 2.5,
                    color: Colors.yellow,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 53, 20, 20),
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection(
                                "users/" + this.email + "/subjectDetails")
                            .document(this.document['subject'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          return Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text(
                                        "NO OF BUNKS",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 130),
                                        child: Text(
                                          snapshot.data['noOfBunks'].toString(),
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                alignment: Alignment.center,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text(
                                        "NO OF CLASSES",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 113),
                                        child: Text(
                                          snapshot.data['classesAttended']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                alignment: Alignment.center,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text(
                                        "ATTENDANCE",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 130),
                                        child: Text(
                                          calculate(
                                              snapshot.data['classesAttended'],
                                              snapshot.data['noOfBunks']),
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: GestureDetector(
                      onTap: () async {
                        print("Hi");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "BUNKED DAYS LIST",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 10, 30),
                                child: Container(
                                  height: 50,
                                  child: FlatButton.icon(
                                    color: Colors.green[700],
                                    onPressed: () {
                                      _addClass(this.document);
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text('Attend Class'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 10, 30),
                                child: Container(
                                  height: 50,
                                  child: FlatButton.icon(
                                    color: Colors.blue[300],
                                    onPressed: () {
                                      _removeClass(this.document);
                                    },
                                    icon: Icon(Icons.remove),
                                    label: Text("Remove Class"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 5, 10, 30),
                                child: Container(
                                  height: 50,
                                  child: FlatButton.icon(
                                    color: Colors.green[700],
                                    onPressed: () {
                                      _addBunk(document);
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text('Bunk Class    '),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 5, 10, 30),
                                child: Container(
                                  height: 50,
                                  child: FlatButton.icon(
                                    color: Colors.blue[300],
                                    onPressed: () {
                                      _removeBunk(this.document);
                                    },
                                    icon: Icon(Icons.remove),
                                    label: Text("Remove Bunk"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: GestureDetector(
                      onTap: () {
                        _clearAllDetails(this.document);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "CLEAR ALL DETAILS",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

void _clearAllDetails(final document) async {
  SharedPreferences st = await SharedPreferences.getInstance();
  String email = st.getString('user');
  await Firestore.instance
      .collection('users/' + email + '/subjectDetails')
      .document(document['subject'])
      .updateData(
    {
      "attendancePercentage": 0,
      "classesAttended": 0,
      "noOfBunks": 0,
    },
  );
}

void _addBunk(final document) async {
  SharedPreferences st = await SharedPreferences.getInstance();
  String email = st.getString('user');
  int noOfBunks = 0;
  Firestore.instance
      .collection('users/' + email + '/subjectDetails')
      .document(document['subject'])
      .get()
      .then((DocumentSnapshot ds) {
    noOfBunks = ds["noOfBunks"];
    Firestore.instance
        .collection('users/' + email + '/subjectDetails')
        .document(document['subject'])
        .updateData(
      {
        "noOfBunks": noOfBunks + 1,
      },
    );
  });
}

void _removeBunk(final document) async {
  SharedPreferences st = await SharedPreferences.getInstance();
  String email = st.getString('user');
  int noOfBunks = 0;
  Firestore.instance
      .collection('users/' + email + '/subjectDetails')
      .document(document['subject'])
      .get()
      .then((DocumentSnapshot ds) {
    noOfBunks = ds["noOfBunks"];
    if (noOfBunks != 0) {
      Firestore.instance
          .collection('users/' + email + '/subjectDetails')
          .document(document['subject'])
          .updateData(
        {
          "noOfBunks": noOfBunks - 1,
        },
      );
    }
  });
}

void _addClass(final document) async {
  SharedPreferences st = await SharedPreferences.getInstance();
  String email = st.getString('user');
  int noOfClasses = 0;
  Firestore.instance
      .collection('users/' + email + '/subjectDetails')
      .document(document['subject'])
      .get()
      .then((DocumentSnapshot ds) {
    noOfClasses = ds["classesAttended"];

    Firestore.instance
        .collection('users/' + email + '/subjectDetails')
        .document(document['subject'])
        .updateData(
      {
        "classesAttended": noOfClasses + 1,
      },
    );
  });
}

void _removeClass(final document) async {
  SharedPreferences st = await SharedPreferences.getInstance();
  String email = st.getString('user');
  int noOfClasses = 0;
  Firestore.instance
      .collection('users/' + email + '/subjectDetails')
      .document(document['subject'])
      .get()
      .then((DocumentSnapshot ds) {
    noOfClasses = ds["classesAttended"];
    if (noOfClasses != 0) {
      Firestore.instance
          .collection('users/' + email + '/subjectDetails')
          .document(document['subject'])
          .updateData(
        {
          "classesAttended": noOfClasses - 1,
        },
      );
    }
  });
}
