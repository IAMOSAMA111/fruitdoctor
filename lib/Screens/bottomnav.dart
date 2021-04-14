//import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_doctor/Provider/home_provider.dart';
import 'package:flutter_doctor/Screens/scraper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_doctor/Screens/home.dart';
import 'package:flutter_doctor/Screens/profile.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_doctor/Screens/todoist.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  Map up;
  static const String id = 'BottomNavigation';

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedPage = 0;
  String name;

  final _pageOption = [
    Home(),
    Text(
      "Community",
      style: TextStyle(fontSize: 20),
    ),
    ScraperScreen(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Fruit Doctor'),
            centerTitle: true,
            backgroundColor: Color(0xff27AE5A),
          ),
          body: Consumer<HomeProvider>(
            builder: (_, value, child) {
              return value.widget;
            },
          ),
          bottomNavigationBar: Consumer<HomeProvider>(
            builder: (context, value, child) {
              return BottomNavigationBar(
                selectedItemColor: primary_Color,
                unselectedItemColor: Colors.blueGrey,
                currentIndex: value.selectedPage,
                onTap: (int index) {
                  context.read<HomeProvider>().setPage(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.home,
                    ),
                    title: Text('Home'),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.comment),
                    title: Text("Community"),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.globe),
                    title: Text("Pundit"),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.user),
                    title: Text("Profile"),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
