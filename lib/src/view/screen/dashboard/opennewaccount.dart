import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';


class OpenNewAccount extends StatefulWidget {
  @override
  _OpenNewAccountState createState() => _OpenNewAccountState();
}

class _OpenNewAccountState extends State<OpenNewAccount>
     {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        width: 150,
        child: Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
                title: Text('Open new Account',
                    style: TextStyle(
                        fontFamily: "Questrial-Regular", color: Colors.black)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
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
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'John Walker',
                        style: TextStyle(
                            fontFamily: "Questrial-Regular",
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),

                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    decoration: const InputDecoration(hintText: "Enter Account Number"),
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    decoration: const InputDecoration(hintText: "Enter Initial Amount "),
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    decoration: const InputDecoration(hintText: "Enter First Name "),
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    decoration: const InputDecoration(hintText: "Enter Last Name "),
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                new Flexible(
                                  child: new TextField(
                                    decoration: const InputDecoration(hintText: "Enter Email ID"),
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ),

                                  ],

                            ),
                            SizedBox(height: 10),

                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(hintText: "Enter Mobile Number"),
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                  ),

                                ],
                              ),

                            SizedBox(height: 10),
                            SizedBox(height: 30),


                                RaisedButton(
                                  color: Color.fromRGBO(53, 161, 138, 1),
                                  textColor: Color.fromRGBO(53, 161, 138, 1),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontFamily: "Questrial-Regular",
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300),
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
