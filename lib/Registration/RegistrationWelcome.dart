import 'package:flutter/material.dart';
import 'package:paychalet/Registration/SignIn.dart';
import 'package:paychalet/colors.dart';
import './SignUp.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:paychalet/Products/ProductsMain.dart';

class RegistrationWelcome extends StatefulWidget {
  @override
  _RegistrationWelcomeState createState() => _RegistrationWelcomeState();
}

class _RegistrationWelcomeState extends State<RegistrationWelcome> {
  String Username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });


//    getUser().then((user) {
//      print('user==$user');
//    });
  }
  @override
  Widget build(BuildContext context) {



    final double pheight=MediaQuery.of(context).size.height;
    final double pwidth=MediaQuery.of(context).size.width;
    var appLanguage = Provider.of<AppLanguage>(context);

    print(pheight);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(

            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              height: pheight /2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage('images/registration.png'),
                      // AssetImage(photos[photoIndex]),
                      fit: BoxFit.contain)),
            ),
          ),
          SizedBox(height: pheight/45,),
        //  AppLocalizations.of(context).translate('Sciences articles');
         Text( AppLocalizations.of(context).translate('RIGISTR WITH BY'),
           style: TextStyle(fontSize: pheight/45),),
         // Text('RIGISTR WITH BY',style: TextStyle(fontSize: pheight/45),),

          SizedBox(height: pheight/45,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: pwidth / 4,
                height: pheight / 12,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12,width: 1),
                  shape: BoxShape.circle,
                  color: Colors.white,
                 //   borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: AssetImage('images/face4.png'),
                        // AssetImage(photos[photoIndex]),
                        fit: BoxFit.contain)),
              ),
              Container(
                width: pwidth / 4,
                height: pheight / 12,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12,width: 1),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    //   borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: AssetImage('images/google3.png'),
                        // AssetImage(photos[photoIndex]),
                        fit: BoxFit.contain)),
              ),
              Container(
                width: pwidth / 4,
                height: pheight / 12,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12,width: 1),
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
          SizedBox(height: pheight/40,),
          //Text('---- OR ----'),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 10.0),
                  child: Divider(
                    color: Colors.black,
                    height: 50,
                  )),
            ),

            Text(AppLocalizations.of(context).translate('OR'),
              style: TextStyle(fontSize: pheight/45),),

            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 100.0),
                  child: Divider(
                    color: Colors.black,
                    height: 50,
                  )),
            ),
          ]),
          SizedBox(height: pheight/10,),
          Column(
            children: <Widget>[
              Container(
                height: pheight / 18,
                width: pwidth / 1.5 ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Red_deep1,
                ),
                child: FlatButton(
                  //color: Colors.amber,
                  textColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Red_deep,
                  onPressed: () {
                    print('inside button');
                    Navigator.pushNamed(context, '/SignUp');
//                    Navigator.of(context).push(new MaterialPageRoute(
//                      builder: (BuildContext context) => new SignUp(),
//                    ),
//                    );
                  //  call_func_photo();
                  },
                  child: Text(  AppLocalizations.of(context).translate('EMAIL REGISTRATION'),
                    style: TextStyle(fontSize: pheight/45,color: Colors.white),
                   // style: TextStyle(fontSize: 20.0,color: Colors.white),
                  ),

                ),
              ),
              Container(
                height: pheight / 16,
                width: pwidth / 1.2 ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: FlatButton(
                  //color: Colors.amber,
                  textColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Red_deep1,
                  onPressed: () {
                    Navigator.pushNamed(context, '/SignIn');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[ 
                       Text(AppLocalizations.of(context).translate('Already Have An account'),
                     style: TextStyle(fontSize: pheight/45,fontWeight: FontWeight.w200),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8),
                        child: Text(AppLocalizations.of(context).translate('?')
                          ),
                      ),
                      InkWell(
                        child: Text(
                      AppLocalizations.of(context).translate('SIGN IN'),
                          style: TextStyle(fontSize: pheight/45,fontWeight: FontWeight.w300,color: Red_deep1),
                        ),
                        onTap: (){
                          print('inside button2');
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User user) {
                            if (user == null) {
                              print('User is currently signed out!');
                              //Navigator.pushNamed(context, '/ProductsMain');
                              Navigator.pushReplacementNamed(context, '/SignIn');
                            } else {
                              print('User is signed in!');
                              Navigator.pushNamed(context, '/main_page');
                            }
                          });
//                          getUser().then((user) {
//                            print(user);
//                            if (user != null) {
//                              print('inside if the user login ');
//                              Navigator.pushNamed(context, '/ProductsMain');
//                              setState(() {
//                                Username=user;
//
//                              });
//                            }
//                            else
//                              Navigator.pushReplacementNamed(context, '/SignIn');
//                            //  Navigator.pushNamed(context, '/SignIn');
//                          });


                        },
                      ), 
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    print('the user${_auth.currentUser.email}');
    return await _auth.currentUser.email.toString();
  }
}
