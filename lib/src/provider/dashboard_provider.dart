import 'dart:convert';

import 'package:flutter_banking/src/injector/injector.dart';
import 'package:flutter_banking/src/model/client_detail/client_detail_response.dart';
import 'package:flutter_banking/src/model/dashboard/account_detail.dart';

import 'package:flutter_banking/src/resources/string_resources.dart';
import 'package:flutter_banking/src/service/api_constant.dart';
import 'package:flutter_banking/src/service/custom_error.dart';
import 'package:flutter_banking/src/service/session_expire.dart';
import 'package:flutter_banking/src/storage/preference_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DashboardProvider extends ChangeNotifier {
  final PreferenceManager preferenceManager = locator<PreferenceManager>();
  String _localToken;
  String _idToken;
  List<AccountDetail> _accounts = [];
  ClientDetail _clientDetail = ClientDetail(name: '', accounts: [], age: 0);
  bool _callAPI = false;

  // used to initialise the token from preferenceManger Before calling api
  void initToken() {
    _localToken = preferenceManager.getString(PreferenceManager.keyLocalToken);
    _idToken = preferenceManager.getString(PreferenceManager.keyAccessToken);
  }

  // used to call the api for dashboard
  Future<void> callAPI() async {
    try {
      await handleClient();
      if (_clientDetail.accounts == null ||
          _clientDetail.accounts.length == 0) {
        return;
      }
      await handleAccountDetail();
    } catch (error) {
      throw error;
    }
  }

  //used to call the client api for user
  Future<void> handleClient() async {
    String clientUrl =
        APIConstant.baseUrl + '/clients/$_localToken.json?auth=$_idToken';
    print(clientUrl);
    final response = await http.get(clientUrl, headers: {
      APIConstant.contentType: APIConstant.applicationJson,
    });
    final res = json.decode(response.body) as Map<String, dynamic>;
    print(res.toString());
    if (response.statusCode == 200) {
      _clientDetail = ClientDetail.fromJson(res);
      notifyListeners();
    } else if (response.statusCode == 401) {
      throw SessionExpire('session expire');
    } else {
      throw CustomError(StringResources.textApiError);
    }

    notifyListeners();
  }

  // used to get data of the all accounts
  Future<void> handleAccountDetail() async {
    try {
      print("handle Account details");
      var response = await Future.wait(_clientDetail.accounts.map((account) =>
          http.get(
              '${APIConstant.baseUrl}/accounts/$account.json?auth=$_idToken')));
      int totalAccount = _clientDetail.accounts.length;
      _accounts.clear();
      for (int i = 0; i < totalAccount; i++) {
        if (response[i].statusCode == 200) {
          print(response[i].body);
          final res = json.decode(response[i].body) as Map<String, dynamic>;
          final data = AccountDetail.fromJson(res, _clientDetail.accounts[i]);
          _accounts.add(data);
        } else if (response[i].statusCode == 401) {
          throw SessionExpire('session expire');
        }
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw CustomError(StringResources.textApiError);
    }
    notifyListeners();
  }

  // getter to get the accounts details
  List<AccountDetail> get getAccounts {
    return _accounts;
  }

  //getter to get the client data
  ClientDetail get getClient {
    return _clientDetail;
  }

  //getter to get _callAPI value
  bool get getCallAPI {
    return _callAPI;
  }

  //setter to set _callAPI
  void setCallAPI(bool value) {
    _callAPI = value;
  }
}
