import 'package:flutter/material.dart';
import 'package:flutter_banking/src/injector/injector.dart';
import 'package:flutter_banking/src/model/dashboard/account_detail.dart';
import 'package:flutter_banking/src/provider/dashboard_provider.dart';
import 'package:flutter_banking/src/resources/string_resources.dart';
import 'package:flutter_banking/src/service/session_expire.dart';
import 'package:flutter_banking/src/storage/preference_manager.dart';
import 'package:flutter_banking/src/utility/util.dart';
import 'package:flutter_banking/src/view/screen/login/login_screen.dart';
import 'package:flutter_banking/src/view/widget/app_bar.dart';
import 'package:flutter_banking/src/view/widget/session_expire_dialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../transaction/deposit_withdraw_screen.dart';
import 'opennewaccount.dart';

/* This is the dashboard screen, which can the list of all the account of user*/
class DashboardScreen extends StatefulWidget {
  static String routeName = '/dashboard';

  @override
  State<StatefulWidget> createState() {
    return new _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  // This is used to show the loader while waiting for api response
  bool isLoading = false;

  //This is used to check if api called is made or not
  bool callApi = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // call api if it is not yet called.
    if (callApi) {
      callDashBoardAPI();
      callApi = false;
    }
  }

  /*
  This is called the api and handle the api response
  * */
  void callDashBoardAPI() async {
    setState(() {
      isLoading = true;
      callApi = false;
    });
    try {
      Provider.of<DashboardProvider>(context, listen: false).initToken();
      Provider.of<DashboardProvider>(context, listen: false).setCallAPI(false);
      await Provider.of<DashboardProvider>(context, listen: false).callAPI();
      setState(() {
        isLoading = false;
      });
    } on SessionExpire {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SessionExpireDialog(),
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Util.showToastMessage(message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    // used to check if  it is refresh
    final refreshData = provider.getCallAPI;
    final accountList = provider.getAccounts;
    final client = provider.getClient;
    if (!isLoading && callApi == false && refreshData) {
      callDashBoardAPI();
    }
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.white,
      floatingActionButton: SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      //visible: _dialVisible,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor:Colors.blue[900],
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: IconButton(
              icon: Icon(
                Icons.add_business,
                color: Colors.white,
                size: 18,
              )),
          backgroundColor: Colors.blue[700],
          label: StringResources.textOpenAccount,
          labelStyle:
          TextStyle(fontSize: 14.0, fontFamily: "Questrial-Regular"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OpenNewAccount ()));
          },
        ),
      ],
    ),
            appBar: applicationAppBar(
              context: context,
              actions: [
                IconButton(
                    icon: Icon(Icons.refresh, color: Colors.black),
                    onPressed: callDashBoardAPI),
                IconButton(
                    icon: Icon(
                      Icons.power_settings_new_sharp,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      final PreferenceManager preferenceManager =
                          locator<PreferenceManager>();
                      preferenceManager.clearAll();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.routeName, (route) => false);
                    })
              ],
              title: StringResources.textDashBoard,
              hasBackIcon: false,
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                Container(
                  child: Text(
                    "Hi, ${client.name}",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: accountList.length,
                  itemBuilder: (context, index) => listItem(accountList[index]),
                ))
              ],
            )),
        isLoading
            ? Container(
                color: Colors.black38,
                child: Center(
                  child: Container(child: CircularProgressIndicator()),
                ),
              )
            : const SizedBox()
      ],
    );
  }

/*item list for accounts*/
  Widget listItem(AccountDetail account) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color(0xFFE8F8F5),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              textWithIcon('${account.account}', Icons.account_balance),
              textBalance(account.balance),
              textOverDraft(account.overdraft),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, DepositWithdrawScreen.routeName,
                          arguments: [account, true]);
                    },
                    child: Text(StringResources.textDeposit),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, DepositWithdrawScreen.routeName,
                          arguments: [account, false]);
                    },
                    child: Text(StringResources.textWithdraw),
                  )
                ],
              )
            ],
          ),
        ));
  }

//text with icon
  Widget textWithIcon(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1.copyWith(),
        ),
      ],
    );
  }

// text with balance label
  Widget textBalance(double balance) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            StringResources.textBalance,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: Colors.green[900]),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Text(
            '\$${balance.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
      ],
    );
  }

//text with overdraft label
  Widget textOverDraft(double overDraft) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            StringResources.textOverDraft,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: Colors.red),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Text(
            '\$${overDraft.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
