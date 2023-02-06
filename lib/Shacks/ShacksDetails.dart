
import 'package:flutter/material.dart';
import 'package:paychalet/Payments/PaysEditNew.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
import 'package:paychalet/Shacks/MainShacks.dart';
import 'package:paychalet/Shacks/Shack_Class.dart';
import 'dart:ui';
import 'dart:math';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import './ShacksEdit.dart';
import '../main_page.dart';
import 'package:date_format/date_format.dart';
class ShacksDetails extends StatefulWidget {
  Shacks shack_inst =new Shacks();
  ShacksDetails({this.shack_inst});
  @override
  _ShacksDetailsState createState() => _ShacksDetailsState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne ;
Color colorTwo ;
Color colorThree ;


class _ShacksDetailsState extends State<ShacksDetails> {

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
                                  '${AppLocalizations.of(context).translate('No') } :  ${widget.shack_inst.Shack_no}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Shack No Ref') } :  ${widget.shack_inst.Shack_no_ref}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Shack For')} :  ${widget.shack_inst.Shack_for_name}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Shack Owner') } :  ${widget.shack_inst.Shack_owner_name}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Entry Date') } : ${'${formatDate(widget.shack_inst.Shack_entry_date,
                                      [yyyy,'-',mm,'-',dd])}'}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Come Date') } : ${'${formatDate(widget.shack_inst.Shack_come_date,
                                      [yyyy,'-',mm,'-',dd])}'}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),

                                new Text(
                                  '${AppLocalizations.of(context).translate('Category') }  :  ${widget.shack_inst.Shack_cat}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),

                                new Text(
                                  '${AppLocalizations.of(context).translate('Payment_amt') }  :  ${widget.shack_inst.Shack_amt }',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
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
                                  '${AppLocalizations.of(context).translate('Payment_from') }  :  ${widget.shack_inst.Shack_owner_name}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Payment_to') }  :  ${widget.shack_inst.Shack_for_name}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Currency') }  :  ${widget.shack_inst.Shack_currency}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
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
                                          child: new Text(AppLocalizations.of(context).translate('Edit')),
                                          color: Red_deep,
                                          textColor: Colors.white,
                                          // onPressed: ()
                                          onPressed: () {
                                            // print("widget.pcarnameg = ${widget.pcarnameg}");
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                  new ShackEdit(shack_inst:widget.shack_inst)),

                                            );

                                          }),
                                    ),
                                    new RaisedButton(
                                      child: new Text(AppLocalizations.of(context).translate('Delete')),
                                      color: Red_deep,
                                      textColor: Colors.white,
                                      onPressed: () {

                                        deleteData(widget.shack_inst.Shack_doc) ;
                                        Navigator.of(context).pushReplacement(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) => new MainShacks()),
                                        );
                                        //    Navigator.of(context).pop();
                                        // comfirm();

                                        //  updatedata();




                                      },
                                    ),
                                    RaisedButton(
                                      elevation: 7.0,
                                      child:  Text(AppLocalizations.of(context).translate('Cancel')),

                                      // Text("Upload"),
                                      textColor: Colors.white,
                                      color: Red_deep,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )
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
                ' ${ widget.shack_inst.Shack_for_name}',
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold,color: Colors.white,),
              ),
            ),
          ),



        ],
      ),
    );






  }

  deleteData(docId) async {
//    if (widget.Payment_img != null) {
//      StorageReference storageReference =
//      await FirebaseStorage.instance.getReferenceFromUrl(widget.Payment_img);
//
//      print(storageReference.path);
//
//      await storageReference.delete();
//
//      print('image deleted');
//    }
    FirebaseFirestore.instance
        .collection('Shacks')
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

