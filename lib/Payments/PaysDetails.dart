
import 'package:flutter/material.dart';
import 'package:paychalet/Payments/PaysEditNew.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
import 'dart:ui';
import 'dart:math';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';

import '../main_page.dart';
import 'package:date_format/date_format.dart';
class PaysDetails extends StatefulWidget {
  final String Payment_id;
  final String Payment_name;
  final String Payment_desc;
  final String Payment_price;
  final String Payment_fav;
  final String Payment_cat;
  final String Payment_img;
  final String Payment_date;
  final String Payment_entry_date;
  final String Payment_modify_date;
  final String Payment_doc_id;
  final String Payment_amt;
  final String Payment_to;
  final String Payment_from;
  final String Payment_currency;
  final String Payment_user;
  PaysDetails(
      {
        this.Payment_id,
        this.Payment_name,
        this.Payment_desc,
        this.Payment_price,
        this.Payment_fav,
        this.Payment_cat,
        this.Payment_img,
        this.Payment_date,
        this.Payment_entry_date,
        this.Payment_modify_date,
        this.Payment_doc_id,
        this.Payment_amt,
        this.Payment_to,
        this.Payment_from,
        this.Payment_currency,
        this.Payment_user

      }
      );
  @override
  _PaysDetailsState createState() => _PaysDetailsState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne ;
Color colorTwo ;
Color colorThree ;


class _PaysDetailsState extends State<PaysDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    colorOne = Red_deep;
    colorTwo = Red_deep2;
    colorThree = Red_deep3;
  }
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color pyellow = Color(Colors.amber);
  bool data_deleted =false;


  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    var appLanguage = Provider.of<AppLanguage>(context);


    return Scaffold(
      key: _scaffoldKey,

      // drawer: Appdrawer(),
      body:
      Stack(
        children: <Widget>[
          //header shape
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 4,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(200),
                //  color: Colors.amber,
              ),
              child: CustomPaint(
                child: Container(
                  height: 400.0,
                ),
                painter: _MyPainter(),
              ),
            ),
          ),

          //a
          Positioned(
            bottom: -125,
            left: -150,
            child: Container(
              height: 250, //MediaQuery.of(context).size.height / 4,
              width: 250, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color: colorOne,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -115,
            child: Container(
              height: 250, //MediaQuery.of(context).size.height / 4,
              width: 250, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: colorTwo),
            ),
          ),
          //menu
          Positioned(
            top: pheight/25,
            left: pwidth/20,
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                print('inside button');
                // _scaffoldKey.currentState.openDrawer();

                Navigator.pushReplacementNamed(context, "/main_page");
              },
            ),
          ),
          Positioned(
            top: pheight/25,
            right: pwidth/20,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                print('inside button');
                // FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                //  Navigator.popAndPushNamed(context, "/SignIn");

                //Navigator.pushReplacementNamed(context, "/SignIn");
              },
            ),
          ),
          //body
          Positioned(
            top: MediaQuery.of(context).size.height/10,
            bottom: MediaQuery.of(context).size.height/30,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,

                child:Container(

                    padding: EdgeInsets.all(5.0),
                    child: new Card(
                      child: new Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right:10),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.all(10.0),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('No') } :  ${widget.Payment_id}',
                                  style: TextStylesmall(pheight,Colors.black),
                                  textAlign: TextAlign.right,
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Name')} :  ${widget.Payment_name}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Desc') } :  ${widget.Payment_desc}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Entry Date') } : ${widget.Payment_entry_date.substring(0,18)}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Modify Date') } : ${widget.Payment_modify_date.substring(0,18)}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),

                                new Text(
                                  '${AppLocalizations.of(context).translate('Category') }  :  ${widget.Payment_cat}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),

                                new Text(
                                  '${AppLocalizations.of(context).translate('Payment_amt') }  :  ${widget.Payment_amt +' '+ widget.Payment_currency}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(top:8.0,bottom:8),
//                                  child: Container(
//
//                                    height: MediaQuery.of(context).size.height/2.5,
//                                    width: MediaQuery.of(context).size.width-30,
//                                    decoration: BoxDecoration(
////                                        image: DecorationImage(
////                                          image:  NetworkImage(widget.Payment_img),
////                                          fit: BoxFit.cover,
////
////                                        ),
//                                        borderRadius: BorderRadius.circular(10)
//
//
//                                    ),
////                                  child: Image.network(
////                                    widget.Payment_img,
////                                   // height: pheight/2,
////                                 //   width: pwidth-20,
////                                  ),
//                                  ),
//                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Payment_from') }  :  ${widget.Payment_from}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Payment_to') }  :  ${widget.Payment_to}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Currency') }  :  ${widget.Payment_currency}',
                                  style: TextStylesmall(pheight,Colors.black),
                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(top:8.0,bottom:8),
//                                  child: Container(
//
//                                    height: MediaQuery.of(context).size.height/2.5,
//                                    width: MediaQuery.of(context).size.width-30,
//                                    decoration: BoxDecoration(
////                                        image: DecorationImage(
////                                          image:  NetworkImage(widget.Payment_img),
////                                          fit: BoxFit.cover,
////
////                                        ),
//                                        borderRadius: BorderRadius.circular(10)
//
//
//                                    ),
////                                  child: Image.network(
////                                    widget.Payment_img,
////                                   // height: pheight/2,
////                                 //   width: pwidth-20,
////                                  ),
//                                  ),
//                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: new RaisedButton(
                                          child: new Text(AppLocalizations.of(context).translate('Edit')
                                          ,
                                            style: TextStylesmall(pheight,Colors.white),),
                                          color: Red_deep,
                                          textColor: Colors.white,
                                          // onPressed: ()
                                          onPressed: () {
                                            // print("widget.pcarnameg = ${widget.pcarnameg}");
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                  new ProductsEditNew(

                                                    Payment_id: widget.Payment_id,
                                                    Payment_name: widget.Payment_name,
                                                    Payment_desc: widget.Payment_desc,
                                                    Payment_amt: widget.Payment_amt,
                                                    Payment_fav: widget.Payment_fav,
                                                    Payment_cat: widget.Payment_cat,
                                                    Payment_entry_date: widget.Payment_entry_date,
                                                    Payment_img: widget.Payment_img,
                                                    Payment_doc_id: widget.Payment_doc_id,
                                                    Payment_to: widget.Payment_to,
                                                    Payment_currency: widget.Payment_currency,
                                                    Payment_from: widget.Payment_from,
                                                  )),

                                            );

                                          }),
                                    ),

                                    RaisedButton(
                                      child: new Text(AppLocalizations.of(context).translate('Delete'),
                                        style: TextStylesmall(pheight,Colors.white),),
                                      color: Red_deep,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        print("widget.pproductdocid ${widget.Payment_doc_id}");
                                        deleteData(widget.Payment_doc_id) ;
                                        Navigator.of(context).pushReplacement(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) => new main_page()),
                                        );
                                        //    Navigator.of(context).pop();
                                        // comfirm();

                                        //  updatedata();




                                      },
                                    ),
                                    RaisedButton(
                                      elevation: 7.0,
                                      child:  Text(AppLocalizations.of(context).translate('Cancel'),
                                        style: TextStylesmall(pheight,Colors.white),),

                                      // Text("Upload"),
                                      textColor: Colors.white,
                                      color: Red_deep,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          )),
                    ))



            ),
          ),

//title
          Positioned(
            top: MediaQuery
                .of(context)
                .size
                .height/20,
            left: MediaQuery
                .of(context)
                .size
                .width / 5,
            right: MediaQuery
                .of(context)
                .size
                .width / 5,
            child: Center(
              child: Text(
                ' ${ widget.Payment_name.length>18?  widget.Payment_name.substring(1,18):widget.Payment_name}',
                style: TextStyle(fontSize:  pheight/40, fontWeight: FontWeight.bold,color: Colors.white,),
              ),
            ),
          ),



        ],
      ),
    );






  }

  deleteData(docId) async {
    if (widget.Payment_img != null) {
      StorageReference storageReference =
      await FirebaseStorage.instance.getReferenceFromUrl(widget.Payment_img);

      print(storageReference.path);

      await storageReference.delete();

      print('image deleted');
    }
    FirebaseFirestore.instance
        .collection('Payments')
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });

//    Navigator.of(context).pushReplacement(
//      new MaterialPageRoute(
//          builder: (BuildContext context) => new SocialHome()),
//    );
  }

  void _showSnackbar(String name) {
//    final scaff = Scaffold.of(context);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Tranaction ${name} Saved'),
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Done', onPressed: _scaffoldKey.currentState.hideCurrentSnackBar,
      ),
    ));
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = colorOne;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width /2, size.height / 1, size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

