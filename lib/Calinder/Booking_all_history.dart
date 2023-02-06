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
//import '../eventclass/eventclassAdd.dart';
import 'dart:async';
//import 'PaysDetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:paychalet/Payments/PaysMainHistoryOne.dart';
import 'package:date_format/date_format.dart';
import 'dart:io' as plat;

import 'Booking.dart';
import 'BookingAdd.dart' as add;
import 'BookingEdit_all.dart';
//import 'eventclassDetails.dart';

class Booking_all_history extends StatefulWidget {
  String Booking_no;
  Booking_all_history({
    this.Booking_no,
});

  @override
  _Booking_all_historyState createState() => _Booking_all_historyState();
}

class _Booking_all_historyState extends State<Booking_all_history> {




  DateTime datetime;
  //////device info
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  String _messageTitle = "Waiting for Title...";
  String g_token ;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String Username;
  var Shack_max;
  List<eventclass> instlist = [];
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
      print('inside  get user');if (user != null) {
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
  {print('inside  get data');
    getData().then((results) {
      setState(() {
        cars = results;

        printlist();
      });
    });
  }

 
  //List<eventclass> instlist = List<eventclass>();
  List<eventclass> listtemp;
  List<eventclass> dummyListData = List<eventclass>();
  List<eventclass> duplicateItems2 = List<eventclass>();
  List<eventclass> duplicateItems = List<eventclass>();
  List<eventclass> dummySearchList = List<eventclass>();



  TextEditingController contsearch = new TextEditingController();

  void gettypetotalprice() {
    sumprice = 0.0;
    int len = instlist.length;
    double loc_sum = 0.0;
    for (int i = 0; i < len; i++) {
      // print(instlist[i]['Payment_amt']);
      var temp = (instlist[i].cust_pay) != null ? instlist[i].cust_pay: 0.0;
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
            left: MediaQuery.of(context).size.width / 3.5,//- ('eventclass').length,
            right:MediaQuery.of(context).size.width /  3.5,//- ('eventclass').length,
            child: Center(
              child: Text(//'eventclass',
                AppLocalizations.of(context).translate('Booking'),
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
                print(('eventclass').length);
                print(('eventclassHistory').length);
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
              icon: Icon(Icons.arrow_back, size: 30),
              onPressed: () {
                Navigator.pop(context);

                // _scaffoldKey.currentState.openDrawer();

//                Navigator.of(context).push(
//                  new MaterialPageRoute(
//                      builder: (BuildContext context) =>
//                      new ShackAdd(Docs_max: Shack_max,Docs_max_ref: Shack_max_ref,)),
//                );
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
                        instlist.sort((a,b) =>
                            a.booking_date.compareTo(b.booking_date));

                        print(instlist);
                        for (int i =0 ;i<instlist.length;i++)
                          {
                            print(instlist[i].booking_entry_date);
                          
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
                        instlist.sort((b,a) =>
                            a.booking_no.compareTo(b.booking_no));
                        print(instlist);
                        for (int i =0 ;i<instlist.length;i++)
                        {
                          print(instlist[i].booking_entry_date);
                          print(instlist[i].booking_no);
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
    return //instlist.length > 0
      //    ?
      RefreshIndicator(
        // key: refreshKey,
          child:  ListView.builder(
              itemCount: instlist.length,
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
    return await FirebaseFirestore.instance.collection('eventshistory')
      //  .where("Payment_user", isEqualTo:Username.toString())
       .where("booking_no", isEqualTo: int.parse(widget.Booking_no))
        .get();

  }

  printlist() {print('inside  printlist');
    if (cars != null) {
      print('inside if${cars.docs.length}');
      setState(() {
        instlist.clear();
       // _events = {};
      });

      for (var i = 0; i < cars.docs.length; i++) {
         print('inside for $i');  print(cars.docs);
        eventclass instone = new eventclass();
        instone.booking_no = cars.docs[i].data()['booking_no'];
        instone.booking_date = cars.docs[i].data()['booking_date'].toDate();
        instone.booking_entry_date =
            cars.docs[i].data()['booking_entry_date'].toDate();
        instone.booking_startTime =
            cars.docs[i].data()['booking_startTime'].toDate();

        instone.booking_endTime =
            cars.docs[i].data()['booking_endTime'].toDate();
        instone.cust_name = cars.docs[i].data()['cust_name'];
        instone.cust_mobile = cars.docs[i].data()['cust_mobile'];
        instone.booking_desc = cars.docs[i].data()['booking_desc'];
        instone.cust_pay = cars.docs[i].data()['cust_pay'];
        instone.booking_by = cars.docs[i].data()['booking_by'];
        instone.booking_type = cars.docs[i].data()['booking_type'];
        instone.booking_status = cars.docs[i].data()['booking_status'];
        instone.docs_id = cars.docs[i].id;
        //instlist.add(instone);
      //  _selectedDay = instone.booking_date;
         print(cars.docs[i].data()['cust_name']);
        setState(() {
          instlist.add(instone);
        });
      }
      if(instlist.length>0) {
        print(instlist.length);
        instlist.sort(
                (a, b) => a.booking_no.compareTo(b.booking_no));
        var array_len = instlist.length;
        setState(() {
          Shack_max = ((instlist[array_len - 1].booking_no + 1)
              .toString());

//          Shack_max_ref =((instlist[array_len - 1].booking_no_ref + 1)
//              .toString());



          instlist.sort((a,b) =>
              a.booking_date.compareTo(b.booking_date));





          duplicateItems = instlist;
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
              eventclass event1 = instlist[index];
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new BookingEdit_all( evn: event1,)


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
////                                          image: instlist[index]
////                                                          ['Payment_img']
////                                                      .toString() !=
////                                                  null
////                                              ? NetworkImage(
////                                                  instlist[index]
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
                                        instlist[index].cust_name.toString(),
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
                                        (instlist[index].cust_pay).toString()+ (instlist[index].booking_status=='Dollar' ? ' \$':' sh'),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                        color: Color(0xFFFDD34A)),
                                  ),
                                  Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        instlist[index].booking_desc,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.black),
                                      ),
                                      SizedBox(width:20),
                                      Container(
                                          height:25 ,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.amber,
                                          ),
                                          child:Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Center(child: Text(instlist[index].booking_type)),
                                          )
                                      ),
                                    ],
                                  ),

                                  Text(
    'Entry: ${formatDate(instlist[index].booking_entry_date,[yyyy,'-',M,'-',dd])}'
                                    ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    'Date: ${formatDate(instlist[index].booking_date,[yyyy,'-',M,'-',dd])}'
                                    ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.black),
                                  ),
                                  Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('From : ${formatDate(instlist[index].booking_startTime,[dd,':',hh])}',
//                                      ( instlist[index]['Payment_to'].length > 19)
//                                        ? instlist[index]['Payment_to']
//                                        .substring(0, 19)
//                                        : instlist[index]['Payment_to'],
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Colors.black),
                                      ),
                                      SizedBox(width:20),
                                      Text('To : ${formatDate(instlist[index].booking_endTime,[dd,':',hh])}',
//                                      ( instlist[index]['Payment_to'].length > 19)
//                                        ? instlist[index]['Payment_to']
//                                        .substring(0, 19)
//                                        : instlist[index]['Payment_to'],
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height:25 ,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: instlist[index].booking_date.isAfter(DateTime.now()) ? Colors.lightBlue :Colors.green,
                                    ),
                                    child:Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(child: Text(instlist[index].booking_status)),
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
                                            '${instlist[index].booking_by!=null ? instlist[index].booking_by : 0}',
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            'No :' + instlist[index].booking_no.toString(),
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
                                          showAlertDialog(context,index);
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
//                                                new Booking_all_historyHistoryOne(
//                                                  Payment_id: instlist[index]['Payment_id'],
//
//                                                )),);


//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new ProductsEditNew(
//                            Payment_id: instlist[index]['Payment_id'],
//                            Payment_name: instlist[index]['Payment_name'],
//                            Payment_desc: instlist[index]['Payment_desc'],
//                            Payment_img: instlist[index]['Payment_img'],
//                            Payment_amt: instlist[index]['Payment_amt'],
//                            Payment_to: instlist[index]['Payment_to'],
//                            Payment_cat: instlist[index]['Payment_cat'],
//                           Payment_entry_date: instlist[index]['Payment_entry_date'],
//                           Payment_modify_date: instlist[index]['Payment_modify_date'],
//                            Payment_doc_id: instlist[index]['Payment_doc_id'].toString(),
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
        .collection('events')
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
    //instlist.clear();

    // List<Clients> dummySearchList = List<Clients>();
    dummySearchList = duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      dummyListData.clear();
      // List<Clients> dummyListData = List<Clients>();
      dummySearchList.forEach((item) {
        //print(item['Payment_name']);
        if (item.cust_name.toUpperCase().contains(query.toUpperCase()) ||
            item.cust_name.contains(query)) {
         // print('inside if ${item['Payment_name']}');
          dummyListData.add(item);
        }
      });
      setState(() {
        //  instlist=null;
        instlist = dummyListData;
      });
      print('the list search${instlist}');
      return;
    } else {
      setState(() {
        //instlist.clear();
        instlist = duplicateItems;
      });
    }

    print('the list search${instlist}');
  }

  showAlertDialog(BuildContext context,int  index) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Comfired"),
        onPressed:  () {


          print(instlist[index].docs_id
              .toString());

          deleteData(instlist[index].docs_id
              .toString());
          //instlist[index]['Payment_img']
          //);
          instlist.removeAt(index);
          gettypetotalprice();


          Navigator.pop(context);
        });


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete record"),
      content: Text("Are You Sure!   delete Record ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}





