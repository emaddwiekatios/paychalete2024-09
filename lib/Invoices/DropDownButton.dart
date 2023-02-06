import 'package:flutter/material.dart';

class DropDownButtonString extends StatefulWidget {
  String  messg='2';
  var users = <String>[
    'Bob',
    'Allie',
    'Jason',
  ];
  Function(String) onDropDownChange;
  DropDownButtonString(this.users,this.messg,this.onDropDownChange);
  @override
  _DropDownButtonStringState createState() => _DropDownButtonStringState();
}

class _DropDownButtonStringState extends State<DropDownButtonString> {


  int _user;



  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(


      elevation: 0,
      hint: new Text('${widget.messg}'),
      value: _user == null ? null : widget.users[_user],
      items:  widget.users.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _user =  widget.users.indexOf(value);
          widget.onDropDownChange(value.toString());
        });



      },

        underline: Container(
          height: 1.0,
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))
          ),
        ),
    );
  }
}




///////number


class DropDownButtonNumber extends StatefulWidget {
  String  messg='2';
  var users = <int>[
    1,2
  ];
  DropDownButtonNumber(this.users,this.messg);
  @override
  _DropDownButtonNumberState createState() => _DropDownButtonNumberState();
}

class _DropDownButtonNumberState extends State<DropDownButtonNumber> {


  int _user;



  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      hint: new Text('${widget.messg}'),
      value: _user == null ? null : widget.users[_user],
      items:  widget.users.map((int value) {
        return new DropdownMenuItem<int>(
          value: value,
          child: Center(child: new Text(value.toString())),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _user =  widget.users.indexOf(value);
        });
      },
    );
  }
}
