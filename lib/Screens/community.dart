import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/query_and_replies.dart';
import 'package:flutter_doctor/Screens/loader.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:select_dialog/select_dialog.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file/file.dart';

import 'package:image_picker/image_picker.dart';

import 'package:flutter_doctor/utilities/forum.dart' as forum;

import 'package:flutter_doctor/utilities/auth.dart' as auth;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as io;

class User {
  String id;
  String name;
  String email;

  User(this.id, this.name, this.email);
}

class Reply {
  String id;
  String replyText;
  int rating;
  User author;
  String postDate;

  Reply(this.id, this.replyText, this.rating, this.author, this.postDate);
}

class Query {
  String id;
  String imageURL;
  User author;
  String authorImage;
  String postDate;
  String relatedFruit;
  String subject;
  String query;
  List<Reply> replies;

  Query(this.id, this.imageURL, this.author, this.authorImage, this.postDate,
      this.relatedFruit, this.subject, this.query, this.replies);
}

class Community extends StatefulWidget {
  static const String id = 'Community';
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  bool isLoading = false;
  bool queriesLoading = true;
  var queries;
  var totalQueries = 0;
  bool postingQuery = false;

  _CommunityState() {
    initState() async {}
  }
  Future<List<Query>> fetchQueries() async {
    List<Query> queriesList = [];

    await forum.getQueries().then((queryArray) {
      print(queryArray);
      var jsonData = jsonDecode(queryArray.body);

      for (var u in jsonData) {
        List<Reply> replies = [];

        //Adding the user credentials who uploaded the post
        User user =
            User(u['author']['_id'], u['author']['name'], u['author']['email']);

        //adding replies in each post
        var jsonData2 = u['replies'];
        for (var v in jsonData2) {
          //adding user credentials for each reply
          User user2 = User(
              v['author']['_id'], v['author']['name'], v['author']['email']);

          Reply reply = Reply(
              v['_id'], v['replyText'], v['ratings'], user2, v['postDate']);

          replies.add(reply);
        }

        Query query = Query(
            u['_id'],
            u['imageURL'],
            user,
            u['imageURL'],
            u['postDate'],
            u['relatedFruit'],
            u['subject'],
            u['query'],
            replies);

        queriesList.add(query);
      }
      queriesLoading = false;
      totalQueries = queriesList.length;
      print(totalQueries);
    });
    return queriesList;
  }

  Color lightgrey = Color(0xffEAEAEA);
  Color darkgrey = Color(0xffa9a9a9);
  List<String> filterTags = [
    'Apple',
    'Banana',
    'Citrus',
    'Mango',
    'Pine Apple',
    'Strawberry',
    'Recent'
  ];
  List<String> selectedFilterTags = ['Popular'];

  Color penColor = Colors.blueGrey;

  List<String> fruits = [
    'Apple',
    'Banana',
    'Citrus',
    'Mango',
    'Pine Apple',
    'Strawberry'
  ];
  String queryFruit = 'Query Fruit';
  final List<Map<String, dynamic>> _items = [
    {'label': 'Apple'},
    {'label': 'Banana'},
    {'label': 'Citrus'},
    {'label': 'Mango'},
    {'label': 'Pine Apple'},
    {'label': 'Strawberry'},
  ];

  io.File _image;
  bool picLoading = false;

  _imgFromCamera() async {
    io.File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      picLoading = false;
    });
  }

  _imgFromGallery() async {
    io.File image = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 50)
        .then((image) {
      setState(() {
        _image = image;
        picLoading = false;
      });
    });
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setState) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () async {
                          await _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () async {
                        await _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  String _fruit = '';
  String _subject = '';
  String _query = '';

  final _queryForm = GlobalKey<FormState>();
  final _formFruit = GlobalKey<FormState>();
  final _formSubject = GlobalKey<FormState>();
  final _formQuery = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightgrey,
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.filter_list,
                                            color: Colors.blueGrey,
                                            size: 28,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Filter by',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              Icons.edit,
                                              color: penColor,
                                              size: 20,
                                            ),
                                            onTap: () => {
                                              SelectDialog.showModal<String>(
                                                context,
                                                label: "Filter Forum",
                                                multipleSelectedValues:
                                                    selectedFilterTags,
                                                items: filterTags,
                                                onMultipleItemsChange:
                                                    (List<String> selected) {
                                                  setState(() {
                                                    selectedFilterTags =
                                                        selected;
                                                  });
                                                },
                                              )
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (var i in selectedFilterTags)
                                        Tag(i.toString())
                                    ],
                                  ))
                            ],
                          )))),
              FutureBuilder(
                future: fetchQueries(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Post(context, Colors.white,
                              snapshot.data[snapshot.data.length - index - 1]);
                        });
                  } else {
                    return Center(
                        child: Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            backgroundColor: appbar_Color,
                            strokeWidth: 4,
                          )),
                      SizedBox(
                        height: 10,
                      )
                    ]));
                  }
                },
              ),
            ],
          )),
      floatingActionButton: postingQuery
          ? SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                backgroundColor: appbar_Color,
                strokeWidth: 6,
              ))
          : FloatingActionButton.extended(
              backgroundColor: appbar_Color,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          scrollable: true,
                          content: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Positioned(
                                right: -10.0,
                                top: -10.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                              Form(
                                key: _queryForm,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            5.0, 5.0, 5.0, 0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.question_answer,
                                              size: 30,
                                              //color: primary_Color //Colors.blue,
                                            ),
                                            Icon(
                                              Icons.people,
                                              size: 60,
                                              //color: primary_Color //Colors.blue,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        )),
                                    Text('Upload a Picture',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 12)),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          picLoading = true;
                                        });
                                        await _showPicker(context);
                                        //while (_image == null) {}
                                        setState(() {
                                          _image = _image;
                                        });
                                      },
                                      child: _image != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.file(
                                                _image,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    200,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  200,
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                    ),

                                    SizedBox(height: 10),
                                    Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: DropdownButton<String>(
                                          key: _formFruit,
                                          //value: '',
                                          hint: new Text(queryFruit),
                                          isExpanded: true,
                                          icon: Icon(Icons.arrow_downward),
                                          iconSize: 24,
                                          elevation: 16,
                                          style:
                                              TextStyle(color: primary_Color),
                                          underline: Container(
                                            height: 2,
                                            color: primary_Color,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              queryFruit = newValue;
                                              _fruit = newValue;
                                            });
                                          },
                                          items: fruits
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: TextFormField(
                                        key: _formSubject,
                                        validator: Validators.required(
                                            'Subject is required'),
                                        initialValue: '',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: 'Your Question',
                                        ),
                                        onChanged: (value) {
                                          this._subject = value;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: TextFormField(
                                        key: _formQuery,
                                        validator: Validators.required(
                                            'Problem description is required'),
                                        initialValue: '',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: 'Problem Description',
                                        ),
                                        onChanged: (value) {
                                          this._query = value;
                                        },
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.all(8.0),
                                    //   child: TextFormField(
                                    //       initialValue: 'Problem description'),
                                    // ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: RaisedButton(
                                        color: primary_Color,
                                        textColor: Colors.white,
                                        child: Text("Post Query"),
                                        onPressed: () async {
                                          if (_queryForm.currentState
                                              .validate()) {
                                            this.setState(() {
                                              postingQuery = true;
                                              isLoading = true;
                                            });
                                            Navigator.of(context).pop();
                                            SharedPreferences sharedPref =
                                                await SharedPreferences
                                                    .getInstance();
                                            var email = sharedPref.get('email');

                                            forum
                                                .postQuery(_subject, _query,
                                                    email, _fruit, _image)
                                                .then((val) async {
                                              this.setState(() {
                                                isLoading = false;
                                                _image = null;
                                                postingQuery = false;
                                              });
                                              if (val.data['success']) {
                                                Fluttertoast.showToast(
                                                    msg: 'Query Posted',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    backgroundColor:
                                                        Colors.green,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Post Failed",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            });
                                          } else {
                                            var errMsg;
                                            if (!_formSubject.currentState
                                                .validate())
                                              errMsg =
                                                  "Please enter your subject";
                                            else
                                              errMsg =
                                                  "Please describe your query";
                                            Fluttertoast.showToast(
                                                msg: errMsg,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    });
                //   Navigator.push(
                //       context,
                //       CupertinoPageRoute(
                //           builder: (_) => AddTaskSreen(
                //                 updateTaskList: _updateTaskList,
                //               )));
              },
              icon: Icon(Icons.edit),
              label: Text('Ask Community'),
            ),
    );
  }

  Widget Post(context, Color color, Query query) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Replies(query)));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            color: color,
            child: Container(
              width: (MediaQuery.of(context).size.width),
              //height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: [
                  Container(
                      height: 200,
                      width: (MediaQuery.of(context).size.width),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: FittedBox(
                          child: query.imageURL != ''
                              ? Image.network(query.imageURL)
                              : Image.asset('assets/images/apple.jpg'),
                          fit: BoxFit.fill,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 40,
                                      width: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: FittedBox(
                                          child: Image.network(query.imageURL),
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    //mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          alignment: Alignment.topLeft,
                                          width: 300,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                query.author.name,
                                                style: TextStyle(
                                                  color: primary_Color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          width: 300,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                forum.timeAgo(query.postDate),
                                                style: TextStyle(
                                                  color: darkgrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image(
                                                image: AssetImage(
                                                  'assets/images/home/' +
                                                      query.relatedFruit +
                                                      '.png',
                                                ),
                                                height: 15,
                                                width: 15,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                query.relatedFruit,
                                                style: TextStyle(
                                                  color: darkgrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                query.subject,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                query.query,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(color: lightgrey),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Upvote',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.thumb_down,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Downvote',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget Tag(text) {
  return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              color: Color(0xffEAEAEA),
              child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(text, style: TextStyle())))));
}
