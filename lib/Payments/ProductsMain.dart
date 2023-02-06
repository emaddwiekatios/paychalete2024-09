
//import 'dart:html';
import 'package:paychalet/Payments/PaysEditNew.dart';
import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/Payments/PaysAddSt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import './Drawer.dart';
import 'dart:async';
import 'PaysDetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:paychalet/Payments/PaysMainHistoryOne.dart';

import 'dart:io' as plat;
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
class PaysMain extends StatefulWidget {

  @override
  _PaysMainState createState() => _PaysMainState();
}

class _PaysMainState extends State<PaysMain> {




  DateTime datetime;
  //////device info
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  String _messageTitle = "Waiting for Title...";
  String g_token ;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String Username;
  var Payment_max;
  QuerySnapshot cars;
  double sumprice = 0.0;double sumpricework = 0.0;
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



      subscripetotoken();
//     Textmsg1 = AppLocalizations.of(context).translate('Lots Of Nutritional');
//     Textmsg2 = AppLocalizations.of(context).translate('Sciences articles');
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {

          String psubtitle;
          String ptitle;
          String pplatform;
          if (Platform.isAndroid) {
            pplatform='Android';
            if (this.mounted) {
              setState(() {
                ptitle = '${message['notification']['title']}';
                psubtitle = '${message['notification']['body']}';
              });
            }
            // Android-specific code
          }
          else if (Platform.isIOS) {
            pplatform='IOS';
            if (this.mounted) {
              setState(() {
                ptitle = '${message['aps']['alert']['title']}';
                psubtitle = '${message['aps']['alert']['body']}';
//              ptitle='${message['notification']['title']}';
//              psubtitle='${message['notification']['body']}';

              });
            }
          }
          else
          {
            pplatform='others';
            if (this.mounted) {
              setState(() {
                ptitle = '${message['notification']['title']}';
                psubtitle = '${message['notification']['body']}';
              });
            }
          }
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(ptitle),//'${message['aps']['alert']['title']}'),
                subtitle: Text(psubtitle),//'${message['aps']['alert']['body']}'),

              ),

              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
          if (this.mounted) {
            setState(() {
              _messageText =
                  ptitle; //'${message['notification']['body']}';//['alert']['body']}";
              _messageTitle =
                  psubtitle; //'${message['notification']['title']}';
            });
          }
          //print("onMessage: ${message['notification']['title']}");
        },
        onLaunch: (Map<String, dynamic> message) async {
         // print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          //print("onResume: $message");
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
       // print("Settings registered: $settings");
      });
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        if (this.mounted) {
          setState(() {
           // print(token);
            _homeScreenText = "Push Messaging token: $token";
            _saveDeviceToken(token);
            call_get_data_token(token);
          });
        }

      });


      getUser().then((user) {
        if (user != null) {
          if (this.mounted) {
            setState(() {
              Username = user.email;
            //  print('Username0= ${Username}');
              call_get_data();
              paymentslist.removeAt(0);
            });
          }

        };
      });



    }


  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser;

    return user;
    //return user.email;
  }

    _saveDeviceToken(String ptoken) async {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      // Get the current user
      User  puser =await getCurrentUser();
      String uid = puser.uid.toString() ;
       String fcmToken =ptoken;
      // Save it to Firestore
      if (fcmToken != null) {

       var tokens = _db
            .collection('users')
            .doc(uid)
            .collection('tokens')
            .doc(fcmToken);

        await tokens.set({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': plat.Platform.operatingSystem// optional
        });




      }
    }

  void printlisttoken(p_token) {
    var cnt =0;
   // print('inside printlisttoken${carstoken.docs.length}');
    if (carstoken.docs.length>0) {
      for (var i = 0; i < carstoken.docs.length; i++) {
        if (p_token == carstoken.docs[i].data()['token'].toString()) {
          //print('inside if token exits new=0');
          cnt=1;
          return ;

        }
      }
      if(cnt==0)
      {
       // print('cnt=0 token not exists');
        addOrdersToken(p_token);
      }

    }
    else
    {
      //print('inside else token added =0');
      addOrdersToken(p_token);
    }
  }

  addOrdersToken(fcmToken) async{
    User  puser =await getCurrentUser();
    FirebaseFirestore.instance.collection("PaymentsToken").doc().set({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': plat.Platform.operatingSystem,// optional
      'username':puser.email
    });
  }

  call_get_data_token(ptoken)
  {
    getDatatoken().then((resultstoken) {
      if (this.mounted) {
        setState(() {
          carstoken = resultstoken;

          printlisttoken(ptoken);
        });
      }
    });
  }


  getDatatoken() async {
    return await FirebaseFirestore.instance.collection('PaymentsToken')
        .get();

  }

  call_get_data()
  {
    getData().then((results) {
      if (this.mounted) {
        setState(() {
          cars = results;

          printlist();
        });
      }
    });
  }
  var paymentslist = [
    {
      "Payment_id": "Weman Dress",
      "Payment_name": "Weman Dress",
      "Payment_desc": "Weman Dress",
      "Payment_amt": "7.0",
      "Payment_currency": "7.0",
      "Payment_modify_date": "2020-10-10",
      "Payment_entry_date":  "2020-10-10",
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
      "Payment_modify_date":  "2020-10-10",
      "Payment_entry_date":  "2020-10-10",
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
      "Payment_modify_date":  "2020-10-10",
      "Payment_entry_date":  "2020-10-10",
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
      "Payment_modify_date":  "2020-10-10",
      "Payment_entry_date":  "2020-10-10",
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
      "Payment_modify_date":  "2020-10-10",
      "Payment_entry_date":  "2020-10-10",
      "Payment_Fav": 'True',
      "Payment_cat": "Weman Dress",
      "Payment_img":
          'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
    }
  ];

  TextEditingController contsearch = new TextEditingController();

  void gettypetotalprice() {
    sumprice = 0.0;
    sumpricework = 0.0;
    int len = paymentslist.length;
    double loc_sum = 0.0;double loc_sum_work = 0.0;
    for (int i = 0; i < len; i++) {
    //  print(paymentslist[i]['Payment_cat']);

      if (paymentslist[i]['Payment_cat'] != 'مصاريف ‏تشغيلية') {
        var temp = (paymentslist[i]['Payment_amt']) != null
            ? paymentslist[i]['Payment_amt']
            : 0.0;
        loc_sum = loc_sum + double.parse(temp);
      }
      else {//print('inside work cat');  print(loc_sum_work);
        var tempwork = (paymentslist[i]['Payment_amt']) != null
            ? paymentslist[i]['Payment_amt']
            : 0.0;
        loc_sum_work = loc_sum_work + double.parse(tempwork);
      }
    }
      if (this.mounted) {
        setState(() {
          sumprice = loc_sum;  sumpricework = loc_sum_work;
        });
      }

  }




final _scrffordkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      key: _scrffordkey,
      drawer: Appdrawer(appLanguage: appLanguage,),
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
            left: MediaQuery.of(context).size.width / 3.5,//- ('Payments').length,
            right:MediaQuery.of(context).size.width /  3.5,//- ('Payments').length,
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('Payments'),
                style: TextStylelarg(pheight,Colors.black),//TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
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
               // print(('Payments').length);
               // print(('PaymentsHistory').length);
               // print(MediaQuery.of(context).size.width);
           //print('inside menu');
                _scrffordkey.currentState.openDrawer();
             //   FirebaseAuth.instance.signOut();
               // Navigator.pushReplacementNamed(context, "/RegistrationWelcome");
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
                          new ProductAddSt(Docs_max:Payment_max ,)),
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
                children: [SizedBox(width: 0,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.red
                      //),
                    ),



                    height: MediaQuery.of(context).size.height / 22,
                    width: MediaQuery.of(context).size.width/3,

                    child: Center(child: Text('${AppLocalizations.of(context).translate('Work')}'+ ' : ${sumpricework}')
                    ),
                  ),
                  SizedBox(width: 0,),
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
                    //  print('inside change$value');
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
                             // print('inside clear');
                              contsearch.clear();
                              contsearch.text = null;
                              filterSearchResults(contsearch.text);
                              gettypetotalprice();
                            }),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText:AppLocalizations.of(context).translate('Search by Name') ,
                        hintStyle: TextStylesmall(pheight,Colors.grey)),//TextStyle(color: Colors.grey, fontFamily: 'Quicksand'))),
              ),
            ),
          ),
          ),


        ],
      ),
    );



  }
  Widget _BuildList() {
    return //paymentslist.length > 0
    //    ?
    RefreshIndicator(
     // key: refreshKey,
      child:  ListView.builder(
                  itemCount: paymentslist.length,
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
     if (this.mounted) {
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
     }

     return null;
   }




  getData() async {
    return await FirebaseFirestore.instance.collection('Payments')
       //.orderBy('Payment_id', descending: true)
          .where("Payment_user", isEqualTo:Username.toString())
          .get();

  }

  printlist() {
    if (cars != null) {
      paymentslist.clear();
      for (var i = 0; i < cars.docs.length; i++) {

        paymentslist.add({
          "Payment_id": cars.docs[i].data()['Payment_id'].toString(),
          "Payment_name": cars.docs[i].data()['Payment_name'],
          "Payment_desc": cars.docs[i].data()['Payment_desc'],
          "Payment_amt": cars.docs[i].data()['Payment_amt'],
          "Payment_fav": cars.docs[i].data()['rod_fav'].toString(),
          "Payment_cat": cars.docs[i].data()['Payment_cat'],
          "Payment_currency": cars.docs[i].data()['Payment_currency'],
          "Payment_entry_date": cars.docs[i].data()['Payment_entry_date'].toDate().toString(),
          "Payment_modify_date": cars.docs[i].data()['Payment_modify_date'].toDate().toString(),

          "Payment_img": cars.docs[i].data()['Payment_img'],
          "Payment_to": cars.docs[i].data()['Payment_to'],
          "Payment_from": cars.docs[i].data()['Payment_from'],
          "Payment_doc_id": cars.docs[i].id,
        });
      }
print(paymentslist.length);
      for (var i = 0; i < paymentslist.length; i++) {//print(int.parse(paymentslist[i]['Payment_id']));

       // for (var i = 0; i <35 ; i++) {

//          if (int.parse(paymentslist[i]['Payment_id'])>=370
//          && int.parse(paymentslist[i]['Payment_id'])<390) {
//            var url = ("http://emaddwiekat.atwebpages.com/Sales/Flutter/Addpaymentd.php");
//
//            http.post(url,body: {
//              "Payment_id": paymentslist[i]['Payment_id'],
//              "Payment_name": paymentslist[i]['Payment_name'],
//              "Payment_desc": paymentslist[i]['Payment_desc'],
//              "Payment_amt": paymentslist[i]['Payment_amt'],
//              "Payment_to": paymentslist[i]['Payment_to'],
//              "Payment_fav": paymentslist[i]['Payment_fav'],
//              "Payment_cat": paymentslist[i]['Payment_cat'],
//              "Payment_entry_date": paymentslist[i]['Payment_entry_date'],
//              // currentdate,
//              "Payment_modify_date": paymentslist[i]['Payment_modify_date'],
//              // currentdate,
//              "Payment_img": 'No',
//              "Payment_from": paymentslist[i]['Payment_from'],
//              "Payment_user": "e@abc.com",
//              "Payment_currency": paymentslist[i]['Payment_currency']
//            });
//          }

           //  print('inside add');
            // final todayDate = DateTime.now();
            //currentdate = formatDate(todayDate,
            //    [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);


         // }
        }

     // print(paymentslist);
    //  paymentslist.sort(
      //        (a, b) => int.parse(a['Payment_id']).compareTo(int.parse(b['Payment_id'])));
      var array_len = paymentslist.length;
      if (this.mounted) {
        setState(() {
          paymentslist.sort((a,b) =>
              int.parse(a['Payment_id']).compareTo(int.parse(b['Payment_id'])));

          Payment_max =
          ((int.parse(paymentslist[array_len - 1]['Payment_id']) + 1)
              .toString());
         // print('Payment_max${Payment_max}');

          paymentslist.sort((b,a) =>
              int.parse(a['Payment_id']).compareTo(int.parse(b['Payment_id'])));


          duplicateItems = paymentslist;
        });
      }
    } else {
      print("error");
    }

    gettypetotalprice();
  }


  Widget build_item(BuildContext context, int index) {

    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: InkWell(
            onTap: () {
            //  print('${paymentslist[index]['Payment_from']}');
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new PaysDetails(
                          Payment_id: paymentslist[index]['Payment_id'],
                          Payment_name: paymentslist[index]['Payment_name'],
                          Payment_desc: paymentslist[index]['Payment_desc'],
                          Payment_img: paymentslist[index]['Payment_img'],
                          Payment_amt: paymentslist[index]['Payment_amt'],
                          Payment_cat: paymentslist[index]['Payment_cat'],
                         // Payment_date: paymentslist[index]['Payment_date'],
                      Payment_entry_date: paymentslist[index]['Payment_entry_date'],
                      Payment_modify_date: paymentslist[index]['Payment_modify_date'],
                          Payment_doc_id: paymentslist[index]['Payment_doc_id'].toString(),
                       Payment_currency: paymentslist[index]['Payment_currency'],
                      Payment_to: paymentslist[index]['Payment_to'],
                      Payment_from: paymentslist[index]['Payment_from'],


                        )),
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
////                                          image: paymentslist[index]
////                                                          ['Payment_img']
////                                                      .toString() !=
////                                                  null
////                                              ? NetworkImage(
////                                                  paymentslist[index]
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
                                        paymentslist[index]['Payment_name'],
                                        style: TextStylemedium(pheight,Colors.black),
                                      ),
                                      SizedBox(width: 5.0),
                                    ],
                                  ),
                                  SizedBox(height: 0.0),

                                  //SizedBox(height: 7.0),
                                  //
                                  Text(
                                    '${AppLocalizations.of(context).translate('Amount') }: '  +
                                        paymentslist[index]['Payment_amt'] + (paymentslist[index]['Payment_currency']=='Dollar' ? ' \$':' sh'),
                                    style: TextStylesmall(pheight,Colors.amberAccent),
                                  ),
                                  Text(
                                    paymentslist[index]['Payment_cat'],
                                    style: TextStylesmall(pheight,Colors.black),
                                  ),

                                  Text( formatDate(
                                     DateTime.parse(paymentslist[index]['Payment_entry_date']),
                                      [yyyy, '-', mm, '-', dd]

                                  ),



                                    style: TextStylesmall(pheight,Colors.black),
                                  ),
                                  Text(paymentslist[index]['Payment_to'].toString(),
//                                      ( paymentslist[index]['Payment_to'].length > 19)
//                                        ? paymentslist[index]['Payment_to']
//                                        .substring(0, 19)
//                                        : paymentslist[index]['Payment_to'],
                                    style: TextStylesmall(pheight,Colors.black),
                                  ),

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
                                            paymentslist[index]['Payment_from']!=null ? (paymentslist[index]['Payment_from'].length>=6?
                                            '${paymentslist[index]['Payment_from'].substring(0,1)}+${paymentslist[index]['Payment_from'].substring(5,6)}':paymentslist[index]['Payment_from'].substring(0,1)) : '0',
                                            style: TextStylesmall(pheight,Colors.black),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                             paymentslist[index]['Payment_id'],
                                            style: TextStylesmall(pheight,Colors.black),
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
                                          if (this.mounted) {
                                            showAlertDialog(context,index);
//                                            setState(() {
//                                              print(paymentslist[index]
//                                              ['Payment_doc_id']
//                                                  .toString());
//
//                                              deleteData(paymentslist[index]
//                                              ['Payment_doc_id']
//                                                  .toString()
//                                                //paymentslist[index]['Payment_img']
//                                              );
//                                              paymentslist.removeAt(index);
//                                              gettypetotalprice();
//                                            });
                                          }

                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.history, color: Colors.red),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                new PaysMainHistoryOne(
                                                  Payment_id: paymentslist[index]['Payment_id'],

                                                )),);


//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new ProductsEditNew(
//                            Payment_id: paymentslist[index]['Payment_id'],
//                            Payment_name: paymentslist[index]['Payment_name'],
//                            Payment_desc: paymentslist[index]['Payment_desc'],
//                            Payment_img: paymentslist[index]['Payment_img'],
//                            Payment_amt: paymentslist[index]['Payment_amt'],
//                            Payment_to: paymentslist[index]['Payment_to'],
//                            Payment_cat: paymentslist[index]['Payment_cat'],
//                           Payment_entry_date: paymentslist[index]['Payment_entry_date'],
//                           Payment_modify_date: paymentslist[index]['Payment_modify_date'],
//                            Payment_doc_id: paymentslist[index]['Payment_doc_id'].toString(),
//                                                )),);

//                                        );
                                        },
                                      )
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
        .collection('Payments')
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
  //  print(duplicateItems);
    // duplicateItems.removeAt(0);
    //dummyListData.removeAt(0);
    //paymentslist.clear();
    // List<Clients> dummySearchList = List<Clients>();
    dummySearchList = duplicateItems;
    if (query.isNotEmpty) {
     // print('inside if');
      dummyListData.clear();
      // List<Clients> dummyListData = List<Clients>();
      dummySearchList.forEach((item) {
        //print(item['Payment_name']);
        if (item['Payment_name'].toUpperCase().contains(query.toUpperCase()) ||
            item['Payment_name'].contains(query)) {
          //print('inside if ${item['Payment_name']}');
          dummyListData.add(item);
        }
      });
      if (this.mounted) {
        setState(() {
          //  paymentslist=null;
          paymentslist = dummyListData;
        });
      }
     // print('the list search${paymentslist}');
      return;
    } else {
      if (this.mounted) {
        setState(() {
          //paymentslist.clear();
          paymentslist = duplicateItems;
        });
      }
    }

  //  print('the list search${paymentslist}');
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

          setState(() {
            deleteData(paymentslist[index]
            ['Payment_doc_id']
                .toString()
              //paymentslist[index]['Payment_img']
            );
            paymentslist.removeAt(index);
            gettypetotalprice();
          });


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





