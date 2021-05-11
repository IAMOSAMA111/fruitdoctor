import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/scraper.dart';
import 'package:flutter_doctor/Screens/todo_list_screen.dart';
import 'package:flutter_doctor/Screens/welcome.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'note_home.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

class Profile extends StatefulWidget {
  static const String id = 'Profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "anonumus";
  String email = "somewhere.com";
  String url =
      "https://p.kindpng.com/picc/s/78-786207_user-avatar-png-user-avatar-icon-png-transparent.png";

  getUserCred({int choice}) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (choice == 1) {
      String name = sharedPref.get('name');
      if (name == null) return 'Anonymous';
      return name;
    } else if (choice == 2) {
      String email = sharedPref.get('email');
      if (email == null) return 'sample@email.com';
      return email;
    } else if (choice == 3) {
      String url = sharedPref.get('url');

      return url;
    }
  }

  /*getUserCresentials() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.getString('name') != null
        ? name = sharedPref.getString('name')
        : name = "Anonymous";
    sharedPref.getString('email') != null
        ? email = sharedPref.getString('email')
        : email = "sample@email.com";
    sharedPref.getString('url') != null
        ? url = sharedPref.getString('url')
        : url = "";
  }*/

  @override
  Widget build(BuildContext context) {
    //getUserCresentials();
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment
                                  .bottomCenter, // 10% of the width, so there are ten blinds.
                              colors: <Color>[
                                primary_Color.withOpacity(0.9),
                                primary_Color.withOpacity(0.9)
                              ], // red to yellow
                              tileMode: TileMode
                                  .repeated, // repeats the gradient over the canvas
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          //color: primary_Color.withOpacity(0.9),
                          height: MediaQuery.of(context).size.height / 3.3,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: getUserCred(choice: 3),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data != '') {
                                    return Padding(
                                        padding: EdgeInsets.only(top: 30),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                            snapshot.data,
                                          ),
                                        ));
                                  } else {
                                    return Padding(
                                        padding: EdgeInsets.only(top: 30),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 50,
                                          child: SvgPicture.asset(
                                              'assets/images/farmer-avatar.svg',
                                              height: 100,
                                              width: 100),
                                        ));
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              FutureBuilder(
                                future: getUserCred(choice: 1),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                        /*auth.a.isLoggedIn
                              ? auth.a.userProfile[auth.E.username.index]
                              : 'Anonymous',*/
                                        snapshot.data,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Colors.white));
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                              SizedBox(height: 5),
                              FutureBuilder(
                                future: getUserCred(choice: 2),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                        /*auth.a.isLoggedIn
                              ? auth.a.userProfile[auth.E.username.index]
                              : 'Anonymous',*/
                                        snapshot.data,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.white));
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                              SizedBox(height: 10)
                            ],
                          )),
                      // Divider(
                      //   color: Colors.grey[700],
                      //   height: MediaQuery.of(context).size.height / 25,
                      // ),
                      SizedBox(
                        height: 5,
                      ),

                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                          child: Text(
                            'My Data',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: NoteHome(),
                                      ));
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 1, //Colors.blue[300],
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: FaIcon(
                                          FontAwesomeIcons.book,
                                          color: Colors.blueGrey,
                                          size: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, top: 15, bottom: 15),
                                        child: Text("Notes",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TodoListScreen(),
                                      ));
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: FaIcon(
                                          FontAwesomeIcons.solidListAlt,
                                          color: Colors.blueGrey,
                                          size: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, top: 15, bottom: 15),
                                        child: Text("To do",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),

                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                          child: Text(
                            'General',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: TodoListScreen(),
                                    ));
                              },
                              child: Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: FaIcon(
                                        FontAwesomeIcons.userAlt,
                                        color: Colors.blueGrey,
                                        size: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 30, top: 15, bottom: 15),
                                      child: Text("Personal Profile",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: TodoListScreen(),
                                    ));
                              },
                              child: Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: FaIcon(
                                        FontAwesomeIcons.users,
                                        color: Colors.blueGrey,
                                        size: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 30, top: 15, bottom: 15),
                                      child: Text("Community Profile",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ])),
                    ]))));
  }
}
