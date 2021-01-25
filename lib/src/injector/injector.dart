import 'package:flutter_banking/src/provider/auth_provider.dart';
import 'package:flutter_banking/src/storage/preference_manager.dart';

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
//This is used to get the preferenceManage from any where in code
Future setupLocator() async {
  PreferenceManager sharedPreferencesManager =
      await PreferenceManager.getInstance();
  locator.registerSingleton<PreferenceManager>(sharedPreferencesManager);
}
