import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:paychalet/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:date_format/date_format.dart';

class EditCategory extends StatefulWidget {
  final String cat_id;
  final String cat_name;
  final String cat_desc;
  final String cat_remark;
  final String cat_img;
  final String cat_date;
  final String cat_doc_id;
  EditCategory({
    this.cat_id,
    this.cat_name,
    this.cat_desc,
    this.cat_remark,
    this.cat_img,
    this.cat_date,
    this.cat_doc_id,
  });
  @override
  _EditCategoryState createState() => _EditCategoryState();
}





const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Colors.amber;
Color colorTwo = Colors.amber[300];
Color colorThree = Colors.amber[100];

class _EditCategoryState extends State<EditCategory> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color pyellow = Color(Colors.amber);
  String imagename;
  File sampleimage;
  int state = 0;
  var url2;


  void initState(){
    print("inside init");
    setState(() {
      contcatid.text = widget.cat_id;
      contcatname.text = widget.cat_name;
      contcatremark.text=widget.cat_remark;
      contcatdesc.text = widget.cat_desc;
      contcatimg.text=widget.cat_img;
      contcatentrydate.text=widget.cat_date;

    });

  }
  TextEditingController contcatid = new TextEditingController();
  TextEditingController contcatname = new TextEditingController();
  TextEditingController contcatremark = new TextEditingController();
  TextEditingController contcatdesc = new TextEditingController();
  TextEditingController contcatimg = new TextEditingController();
  TextEditingController contcatentrydate = new TextEditingController();



  Future getImagecamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {

      sampleimage = tempImage;

    });

    //  compressImage();
  }

  Future getImagegalary() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleimage = tempImage;

    });

    /// compressImage();
  }

  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

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
                color: Red_deep2,
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
                  color: Red_deep1),
            ),
          ),
          //menu
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                print('inside button');
                //   _scaffoldKey.currentState.openDrawer();

                Navigator.pushReplacementNamed(context, "/ProductsMain");
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                print('inside button');
                Navigator.pop(context);
                // FirebaseAuth.instance.signOut();

                // Navigator.popAndPushNamed(context, "/SignIn");

                // Navigator.pushReplacementNamed(context, "/SignIn");
              },
            ),
          ),
          //body
          Positioned(
            top: 75,
            right: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,

                child:Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: pheight/1.5,
                    width: pwidth-20,
                    child: new Center(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: contcatid,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please Cat Id ';
                                }
                              },
                              onSaved: (input) => imagename = input,

                              decoration: InputDecoration(
                                labelText: 'Cat id',
                              ),
                              // obscureText: true,
                            ),
                            TextFormField(
                              controller: contcatname,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please Type an Name for Category';
                                }
                              },
                              onSaved: (input) => imagename = input,
                              decoration: InputDecoration(labelText: 'Category Name',
                              ),

                              // obscureText: true,
                            )
                            ,
                            TextFormField(
                              controller: contcatdesc,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please Type Category  Desc';
                                }
                              },
                              onSaved: (input) => imagename = input,
                              decoration: InputDecoration(labelText: 'Category Desc'),
                              // obscureText: true,
                            ),

                            TextFormField(
                              controller: contcatremark,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please Type Category Remark';
                                }
                              },
                              onSaved: (input) => imagename = input,
                              decoration: InputDecoration(labelText: 'Category Remark'),
                              // obscureText: true,
                            ),
                            SizedBox(height: 20,),
                            //Image.network(widget.prodimg),
                            //enableupload(),

                            //sampleimage  != null ? Text("Select an image") : enableupload(),
                            enableupload(),
//                            new Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                IconButton(
//                                  icon: Icon(Icons.camera_roll),
//                                  onPressed: () {
//                                    getImagecamera();
//
//                                    setState(() {
//                                      state = 0;
//                                    });
//                                  },
//
//                                ),
//
//                                IconButton(
//                                  icon: Icon(Icons.add_a_photo),
//                                  onPressed: () {
//                                    getImagegalary();
//
//                                    setState(() {
//                                      state = 0;
//                                    });
//                                  },
//
//                                )
//                              ],
//                            )
                          ],
                        )),
                  ),
                ),


            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 20,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: Text(
              AppLocalizations.of(context).translate('Category'),
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),





        ],
      ),
    );

  }
  Widget enableupload() {
    return Container(
      child: Column(
        children: <Widget>[
//          sampleimage ==null ?
//          Image.network(
//
//            widget.cat_img,
//            height: MediaQuery.of(context).size.height/3.5,
//            width: MediaQuery.of(context).size.width-20,
//          ) :
//          Image.file(
//            sampleimage,
//            height: MediaQuery.of(context).size.height/3.5,
//            width: MediaQuery.of(context).size.width-20,
//          )
//
//          ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                elevation: 7.0,
                child: Text(AppLocalizations.of(context).translate('Save')),

                textColor: Colors.white,
                color: Red_deep,
                onPressed: () {
                  setState(() {
                    state = 1;
                  });
                  if ( sampleimage == null )
                  {
                    print("inside uploadimg  no file update data only");

                    updateDataonly(widget.cat_doc_id);
                    Navigator.pushReplacementNamed(context, "/CategoryMain2");
                  }
                  else
                  {
                    print("inside uploadimg  file update data only");
                    uploadimage();

                  }
                  //addimagedata();
                  //updateData(widget.cat_id);
                  /* final StorageReference fbsr =FirebaseStorage.instance.ref().child('${contimage.text}.jpg');
               final StorageUploadTask task = fbsr.putFile(sampleimage);
               var downurl = fbsr.getDownloadURL();
              print("the URL for image= ${downurl.toString()}");
               */
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
          ),

////////

///////
        ],
      ),
    );
  }

////////

///////

  Future<String> uploadimage() async {

    final StorageReference ref =
    FirebaseStorage.instance.ref().child('${contcatname.text}.jpg');
    print("the pict${sampleimage}");
    final StorageUploadTask task = ref.putFile(sampleimage);
    var downurl = await (await task.onComplete).ref.getDownloadURL();

    var url = downurl.toString();
    url2 = url;
    //print("the URL for image= ${url}");
    setState(() {
      state = 2;
    });

    final todayDate = DateTime.now();
    // currentdate=formatDate(todayDate, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);
    updateData(widget.cat_doc_id);
    //addimagedata();
    return "";

  }

  Widget setUpButtonChild() {
    if (state == 0) {
      return new Text(
        "Click Upload",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void compressImage() async {
    print("inside compressed");

    if ( sampleimage == null )
    {
      print("inside compressed no file ");


    }
    else
    {
      File imageFile = sampleimage;
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      int rand = new Math.Random().nextInt(10000);

      Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
      Im.Image smallerImage = Im.copyResize(
          image); // choose the size here, it will maintain aspect ratio

      var compressedImage = new File('$path/img$rand.jpg')
        ..writeAsBytesSync(Im.encodeJpg(image, quality: 50));
      setState(() {
        sampleimage = compressedImage;
      });
    }
  }

  addimagedata() {
    FirebaseFirestore.instance.collection("PaymentsCategory").doc().setData({
      'cat_id': contcatid.text,
      'cat_name': contcatname.text,
      'cat_desc': contcatdesc.text,
      'cat_remark': contcatremark.text,
      'cat_date':contcatentrydate.text,// contCatenterydate.text,
      'cat_img': url2
    });
  }

  updateData(selectedDoc) {

    FirebaseFirestore.instance
        .collection('PaymentsCategory')
        .doc(selectedDoc)
        .updateData(
        {
          'cat_id': contcatid.text,
          'cat_name': contcatname.text,
          'cat_desc': contcatdesc.text,
          'cat_remark': contcatremark.text,
          'cat_date':contcatentrydate.text,// contCatenterydate.text,
          'cat_img': url2
        }
    )
        .catchError((e) {
      print(e);
    });
  }


  updateDataonly(selectedDoc) {
    final todayDate = DateTime.now();
   var currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    FirebaseFirestore.instance
        .collection('PaymentsCategory')
        .doc(selectedDoc)
        .update(
        {
          'cat_id': contcatid.text,
          'cat_name': contcatname.text,
          'cat_desc': contcatdesc.text,
          'cat_remark': contcatremark.text,
          'cat_date':currentdate// contCatenterydate.text,
          // 'cat_img': url2
        }
    )
        .catchError((e) {
      print(e);
    });

    setState(() {
      state = 2;
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
