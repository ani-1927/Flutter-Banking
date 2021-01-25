import 'package:flutter/material.dart';
import 'package:flutter_banking/src/provider/auth_provider.dart';
import 'package:flutter_banking/src/resources/string_resources.dart';
import 'package:flutter_banking/src/utility/util.dart';
import 'package:flutter_banking/src/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

//This is the login screen
class LoginScreen extends StatefulWidget {
  static const routeName = '/Login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controller for email
  final TextEditingController _emailController = new TextEditingController();

  //controller for password
  final TextEditingController _passwordController = new TextEditingController();

  //isLoading is used to show the loader while waiting for api response
  bool isLoading = false;

  //it is a getting used to get the textField for email
  TextField get emailField => TextField(
        controller: _emailController,
        decoration: InputDecoration(labelText: StringResources.textEmail),
      );

  //it is a getting used to get the textField for password
  TextField get passwordField => TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(labelText: StringResources.textPassword),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Image.asset(
                      "assets/images/icon.png",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: emailField,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: passwordField,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    color: Color(0xFF2979FF),
                    textColor: Colors.white,
                    onPressed: () {
                      login();
                    },
                    child: Text('Login', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              isLoading
                  ? Container(
                      color: Colors.black38,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  //this function is used to handle to login and api response
  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).handleLogin(
          _emailController.text.trim(), _passwordController.text.trim());
      setState(() {
        isLoading = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Util.showToastMessage(message: error.toString());
    }
  }
}
