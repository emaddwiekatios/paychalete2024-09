import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/Payments/Drawer.dart';

import 'package:paychalet/Providers/AddProvider.dart';
//import 'package:paychalet/Providers/ProviderList.dart';

class SelectionProvider extends StatefulWidget {
  String SelectedProvivider;
  SelectionProvider({this.SelectedProvivider});
  @override
  _SelectionProviderState createState() => _SelectionProviderState();
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
//var catslist
//=[
//  {
//    "Provider_id":"Weman Dress",
//    "Provider_name":"Weman Dress",
//    "Provider_desc":"Weman Dress",
//    "Provider_remark":"Weman Dress",
//    "Provider_date":"Weman Dress",
//
//    "Provider_img":'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
//
//  }
//];

class _SelectionProviderState extends State<SelectionProvider> {
  int selectedCard = -1;



  getData() async {
    return await FirebaseFirestore.instance.collection('Providers').get();
  }


  printlist(){
    print('inside printlist');
    if (cars != null) {

      for(var i =0 ;i<cars.docs.length;i++)
      {
        print(cars.docs[i].data()['Provider_remark']);

        providerslist.add(
            {
              "Provider_id":cars.docs[i].data()['Provider_id'],
              "Provider_name":cars.docs[i].data()['Provider_name'],
              "Provider_desc":cars.docs[i].data()['Provider_desc'],
              "Provider_remark":cars.docs[i].data()['Provider_remark'],
              "Provider_date":cars.docs[i].data()['Provider_date'].toString(),

              "Provider_img":cars.docs[i].data()['Provider_img'],
              "Provider_doc_id"  : cars.docs[i].id.toString(),


            }

        );


      }
      providerslist.removeAt(0);

      print(providerslist);
    }

    else
    {
      print("error");
    }


  }

  void initState() {
    print("inside init");
    getData().then((results) {
      setState(() {

        cars = results;

        printlist();
      });
    });
    setState(() {
      //  printlist();
    });

    //   print("after init");

    super.initState();
  }
  var Provider_max;

  var providerslist
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

                Navigator.pop(context,widget.SelectedProvivider);
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

              child://ProviderList(),
              GridView.builder(

                  itemCount: providerslist.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                  ),
                  itemBuilder: (BuildContext context,int index){

                     return  Container(
                       //Image.network(productslist[index]['picture'], fit: BoxFit.cover, ),
                      child:Card(

                        clipBehavior: Clip.antiAlias,
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),


                        child: Hero(
                          tag:new Text("Hero1") //productname
                          ,child: Material(
                          color: selectedCard == index ? Red_deep1 : Colors.white,
                          child: InkWell(onTap: (){
                            print('Provider_name=${providerslist[index]['Provider_name']}');
                            setState(() {
                              widget.SelectedProvivider=providerslist[index]['Provider_name'];
                              selectedCard = index;
                              Navigator.pop(context,widget.SelectedProvivider);

                            });


                          },


                              child: GridTile(
                                header: Center(child: Text('${providerslist[index]['Provider_desc'].toString()}',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),

                                footer: Container(
                                    color: Colors.white70,
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:20.0),
                                            child: Center(child: new Text(providerslist[index]['Provider_name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),)),
                                          ),
                                        ),
//                       Padding(
//                         padding: const EdgeInsets.only(right:20.0,left:20),
//                         child: Text("\$${Provider_remark.toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
//                       )
//                       ,
                                        // Text("\$${prodoldprice}",
                                        // style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,
                                        // decoration: TextDecoration.lineThrough
                                        // )
                                        // ,)
                                      ],
                                    )



                                ),
                                // child: Image.asset(prodpicture,fit: BoxFit.cover,),
                                child: Center(child: Text("${providerslist[index]['Provider_remark'].toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                                //Image.network(cat_img,fit: BoxFit.cover,),
                              ),
                            ),

                          ),
                        ),
                        ),


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


