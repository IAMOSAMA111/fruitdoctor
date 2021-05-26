import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doctor/Provider/modelResult.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
//import 'package:pie_chart/pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_doctor/Widget/indicator.dart';

class GalleryScreen extends StatefulWidget {
  String endpoint;
  GalleryScreen(this.endpoint);
  @override
  _GalleryScreenState createState() => _GalleryScreenState(endpoint);
}

class _GalleryScreenState extends State<GalleryScreen> {
  File _image;
  String endpoint;
  String status = "Prediction";
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

  int touchedIndex = 0;

  // List<double> percentages = [15, 40, 30, 10, 5];
  List<String> papayaDiseases = [
    "Anthracnose",
    "Black Spot",
    'Phytophthora',
    "Powdery Mildew",
    "Ring Spot"
  ];
  List<String> cornDiseases = [
    "Grey Leaf Spot",
    "Common Rust",
    "Northern Leaf Blight",
    "Healthy"
  ];
  List<String> appleDiseases = [
    "Apple Scab",
    "Black Rot",
    "Cedar Apple Rust",
    "Healthy"
  ];
  List<String> strawberryDiseases = ["Leaf Scrotch", "Healthy"];
  List<String> appleGrades = [
    'Apple Green',
    'Apple Red G1',
    'Apple Red G2',
    'Apple Yellow'
  ];
  List<String> bananaGrades = [
    'Banana Yellow',
    'Banana Green',
    'Rotten Banana'
  ];
  List<String> orangeGrades = ['Orange G1', 'Orange G2', 'Rotten orange'];

  List<double> percentages = [100];
  List<String> classes = ['None'];
  List<Color> doughnutColors = [
    const Color(0xff0293ee),
    const Color(0xfff8b250),
    const Color(0xff845bef),
    const Color(0xff13d38e),
    Colors.pinkAccent
  ];

  getList() {
    return Column(
      children: [
        for (var i in classes) Text('this'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primary_Color,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 5),
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
                              height: MediaQuery.of(context).size.width - 300,
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
              Center(
                child: Consumer<ModelResults>(builder: (_, myResults, child) {
                  return RaisedButton(
                    child: Text('Send to Server'),
                    onPressed: () async {
                      Dio dio = new Dio();

                      var address = 'http://10.0.2.2:5000/$endpoint';
//192.168.0.105
                      debugPrint('here');
                      if (_image != null) {
                        dynamic img_file = _image.path.split('/').last;

                        ////The other way to do it
                        FormData formdata;
                        var imageName;

                        setState(() {
                          status = "loading";
                        });
                        imageName = _image.path.split('/').last;
                        final mimeTypeData = lookupMimeType(_image.path,
                            headerBytes: [0xFF, 0xD8]).split('/');
                        formdata = new FormData();
                        formdata.files.add(MapEntry(
                          "img",
                          await MultipartFile.fromFile(_image.path,
                              filename: imageName,
                              contentType: new MediaType(
                                  mimeTypeData[0], mimeTypeData[1])),
                        ));

                        ////

                        FormData dt = FormData.fromMap({
                          "img": await MultipartFile.fromFile(_image.path,
                              filename: img_file)
                        });

                        Response<String> res =
                            await dio.post(address, data: dt);
                        var js = jsonDecode(res.data);
                        print(js);

                        this.setState(() {
                          if (endpoint == "predictPapayaDisease")
                            classes = papayaDiseases;
                          else if (endpoint == "predictAppleDisease")
                            classes = appleDiseases;
                          else if (endpoint == "predictCornDisease")
                            classes = cornDiseases;
                          else if (endpoint == "predictStrawberryDisease")
                            classes = strawberryDiseases;
                          else if (endpoint == "gradeApple")
                            classes = appleGrades;
                          else if (endpoint == "gradeBanana")
                            classes = bananaGrades;
                          else if (endpoint == "gradeOrange")
                            classes = orangeGrades;
                          percentages = new List<double>(classes.length);

                          for (var i = 0; i < classes.length; i++) {
                            percentages[i] =
                                double.parse(js[i.toString()]) * 100;
                          }
                        });

                        var maxIndex = 0;
                        double maxvalue = 0;
                        for (var i = 0; i < classes.length; i++) {
                          if (percentages[i] > maxvalue) {
                            maxIndex = i;
                            maxvalue = percentages[i];
                          }
                        }
                        print(maxIndex);
                        setState(() {
                          touchedIndex = maxIndex;
                        });

                        //

                        setState(() {
                          status = classes[maxIndex].toString();
                        });
                      } else {
                        setState(() {
                          status = "Select an image";
                        });
                      }
                    },
                  );
                }),
              ),
              Consumer<ModelResults>(builder: (_, myResults, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(status,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent)),
                );
              }),
              AspectRatio(
                aspectRatio: 1.1,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                                pieTouchData: PieTouchData(
                                    touchCallback: (pieTouchResponse) {
                                  setState(() {
                                    final desiredTouch = pieTouchResponse
                                            .touchInput is! PointerExitEvent &&
                                        pieTouchResponse.touchInput
                                            is! PointerUpEvent;
                                    if (desiredTouch &&
                                        pieTouchResponse.touchedSection !=
                                            null) {
                                      touchedIndex =
                                          pieTouchResponse.touchedSectionIndex;
                                    } else {
                                      touchedIndex = -1;
                                    }
                                  });
                                }),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                sections: showingSections()),
                          ),
                        ),
                      ),
                      Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < classes.length; i++)
                              Indicator(
                                color: doughnutColors[i],
                                text: classes[i],
                                isSquare: true,
                                isLast: i == classes.length - 1 ? true : false,
                              ),
                          ]),
                      const SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  updateLists() {}

  List<PieChartSectionData> showingSections() {
    return List.generate(classes.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 80.0 : 70.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      return PieChartSectionData(
        color: doughnutColors[i],
        value: percentages[i],
        title: percentages[i].round().toString() + '%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
        // badgeWidget: _Badge(
        //   'assets/worker-svgrepo-com.svg',
        //   size: widgetSize,
        //   borderColor: const Color(0xff13d38e),
        // ),
        // badgePositionPercentageOffset: .98,
      );
    });
  }
}

// class _Badge extends StatelessWidget {
//   final String svgAsset;
//   final double size;
//   final Color borderColor;

//   const _Badge(
//     this.svgAsset, {
//     Key? key,
//     required this.size,
//     required this.borderColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: PieChart.defaultDuration,
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: 2,
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.black.withOpacity(.5),
//             offset: const Offset(3, 3),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(size * .15),
//       child: Center(
//         child: SvgPicture.asset(
//           svgAsset,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }
