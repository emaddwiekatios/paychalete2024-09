import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
import 'dart:ui';
import 'dart:math';
//import 'package:flutter_app_vetagable/Pages/colors.dart';
//import 'Category.dart';
//import './categoryAdd.dart';
//import 'package:paychalet/Products/Drawer.dart';

import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/Payments/Drawer.dart';

import 'AddProvider.dart';
import 'ProviderList.dart';

class ProvidersMain extends StatefulWidget {
  @override
  _ProvidersMainState createState() => _ProvidersMainState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Red_deep1;
Color colorTwo = Red_deep3;
Color colorThree = Red_deep2;

QuerySnapshot cars;
var Provider_max;
List<int> list_cat = [];
var catslist
=[
  {
    "Provider_id":"Weman Dress",
    "Provider_name":"Weman Dress",
    "Provider_desc":"Weman Dress",
    "Provider_remark":"Weman Dress",
    "Provider_date":"Weman Dress",

    "Provider_img":'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',

  }
];

class _ProvidersMainState extends State<ProvidersMain> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData().then((results) {
      setState(() {
        cars = results;

        printlist();
      });
    });

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
      drawer: Appdrawer(),
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
                color: Red_deep1,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -115,
            child: Container(
              height: 350, //MediaQuery.of(context).size.height / 4,
              width: 350, //MediaQuery.of(context).size.width,
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
            top: 75,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0
                  ? MediaQuery.of(context).size.height
                  : 775.0,

              child:ProviderList(),


            ),
          ),
          //header title
          Positioned(
            top: MediaQuery.of(context).size.height / 18,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Text(
              AppLocalizations.of(context).translate('Providers'),
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),







        ],
      ),

      floatingActionButton: new  FloatingActionButton(
        onPressed: ()
        {
          print(Provider_max);
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder:  (BuildContext context) => new AddProvider(Provider_max: Provider_max,)),
          );
          /*  FirebaseFirestore.instance.collection("cars").doc().setData({
            'carname':'bmw1',
             'color':'red2'
          });
          */
        },
        tooltip: 'Increement',
        child: new Icon(Icons.add),
        backgroundColor: Red_deep,
      ),

    );






  }

  getData() async {
    //return await FirebaseFirestore.instance.collection("Gym-Category").snapshots();


    return await FirebaseFirestore.instance.collection('Providers').get();

  }


  printlist(){
    if (cars != null) {
      list_cat.clear();
      for(var i =0 ;i<cars.docs.length;i++)
      {

        print(cars.docs[i].data()['Provider_id']);
        list_cat.add(int.parse(cars.docs[i].data()['Provider_id']));
        catslist.add(
            {
              "Provider_name":cars.docs[i].data()['Provider_name'],
              "Provider_desc":cars.docs[i].data()['Provider_desc'],
             // "Provider_remark":cars.docs[i].data()['Provider_remark'],
              "Provider_date":cars.docs[i].data()['Provider_date'].toString(),

              "Provider_img":cars.docs[i].data()['Provider_img'],
              "Provider_doc_id"  : cars.docs[i].id.toString(),


            }

        );


      }
      catslist.removeAt(0);
      print('list=====');

      list_cat.sort();
      print(list_cat);
      var array_len = list_cat.length;
      print(array_len);
      print(list_cat[array_len-1]);
      setState(() {
        Provider_max = list_cat[array_len-1]+ 1;


        print(Provider_max);
        //duplicateItems = catslist;
      });
    }

    else
    {
      print("error");
    }


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
/*
class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = Colors.purple[700];

    Offset circleCenter = Offset(size.width / 2, size.height - AVATAR_RADIUS);

    Offset topLeft = Offset(0, 0);
    Offset bottomLeft = Offset(0, size.height * 0.25);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, size.height * 0.5);

    Offset leftCurveControlPoint = Offset(circleCenter.dx * 0.5, size.height - AVATAR_RADIUS * 1.5);
    Offset rightCurveControlPoint = Offset(circleCenter.dx * 1.6, size.height - AVATAR_RADIUS);

    final arcStartAngle = 200 / 180 * pi;
    final avatarLeftPointX = circleCenter.dx + AVATAR_RADIUS * cos(arcStartAngle);
    final avatarLeftPointY = circleCenter.dy + AVATAR_RADIUS * sin(arcStartAngle);
    Offset avatarLeftPoint = Offset(avatarLeftPointX, avatarLeftPointY); // the left point of the arc

    final arcEndAngle = -5 / 180 * pi;
    final avatarRightPointX = circleCenter.dx + AVATAR_RADIUS * cos(arcEndAngle);
    final avatarRightPointY = circleCenter.dy + AVATAR_RADIUS * sin(arcEndAngle);
    Offset avatarRightPoint = Offset(avatarRightPointX, avatarRightPointY); // the right point of the arc

    Path path = Path()
      ..moveTo(topLeft.dx, topLeft.dy) // this move isn't required since the start point is (0,0)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftCurveControlPoint.dx, leftCurveControlPoint.dy, avatarLeftPoint.dx, avatarLeftPoint.dy)
      ..arcToPoint(avatarRightPoint, radius: Radius.circular(AVATAR_RADIUS))
      ..quadraticBezierTo(rightCurveControlPoint.dx, rightCurveControlPoint.dy, bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
*/