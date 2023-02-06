import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle TextStylesmall(double pheight,Color pcolor) {
  TextStyle ts_small = TextStyle(
      color: pcolor,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: pheight / 45);
  return ts_small;
}

TextStyle TextStylemedium(double pheight,Color pcolor) {
  TextStyle ts_meduim = TextStyle(
    color: pcolor,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      fontSize: pheight / 40);
  return ts_meduim;
}


TextStyle TextStylelarg(double pheight,Color pcolor) {
  TextStyle ts_larg = TextStyle(
      color: pcolor,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      fontSize: pheight / 25);
  return ts_larg;
}




final Color primaryColor = Color(0xFFFF9F59);
final Color backgroundColor = Color(0xFFE4E6F1);
final Color firstCircleColor = Colors.white.withOpacity(0.3);
final Color secondCircleColor = Colors.white.withOpacity(0.4);
final Color thirdCircleColor = Colors.white.withOpacity(0.6);


final Color Orange_color = Colors.orange[600].withOpacity(.8);
final Color Orange_color1 = Colors.orange[600].withOpacity(.5);
final Color Orange_color2 = Colors.orange[600].withOpacity(.3);

final Color Red_deep = Colors.redAccent.withOpacity(.9);
final Color Red_deep1 = Colors.redAccent.withOpacity(.6);
final Color Red_deep2 = Colors.redAccent.withOpacity(.3);
final Color Red_deep3 = Colors.redAccent.withOpacity(.05);

Color firstColor = Color(0xFF7A36DC);

Color secondColor= Color(0xFF7A36DC).withOpacity(0.5);

Color thirdColor= Color(0xFF7A36DC).withOpacity(0.2);



Color white0 = Color(0xffdd13).withOpacity(0.2);

final Color yalow0 = Color(0xffdd13).withOpacity(0.9);
final Color yalow1 =Color(0xffdd13).withOpacity(0.2);
Color yalow2 =Color(0xffdd13).withOpacity(0.2);
Color yalow3 =Color(0xffdd13).withOpacity(0.2);
Color yalow4 =Color(0xffdd13).withOpacity(0.2);
Color yalow5 =Color(0xffdd13).withOpacity(0.2);

final Color pcolor1 = Colors.blue[100];//.withOpacity(0.9);
final Color pcolor2 =Colors.blue[200];//.withOpacity(0.2);
final Color pcolor3 =Colors.blue[300];//.withOpacity(0.2);
final Color pcolor4 =Colors.blue[400];//.withOpacity(0.2);
final Color pcolor5 =Colors.blue[600];//.withOpacity(0.2);
final Color pcolor6 =Colors.blue[700];//.withOpacity(0.2);




int getColorHexFromStr(String colorStr) {
  colorStr = "FF" + colorStr;
  colorStr = colorStr.replaceAll("#", "");
  int val = 0;
  int len = colorStr.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = colorStr.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("An error occurred when converting a color");
    }
  }
  return val;
}

final appTheme = ThemeData(
  primarySwatch: Colors.blue,

);