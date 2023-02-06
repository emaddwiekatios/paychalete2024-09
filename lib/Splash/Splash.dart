import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Splash extends StatefulWidget {
  final AppLanguage appLanguage;

  Splash({this.appLanguage});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  int photoIndex = 0;

  List<String> photos = [
    'images/splash1.png',
    'images/splash4.png',
    'images/splash3.png',
  ];
  var lang='E';
  String Textmsg1 = 'Lots Of Nutritional';
  String Textmsg2 = 'Sciences articles';
  //photos.add(widget.prod_img);
  void _previousImage() {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0;
      if (photoIndex == 0) {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Lots Of Nutritional');
          Textmsg2 = AppLocalizations.of(context).translate('Sciences articles');

        });
        } else if (photoIndex == 1) {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Useful recipes for');
          Textmsg2 = AppLocalizations.of(context).translate('every day');

        });
        } else {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Conveniently track your');
          Textmsg2 = AppLocalizations.of(context).translate('achievements');


        });
       }
    });


  }

   void _nextImage() {
    setState(() {
      photoIndex = photoIndex < photos.length - 1 ? photoIndex + 1 : photoIndex;
      if (photoIndex == 0) {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Lots Of Nutritional');
          Textmsg2 = AppLocalizations.of(context).translate('Sciences articles');

        });
      } else if (photoIndex == 1) {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Useful recipes for');
          Textmsg2 = AppLocalizations.of(context).translate('every day');

        });
      } else {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Conveniently track your');
          Textmsg2 = AppLocalizations.of(context).translate('achievements');


        });
      }
    });
  }


  void _change_splash_text() {

    setState(() {
       if (photoIndex == 0) {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Lots Of Nutritional');
          Textmsg2 = AppLocalizations.of(context).translate('Sciences articles');

        });
      } else if (photoIndex == 1) {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Useful recipes for');
          Textmsg2 = AppLocalizations.of(context).translate('every day');

        });
      } else {
        setState(() {
          Textmsg1 = AppLocalizations.of(context).translate('Conveniently track your');
          Textmsg2 = AppLocalizations.of(context).translate('achievements');

        });
      }
    });


  }
  void call_func_photo() {
    int len = photos.length;
    if (photoIndex < (len - 1)) {
      // print("the photoIndex =${photoIndex}");
      // print("the len == ${len -1}");
      _nextImage();
    } else if (photoIndex == (len - 1)) {
      //print("the photoIndex else = ${photoIndex}");
      //print("the len ==${len -1}");
      Navigator.pushNamed(context, '/RegistrationWelcome');

      //setState(() {
      //  photoIndex = 0;
      //});
      // _nextImage();

    }
  }


  @override
  Widget build(BuildContext context) {

    double pheight = MediaQuery.of(context).size.height;
    double pwidth = MediaQuery.of(context).size.width;
    var appLanguage = Provider.of<AppLanguage>(context);

        Textmsg1 = AppLocalizations.of(context).translate('Lots Of Nutritional');
     Textmsg2 = AppLocalizations.of(context).translate('Sciences articles');

    _change_splash_text();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 4, //275.0,
                decoration: BoxDecoration(),
              ),
              Positioned(
                  top: pwidth/5,
                  right:MediaQuery.of(context).size.width/18,
                  left: MediaQuery.of(context).size.width/18,//MediaQuery.of(context).size.width / 2 -
                    //  (MediaQuery.of(context).size.width / 3 ),
                  child:  Container(
                      height: pwidth/10,
                    width: pwidth/1.5,
                      //color: Colors.red,
                      child: Center(
                        child:
                        Row(
                          children: [
                        Text(AppLocalizations.of(context).translate('title'),
                              style: TextStyle(
                                    color: Colors.black,
                                    fontSize: pheight / 25,
                                    fontWeight: FontWeight.w600)),
                            Text(AppLocalizations.of(context).translate('Chalet'),
                                style: TextStyle(
                                    color: Red_deep,
                                    fontSize: pheight / 25,
                                    fontWeight: FontWeight.w600)),
                                  ],
                        ),
                      ),
                    ),
                  ),
//              Positioned(
//                  top: pwidth/4.5,
//                  left: MediaQuery.of(context).size.width / 2 -
//                      (MediaQuery.of(context).size.width / 4 / 2),
//                  child: Container(
//                    height: pwidth/10,
//                    width: pwidth/4,
//                    //color: Colors.red,
//                    child: Center(
//                      child: Text(AppLocalizations.of(context).translate('Healthy'),
//                          style: TextStyle(
//                              color: pcolor3,
//                              fontSize: pheight / 25,
//                              fontWeight: FontWeight.w600)),
//                    ),
//                  )),
              Positioned(
                  top: 30.0,
                  left: 10,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width / 6,
                    decoration: BoxDecoration(
                      shape:BoxShape.circle,
                      //borderRadius: BorderRadius.circular(150),
                      color: Red_deep1,
                    ),
                    child: FlatButton(
                      //color: Colors.amber,
                      textColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Red_deep2,
                      onPressed: () {
                        print('inside button');
                        if (lang=='E') {
                          setState(() {
                            appLanguage.changeLanguage(Locale("en"));
                            lang='A';
                          });
                        }
                        else
                          {
                            setState(() {
                              appLanguage.changeLanguage(Locale("ar"));
                              lang='E';
                            });
                          }
                       // print(appLanguage.appLocal);
                        // call_func_photo();
                      },
                      child: Text(
                        '$lang',
                        style: TextStyle(
                            fontSize: pheight / 40.0, color: Colors.white),
                      ),
                    ),
                  )),
//              Positioned(
//                  top: 30.0,
//                  right: 10,
//                  child: Container(
//                    height: MediaQuery.of(context).size.height / 18,
//                    width: MediaQuery.of(context).size.width / 6,
//                    decoration: BoxDecoration(
//                      shape:BoxShape.circle,
//                     // borderRadius: BorderRadius.circular(150),
//                      color: pcolor3,
//                    ),
//                    child: FlatButton(
//                      //color: Colors.amber,
//                      textColor: Colors.black,
//                      padding: EdgeInsets.all(8.0),
//                      splashColor: pcolor1,
//                      onPressed: () {
//                        print('inside button');
//                        setState(() {
//                          appLanguage.changeLanguage(Locale("ar"));
//
//                        });
//
//                        //print(appLanguage.appLocal);
//                        // call_func_photo();
//                      },
//                      child: Text(
//                        "A",
//                        style: TextStyle(
//                            fontSize: pheight / 40.0, color: Colors.white),
//                      ),
//                    ),
//                  )),
            ],
          ),

          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height / 1.2), //275.0,
                decoration: BoxDecoration(),
              ),

              //images

              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10, bottom: 10.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(photos[photoIndex]),
                              // AssetImage(photos[photoIndex]),
                              fit: BoxFit.contain)),
                    ),
                    GestureDetector(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                      ),
                      onTap: _nextImage,
                    ),
                    GestureDetector(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.transparent,
                      ),
                      onTap: _previousImage,
                    ),
                  ],
                ),
              ),
              //next
              GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,

                  ///3.5,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                onTap: _nextImage,
              ),
              //prevous
              GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,

                  ///3.5,
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.transparent,
                ),
                onTap: _previousImage,
              ),

//dots
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 8,
            child: Center(
                child: Column(
              children: <Widget>[
                Text(Textmsg1,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: pheight / 35,
                        fontWeight: FontWeight.w400)),
                Text(Textmsg2,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: pheight / 35,
                        fontWeight: FontWeight.w400)),

              ],
            )),
          ),
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 4.5, //275.0,
                decoration: BoxDecoration(),
              ),
              Positioned(
                bottom: 230.0,
                left: MediaQuery.of(context).size.width / 2 - 35.0,
                child: Row(
                  children: <Widget>[
                    SelectedPhoto(
                      numberOfDots: photos.length,
                      photoIndex: photoIndex,
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 70.0,
                left: MediaQuery.of(context).size.width / 2 -
                    (MediaQuery.of(context).size.width / 3 / 2),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 18,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Red_deep1,
                      ),
                      child: FlatButton(
                        //color: Colors.amber,
                        textColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () {

                           call_func_photo();
                        },
                        child: Text(  AppLocalizations.of(context).translate('Next'),
                          style: TextStyle(
                              fontSize: pheight / 40.0, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 18,
                      width: MediaQuery.of(context).size.width / 3 - 20,
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
                          Navigator.pushNamed(context, '/RegistrationWelcome');
                        },
                        child: Text(AppLocalizations.of(context).translate('Skip'),
                          style: TextStyle(
                              fontSize: pheight / 40.0,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget _inactivePhoto() {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(4.0))),
      ),
    );
  }

  //
  Widget _activePhoto() {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, spreadRadius: 0.0, blurRadius: 2.0)
                ])),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for (int i = 0; i < numberOfDots; ++i) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildDots(),
    ));
  }
}


