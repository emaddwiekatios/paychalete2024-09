import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:grouped_list/grouped_list.dart';

import "package:collection/collection.dart";

class PaysMainSummary extends StatefulWidget {
  @override
  _PaysMainSummaryState createState() => _PaysMainSummaryState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Colors.amber;
Color colorTwo = Colors.amber[300];
Color colorThree = Colors.amber[100];

List PaymentsCat = [];
List Paymentsfrom = [];



List paymentsgroup = [
  {
    "Payment_total": "7.0",
    "Payment_currency": "7.0",
    "Payment_cat": "Weman Dress",
  }
];

List paymentslist = [
  {
    "Payment_id": "Weman Dress",
    "Payment_name": "Weman Dress",
    "Payment_desc": "Weman Dress",
    "Payment_amt": "7.0",
    "Payment_currency": "7.0",
    "Payment_modify_date": "Weman Dress",
    "Payment_entry_date": "Weman Dress",
    "Payment_Fav": 'True',
    "Payment_cat": "Weman Dress",
    "Payment_img":
        'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
  }
];

class _PaysMainSummaryState extends State<PaysMainSummary> {
  printlist() {
    if (cars != null) {
      paymentslist.clear();
      PaymentsCat.clear();
       Paymentsfrom.clear();

      for (var i = 0; i < cars.docs.length; i++) {
        PaymentsCat.add(cars.docs[i].data()['Payment_cat']);
      //  Paymentsfrom.add(cars.docs[i].data()['Payment_from']);


        paymentslist.add({
          "Payment_id": cars.docs[i].data()['Payment_id'].toString(),
          "Payment_name": cars.docs[i].data()['Payment_name'],
          "Payment_desc": cars.docs[i].data()['Payment_desc'],
          "Payment_amt": cars.docs[i].data()['Payment_amt'],
          "Payment_fav": cars.docs[i].data()['rod_fav'].toString(),
          "Payment_cat": cars.docs[i].data()['Payment_cat'],
          "Payment_currency": cars.docs[i].data()['Payment_currency'],
          "Payment_entry_date":
          cars.docs[i].data()['Payment_entry_date'].toDate().toString(),
          "Payment_modify_date":
          cars.docs[i].data()['Payment_modify_date'].toDate().toString(),
          "Payment_img": cars.docs[i].data()['Payment_img'],
          "Payment_to": cars.docs[i].data()['Payment_to'],
          "Payment_doc_id": cars.docs[i].id,
        });
      }

      PaymentsCat = Set.of(PaymentsCat).toList();
      Paymentsfrom = Set.of(Paymentsfrom).toList();

      double temp_amt_sh = 0;
      double temp_amt_do = 0;
      paymentsgroup.clear();
      for (int i = 0; i < PaymentsCat.length; i++) {
        temp_amt_sh = 0.0;
        temp_amt_do = 0.0;
        for (int j = 0; j < paymentslist.length; j++) {
          if (paymentslist[j]['Payment_cat'] == PaymentsCat[i]) {
            if (paymentslist[j]['Payment_currency'] == 'Dollar') {
              temp_amt_do = temp_amt_do + double.parse(paymentslist[j]['Payment_amt']);
            }
            else {
              temp_amt_sh = temp_amt_sh + double.parse(paymentslist[j]['Payment_amt']);
            }
          }
        }
        paymentslist.removeAt(0);
        paymentsgroup.add({
          "Payment_cat": PaymentsCat[i].toString(),
          "Payment_currency": 'Dollar',
          "Payment_total": temp_amt_do,
        });
        paymentsgroup.add({
          "Payment_cat": PaymentsCat[i].toString(),
          "Payment_currency": 'Shakel',
          "Payment_total": temp_amt_sh,
        });
      }

      //print('group=');
     // print(paymentsgroup);
//      paymentslist.sort(
//              (a, b) => int.parse(a['Payment_id']).compareTo(int.parse(b['Payment_id'])));
//      var array_len = paymentslist.length;
//      setState(() {
//        Payment_max = ((int.parse(paymentslist[array_len - 1]['Payment_id']) + 1)
//            .toString());
//        paymentslist.sort((b, a) =>
//            int.parse(a['Payment_id']).compareTo(int.parse(b['Payment_id'])));
//
//        duplicateItems = paymentslist;
//      });

    for (int i=0; i< Paymentsfrom.length;i++)
      {

        print('the payment from =${Paymentsfrom[i].payment_from}');
      }


    } else {
      print("error");
    }

    // gettypetotalprice();
  }

  Future<User> getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return await _auth.currentUser;
  }

  //get payment
  getData() async {
    return await FirebaseFirestore.instance
        .collection('Payments')
          .where("Payment_user",isEqualTo: Username.toString())
          .get();
  }




  call_get_data() {
    getData().then((results) {
      setState(() {
        cars = results;

        printlist();
      });
    });
  }

  String Username;

  QuerySnapshot cars;
  QuerySnapshot carsgroups;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    getUser().then((user) {
      if (user != null) {
        setState(() {
          Username = user.email;
          print('Username0= ${Username}');
          call_get_data();
          //paymentslist.removeAt(0);
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    paymentslist.clear();
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
      body: GestureDetector(
        onTap: () {
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
                  color: Red_deep3,
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
                    borderRadius: BorderRadius.circular(200), color: Red_deep2),
              ),
            ),
            //menu
            Positioned(
              top: pheight / 25,
              left: pwidth / 20,
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
              top: pheight / 25,
              right: pwidth / 20,
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
              top: pheight / 8,
              right: 0,
              bottom: 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,

                child:
                  GridView.builder(
                      itemCount: paymentsgroup.length,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:3
                      ),
                      itemBuilder: (BuildContext context,int index){
                        return  _build_summary(
                          Payment_cat: paymentsgroup[index]['Payment_cat'],
                          Payment_currency: paymentsgroup[index]['Payment_currency'],
                          Payment_total: paymentsgroup[index]['Payment_total'].toString(),
                        );
                      }

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
      ),
    );
  }
}

class _build_summary extends StatelessWidget {
  final String Payment_cat;
  final String Payment_currency;
  final String Payment_total;
  _build_summary({
    this.Payment_cat,
    this.Payment_currency,
  this.Payment_total,
});
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Hero(
        tag: new Text("Hero1") //productname
        ,
        child: Material(
          child: InkWell(
            onTap: () {
              //  print('${cat_date}');
//          Navigator.of(context).push(
//            new MaterialPageRoute(
//                builder:  (BuildContext context) => new categorysdetails(
//
//                  cat_id:cat_id,
//                  cat_name: cat_name,
//                  cat_desc:cat_desc ,
//                  cat_img:cat_img ,
//                  cat_remark:cat_remark ,
//                  cat_date: cat_date,
//                  cat_doc_id: cat_doc_id,
//
//
//                )
//            ),
//          );
            },
            child: GridTile(
              header: Center(
                  child: Container(
                    color: Colors.black12,
                    child: Text(
                '${Payment_cat}',
                style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
                  )),

              footer: Container(
                  color: Colors.white70,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Center(
                              child: new Text(
                                Payment_currency,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          )),
                        ),
                      ),
                    ],
                  )

                  /*  ListTile(
                     leading: Text(productname , style: TextStyle(fontWeight: FontWeight.bold),

                     ),
                     title: Text("\$$prodprice",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800),),
                       subtitle: Text("\$$prodoldprice",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800,
                                                                       decoration: TextDecoration.lineThrough),),

                       ),
                */

                  ),
              // child: Image.asset(prodpicture,fit: BoxFit.cover,),
              child: Center(
                  child: Text(
                "${Payment_total}",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
              //Image.network(cat_img,fit: BoxFit.cover,),
            ),
          ),
        ),
      ),
    );
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


class payment_from_class
{
  String payment_from;
  double payment_total;
  payment_from_class({this.payment_from,this.payment_total});

}