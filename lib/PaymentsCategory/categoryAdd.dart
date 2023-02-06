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
import 'package:date_format/date_format.dart';
import 'dart:ui';
class AddCategory extends StatefulWidget {
  var cat_max;
  AddCategory({this.cat_max});
  @override
  AddCategoryState createState() => AddCategoryState();
}


const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Colors.amber;
Color colorTwo = Colors.amber[300];
Color colorThree = Colors.amber[100];

QuerySnapshot cars;
var cat_max;
List<int> list_cat = [];

var catslist
=[
  {
    "cat_id":"Weman Dress",
    "cat_name":"Weman Dress",
    "cat_desc":"Weman Dress",
    "cat_remark":"Weman Dress",
    "cat_date":"Weman Dress",

    "cat_img":'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',

  }
];

class AddCategoryState extends State<AddCategory> {
  String imagename;
  File sampleimage;
  var currentdate;
  int state = 0;
  var url2;

  TextEditingController contCatid = new TextEditingController();
  TextEditingController contCatname = new TextEditingController();
  TextEditingController contCatremark = new TextEditingController();
  TextEditingController contCatdesc = new TextEditingController();
  TextEditingController contCaturl = new TextEditingController();
  TextEditingController contCatdentrydate = new TextEditingController();


  getData() async {
    //return await FirebaseFirestore.instance.collection("Gym-Category").snapshots();


    return await FirebaseFirestore.instance.collection('PaymentsCategory').get();

  }

  printlist(){
    if (cars != null) {
      list_cat.clear();
      //print('inside printlist cat');
      for(var i =0 ;i<cars.docs.length;i++)
      {//print(cars.docs[i].data()['cat_id']);
        list_cat.add(int.parse(cars.docs[i].data()['cat_id']));
      }
      list_cat.sort();
      print(list_cat);
      var array_len = list_cat.length;
      print(array_len);
      print(list_cat[array_len-1]);
      setState(() {
        cat_max = list_cat[array_len-1]+ 1;


        print(cat_max);
        contCatid.text = cat_max.toString();
      });
    }

    else
    {
      print("error");
    }


  }

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
  void initState() {
    state=0;
    // TODO: implement initState
    super.initState();
    getData().then((results) {
      setState(() {
        cars = results;

        printlist();
      });
    });


  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color pyellow = Color(Colors.amber);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: Appdrawer(),
      body:
      GestureDetector(
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
                  color: Red_deep,
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
                  Navigator.popAndPushNamed(context, "/main_page");
                 // _scaffoldKey.currentState.openDrawer();

                  // Navigator.pushNamed(context, "/template");
                },
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close),
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
                  /* decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              Colors.red,
                            Colors.orange

                            //Color(getColorHexFromStr('#FDD100')),
                             //Color(getColorHexFromStr('#FDD120'))
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
*/
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      height: 600,
                      width: 400,
                      child: new Center(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                enabled: false,
                                controller: contCatid,
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
                                controller: contCatname,
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Please Category Name';
                                  }
                                },
                                onSaved: (input) => imagename = input,
                                decoration: InputDecoration(labelText: 'Cat Name',
                                ),

                                // obscureText: true,
                              )
                              ,
                              TextFormField(
                                controller: contCatdesc,
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Please Category Desc ';
                                  }
                                },
                                onSaved: (input) => imagename = input,
                                decoration: InputDecoration(labelText: 'Category Desc'),
                                // obscureText: true,
                              ),
                              /*
                TextFormField(
                  controller: contCatremark,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please Category Remark';
                    }
                  },
                  onSaved: (input) => imagename = input,
                  decoration: InputDecoration(labelText: 'Category Remark'),
                  // obscureText: true,
                ),
               */
                              RaisedButton(
                                elevation: 7.0,
                                child: Text("Save"),
                                //  Text("Upload"),
                                textColor: Colors.white,
                                color: Red_deep,
                                onPressed: () {


                                  addimagedata();
                                  Navigator.pop(context);
                                 // Navigator.pushNamed(context, '/CategoryMain2');
                                },
                              ),

//                              sampleimage == null ? Text("Select an image") : enableupload(),
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
//
//                                  ),
//
//                                  IconButton(
//                                    icon: Icon(Icons.add_a_photo),
//                                    onPressed: () {
//                                      getImagegalary();
//
//                                      setState(() {
//                                        state = 0;
//                                      });
//                                    },
//
//                                  )
//                                ],
//                              )
                            ],
                          )),
                    ),
                  ),
/*
FutureBuilder<List<UserModel>>(
future: db.getUserModelData(),
builder: (context, snapshot) {
if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
*/


              ),
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
            height: 200.0,
            width: 200.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                elevation: 7.0,
                child: Text("Compressed"),
                //  Text("Upload"),
                textColor: Colors.white,
                color: Color(getColorHexFromStr('#FDD148'),),
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
                color: Color(getColorHexFromStr('#FDD148'),),
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

    final StorageReference ref =
    FirebaseStorage.instance.ref().child('${contCatname.text}.jpg');
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
    currentdate=formatDate(todayDate, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    addimagedata();
    contCatid.text=(int.parse(contCatid.text)+1).toString();
    contCatname.clear();
    contCatdesc.clear();
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
      Im.Image smallerImage = Im.copyResize(image);
      // Im.copyResize(image, 100); // choose the size here, it will maintain aspect ratio

      var compressedImage = new File('$path/img$rand.jpg')
        ..writeAsBytesSync(Im.encodeJpg(image, quality: 50));
      setState(() {
        sampleimage = compressedImage;
      });
    }
  }

  addimagedata() {

    final todayDate = DateTime.now();
    currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    print(currentdate);
    FirebaseFirestore.instance.collection("PaymentsCategory").doc().set({
      'cat_id': contCatid.text,
      'cat_name': contCatname.text,
      'cat_desc': contCatdesc.text,
      'cat_date':currentdate,// contCatenterydate.text,
      'cat_img': url2 == null ? 'no image': url2
    });


    contCatid.text=(int.parse(contCatid.text)+1).toString();
    contCatname.clear();
    contCatdesc.clear();
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
