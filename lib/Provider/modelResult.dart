import 'package:flutter/material.dart';

class ModelResults with ChangeNotifier {
  String result = ".";

  resultsFetch(String res) {
    result = res;
    notifyListeners();
  }
}
