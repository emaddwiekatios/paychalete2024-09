


import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/colors.dart';

import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
//import 'package:paychalet/main_page.dart';
//import 'package:flutter_app_vetagable/Pages/colors.dart';
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:paychalet/Payments/ProductsMain.dart';

class ProductsEdit extends StatefulWidget {

  final String Docs_id;
  final String Docs_name;
  final String Docs_desc;
  final String Docs_price;

  final String Docs_fav;
  final String Docs_cat;
  final String Docs_img;
  final String Docs_date;
  final String Docs_doc_id;
  ProductsEdit({
    this.Docs_id,
    this.Docs_name,
    this.Docs_desc,
    this.Docs_price,

    this.Docs_fav,
    this.Docs_cat,
    this.Docs_img,
    this.Docs_date,
    this.Docs_doc_id,
  });

  @override
  _ProductsEditState createState() => _ProductsEditState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = pcolor2;
Color colorTwo = pcolor3;
Color colorThree = pcolor4;
QuerySnapshot cars;
class _ProductsEditState extends State<ProductsEdit> {


  String imagename;
  File sampleimage;
  int state = 0;
  var url2;
  String _selectedCat = 'Please choose a Category';
  List<String> list_cat = [];

  void initState() {
    print("inside init");
    setState(() {
      contprodid.text = widget.Docs_id;
      contprodname.text = widget.Docs_name;
      contprodPrice.text = widget.Docs_price.toString();
      contprodset.text = widget.Docs_fav.toString();
      _selectedCat = widget.Docs_cat;

      contproddesc.text = widget.Docs_desc;
      contprodimg.text = widget.Docs_img;
      contprodentrydate.text = widget.Docs_date;
       colorOne = pcolor2;
       colorTwo = pcolor3;
       colorThree = pcolor4;
    });

    getData().then((results) {
      setState(() {
        cars = results;
        printlist();
      });
    });
  }

  TextEditingController contprodid = new TextEditingController();
  TextEditingController contprodname = new TextEditingController();

  TextEditingController contprodset = new TextEditingController();
  TextEditingController contprodcat = new TextEditingController();

  TextEditingController contproddesc = new TextEditingController();
  TextEditingController contprodimg = new TextEditingController();
  TextEditingController contprodentrydate = new TextEditingController();

  TextEditingController contprodPrice = new TextEditingController();
  TextEditingController contprodPriceM = new TextEditingController();
  TextEditingController contprodPriceL = new TextEditingController();

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
            top: MediaQuery
                .of(context)
                .size
                .height/12,
            right: 10,
            left:10,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,

                child:SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      height: MediaQuery.of(context).size.height-2,
                      width: MediaQuery.of(context).size.width,
                      child: new Center(
                          child: Column(
                            children: <Widget>[
//                              TextFormField(
//                                controller: contprodid,
//                                validator: (input) {
//                                  if (input.isEmpty) {
//                                    return 'Please prod Id ';
//                                  }
//                                },
//                                onSaved: (input) => imagename = input,
//
//                                decoration: InputDecoration(
//                                  labelText: 'prod id',
//                                ),
//                                // obscureText: true,
//                              ),
//                              TextFormField(
//                                controller: contprodname,
//                                validator: (input) {
//                                  if (input.isEmpty) {
//                                    return 'Please Type an Name for Trining';
//                                  }
//                                },
//                                onSaved: (input) => imagename = input,
//                                decoration: InputDecoration(
//                                  labelText: 'Prod Name',
//                                ),
//
//                                // obscureText: true,
//                              ),
//                              TextFormField(
//                                controller: contproddesc,
//                                validator: (input) {
//                                  if (input.isEmpty) {
//                                    return 'Please Type Trining  Desc';
//                                  }
//                                },
//                                onSaved: (input) => imagename = input,
//                                decoration: InputDecoration(labelText: 'Prod Desc'),
//                                // obscureText: true,
//                              ),
                              ///
//                              Align(
//                                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
//
//                                child: new DropdownButton<String>(
//
//                                    items: list_cat.map((String val)
//                                    {
//                                      return new DropdownMenuItem<String>(
//                                        value: val,
//                                        child: new Text(val),
//                                      );
//                                    }).toList(),
//                                    hint: Text(_selectedCat),
//                                    onChanged: (newVal) {
//
//                                      this.setState(() {
//                                        _selectedCat = newVal;
//                                      });
//                                    }),
//                              ),
//                              TextFormField(
//                                controller: contprodPrice,
//                                validator: (input) {
//                                  if (input.isEmpty) {
//                                    return 'Please Price';
//                                  }
//                                },
//                                onSaved: (input) => imagename = input,
//                                decoration: InputDecoration(labelText: 'Price '),
//                                // obscureText: true,
//                              ),
//                               SizedBox(height: 5.0,),
//                              enableupload(),
//                              new Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  IconButton(
//                                    icon: Icon(Icons.camera_roll),
//                                    onPressed: () {
//                                      getImagecamera();
//
//                                      setState(() {
//                                        state = 0;
//                                      });
//                                    },
//                                  ),
//                                  IconButton(
//                                    icon: Icon(Icons.add_a_photo),
//                                    onPressed: () {
//                                      getImagegalary();
//
//                                      setState(() {
//                                        state = 0;
//                                      });
//                                    },
//                                  )
//                                ],
//                              )
                            ],
                          )),
                    ),
                  ),
                ),


            ),
          ),
          //header title
          Positioned(
            top: MediaQuery.of(context).size.height / 18,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Text(
              AppLocalizations.of(context).translate('Details'),
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
          sampleimage == null
              ? Image.network(
            widget.Docs_img,
            height: MediaQuery.of(context).size.height/4,
            width: MediaQuery.of(context).size.width-20,
          )
              : Image.file(
            sampleimage,
            height: MediaQuery.of(context).size.height/4,
            width: MediaQuery.of(context).size.width-20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                elevation: 7.0,
                child: Text("Compressed"),
                //  Text("Upload"),
                textColor: Colors.white,
                color:Red_deep,
                onPressed: () {
                  compressImage();
                  /* final StorageReference fbsr =FirebaseStorage.instance.ref().child('${contimage.text}.jpg');
                   final StorageUploadTask task = fbsr.putFile(sampleimage);
                   var downurl = fbsr.getDownloadURL();
                  print("the URL for image= ${downurl.toString()}");
                   */
                },
              ),
              RaisedButton(
                elevation: 7.0,
                child: setUpButtonChild(),
                // Text("Upload"),
                textColor: Colors.white,
                color: Red_deep,
                onPressed: () {
                  setState(() {
                    state = 1;
                  });
                  if (sampleimage == null) {
                    print("inside uploadimg  no file update data only");

                    updateDataonly(widget.Docs_doc_id);
                  }
                  else {
                    deleteold_image();
                    uploadimage();
                  }

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

    if (sampleimage == null) {
      print("inside compressed no file ");
    } else {
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


    FirebaseFirestore.instance.collection("Document").doc().set({
      'Docs_id': contprodid.text,
      'Docs_name': contprodname.text,
      'Docs_desc': contproddesc.text,
      'Docs_price': contprodPrice.text,
      'Docs_set': contprodset.text,
      'Docs_cat': contprodcat.text,
      'Docs_entry_date': contprodentrydate.text, // contprodenterydate.text,
      'Docs_img': url2
    });
  }

  updateData(selectedDoc) {
    final todayDate = DateTime.now();
    contprodentrydate.text = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    FirebaseFirestore.instance
        .collection('Document')
        .doc(selectedDoc)
        .updateData({
      'Docs_id': contprodid.text,
      'Docs_name': contprodname.text,
      'Docs_desc': contproddesc.text,

      'Docs_price': contprodPrice.text,
      'Docs_priceM': contprodPriceM.text,
      'Docs_priceL': contprodPriceL.text,
      'Docs_fav': contprodset.text,
      'Docs_cat': _selectedCat,
      'Docs_date': contprodentrydate.text, // contprodenterydate.text,
      'Docs_img': url2
    }).catchError((e) {
      print(e);
    });
  }

  updateDataonly(selectedDoc) {
    final todayDate = DateTime.now();
    contprodentrydate.text = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    FirebaseFirestore.instance
        .collection('Document')
        .doc(selectedDoc)
        .updateData({
      'Docs_id': contprodid.text,
      'Docs_name': contprodname.text,
      'Docs_desc': contproddesc.text,
      'Docs_price': contprodPrice.text,
      'Docs_fav': contprodset.text,
      'Docs_cat': _selectedCat,
      'Docs_date': contprodentrydate.text, // contprodenterydate.text,
      //'Docs_img': url2 // contprodenterydate.text,
      // 'Docs_img': url2
    }).catchError((e) {
      print(e);
    });

    setState(() {
      state = 2;
    });
  }


  deleteold_image() async {
    if (widget.Docs_img != null) {
      StorageReference storageReference =
      await FirebaseStorage.instance.getReferenceFromUrl(widget.Docs_img);

      print(storageReference.path);

      await storageReference.delete();

      print('image deleted');
    }
  }
  getData() async {
    //return await FirebaseFirestore.instance.collection("Furnit_Products").snapshots();
    return await FirebaseFirestore.instance.collection('Category').get();
  }
  printlist(){
    if (cars != null) {
      for(var i =0 ;i<cars.docs.length;i++)
      {
        list_cat.add(cars.docs[i].data()['cat_name']);
      }
    }
    else
    {
      print("error");
    }


  }

  //void uploadimage() {}


  Future<String> uploadimage() async {


    final StorageReference ref =
    FirebaseStorage.instance.ref().child('${contprodname.text}.jpg');
    final StorageUploadTask task = ref.putFile(sampleimage);
    var downurl = await (await task.onComplete).ref.getDownloadURL();

    var url = downurl.toString();
    url2 = url;
    //print("the URL for image= ${url}");
    setState(() {
      state = 2;
    });
    //addimagedata();
    updateData(widget.Docs_doc_id);
    //  Navigator.pushNamed(context, '/productsallcom');
    return "";

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

