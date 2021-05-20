import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/Provider/modelResult.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pie_chart/pie_chart.dart';

class GalleryScreen extends StatefulWidget {
  String endpoint;
  GalleryScreen(this.endpoint);
  @override
  _GalleryScreenState createState() => _GalleryScreenState(endpoint);
}

class _GalleryScreenState extends State<GalleryScreen> {
  File _image;
  String endpoint;
  _GalleryScreenState(this.endpoint);
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future getPrediction() {
    List<String> pred;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary_Color,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: Container(
                color: Colors.white,
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _image,
                          width: MediaQuery.of(context).size.width - 70,
                          height: MediaQuery.of(context).size.width - 70,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Consumer<ModelResults>(builder: (_, myResults, child) {
            return RaisedButton(
              child: Text('Send to Server'),
              onPressed: () async {
                Dio dio = new Dio();
                Provider.of<ModelResults>(context, listen: false)
                    .resultsFetch("Loading");
                var address = 'http://10.0.2.2:5000/$endpoint';
//192.168.0.105
                debugPrint('here');

                dynamic img_file = _image.path.split('/').last;

                ////The other way to do it
                FormData formdata;
                var imageName;
                if (_image != null) {
                  imageName = _image.path.split('/').last;
                  final mimeTypeData =
                      lookupMimeType(_image.path, headerBytes: [0xFF, 0xD8])
                          .split('/');
                  formdata = new FormData();
                  formdata.files.add(MapEntry(
                    "img",
                    await MultipartFile.fromFile(_image.path,
                        filename: imageName,
                        contentType:
                            new MediaType(mimeTypeData[0], mimeTypeData[1])),
                  ));
                }
                ////

                FormData dt = FormData.fromMap({
                  "img": await MultipartFile.fromFile(_image.path,
                      filename: img_file)
                });
                Response<String> res = await dio.post(address, data: dt);
                var js = res.data.toString();

                var final_res = convJsonToRes(jsonDecode(js));

                Provider.of<ModelResults>(context, listen: false)
                    .resultsFetch(final_res);
                debugPrint(final_res);
              },
            );
          }),
          Consumer<ModelResults>(builder: (_, myResults, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(myResults.result,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent)),
            );
          })
        ],
      ),
    );
  }
}

convJsonToRes(Map<String, dynamic> js) {
  return js['name'].toString();
}
