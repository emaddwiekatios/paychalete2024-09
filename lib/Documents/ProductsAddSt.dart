import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:paychalet/colors.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/Documents/ProductsMain.dart';
//import 'package:paychalet/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import  'package:keyboard_actions/keyboard_actions.dart';

class ProductAddSt extends StatefulWidget {
  var Docs_max;
  ProductAddSt({this.Docs_max});
  @override
  _ProductAddStState createState() => _ProductAddStState();
}

QuerySnapshot cars;
const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne ;
Color colorTwo ;
Color colorThree ;
User user;

class _ProductAddStState extends State<ProductAddSt> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

// Color pyellow = Color(Colors.amber);

  ////  add  keyboard action

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(
          focusNode: _nodeText3,
          onTapAction: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Custom Action"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                });
          },
        ),
        KeyboardActionsItem(
          focusNode: _nodeText4,
          // displayCloseWidget: false,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText5,
          toolbarButtons: [
            //button 1
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            //button 2
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DONE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeText6,
          footerBuilder: (_) => PreferredSize(
              child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Custom Footer'),
                  )),
              preferredSize: Size.fromHeight(40)),
        ),
      ],
    );
  }

//note  add  code on text field
//  KeyboardActions(
//  config: _buildConfig(context),
  //child:widget
  // add on text field  focusNode: _nodeText1,
  // Color pyellow = Color(red4);
  File _image;
  final ImagePicker _picker = ImagePicker();
  // PickedFile _imageFile;
  File _imageFile;

  @override
  void initState() {
    getCurrentUser();
    //  print("inside init");
    colorOne = pcolor6;
    colorTwo = pcolor3;
    colorThree = pcolor1;
    getData().then((results) {
      setState(() {

        contProdid.text = widget.Docs_max;
        cars = results;
        printlist();
      });
    });
    super.initState();
  }

/*
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

*/
  String imagename;
  //PickedFile sampleimage;
  File sampleimage;
  var currentdate;
  int state = 0;
  var url2;

  List<String> list_cat = [];

  String _selectedCat = 'Choose a Category';

  TextEditingController contProdid = new TextEditingController();
  TextEditingController contProdname = new TextEditingController();
  TextEditingController contProdprice = new TextEditingController();
  TextEditingController contProdfav = new TextEditingController();
  TextEditingController contProdcat = new TextEditingController();
  TextEditingController contProddesc = new TextEditingController();
  TextEditingController contProdurl = new TextEditingController();
  TextEditingController contProddentrydate = new TextEditingController();

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
    return Scaffold(
      key: _scaffoldKey,
      // drawer: Appdrawer(),
      body:GestureDetector(
        onTap: (){
          print('ontap');
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

        child: Stack(
          children: <Widget>[
            //header shape
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(200),
                  //  color: red4,
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
                  color: red4,
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
                    color: red4),
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
                  color: pcolor4,
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
                    color: pcolor4),
              ),
            ),
            //menu
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  print('inside button');
                  //_scaffoldKey.currentState.openDrawer();
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new ProductsMain()),
                  );
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 14,
              left: MediaQuery.of(context).size.width / 2 -
                  ('Add Document'.toString().length * 8),
              child: Text(
                'Add Document',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            //body
            Positioned(
              top: 110,
              right: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height >= 775.0
                      ? MediaQuery.of(context).size.height
                      : 775.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      // color: Colors.red,
                      //   height: MediaQuery.of(context).size.height/2,
                      //   width: MediaQuery.of(context).size.width,
                      child:  KeyboardActions(
                config: _buildConfig(context),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(5.0),
                                child: TextFormField(

                                    keyboardType: TextInputType.number,
                                    controller: contProdid,
                                    onChanged: (value) {},
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please Prod Id ';
                                      }
                                    },
                                    onSaved: (input) => imagename = input,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,

//                        prefixIcon: Icon(Icons.search,
//                            color: red2),
//                            size: 30.0),
                                        suffixIcon: IconButton(
                                            icon: Icon(Icons.cancel,
                                                color: Color(
                                                    getColorHexFromStr('#FEE16D')),
                                                size: 20.0),
                                            onPressed: () {
                                              print('inside clear');
                                              contProdid.clear();
                                              contProdid.text = null;
                                            }),
                                        contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
                                        hintText: 'Docs_id',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Quicksand'))),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(5.0),
                                child: TextFormField(
                                    controller: contProdname,
                                    onChanged: (value) {},
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please Prod Name ';
                                      }
                                    },
                                    onSaved: (input) => imagename = input,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
//                        prefixIcon: Icon(Icons.search,
//                            color: red2),
//                            size: 30.0),
                                        suffixIcon: IconButton(
                                            icon: Icon(Icons.cancel,
                                                color: Color(
                                                    getColorHexFromStr('#FEE16D')),
                                                size: 20.0),
                                            onPressed: () {
                                              print('inside clear');
                                              contProdname.clear();
                                              contProdname.text = null;
                                            }),
                                        contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
                                        hintText: 'Docs_name',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Quicksand'))),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(5.0),
                                child: TextFormField(
                                    controller: contProddesc,
                                    onChanged: (value) {},
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please Prod Name ';
                                      }
                                    },
                                    onSaved: (input) => imagename = input,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
//                        prefixIcon: Icon(Icons.search,
//                            color: red2),
//                            size: 30.0),
                                        suffixIcon: IconButton(
                                            icon: Icon(Icons.cancel,
                                                color: Color(
                                                    getColorHexFromStr('#FEE16D')),
                                                size: 20.0),
                                            onPressed: () {
                                              print('inside clear');
                                              contProddesc.clear();
                                              contProddesc.text = null;
                                            }),
                                        contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
                                        hintText: 'Docs_Desc',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Quicksand'))),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(5.0),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: DropdownButton<String>(
                                            items: list_cat.map((String val) {
                                              return new DropdownMenuItem<String>(
                                                value: val,
                                                child: new Text(val),
                                              );
                                            }).toList(),
                                            hint: Text(_selectedCat),
                                            onChanged: (newVal) {
                                              this.setState(() {
                                                _selectedCat = newVal;
                                              });
                                            }),
                                      ),
                                    ),
                                    IconButton(icon:Icon(Icons.refresh,color: Red_deep,
                                      ),


                                      onPressed:(){
                                      getData().then((results) {
                                        setState(() {
                                          print(widget.Docs_max);
                                          contProdid.text = widget.Docs_max;
                                          cars = results;
                                          printlist();
                                        });
                                      });
                                    },),
                                    RaisedButton(
                                        elevation: 7.0,
                                        child: Text("Add Category"),
                                        textColor: Colors.white,
                                        color: Red_deep,
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/CategoryAdd');
                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(5.0),
                                child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    focusNode: _nodeText1,
                                    controller: contProdprice,
                                    onChanged: (value) {},
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please Prod Cost ';
                                      }
                                    },
                                    onSaved: (input) => imagename = input,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
//                        prefixIcon: Icon(Icons.search,
//                            color: red2),
//                            size: 30.0),
                                        suffixIcon: IconButton(
                                            icon: Icon(Icons.cancel,
                                                color: Color(
                                                    getColorHexFromStr('#FEE16D')),
                                                size: 20.0),
                                            onPressed: () {
                                              print('inside clear');
                                              contProdprice.clear();
                                              contProdprice.text = null;
                                            }),
                                        contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
                                        hintText: 'Docs_Cost',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Quicksand'))),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              sampleimage == null
                                  ? Text("Select an image")
                                  : enableupload(),
                              SizedBox(
                                height: 5,
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.camera_roll),
                                    onPressed: () {
                                      getImagegalary();

                                      setState(() {
                                        state = 0;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      getImagecamera();

                                      setState(() {
                                        state = 0;
                                      });
                                    },
                                  )
                                ],
                              ),

                            ],
                          )),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget enableupload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(
            sampleimage,
            height: MediaQuery.of(context).size.height/3.5,
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
                color: Red_deep,
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
                //  Text("Upload"),
                textColor: Colors.white,
                color: Red_deep,
                onPressed: () {
                  setState(() {
                    state = 1;
                  });

                  uploadimage();

                  /* final StorageReference fbsr =FirebaseStorage.instance.ref().child('${contimage.text}.jpg');
               final StorageUploadTask task = fbsr.putFile(sampleimage);
               var downurl = fbsr.getDownloadURL();
              print("the URL for image= ${downurl.toString()}");
               */
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

  Future<String> uploadimage() async {
    print('inside upload proc');
    final StorageReference ref =
    FirebaseStorage.instance.ref().child('${contProdname.text}.jpg');
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
    currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    addimagedata();
    addimagedatahist();
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





  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser;

    //final uid = user.uid;
    //return user.email;
  }
  addimagedata() {
    getCurrentUser();
    FirebaseFirestore.instance.collection("Document").doc().set({
      'Docs_id': contProdid.text,
      'Docs_name': contProdname.text,
      'Docs_desc': contProddesc.text,
      'Docs_price': contProdprice.text,
      'Docs_fav': "false",
      'Docs_cat': _selectedCat,
      'Docs_entry_date': currentdate,
      'Docs_img': url2,
      'Docs_user':user.email.toString()
    });

//    setState(() {
//      contProdid.text = (int.parse(contProdid.text) + 1).toString();
//      contProdname.clear();
//      contProddesc.clear();
//      contProdprice.clear();
//    });
  }


  addimagedatahist() {
    getCurrentUser();
    FirebaseFirestore.instance.collection("Document_hist").doc().set({
      'Docs_id': contProdid.text,
      'Docs_name': contProdname.text,
      'Docs_desc': contProddesc.text,
      'Docs_price': contProdprice.text,
      'Docs_fav': "false",
      'Docs_cat': _selectedCat,
      'Docs_entry_date': currentdate,
      'Docs_img': url2,
      'Docs_user':user.email.toString()
    });

    setState(() {
      contProdid.text = (int.parse(contProdid.text) + 1).toString();
      contProdname.clear();
      contProddesc.clear();
      contProdprice.clear();
    });
  }
  getData() async {
    //return await FirebaseFirestore.instance.collection("Gym-Proding").snapshots();
    return await FirebaseFirestore.instance.collection('PaymentsCategory').get();
  }

  printlist() {
    if (cars != null) {
      list_cat.clear();
      for (var i = 0; i < cars.docs.length; i++) {
        list_cat.add(cars.docs[i].data()['cat_name']);
      }
    } else {
      print("error");
    }
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = pcolor4;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width / 2, size.height / 1, size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
