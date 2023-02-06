import 'package:flutter/material.dart';
//import 'file:///Users/serviceapp/Desktop/Apps_from_flash/flutter_app_money4/lib/colors.dart' as prefix0;

import 'package:keyboard_actions/keyboard_actions.dart';

import './Restore.dart';
import 'package:paychalet/colors.dart';
//import 'package:paychalet/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paychalet/TextFieldCustom/CustomTextField.dart';
//import '../../../paychalet new2/lib/Home.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'GetCurrentUserFB.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

int _state = 0;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
User user;
final GlobalKey<FormState> _formKeyin = GlobalKey<FormState>();
bool _loading = false;
bool _autoValidate = false;
String errorMsg;

String _email;
String _pass1;

class _SignInState extends State<SignIn> {
  TextEditingController _cont_user = TextEditingController();
  TextEditingController _cont_pass1 = TextEditingController();
  TextEditingController _cont_pass2 = TextEditingController();
//  Color p_color = pcolor;

  FocusNode _nodeuser = FocusNode();
  FocusNode _nodepass1 = FocusNode();
  FocusNode _nodepass2 = FocusNode();
  bool pshow2, pshow1;



  void initState() {
    // TODO: implement initState
    super.initState();




    pshow2 = true;
    pshow1 = true;
    _state = 0;
    _cont_pass1.text = null;

    _cont_user.text = null;
  }
  @override
  Widget build(BuildContext context) {
    final double pheight=MediaQuery.of(context).size.height;
    final double pwidth=MediaQuery.of(context).size.width;
    var appLanguage = Provider.of<AppLanguage>(context);
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
//            ),
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
//          ],
//          child:
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                Align(
                    alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left:10,right:20),
                      child: Text(
                        AppLocalizations.of(context).translate('Sign In'),
                        style: TextStyle(
                            fontSize: pheight/30,
                            fontWeight: FontWeight.bold,
                            color: pcolor2),
                      ),
                    )),
                SizedBox(
                  height: pheight/ 20,
                ),

                Form(
                  key: _formKeyin,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                  p_control:_cont_user,
                        onSaved: (input) {
                          _email = input;
                        },
                        //  validator: emailValidator,
                        icon: Icon(Icons.email),
                        hint: AppLocalizations.of(context).translate('EMAIL'),
                      ),
                      SizedBox(
                        height: pheight / 45,
                      ),
                      CustomTextField(
                        p_control:_cont_pass1,
                        icon: Icon(Icons.lock),
                        obsecure: true,
                        onSaved: (input) => _pass1 = input,
                        validator: (input) => input.isEmpty ? "*Required" : null,
                        hint: AppLocalizations.of(context).translate('PASSWORD'),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 45,
                      ),

                    ],
                  ),
                ),


                /*
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 25),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _nodeuser,
                    controller: _cont_user,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Enter Email?',
                      labelText: 'Email Or User Name ',
                    ),
                    //  obscureText: true,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 45,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 25),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    focusNode: _nodepass1,
                    controller: _cont_pass1,
                    onChanged: (value) {
                      if (value.length >= 6) {
                        setState(() {
                          p_color = Colors.orange[800].withOpacity(0.7);
                        });
                      } else {
                        setState(() {
                          p_color = Colors.grey;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: pcolor,
                        ),
                        onPressed: () {
                          setState(() {
                            pshow1 = !pshow1;
                            print(pshow1);
                          });
                        },
                      ),
                      icon: Icon(Icons.code),
                      hintText: 'Enter Re Password ?',
                      labelText: 'Password',
                    ),
                    obscureText: pshow1,
                  ),
                ),
                 */
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),


                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: pcolor2, //Colors.orange[800].withOpacity(0.7),
                  ),
                   // child :setUpButtonChild(),

                  child: FlatButton(
                    //color: Colors.amber,
                    textColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      print('inside sign in ${_email}');
                      print('inside sign in pass ${_cont_pass1.text}');
                      //add  to sign in without check
           //           Navigator.pushNamed(context, '/Height_Profile2');
                      // Navigator.of(context).pushReplacementNamed('/Home');
                      logInToFb();
                     // _validateLoginInput();

//                      if(_cont_pass2.text != _cont_pass1.text)
//                      {
//                        print('error p1<>p2');
//                      }
//                      print('inside button');
//                      Navigator.of(context).push(
//                        new MaterialPageRoute(
//                          builder: (BuildContext context) => new SignIn(),
//                        ),
//                      );
//                      //  call_func_photo();
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('Sign In'),
                      style: TextStyle(fontSize: pheight/40, color: Colors.white),
                    ),
                  ),

                ),

                Container(
                  height: pheight / 20,
                  width: pwidth / 1.5,
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
                          AppLocalizations.of(context).translate('Forget Your Password'),
                          style: TextStyle(
                              fontSize: pheight/50,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right:8),
                          child: Text( AppLocalizations.of(context).translate('?'),
                          ),
                        ),
                        InkWell(
                          child: Text(
                            AppLocalizations.of(context).translate('Restore'),
                            style: TextStyle(
                                fontSize: pheight/50,
                                fontWeight: FontWeight.w300,
                                color: pcolor2),
                          ),
                          onTap: () {
                            print('inside button');
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new Restore(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 70.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),

                      Text(AppLocalizations.of(context).translate('OR SIGN IN WITH'),style: TextStyle(fontSize: pheight/45),),

                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 70.0),
                            child: Divider(
                              color: Colors.black,
                              height: pheight/50,
                            )),
                      ),
                    ]),

                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          shape: BoxShape.circle,
                          color: Colors.white,
                          //   borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: AssetImage('images/face4.png'),
                              // AssetImage(photos[photoIndex]),
                              fit: BoxFit.contain)),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          shape: BoxShape.circle,
                          color: Colors.white,
                          //   borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: AssetImage('images/google3.png'),
                              // AssetImage(photos[photoIndex]),
                              fit: BoxFit.contain)),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          shape: BoxShape.circle,
                          color: Colors.white,
                          //   borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: AssetImage('images/instagram.jpg'),
                              // AssetImage(photos[photoIndex]),
                              fit: BoxFit.contain)),
                    ),
                  ],
                ),
              ]),
            ),
          ),
    //    ) end key action
    );
  }

  showpass1() {
    setState(() {
      pshow1 = !pshow1;
    });
  }

  void _validateLoginInput() async {
    setState(() {
      _state = 1;
    });
    final FormState form = _formKeyin.currentState;
    if (_formKeyin.currentState.validate()) {
      form.save();
      setState(() {
        _loading = true;
      });
      try {
        print('inside try');
        print(_email);

        User result = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _pass1)) as User;
       // print('result.user=${result.user}');
        user = result;
        print('result.user=${user.email}');
        print('_cont_user.text.toString()${_cont_user.text.toString()}');
      if (user.email == _cont_user.text.toString()) {
        print('ok go to main page');
//
         Navigator.pushNamed(context, '/main_page');
//
//
       }
      }

      catch (error) {
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            {
              setState(() {
                errorMsg =
                    "There is no user with such entries. Please try again.";

                _loading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(errorMsg),
                      ),
                    );
                  });
            }
            break;
          case "ERROR_WRONG_PASSWORD":
            {
              setState(() {
                errorMsg = "Password doesn\'t match your email.";
                _loading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(errorMsg),
                      ),
                    );
                  });
            }
            break;
          default:
            {
              setState(() {
                errorMsg = "";
              });
            }
        }
      }
    } else {
      setState(() {
        show_alert('Message', errorMsg);
        _autoValidate = true;
      });
    }

    setState(() {
      _state = 2;

      //Navigator.pushReplacementNamed('/Home');
      // Navigator.of(context).pushNamed('/Home');

      //Navigator.pushNamed(context, '/Home');
      //Navigator.of(context).pushNamed('/Home');
     // Navigator.of(context).pushReplacementNamed('/Home');
    });
  }

  void logInToFb() {


    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _cont_user.text, password: _cont_pass1.text)
        .then((result) {
      Navigator.pushNamed(context, '/main_page');
//      Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
//      );
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }


  Widget show_alert(String _title, String _mess) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(_title),
          content: new Text(_mess),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
