import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

/* Screen to take amount from user*/
class SendScreen extends StatefulWidget {
  //route Name for this screen
  static String routeName = '/send_screen';

  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  var textFormFieldController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  // variable to enable confirm button
  bool _isButtonDisabled = true;

  @override
  void initState() {
    // initially set value to 0.00
    textFormFieldController.updateValue(0.00);
    super.initState();
  }

  // check input and enable disable button
  _checkInputForConfirm(double amount) {
    if (amount > 0.0) {
      setState(() {
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }
  }

  // function to go back the transaction screen
  _startPayment() {
    Navigator.of(context).pop(textFormFieldController.numberValue);
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Enter amount',
            style:
                TextStyle(fontFamily: "Questrial-Regular", color: Colors.black),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(CommunityMaterialIcons.close_circle,
                  color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop(textFormFieldController.numberValue);
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          'USD ',
                          style: TextStyle(fontFamily: "Questrial-Regular"),
                        ),
                      ),
                      /*    Spacer(flex: 1),*/
                      _amountInputField(),
                    ],
                  ),
                  _confirmButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // field to input amount
  Flexible _amountInputField() {
    return Flexible(
      fit: FlexFit.loose,
      flex: 2,
      child: TextField(
        controller: textFormFieldController,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: true),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(top: 13, start: 25),
            child: Text(
              '\$',
              style: TextStyle(fontSize: 20),
            ),
          ),
          prefixStyle: TextStyle(fontFamily: "Questrial-Regular", fontSize: 25),
          border: InputBorder.none,
        ),
        style: TextStyle(
            fontFamily: "Questrial-Regular", color: Colors.black, fontSize: 50),
        onChanged: (text) {
          _checkInputForConfirm(double.parse(text));
        },
      ),
    );
  }

// Widget building function for confirm button
  SizedBox _confirmButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: FlatButton(
        color: Color.fromRGBO(53, 161, 138, 1),
        textColor: Color.fromRGBO(53, 161, 138, 1),
        disabledColor: Colors.grey,
        child: Text(
          "Confirm",
          style: TextStyle(
              fontFamily: "Questrial-Regular",
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w300),
        ),
        // onPressed: null,
        onPressed: _isButtonDisabled ? null : () => _startPayment(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
