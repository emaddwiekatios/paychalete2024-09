
import 'package:flutter/material.dart';
import 'package:paychalet/Documents/ProductsEditNew.dart';
import 'package:paychalet/Documents/ProductsMain.dart';
import 'dart:ui';
import 'dart:math';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';

import 'ProductDetailsBigimg.dart';

class ProductsDetails extends StatefulWidget {
  final String Docs_id;
  final String Docs_name;
  final String Docs_desc;
  final String Docs_price;
  final String Docs_fav;
  final String Docs_cat;
  final String Docs_img;
  final String Docs_date;
  final String Docs_doc_id;

  ProductsDetails(
      {
        this.Docs_id,
        this.Docs_name,
        this.Docs_desc,
        this.Docs_price,
        this.Docs_fav,
        this.Docs_cat,
        this.Docs_img,
        this.Docs_date,
        this.Docs_doc_id});
  @override
  _ProductsDetailsState createState() => _ProductsDetailsState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = pcolor2;
Color colorTwo = pcolor3;
Color colorThree = pcolor4;


class _ProductsDetailsState extends State<ProductsDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     colorOne = pcolor2;
     colorTwo = pcolor3;
     colorThree = pcolor4;
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

                Navigator.pushReplacementNamed(context, "/ProductsMain");
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
                                  padding: EdgeInsets.all(5.0),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('No') } :  ${widget.Docs_id}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Name')} :  ${widget.Docs_name}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Desc') } :  ${widget.Docs_desc}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Date') }  :  ${widget.Docs_date}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                new Text(
                                  '${AppLocalizations.of(context).translate('Category') }  :  ${widget.Docs_cat}',
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,bottom:8),
                                  child: InkWell(
                                    onTap: () {
                                      print('hello');
                                      Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                            new ProductDetailsBigimg(
                                              Docs_id: widget.Docs_id,
                                              Docs_name: widget.Docs_name,
                                              Docs_desc: widget.Docs_desc,
                                              Docs_price: widget.Docs_price,
                                              Docs_fav: widget.Docs_fav,
                                              Docs_cat: widget.Docs_cat,
                                              Docs_date: widget.Docs_date,
                                              Docs_img: widget.Docs_img,
                                              Docs_doc_id: widget.Docs_doc_id,


                                              //Docs_img: widget.Docs_img

                                            ),)

                                      );

                                    },
                                    child: Container(

                                      height: MediaQuery.of(context).size.height/2.5,
                                      width: MediaQuery.of(context).size.width-30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:  NetworkImage(widget.Docs_img),
                                            fit: BoxFit.cover,

                                          ),
                                          borderRadius: BorderRadius.circular(10)


                                      ),
//                                  child: Image.network(
//                                    widget.Docs_img,
//                                   // height: pheight/2,
//                                 //   width: pwidth-20,
//                                  ),
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 0.0),
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
                                          // onPressed: ()
                                          onPressed: () {
                                            // print("widget.pcarnameg = ${widget.pcarnameg}");
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                  new ProductsEditNew(

                                                    Docs_id: widget.Docs_id,
                                                    Docs_name: widget.Docs_name,
                                                    Docs_desc: widget.Docs_desc,
                                                    Docs_price: widget.Docs_price,
                                                    Docs_fav: widget.Docs_fav,
                                                    Docs_cat: widget.Docs_cat,
                                                    Docs_date: widget.Docs_date,
                                                    Docs_img: widget.Docs_img,
                                                    Docs_doc_id: widget.Docs_doc_id,
                                                  )),

                                            );

                                          }),
                                    ),
                                    new RaisedButton(
                                      child: new Text(AppLocalizations.of(context).translate('Delete')),
                                      color: Red_deep,
                                      onPressed: () {
                                        print("widget.pproductdocid ${widget.Docs_doc_id}");
                                        deleteData(widget.Docs_doc_id) ;
                                        Navigator.of(context).pushReplacement(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) => new ProductsMain()),
                                        );
                                       //    Navigator.of(context).pop();
                                        // comfirm();

                                        //  updatedata();




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
                .width / 2 - 70,
            child: Text(
              ' ${widget.Docs_name}',
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),



        ],
      ),
    );






  }

  deleteData(docId) async {
    if (widget.Docs_img != null) {
      StorageReference storageReference =
      await FirebaseStorage.instance.getReferenceFromUrl(widget.Docs_img);

      print(storageReference.path);

      await storageReference.delete();

      print('image deleted');
    }
    FirebaseFirestore.instance
        .collection('Document')
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
    paint.color = colorTwo;
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

