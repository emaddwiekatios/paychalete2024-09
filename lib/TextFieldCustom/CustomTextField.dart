import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
        this.hint,
        this.obsecure = false,
        this.validator,
        this.onSaved,this.p_control});
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final TextEditingController p_control;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    final double pheight=MediaQuery.of(context).size.height;
    final double pwidth=MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: 10, right: 20),
      child: TextFormField(
        controller: p_control,
        onSaved: onSaved,
        validator: validator,
        autofocus: true,
        obscureText: obsecure,
        style: TextStyle(
          fontSize: pheight/45,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: pheight/45),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: pcolor1,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
      ),
    );
  }
}

Widget filledButton(String text, Color splashColor, Color highlightColor,
    Color fillColor, Color textColor, void function(),BuildContext context) {
  final double pheight=MediaQuery.of(context).size.height;
  final double pwidth=MediaQuery.of(context).size.width;
  return RaisedButton(
    highlightElevation: 0.0,
    splashColor: splashColor,
    highlightColor: highlightColor,
    elevation: 0.0,
    color: fillColor,
    shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0)),
    child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, color: textColor, fontSize: pheight/45),
    ),
    onPressed: () {
      function();
    },
  );
}

