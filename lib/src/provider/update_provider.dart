import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_banking/src/injector/injector.dart';
import 'package:flutter_banking/src/model/client_detail/client_detail_response.dart';
import 'package:flutter_banking/src/model/dashboard/account_detail.dart';
import 'package:flutter_banking/src/resources/string_resources.dart';
import 'package:flutter_banking/src/service/api_constant.dart';
import 'package:flutter_banking/src/service/custom_error.dart';
import 'package:flutter_banking/src/service/session_expire.dart';
import 'package:flutter_banking/src/storage/preference_manager.dart';
import 'package:http/http.dart' as http;

//This is used to update the transaction
class UpdateProvider extends ChangeNotifier {
  final PreferenceManager preferenceManager = locator<PreferenceManager>();
  String _idToken;
  List<AccountDetail> _accounts = [];
  ClientDetail _clientDetail = ClientDetail(name: '', accounts: [], age: 0);

  void initToken() {
    _idToken = preferenceManager.getString(PreferenceManager.keyAccessToken);
  }

  // this function is used to update the amount
  Future<void> updateAmount(
      String amount, AccountDetail accountDetail, bool isDeposit) async {
    double tempBalance = 0.0;
    double tempOverDraft = 0.0;
    /*Check if the transaction type is deposit*/
    if (isDeposit) {
      tempBalance = accountDetail.balance + double.parse(amount);
      if (accountDetail.overdraft > 0.0) {
        tempOverDraft = accountDetail.overdraft - tempBalance;
        if (tempOverDraft < 0) {
          tempBalance = -tempOverDraft;
          tempOverDraft = 0.0;
        }
      }
    } else {
      tempBalance = accountDetail.balance - double.parse(amount);
      if (tempBalance < 0) {
        tempOverDraft = -tempBalance + accountDetail.overdraft;
        tempBalance = 0;
      } else {
        tempOverDraft = accountDetail.overdraft;
      }
    }
    String url = APIConstant.baseUrl +
        '/accounts/${accountDetail.account}.json?auth=$_idToken';

    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        APIConstant.contentType: APIConstant.applicationJson,
      },
      body: jsonEncode({
        'balance': tempBalance,
        'overdraft': tempOverDraft,
      }),
    );
    print(response.body);
    // handle to response
    if (response.statusCode == 200) {
      final res = json.decode(response.body) as Map<String, dynamic>;
      print(res.toString());
    } else if (response.statusCode == 401) {
      throw SessionExpire('session expire');
    } else {
      throw CustomError(StringResources.textApiError);
    }
  }

  Future<void> handleAccountDetail() async {
    try {
      print("handle Account details");
      var response = await Future.wait(_clientDetail.accounts.map((account) =>
          http.put(
              '${APIConstant.baseUrl}/accounts/$account.json?auth=$_idToken')));
      int totalAccount = _clientDetail.accounts.length;
      _accounts.clear();
      for (int i = 0; i < totalAccount; i++) {
        print("hello");
        if (response[i].statusCode == 200) {
          print(response[i].body);
          final res = json.decode(response[i].body) as Map<String, dynamic>;
          final data = AccountDetail.fromJson(res, _clientDetail.accounts[i]);
          _accounts.add(data);
        }
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw CustomError(StringResources.textApiError);
    }
    notifyListeners();
  }

  List<AccountDetail> get getAccounts {
    return _accounts;
  }

  ClientDetail get getClient {
    return _clientDetail;
  }
}
