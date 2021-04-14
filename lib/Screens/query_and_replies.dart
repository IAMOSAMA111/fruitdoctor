import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/calculate_fertilizer.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:select_dialog/select_dialog.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:file/file.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:flutter_doctor/Screens/community.dart' as community;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_doctor/utilities/forum.dart' as forum;

class Replies extends StatefulWidget {
  static const String id = 'Replies';

  community.Query query;

  Replies(this.query);
  @override
  _RepliesState createState() => _RepliesState(this.query);
}

class _RepliesState extends State<Replies> {
  community.Query query;

  String replyText = '';
  SharedPreferences sharedPref;
  var email;
  bool postingReply = false;

  _RepliesState(this.query);

  Color lightgrey = Color(0xffEAEAEA);
  Color darkgrey = Color(0xffa9a9a9);
  FocusNode _focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    //footer: MyFooterWidget(context),
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: true,
      backgroundColor: lightgrey,
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              //reverse: true,
              // child: Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      color: Colors.white,
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
                                    child: Image.network(query.imageURL),
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: 40,
                                            width: 40,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: FittedBox(
                                                child: Image.network(
                                                    query.imageURL),
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      query.author.name,
                                                      style: TextStyle(
                                                        color: primary_Color,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                                width: 300,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      forum.timeAgo(
                                                          query.postDate),
                                                      style: TextStyle(
                                                        color: darkgrey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Image.asset(
                                                      'assets/images/home/' +
                                                          query.relatedFruit +
                                                          '.png',
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
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
                                )),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              for (community.Reply i in query.replies) Reply(i)
                            ],
                          )),
                          // Reply('reply'),
                          Card(
                              //padding: EdgeInsets.only(left: 20),
                              color: Colors.white,
                              //width: MediaQuery.of(context).size.width,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 30,
                                          width: 30,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: FittedBox(
                                              child: Image.asset(
                                                  'assets/images/appleScab.jpg'),
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                          child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Karla',
                                        ),
                                        decoration: InputDecoration.collapsed(
                                          hintText: 'Write your reply...',
                                          hintStyle: TextStyle(
                                            color: Color(0xff2e3039),
                                          ),
                                        ),
                                        onChanged: (value) => {
                                          this.setState(() {
                                            replyText = value;
                                          }),
                                        },
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        child: postingReply
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: appbar_Color,
                                                  strokeWidth: 3,
                                                ))
                                            : Icon(
                                                Icons.send,
                                                color: primary_Color,
                                                size: 26,
                                              ),
                                        onTap: () async => {
                                          sharedPref = await SharedPreferences
                                              .getInstance(),
                                          email = sharedPref.get('email'),
                                          this.setState(() {
                                            postingReply = true;
                                          }),
                                          if (replyText != '')
                                            {
                                              forum
                                                  .postReply(query.id,
                                                      replyText, email)
                                                  .then((val) async {
                                                this.setState(() {
                                                  postingReply = false;
                                                  replyText = '';
                                                });
                                                if (val.data['success']) {
                                                  Fluttertoast.showToast(
                                                      msg: 'Reply Posted',
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
                                                      msg: "Reply Failed",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }
                                              })
                                            }
                                        },
                                      )
                                    ],
                                  )))
                          //Positioned(bottom: 0.0, child: ),
                        ],
                      )),
                ],
              ))),
    );
  }
}

Widget Reply(community.Reply reply) {
  return Container(
      child: Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FittedBox(
                    child: Image.asset('assets/images/appleScab.jpg'),
                    fit: BoxFit.fill,
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    width: 300,
                    child: Row(
                      children: [
                        Text(
                          reply.author.name,
                          style: TextStyle(
                            color: primary_Color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 5,
                ),
                Container(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          forum.timeAgo(reply.postDate),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                      ],
                    ))
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          reply.replyText,
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(color: Colors.white),
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
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 2,
          color: Colors.white,
        ),
      ],
    ),
  ));
}
