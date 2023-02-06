import 'package:paychalet/Invoices/Invoices_Class.dart';
import 'package:paychalet/Payments/PaysEditNew.dart';
import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:paychalet/Payments/PaysAddSt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
//import 'package:paychalet/Payments/Drawer.dart';
import '../Shacks/ShacksAdd.dart';
import 'dart:async';
//import 'PaysDetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:paychalet/Payments/PaysMainHistoryOne.dart';
import 'package:date_format/date_format.dart';
import 'dart:io' as plat;

import 'Shack_Class.dart';
import 'ShacksDetails.dart';

class MainShacks_Future extends StatefulWidget {

  @override
  _MainShacks_FutureState createState() => _MainShacks_FutureState();
}

class _MainShacks_FutureState extends State<MainShacks_Future> {




  DateTime datetime;
  //////device info
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  String _messageTitle = "Waiting for Title...";
  String g_token ;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String Username;
  var Shack_max;

  var Shack_max_ref;
  QuerySnapshot cars;
  double sumprice = 0.0;
  QuerySnapshot carstoken;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  void subscripetotoken()
  {
    _firebaseMessaging.subscribeToTopic('tokens');

  }
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

        });

      };
    });



  }


  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser;

    return user;
    //return user.email;
  }











  call_get_data()
  {
    getData().then((results) {
      setState(() {
        cars = results;

        printlist();
      });
    });
  }

  /*
  var Shackslist = [
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

  var list = [
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
  var dummySearchList = [
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
  var duplicateItems = [
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

  var dummyListData = [
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
*/

  List<Shacks> Shackslist = List<Shacks>();
  List<Shacks> listtemp;
  List<Shacks> dummyListData = List<Shacks>();
  List<Shacks> duplicateItems2 = List<Shacks>();
  List<Shacks> duplicateItems = List<Shacks>();
  List<Shacks> dummySearchList = List<Shacks>();



  TextEditingController contsearch = new TextEditingController();

  void gettypetotalprice() {
    sumprice = 0.0;
    int len = Shackslist.length;
    double loc_sum = 0.0;
    for (int i = 0; i < len; i++) {
      // print(Shackslist[i]['Payment_amt']);
      var temp = (Shackslist[i].Shack_amt) != null ? Shackslist[i].Shack_amt: 0.0;
      loc_sum = loc_sum + temp ;
    }
    setState(() {
      sumprice = loc_sum;
    });
  }
  final _scrffordkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      key: _scrffordkey,
      // drawer: Appdrawer(appLanguage: appLanguage,),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
//background
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //borderRaOdius: BorderRadius.circular(200),
                color: Red_deep,
              ),
            ),
          ),
          Positioned(
            top: 145,
            left: -150,
            child: Container(
              height: 450, //MediaQuery.of(context).size.height / 4,
              width: 450, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color:Red_deep2,// Color(getColorHexFromStr('#FDD110')),
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
                color: Red_deep1,//red2,
                //      )
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: Container(
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: Red_deep2,//red2,
                //),
              ),
            ),
          ),
//title
          Positioned(
            top: MediaQuery.of(context).size.height / 22,
            left: MediaQuery.of(context).size.width / 3.5,//- ('Shacks').length,
            right:MediaQuery.of(context).size.width /  3.5,//- ('Shacks').length,
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('Shacks'),
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          //menu
          Positioned(
            top: pheight / 30,
            left: pwidth / 20,
            child: IconButton(
              icon: Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                print(('Shacks').length);
                print(('ShacksHistory').length);
                print(MediaQuery.of(context).size.width);
                print('inside menu');
                //_scrffordkey.currentState.openDrawer();
                //   FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/main_page");
              },
            ),
          ),
          Positioned(
            top: pheight / 30,
            right: pwidth / 20,
            child: IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () {

                // _scaffoldKey.currentState.openDrawer();

                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new ShackAdd(Docs_max: Shack_max,Docs_max_ref: Shack_max_ref,)),
                );
              },
            ),
          ),
//list
          Positioned(
            top: MediaQuery.of(context).size.height / 6,
            left: 5,
            right: 5,
            bottom: 10,
            child: Container(
              height: MediaQuery.of(context).size.height - 30,
              width: MediaQuery.of(context).size.width - 30,
              child: _BuildList(),

            ),
          ),
          Positioned(
            // top: MediaQuery.of(context).size.height / 6,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width,


              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.deepOrange[50],
                //),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text('Order By:'),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //   color:Colors.red
                      //),
                    ),



                    height: MediaQuery.of(context).size.height / 22,
                    width: MediaQuery.of(context).size.width/6,

                    child: IconButton(icon: Icon(Icons.calendar_today),onPressed: (){
                      setState(() {
                        Shackslist.sort((a,b) =>
                            a.Shack_come_date.compareTo(b.Shack_come_date));

                        print(Shackslist);
                        for (int i =0 ;i<Shackslist.length;i++)
                        {
                          print(Shackslist[i].Shack_come_date);
                          print(Shackslist[i].Shack_no);
                        }


                      });



                    },),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color:Colors.red
                      //),
                    ),



                    height: MediaQuery.of(context).size.height / 22,
                    width: MediaQuery.of(context).size.width/6,

                    child: IconButton(icon: Icon(Icons.arrow_drop_down),onPressed: (){
                      setState(() {
                        Shackslist.sort((b,a) =>
                            a.Shack_no.compareTo(b.Shack_no));
                        print(Shackslist);
                        for (int i =0 ;i<Shackslist.length;i++)
                        {
                          print(Shackslist[i].Shack_come_date);
                          print(Shackslist[i].Shack_no);
                        }



                      });



                    },),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.red
                      //),
                    ),



                    height: MediaQuery.of(context).size.height / 22,
                    width: MediaQuery.of(context).size.width/3,

                    child: Center(child: Text('${AppLocalizations.of(context).translate('Total')}'+ ' : ${sumprice}')
                    ),
                  ),
                ],
              ),

            ),
          ),

          //search
          Positioned(
            top: MediaQuery.of(context).size.height / 9,
            left: 10,
            right: 10,

            // left: MediaQuery.of(context).size.width / 2 - 70,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 30,
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(5.0),
                child: TextField(
                    controller: contsearch,
                    onChanged: (value) {
                      print('inside change$value');
                      filterSearchResults(value);
                      gettypetotalprice();
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search,
                            color: Red_deep,
                            size: 30.0),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.cancel,
                                color: Red_deep,
                                size: 30.0),
                            onPressed: () {
                              print('inside clear');
                              contsearch.clear();
                              contsearch.text = null;
                              filterSearchResults(contsearch.text);
                              gettypetotalprice();
                            }),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText:AppLocalizations.of(context).translate('Search by Name') ,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Quicksand'))),
              ),
            ),
          ),



        ],
      ),
    );



  }
  Widget _BuildList() {
    return //Shackslist.length > 0
      //    ?
      RefreshIndicator(
        // key: refreshKey,
          child:  ListView.builder(
              itemCount: Shackslist.length,
              itemBuilder: (BuildContext context, int index) {
                return build_item(context, index);
              }),
          onRefresh: refreshList
      );
    // : Center(child: CircularProgressIndicator());
  }
  ///

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      getUser().then((user) {
        if (user != null) {
          setState(() {
            //Username = user.email;
            // print('Username0= ${Username}');
            call_get_data();
          });

        };
      });
    });

    return null;
  }




  getData() async {
    return await FirebaseFirestore.instance.collection('Shacks')
    //.orderBy('Payment_id', descending: true)
        .where("Shack_user", isEqualTo:Username.toString())
        .get();

  }

  printlist() {
    if (cars != null) {
      Shackslist.clear();
      for (var i = 0; i < cars.docs.length; i++) {
        print(cars.docs[i].data()['Shack_owner_name']);
        Shacks _shackone = new Shacks()
          ..Shack_no=cars.docs[i].data()['Shack_no']
          ..Shack_no_ref=cars.docs[i].data()['Shack_no_ref']
          ..Shack_amt=cars.docs[i].data()['Shack_amt']
          ..Shack_currency=cars.docs[i].data()['Shack_currency'].toString()
          ..Shack_entry_date=cars.docs[i].data()['Shack_entry_date'].toDate()
          ..Shack_come_date=cars.docs[i].data()['Shack_come_date'].toDate()
          ..Shack_owner_name=cars.docs[i].data()['Shack_owner_name']
          ..Shack_for_name=cars.docs[i].data()['Shack_for_name']
          ..Shack_cat=cars.docs[i].data()['Shack_cat']
          ..Shack_doc=cars.docs[i].id;

        setState(() {
          if(_shackone.Shack_come_date.isAfter(DateTime.now())) {
            Shackslist.add(_shackone);
          }
        });
      }
      if(Shackslist.length>0) {

        Shackslist.sort(
                (a, b) => a.Shack_no.compareTo(b.Shack_no));
        var array_len = Shackslist.length;
        setState(() {
          Shack_max = ((Shackslist[array_len - 1].Shack_no + 1)
              .toString());

          Shack_max_ref =((Shackslist[array_len - 1].Shack_no_ref + 1)
              .toString());



          Shackslist.sort((a,b) =>
              a.Shack_come_date.compareTo(b.Shack_come_date));





          duplicateItems = Shackslist;
        });
      }



    } else {
      print("error");
    }

    gettypetotalprice();
  }

  Widget build_item(BuildContext context, int index) {
    return Stack(
      children: <Widget>[
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: InkWell(
            onTap: () {

              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new ShacksDetails( shack_inst: Shackslist[index],)


                ),
              );
            },
            child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 20,
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 5.0),
                        width: MediaQuery.of(context).size.width - 20.0,
                        height: MediaQuery.of(context).size.height / 5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
//                            Row(
//                              children: <Widget>[
////                                Container(
////                                  alignment: Alignment.topLeft,
////                                  height:
////                                      MediaQuery.of(context).size.height / 6.5,
////                                  width:
////                                      MediaQuery.of(context).size.width / 3.5,
////                                  decoration: BoxDecoration(
////                                      borderRadius: BorderRadius.circular(10.0),
////                                      image: DecorationImage(
////                                          fit: BoxFit.cover,
////
////                                          //image: NetworkImage(user_img),
////                                          image: Shackslist[index]
////                                                          ['Payment_img']
////                                                      .toString() !=
////                                                  null
////                                              ? NetworkImage(
////                                                  Shackslist[index]
////                                                      ['Payment_img'])
////                                              : AssetImage('images/chris.jpg')
////
////                                           //image: AssetImage('images/chris.jpg')
////                                          )),
////                                ),
//
//                                //  SizedBox(width: 10.0),
//
//                                //   SizedBox(width: 20),
//                              ],
//                            ),
                              //SizedBox(width: .4),
                              //name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Text(
                                        Shackslist[index].Shack_for_name.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      SizedBox(width: 15.0),
                                    ],
                                  ),
                                  SizedBox(height: 0.0),

                                  //SizedBox(height: 7.0),
                                  //
                                  Text(
                                    '${AppLocalizations.of(context).translate('Amount') }: '  +
                                        (Shackslist[index].Shack_amt).toString()+ (Shackslist[index].Shack_currency=='Dollar' ? ' \$':' sh'),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                        color: Color(0xFFFDD34A)),
                                  ),
                                  Text(
                                    Shackslist[index].Shack_owner_name,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.black),
                                  ),

                                  Text(
                                    '${formatDate(Shackslist[index].Shack_come_date,[yyyy,'-',M,'-',dd])}'
                                    ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.black),
                                  ),
                                  Text(Shackslist[index].Shack_for_name.toString(),
//                                      ( Shackslist[index]['Payment_to'].length > 19)
//                                        ? Shackslist[index]['Payment_to']
//                                        .substring(0, 19)
//                                        : Shackslist[index]['Payment_to'],
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.black),
                                  ),
                                  Container(
                                      height:25 ,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Shackslist[index].Shack_come_date.isAfter(DateTime.now()) ? Colors.lightBlue :Colors.green,
                                      ),
                                      child:Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text('Scheduale'),
                                      )
                                  )

                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[


                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${Shackslist[index].Shack_amt!=null ? Shackslist[index].Shack_amt : 0}',
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            'No :' + Shackslist[index].Shack_no.toString(),
                                          ),
                                          SizedBox(width: 10.0),

                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_sweep,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            print(Shackslist[index].Shack_doc
                                                .toString());

                                            deleteData(Shackslist[index].Shack_doc
                                                .toString());
                                            //Shackslist[index]['Payment_img']
                                            //);
                                            Shackslist.removeAt(index);
                                            gettypetotalprice();
                                          });
                                        },
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.history, color: Colors.red),
                                            onPressed: () {
//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new MainShacks_FutureHistoryOne(
//                                                  Payment_id: Shackslist[index]['Payment_id'],
//
//                                                )),);


//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new ProductsEditNew(
//                            Payment_id: Shackslist[index]['Payment_id'],
//                            Payment_name: Shackslist[index]['Payment_name'],
//                            Payment_desc: Shackslist[index]['Payment_desc'],
//                            Payment_img: Shackslist[index]['Payment_img'],
//                            Payment_amt: Shackslist[index]['Payment_amt'],
//                            Payment_to: Shackslist[index]['Payment_to'],
//                            Payment_cat: Shackslist[index]['Payment_cat'],
//                           Payment_entry_date: Shackslist[index]['Payment_entry_date'],
//                           Payment_modify_date: Shackslist[index]['Payment_modify_date'],
//                            Payment_doc_id: Shackslist[index]['Payment_doc_id'].toString(),
//                                                )),);

//                                        );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.history, color: Colors.red),
                                            onPressed: () {
//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new MainShacks_FutureHistoryOne(
//                                                  Payment_id: Shackslist[index]['Payment_id'],
//
//                                                )),);


//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new ProductsEditNew(
//                            Payment_id: Shackslist[index]['Payment_id'],
//                            Payment_name: Shackslist[index]['Payment_name'],
//                            Payment_desc: Shackslist[index]['Payment_desc'],
//                            Payment_img: Shackslist[index]['Payment_img'],
//                            Payment_amt: Shackslist[index]['Payment_amt'],
//                            Payment_to: Shackslist[index]['Payment_to'],
//                            Payment_cat: Shackslist[index]['Payment_cat'],
//                           Payment_entry_date: Shackslist[index]['Payment_entry_date'],
//                           Payment_modify_date: Shackslist[index]['Payment_modify_date'],
//                            Payment_doc_id: Shackslist[index]['Payment_doc_id'].toString(),
//                                                )),);

//                                        );
                                            },
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )))),
          ),
        ),
//        Positioned(
//          top: 10,
//          left: 20,
//          child: Icon(
//            Icons.favorite,
//            color: Colors.red,
//          ),
//        )



      ],
    );
  }

  deleteData(docId ) async {
    FirebaseFirestore.instance
        .collection('Shacks')
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Future<User> getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return await _auth.currentUser;
  }


  void filterSearchResults(String query) {
    print(duplicateItems);
    // duplicateItems.removeAt(0);
    //dummyListData.removeAt(0);
    //Shackslist.clear();

    // List<Clients> dummySearchList = List<Clients>();
    dummySearchList = duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      dummyListData.clear();
      // List<Clients> dummyListData = List<Clients>();
      dummySearchList.forEach((item) {
        //print(item['Payment_name']);
        if (item.Shack_for_name.toUpperCase().contains(query.toUpperCase()) ||
            item.Shack_for_name.contains(query)) {
          // print('inside if ${item['Payment_name']}');
          dummyListData.add(item);
        }
      });
      setState(() {
        //  Shackslist=null;
        Shackslist = dummyListData;
      });
      print('the list search${Shackslist}');
      return;
    } else {
      setState(() {
        //Shackslist.clear();
        Shackslist = duplicateItems;
      });
    }

    print('the list search${Shackslist}');
  }
}





