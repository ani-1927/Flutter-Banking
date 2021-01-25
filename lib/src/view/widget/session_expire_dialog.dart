import 'package:flutter/material.dart';
import 'package:flutter_banking/src/injector/injector.dart';
import 'package:flutter_banking/src/storage/preference_manager.dart';
import 'package:flutter_banking/src/view/screen/login/login_screen.dart';

/*This is a dialog which is used for session expire*/
class SessionExpireDialog extends StatelessWidget {
  final PreferenceManager preferenceManager = locator<PreferenceManager>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Alert',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: (Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          'Session expired. Please login again!',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          onPressed: () {
            preferenceManager.clearAll();
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white),
          ),
        )
      ])),
    );
  }
}
