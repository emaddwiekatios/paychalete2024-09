import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:paychalet/colors.dart';
import  'package:keyboard_actions/keyboard_actions.dart';


class KeyBoardDone extends StatefulWidget {
  @override
  _KeyBoardDoneState createState() => _KeyBoardDoneState();
}

class _KeyBoardDoneState extends State<KeyBoardDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 500*1.5,color:Colors.red),
            TextField()
          ],
        ),
      )
    );
  }
}
