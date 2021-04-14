import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/scraper.dart';
import 'package:flutter_doctor/Screens/todo_list_screen.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_doctor/utilities/auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_doctor/Screens/welcome.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note_home.dart';

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
      if (url == null)
        return 'https://p.kindpng.com/picc/s/78-786207_user-avatar-png-user-avatar-icon-png-transparent.png';
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
                child: Column(children: [
                  FutureBuilder(
                    future: getUserCred(choice: 3),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Image.network(
                              /*auth.a.isLoggedIn
                              ? auth.a.userProfile[auth.E.photoURL.index] !=
                                      null
                                  ? auth.a.userProfile[auth.E.photoURL.index]
                                  : 'https://p.kindpng.com/picc/s/78-786207_user-avatar-png-user-avatar-icon-png-transparent.png'
                              : 'https://p.kindpng.com/picc/s/78-786207_user-avatar-png-user-avatar-icon-png-transparent.png',*/
                              snapshot.data,
                              height: 80,
                              width: 80),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 50),
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
                              fontSize: 18,
                            ));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(height: 10),
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
                                fontWeight: FontWeight.bold, fontSize: 16));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[700],
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NoteHome()));
                    },
                    child: Card(
                      color: Colors.blue[300],
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: FaIcon(
                              FontAwesomeIcons.pen,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 40, top: 30, bottom: 30),
                            child: Text(" My Notes",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Card(
                  //   color: Colors.blue[300],
                  //   child: Row(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => NoteHome()));
                  //         },
                  //         child: Padding(
                  //           padding:
                  //               EdgeInsets.only(left: 40, top: 30, bottom: 30),
                  //           child: Text(" My Notes",
                  //               style: TextStyle(
                  //                   fontSize: 20, fontWeight: FontWeight.bold)),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodoListScreen()));
                    },
                    child: Card(
                      color: Colors.red[300],
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: FaIcon(
                              FontAwesomeIcons.list,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 40, top: 30, bottom: 30),
                            child: Text(" My Todo List",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Card(
                  //   color: Colors.redAccent,
                  //   child: Row(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => TodoListScreen()));
                  //         },
                  //         child: Padding(
                  //           padding:
                  //               EdgeInsets.only(left: 40, top: 30, bottom: 30),
                  //           child: Text("Todo",
                  //               style: TextStyle(
                  //                   fontSize: 20, fontWeight: FontWeight.bold)),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height / 15),
                  Divider(
                    color: Colors.grey[700],
                    height: MediaQuery.of(context).size.height / 25,
                  ),

                  ButtonTheme(
                      buttonColor: secondary_Color,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () async {
                          auth.a.logout();
                          SharedPreferences sharepref =
                              await SharedPreferences.getInstance();
                          sharepref.setBool("loggedin", false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (Welcome())));
                        },
                        child: Text(
                          'LOG OUT',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      )),
                ]))));
  }
}
