import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_banking/src/injector/injector.dart';
import 'package:flutter_banking/src/provider/Update_provider.dart';
import 'package:flutter_banking/src/provider/auth_provider.dart';
import 'package:flutter_banking/src/provider/dashboard_provider.dart';
import 'package:flutter_banking/src/utility/util.dart';
import 'package:flutter_banking/src/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_banking/src/view/screen/login/login_screen.dart';
import 'package:flutter_banking/src/view/screen/transaction/deposit_withdraw_screen.dart';
import 'package:flutter_banking/src/view/screen/transaction/send_screen.dart';
import 'package:provider/provider.dart';

/*This is the entry point for our application*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Used the fixed to orientation for our application
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupLocator();
  runApp(MyBankApp());
}

class MyBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLogin = Util.autoLogin();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.blue[900],
            textTheme: TextTheme(
              headline1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              headline2: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              subtitle1: TextStyle(
                  fontFamily: "Questrial-Regular", color: Colors.black),
            ),
            accentColor: Colors.blue[700],
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueAccent[700],
              textTheme: ButtonTextTheme.primary,
            )),
        home: isLogin ? DashboardScreen() : LoginScreen(),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          DashboardScreen.routeName: (context) => DashboardScreen(),
          DepositWithdrawScreen.routeName: (context) => DepositWithdrawScreen(),
          SendScreen.routeName: (context) => SendScreen(),
        },
      ),
    );
  }
}
