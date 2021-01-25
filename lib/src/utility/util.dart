import 'package:flutter_banking/src/injector/injector.dart';
import 'package:flutter_banking/src/storage/preference_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

//Util class contains those functions which are required all over the application
class Util {
  //used to check if email address is valid or not
  static bool checkEmailAddress(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  // this function is used to show the toast message in application
  static void showToastMessage({Color color, String message, Color textColor}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: textColor,
        fontSize: 16.0);
  }

  //This function is used to check if the user is already login in application
  static bool autoLogin() {
    final PreferenceManager preferenceManager = locator<PreferenceManager>();
    if (preferenceManager.isKeyExists(PreferenceManager.keyIsLogin) &&
        preferenceManager.isKeyExists(PreferenceManager.keyExpireTime)) {
      String time =
          preferenceManager.getString(PreferenceManager.keyExpireTime);
      DateTime _time = DateTime.parse(time);
      return _time.isAfter(DateTime.now());
    } else {
      return false;
    }
  }
}
