import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void toast(String msz) {
    Fluttertoast.showToast(
        msg: msz,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade500,
        textColor: Colors.black,
        fontSize: 14);
  }
}
