import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_banking/src/injector/injector.dart';
import 'package:flutter_banking/src/model/dashboard/account_detail.dart';
import 'package:flutter_banking/src/provider/dashboard_provider.dart';
import 'package:flutter_banking/src/provider/update_provider.dart';
import 'package:flutter_banking/src/resources/string_resources.dart';
import 'package:flutter_banking/src/service/session_expire.dart';
import 'package:flutter_banking/src/storage/preference_manager.dart';
import 'package:flutter_banking/src/view/widget/app_bar.dart';
import 'package:flutter_banking/src/view/widget/session_expire_dialog.dart';
import 'package:provider/provider.dart';

import 'send_screen.dart';

// This screen is user for withdrawing and depositing money in account
class DepositWithdrawScreen extends StatelessWidget {
  static String routeName = '/deposit_withdraw_screen';

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context).settings.arguments as List;
    final accountDetail = argument[0] as AccountDetail;
    final isDeposit = argument[1] as bool;
    return ChangeNotifierProvider(
      create: (context) => UpdateProvider(),
      builder: (context, child) => DepositWithdraw(accountDetail, isDeposit),
    );
  }
}

class DepositWithdraw extends StatefulWidget {
  final AccountDetail accountDetail;
  final bool isDeposit;

  DepositWithdraw(this.accountDetail, this.isDeposit);

  @override
  _DepositWithdrawState createState() => _DepositWithdrawState();
}

class _DepositWithdrawState extends State<DepositWithdraw>
    with SingleTickerProviderStateMixin {
  // amount to deposit or withdraw
  String _amountValue = '0.00';

  bool _showAddNote = false;
  bool showPageLoader = false;
  bool _showSpinner = false;
  bool _showChecked = false;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    animationController.addListener(() {
      if (animationController.status.toString() ==
          'AnimationStatus.completed') {
        setState(() {
          _showSpinner = false;
          _showChecked = true;
        });
        Timer(
          Duration(seconds: 1),
          () => setState(() {
            showPageLoader = false;
            Navigator.of(context).pop();
          }),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // this  calls the api api
  _startPayment(String amount) async {
    try {
      print("call updateAmount Api");
      Provider.of<UpdateProvider>(context, listen: false).initToken();
      await Provider.of<UpdateProvider>(context, listen: false)
          .updateAmount(amount, widget.accountDetail, widget.isDeposit);
      Provider.of<DashboardProvider>(context, listen: false).setCallAPI(true);
    } on SessionExpire {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SessionExpireDialog(),
      );
    } catch (error) {
      print(error);
      setState(() {});
    }
    setState(() {
      showPageLoader = true;

      _showSpinner = true;
      animationController.forward();
    });
  }

  // this is the loading while waiting for api response
  Widget _showPageLoader() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 10,
              sigmaX: 10,
            ),
            child: Container(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        _showSpinner
            ? Align(
                alignment: Alignment.center,
              )
            : Container(),
        _showSpinner
            ? Align(
                alignment: Alignment.center,
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 2.0).animate(animationController),
                  child: Image.asset('assets/images/loading.png'),
                ),
              )
            : Container(),
        _showChecked
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*Image.asset('assets/images/checked.png'),*/
                    SizedBox(height: 20),
                    Material(
                      child: Text(
                        'Transaction Successful',
                        style: TextStyle(
                            fontFamily: "Questrial-Regular",
                            fontSize: 17,
                            color: Colors.green),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final PreferenceManager preferenceManager = locator<PreferenceManager>();
    final email = preferenceManager.getString(PreferenceManager.keyEmail);
    final client = provider.getClient;

    return Container(
      width: 150,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            appBar: applicationAppBar(
                title: widget.isDeposit ? 'Deposit Money' : 'Withdraw Money',
                hasBackIcon: true,
                actions: [],
                context: context),
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '${client.name}',
                      style: TextStyle(
                          fontFamily: "Questrial-Regular",
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: 25,
                      child: FlatButton(
                        color: Color.fromRGBO(53, 161, 138, 1),
                        textColor: Colors.white,
                        child: Text(
                          "${email}",
                          style: TextStyle(
                              fontFamily: "Questrial-Regular",
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          textAmount(widget.accountDetail.balance,
                              StringResources.textBalance),
                          textAmount(widget.accountDetail.overdraft,
                              StringResources.textOverDraft),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Amount',
                                style: TextStyle(
                                    fontFamily: "Questrial-Regular",
                                    fontSize: 17),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'USD',
                                    style: TextStyle(
                                        fontFamily: "Questrial-Regular",
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(width: 5),
                                  InkWell(
                                    child: Text(
                                      this._amountValue,
                                      style: TextStyle(
                                          fontFamily: "Questrial-Regular",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onTap: () async {
                                      var navigationResult =
                                          await Navigator.pushNamed(
                                              context, SendScreen.routeName);
                                      setState(() {
                                        this._amountValue =
                                            navigationResult.toString();
                                        if (navigationResult.toString() !=
                                            '0.0') {
                                          this._showAddNote = true;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(height: 0.1, color: Colors.grey),
                          const SizedBox(height: 30),
                          _buildAccountNumber(),
                          const SizedBox(height: 30),
                          Opacity(
                            opacity: this._showAddNote ? 1.0 : 0.0,
                            child: Divider(height: 0.1, color: Colors.grey),
                          ),
                          SizedBox(height: 30),
                          _buildTransactionButton(context),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          showPageLoader ? _showPageLoader() : Container(),
        ],
      ),
    );
  }

  // widget to show the account number
  Row _buildAccountNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Account Number',
              style: TextStyle(
                  fontFamily: "Questrial-Regular",
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              '${widget.accountDetail.account}',
              style: TextStyle(
                  fontFamily: "Questrial-Regular",
                  fontSize: 14,
                  color: Colors.grey),
            ),
          ],
        ),
        Spacer(flex: 5),
        /* Icon(Icons.chevron_right,
                                color: Colors.grey, size: 40),*/
      ],
    );
  }

  //This is the button for transaction
  Opacity _buildTransactionButton(BuildContext context) {
    return Opacity(
      // opacity: 1.0,
      opacity: this._showAddNote ? 1.0 : 0.0,
      child: this._showAddNote
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: FlatButton(
                color: Color.fromRGBO(53, 161, 138, 1),
                textColor: Color.fromRGBO(53, 161, 138, 1),
                disabledColor: Colors.grey,
                child: Text(
                  widget.isDeposit ? "Deposit Now" : "Withdraw Now",
                  style: TextStyle(
                      fontFamily: "Questrial-Regular",
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w300),
                ),
                onPressed: () => _startPayment(
                  this._amountValue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            )
          : SizedBox(),
    );
  }

  //This is widget build function for amounts
  Widget textAmount(double amount, String text) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: Colors.black),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            '\$${amount.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
