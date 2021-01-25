import 'package:flutter/material.dart';

// this is application bar which is used in multiple screens
Widget applicationAppBar(
    {BuildContext context,
    title = '',
    hasBackIcon = false,
    List<Widget> actions}) {
  return AppBar(
    automaticallyImplyLeading: true,
    actions: actions,
    leading: hasBackIcon
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context, false),
          )
        : SizedBox(),
    title: Text(title,
        style: TextStyle(fontFamily: "Questrial-Regular", color: Colors.black)),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
