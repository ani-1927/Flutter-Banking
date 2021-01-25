import 'dart:async';
import 'dart:convert';

import 'package:flutter_banking/src/injector/injector.dart';
import 'package:flutter_banking/src/model/login/login_request.dart';
import 'package:flutter_banking/src/model/login/login_response.dart';

import 'package:flutter_banking/src/resources/string_resources.dart';
import 'package:flutter_banking/src/service/api_constant.dart';
import 'package:flutter_banking/src/service/custom_error.dart';
import 'package:flutter_banking/src/storage/preference_manager.dart';
import 'package:flutter_banking/src/utility/util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

//This is a provider class which is used to handle to login
class AuthProvider extends ChangeNotifier {
  // instance of preference manager to save or get values
  final PreferenceManager preferenceManager = locator<PreferenceManager>();

  // used to handle to login api
  Future<void> handleLogin(String email, String password) async {
    validateLoginCredential(email, password);

    // create the request body for login
    LoginRequest request =
        LoginRequest(password: password, email: email, returnSecureToken: true);
    print(request.toJson());
    try {
      final response = await http
          .post(APIConstant.loginUrl, body: request.toJson(), headers: {
        APIConstant.contentType: APIConstant.applicationJson,
      });
      final res = json.decode(response.body) as Map<String, dynamic>;
      print(res.toString());
      if (response.statusCode == 200) {
        final LoginResponse loginResponse = LoginResponse.fromJson(res);
        await saveLoginData(loginResponse);
        notifyListeners();
      } else {
        throw CustomError(StringResources.textApiError);
      }
    } catch (error) {
      throw CustomError(StringResources.textApiError);
    }
    notifyListeners();
  }

  //used to validate the login credentials
  void validateLoginCredential(String email, String password) {
    if (email.isEmpty) {
      throw CustomError(StringResources.textEmptyEmail);
    }
    if (!Util.checkEmailAddress(email)) {
      throw CustomError(StringResources.textInvalidEmail);
    }
    if (password.isEmpty) {
      throw CustomError(StringResources.textEmptyPassword);
    }
    if (password != 'password') {
      throw CustomError(StringResources.textInvalidPassword);
    }
  }

  //used to save the login data in shared preference
  Future<void> saveLoginData(LoginResponse loginResponse) async {
    await preferenceManager.putString(
        PreferenceManager.keyLocalToken, loginResponse.localId);
    await preferenceManager.putBool(PreferenceManager.keyIsLogin, true);
    await preferenceManager.putString(
        PreferenceManager.keyAccessToken, loginResponse.idToken);
    await preferenceManager.putString(
        PreferenceManager.keyRefreshToken, loginResponse.refreshToken);
    await preferenceManager.putString(
        PreferenceManager.keyEmail, loginResponse.email);
    String _time = DateTime.now()
        .add(Duration(seconds: int.parse(loginResponse.expiresIn)))
        .toIso8601String();
    print(_time);
    await preferenceManager.putString(PreferenceManager.keyExpireTime, _time);
  }
}
