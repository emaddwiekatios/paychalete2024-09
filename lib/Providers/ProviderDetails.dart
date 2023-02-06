import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/colors.dart';
//import './CategoryMain.dart';
//import './categoryedite.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';

import 'ProvidersEdit.dart';

//import './editproductcom.dart';
//import './editeproducts.dart';
//import './image_all.dart';

class providersdetails extends StatefulWidget {
  final String Provider_id;
  final String Provider_name;
  final String Provider_desc;
  final String Provider_remark;
  final String Provider_img;
  final String Provider_date;
  final String Provider_doc_id;

  providersdetails(
      {this.Provider_id,
        this.Provider_name,
        this.Provider_desc,
        this.Provider_remark,
        this.Provider_img,
        this.Provider_date,
        this.Provider_doc_id});

  @override
  providersdetailsState createState() => providersdetailsState();
}


const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Colors.amber;
Color colorTwo = Colors.amber[300];
Color colorThree = Colors.amber[100];

class providersdetailsState extends State<providersdetails> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color pyellow = Color(Colors.amber);

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
          /*
          Positioned(
            top: 125,
            left: -150,
            child: Container(
              height: 450, //MediaQuery.of(context).size.height / 4,
              width: 450, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color: Colors.amber,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 115,
            child: Container(
              height: 350, //MediaQuery.of(context).size.height / 4,
              width: 350, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.amber),
            ),
          ),
          */
          //a
          Positioned(
            bottom: -125,
            left: -150,
            child: Container(
              height: 250, //MediaQuery.of(context).size.height / 4,
              width: 250, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color:Red_deep2,
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
                  color: Red_deep2),
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
            top: pheight/10,
            right: 0,
            bottom: 20,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,

                child:Container(
                  //  height: 500,
                    padding: EdgeInsets.all(5.0),
                    child: new Card(
                      elevation: 12,
                      child: new Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left:20.0,right: 20),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.all(10.0),
                                ),

                                new Text(
                                  '${AppLocalizations.of(context).translate('Cat No') } :  ${widget.Provider_id}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Cat Name') } :  ${widget.Provider_name}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Cat Desc') } :  ${widget.Provider_desc}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Remark') } :  ${widget.Provider_remark}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
//                                Center(
//                                  child: Image.network(
//                                    widget.Provider_img,
//                                    height: pheight/3,
//                                    width: pwidth-20,
//                                  ),
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(top:8.0,bottom:8),
//                                  child: Container(
//
//                                    height: MediaQuery.of(context).size.height/2,
//                                    width: MediaQuery.of(context).size.width-30,
//                                    decoration: BoxDecoration(
//                                        image: DecorationImage(
//                                          image:  NetworkImage(widget.Provider_img),
//                                          fit: BoxFit.cover,
//
//                                        ),
//                                        borderRadius: BorderRadius.circular(10)
//
//
//                                    ),
////                                  child: Image.network(
////                                    widget.Docs_img,
////                                   // height: pheight/2,
////                                 //   width: pwidth-20,
////                                  ),
//                                  ),
//                                ) ,
                                new Text(
                                  '${AppLocalizations.of(context).translate('Date') } :  ${widget.Provider_date}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
//                                Center(
//                                  child: Image.network(
//                                    widget.Provider_img,
//                                    height: pheight/3,
//                                    width: pwidth-20,
//                                  ),
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(top:8.0,bottom:8),
//                                  child: Container(
//
//                                    height: MediaQuery.of(context).size.height/2,
//                                    width: MediaQuery.of(context).size.width-30,
//                                    decoration: BoxDecoration(
//                                        image: DecorationImage(
//                                          image:  NetworkImage(widget.Provider_img),
//                                          fit: BoxFit.cover,
//
//                                        ),
//                                        borderRadius: BorderRadius.circular(10)
//
//
//                                    ),
////                                  child: Image.network(
////                                    widget.Docs_img,
////                                   // height: pheight/2,
////                                 //   width: pwidth-20,
////                                  ),
//                                  ),
//                                ) ,
                                new Padding(
                                  padding: EdgeInsets.only(top: 40.0),
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: new RaisedButton(
                                          textColor: Colors.white,
                                          child: new Text(
                                              AppLocalizations.of(context).translate('Edit')),
                                          color: Red_deep,
                                          // onPressed: ()
                                          onPressed: () {
                                            print("widget.Provider_date = ${widget.Provider_date}");
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                  new ProviderEdit(
                                                    Provider_id: widget.Provider_id,
                                                    Provider_name: widget.Provider_name,
                                                    Provider_desc: widget.Provider_desc,
                                                    Provider_remark: widget.Provider_remark,
                                                    Provider_date: widget.Provider_date,
                                                    Provider_img: widget.Provider_img,
                                                    Provider_doc_id: widget.Provider_doc_id,
                                                  )),
                                            );
                                          }),

                                    ),
                                    new RaisedButton(
                                      textColor: Colors.white,
                                      child: new Text(
                                          AppLocalizations.of(context).translate('Delete')),
                                      color: Red_deep,
                                      onPressed: () {
                                        print("widget.pproductdocid ${widget.Provider_doc_id}");
                                        deleteData(widget.Provider_doc_id) ;
                                        // comfirm();

                                        //  updatedata();
                                        /*  Navigator.of(context).push(
                              new MaterialPageRoute(
                                 builder: (BuildContext context)=> new CategoryMain()
                                 ),
                               );
                     */

                                        Navigator.pushNamed(context, '/ProvidersMain');
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
/*
FutureBuilder<List<UserModel>>(
future: db.getUserModelData(),
builder: (context, snapshot) {
if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
*/


            ),
          ),
          //header title
          Positioned(
            top: MediaQuery.of(context).size.height / 18,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Text(
              AppLocalizations.of(context).translate('Details'),
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold,   color: Colors.white,),
            ),
          ),




        ],
      ),
    );

  }
  deleteData(docId) {
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Red_deep;
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
