import 'package:flutter/material.dart';
import  'package:keyboard_actions/keyboard_actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paychalet/TextFieldCustom/CustomTextField.dart';
import 'package:paychalet/colors.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';



class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _loading=false; 
bool _autoValidate = false;
String errorMsg;
class _SignUpState extends State<SignUp> {


  TextEditingController _cont_user = TextEditingController();
  TextEditingController _cont_pass1 = TextEditingController();
  TextEditingController _cont_pass2 = TextEditingController();
  String _email;
  String _pass1;
  String _pass2;
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
    var appLanguage = Provider.of<AppLanguage>(context);
    final double pheight=MediaQuery.of(context).size.height;
    final double pwidth=MediaQuery.of(context).size.width;
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
                    alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left:10,right:20),
                      child: Text(
                        AppLocalizations.of(context).translate('Sign Up'),
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: pcolor1),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 45,
                ),

                Form(
                  key: _formKey,
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
                        height: MediaQuery.of(context).size.height / 45,
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
                      CustomTextField(
                        p_control:_cont_pass2,
                        icon: Icon(Icons.lock),
                        obsecure: true,
                        onSaved: (input) => _pass2 = input,
                        validator: (input) => input.isEmpty ? "*Re-Required" : null,
                        hint: AppLocalizations.of(context).translate('RE-PASSWORD'),
                      ),
                    ],
                  ),
                ),
              //  filledButton('LOGIN', Colors.white,    Colors.orange, Colors.orange, Colors.white, _validateLoginInput),

               // filledButton("REGISTER", Colors.white, Colors.orange, Colors.orange, Colors.white, _validateRegisterInput)

                ///  old textfield
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
                   onChanged: (value){

                     if(value.length>=6 )
                     {
                       setState(() {
                         p_color=Colors.orange[800].withOpacity(0.7);
                       });
                     }
                     else
                     {

                         setState(() {
                           p_color=Colors.grey;
                         });

                     }
                   },
                    decoration:  InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye,color: paychalet,),
                          onPressed:(){
                            setState(() {
                              pshow1=!pshow1;
                              print(pshow1);
                            });
                          },

                        ),
                      icon: Icon(Icons.code),
                      hintText: 'Enter Re Password ?',
                      labelText: 'Password',
                    ),
                  obscureText:   pshow1 ,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 45,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 25),
                  child: TextField(

                    keyboardType: TextInputType.text,
                    focusNode: _nodepass2,
                    decoration:  InputDecoration(

                       suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye,color: paychalet,),
                         onPressed:(){
                          setState(() {
                            pshow2=!pshow2;
                            print(pshow2);
                          });
                         },

                      )
                      ,
                      icon: Icon(Icons.redo),
                      hintText: 'Enter Re Password ?',
                      labelText: 'Re Password',
                    ),
                    onChanged: (value){

                      if(value.length>=6 )
                      {
                        setState(() {
                          p_color=Colors.orange[800].withOpacity(0.7);
                        });
                      }
                      else
                      {

                        setState(() {
                          p_color=Colors.grey;
                        });

                      }
                    },
                    obscureText: pshow2  ,
                  ),
                ),
                */
                ///////oldtextfield
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 16,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.circular(50),
                    color: pcolor2,//Colors.orange[800].withOpacity(0.7),
                  ),
                  child: FlatButton(
                    //color: paychalet,
                    textColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                     onPressed: () {
                      print('inside sign up');
                       if (!(_pass1 == _pass2)) {
                         show_alert(
                             "Login Message", "Passord Not Match");
                       }

                       else {
                         _validateRegisterInput();

                       }
                     },


                    child: Text(
                      AppLocalizations.of(context).translate('Sign Up'),
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
                          AppLocalizations.of(context).translate('I agree to the'),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        Text(
                          AppLocalizations.of(context).translate('terms and Privacy policy'),
                          style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: pcolor1),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    print('inside sign in button');
                    Navigator.of(context).pushReplacementNamed('/SignIn');
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('Sign In'),
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: pcolor3),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                //AppLocalizations.of(context).translate('
             /*   Text(
                  "---- OR SIGN UP With ----",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
                */
                Row(children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 70.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 50,
                        )),
                  ),

                  Text(AppLocalizations.of(context).translate('OR SIGN UP WITH'),style: TextStyle(fontSize: pheight/45),),

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
      pshow1=!pshow1;
    });
  }
  Future<String> createUser(String email, String password) async {
  //  User user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    //await _firebaseAuth.createUserWithEmailAndPassword(
      //  email: email, password: password);
    //return user.uid;
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


  void _validateRegisterInput() async {
    final FormState form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      form.save();
      setState(() {
        _loading = true;
      });
      try {
        print('inside try');
        User result = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _email, password: _pass1)) as User ;
        print(result);
        User user = result;
       // UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        //userUpdateInfo.displayName = user.displayName;
        user.updateProfile().then((onValue) {
          show_alert('Registration', 'The New User Create Succeessfuly :${user.email}');
          //Navigator.of(context).pushReplacementNamed('/SignIn');
          //add user to Firestore data base
          /*
          FirebaseFirestore.instance.collection('users').doc().setData(
              {'email': _email, 'displayName': user.displayName}).then((onValue) {
            setState(() {
              _loading = false;
            });
          });
          */
        });
      } catch (error) {
//        print(error.toString());
//        show_alert('error', error.toString());
//
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              setState(() {
                errorMsg = "This email is already in use.";
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
          case "ERROR_WEAK_PASSWORD":
            {
              setState(() {
                errorMsg = "The password must be 6 characters long or more.";
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
        _autoValidate = true;
      });
    }
  }
}

