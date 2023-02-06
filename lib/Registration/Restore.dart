import 'package:flutter/material.dart';
import  'package:keyboard_actions/keyboard_actions.dart';

import 'package:paychalet/colors.dart';


class Restore extends StatefulWidget {
  @override
  _RestoreState createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {


  TextEditingController _cont_user = TextEditingController();
  TextEditingController _cont_pass1 = TextEditingController();
  TextEditingController _cont_pass2 = TextEditingController();
  Color p_color=Colors.grey.withOpacity(0.5);

  FocusNode _nodeuser = FocusNode();
  FocusNode _nodepass1 = FocusNode();
  FocusNode _nodepass2 = FocusNode();
  bool pshow2,pshow1;

  void initState() {
    // TODO: implement initState
    super.initState();
    pshow2 =true ;
    pshow1=true;
  }
  @override

  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body:
//        FormKeyboardActions(
//          keyboardActionsPlatform: KeyboardActionsPlatform.ALL, //optional
//          keyboardBarColor: Colors.grey[200], //optional
//          nextFocus: true, //optional
//          actions: [
//            KeyboardAction(
//              focusNode: _nodeuser,
//              displayCloseWidget: true,
//
//            ),
//
//
//            KeyboardAction(
//              displayCloseWidget: true,
//              focusNode: _nodepass1,
//              closeWidget: Padding(
//                padding: EdgeInsets.all(8.0),
//                child: Icon(Icons.close),
//              ),
//            ),
//            KeyboardAction(
//              displayCloseWidget: true,
//              focusNode: _nodepass2,
//              closeWidget: Padding(
//                padding: EdgeInsets.all(5.0),
//                child: Text("CLOSE"),
//              ),
//            ),
//
//          ],
//          child:
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                  Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Restore Your Password By Email',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Orange_color),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 45,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 25),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _nodeuser,
                    controller: _cont_user,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Enter Email?',
                      labelText: 'Email Address ',
                    ),
                    //  obscureText: true,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),


                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(50),
                    color: p_color,//Colors.orange[800].withOpacity(0.7),
                  ),
                  child: FlatButton(
                    //color: Colors.amber,
                    textColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      if(_cont_pass2.text != _cont_pass1.text)
                      {
                        print('error p1<>p2');
                      }
                      print('inside button');
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new Restore(),
                        ),
                      );
                      //  call_func_photo();
                    },
                    child: Text(
                      "Restore Your Password",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: FlatButton(
                    //color: Colors.amber,
                    textColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      // Navigator.pushNamed(context, '/main_page');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Will send New Password to Email ?",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        Text(
                          " Login",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Orange_color),
                        ),
                      ],
                    ),
                  ),
                ),


              ]),
            ),
          ),
    //    ) end key action
    );
  }



  showpass1() {
    setState(() {
      pshow1=!pshow1;
    });
  }
}
