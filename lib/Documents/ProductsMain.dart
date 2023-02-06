
//import 'dart:html';

import 'package:paychalet/Documents/ProductsEditNew.dart';
import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/Documents/ProductsAddSt.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';

import 'dart:async';
import 'ProductsDetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;


import 'dart:io' as plat;

class ProductsMain extends StatefulWidget {

  @override
  _ProductsMainState createState() => _ProductsMainState();
}

class _ProductsMainState extends State<ProductsMain> {





  //////device info
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  String _messageTitle = "Waiting for Title...";
  String g_token ;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String Username;
  var Docs_max;
  QuerySnapshot cars;

  QuerySnapshot carstoken;
  double sumprice = 0.0;

  StreamSubscription iosSubscription;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
void subscripetotoken()
{
  _firebaseMessaging.subscribeToTopic('tokens');

}
    @override
    void initState() {
      // TODO: implement initState
      super.initState();

     // getData2();

//      if (Platform.isIOS) {
//        iosSubscription = _firebaseMessaging.onIosSettingsRegistered.listen((data) {
//          // save the token  OR subscribe to a topic here
//        });
//
//        _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
//      }

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
            setState(() {
              ptitle='${message['notification']['title']}';
              psubtitle='${message['notification']['body']}';

            });
            // Android-specific code
          }
          else if (Platform.isIOS) {
            pplatform='IOS';
            setState(() {
              ptitle='${message['aps']['alert']['title']}';
              psubtitle='${message['aps']['alert']['body']}';
//              ptitle='${message['notification']['title']}';
//              psubtitle='${message['notification']['body']}';

            });
          }
          else
          {
            pplatform='others';
            setState(() {
              ptitle='${message['notification']['title']}';
              psubtitle='${message['notification']['body']}';

            });
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
        setState(() {
          _messageText = ptitle; //'${message['notification']['body']}';//['alert']['body']}";
          _messageTitle = psubtitle ;//'${message['notification']['title']}';
        });
        print("onMessage: ${message['notification']['title']}");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        setState(() {
          _homeScreenText = "Push Messaging token: $token";
          _saveDeviceToken(token);
          call_get_data_token(token);
        });

      });


      getUser().then((user) {
        if (user != null) {
          setState(() {
            Username = user.email;
            print('Username0= ${Username}');
            call_get_data();
            docslist.removeAt(0);
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

    _saveDeviceToken(String ptoken) async {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      // Get the current user
      User  puser =await getCurrentUser();
      String uid = puser.uid.toString() ;
      // FirebaseUser user = await _auth.currentUser();

      // Get the token for this device
      //String fcmToken = await _firebaseMessaging.getToken();
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
          'platform': plat.Platform.operatingSystem,// optional
          'username':puser.email
        });
      }
    }


  addOrdersToken(fcmToken) async{
    User  puser =await getCurrentUser();
    FirebaseFirestore.instance.collection("OrdersToken").doc().set({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': plat.Platform.operatingSystem,// optional
      'username':puser.email
    });
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

  call_get_data_token(ptoken)
  {
    getDatatoken().then((resultstoken) {
      setState(() {
        carstoken = resultstoken;

        printlisttoken(ptoken );
      });
    });
  }


  var docslist = [
    {
      "Docs_id": "Weman Dress",
      "Docs_name": "Weman Dress",
      "Docs_desc": "Weman Dress",
      "Docs_price": "7.0",
      "Docs_date": "Weman Dress",
      "Docs_Fav": 'True',
      "Docs_cat": "Weman Dress",
      "Docs_img":
          'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
    }
  ];

  var list = [
    {
      "Docs_id": "Weman Dress",
      "Docs_name": "Weman Dress",
      "Docs_desc": "Weman Dress",
      "Docs_price": "7.0",
      "Docs_date": "Weman Dress",
      "Docs_Fav": 'True',
      "Docs_cat": "Weman Dress",
      "Docs_img":
          'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
    }
  ];
  var dummySearchList = [
    {
      "Docs_id": "Weman Dress",
      "Docs_name": "Weman Dress",
      "Docs_desc": "Weman Dress",
      "Docs_price": "7.0",
      "Docs_date": "Weman Dress",
      "Docs_Fav": 'True',
      "Docs_cat": "Weman Dress",
      "Docs_img":
          'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
    }
  ];
  var duplicateItems = [
    {
      "Docs_id": "Weman Dress",
      "Docs_name": "Weman Dress",
      "Docs_desc": "Weman Dress",
      "Docs_price": "7.0",
      "Docs_date": "Weman Dress",
      "Docs_Fav": 'True',
      "Docs_cat": "Weman Dress",
      "Docs_img":
          'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
    }
  ];

  var dummyListData = [
    {
      "Docs_id": "Weman Dress",
      "Docs_name": "Weman Dress",
      "Docs_desc": "Weman Dress",
      "Docs_price": "7.0",
      "Docs_date": "Weman Dress",
      "Docs_Fav": 'True',
      "Docs_cat": "Weman Dress",
      "Docs_img":
          'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
    }
  ];

  TextEditingController contsearch = new TextEditingController();

  void gettypetotalprice() {
    sumprice = 0.0;
    int len = docslist.length;
    double loc_sum = 0.0;
    for (int i = 0; i < len; i++) {
      print(docslist[i]['Docs_price']);

      loc_sum = loc_sum + double.parse(docslist[i]['Docs_price']);
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
                color: pcolor2,
              ),
            ),
          ),
          Positioned(
            top: 125,
            left: -150,
            child: Container(
              height: 450, //MediaQuery.of(context).size.height / 4,
              width: 450, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color:pcolor3,// Color(getColorHexFromStr('#FDD110')),
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
                  color: pcolor1,//red2,
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
                color: pcolor4,//red2,
                //),
              ),
            ),
          ),
//title
          Positioned(
            top: MediaQuery.of(context).size.height / 22,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: Text(
              AppLocalizations.of(context).translate('docs'),
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),
          //menu
          Positioned(
            top: pheight / 30,
            left: pwidth / 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
           //print('inside menu');
            //    _scrffordkey.currentState.openDrawer();
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
                          new ProductAddSt(Docs_max: Docs_max)),
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
                            color: pcolor2,
                            size: 30.0),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.cancel,
                                color: pcolor2,
                                size: 30.0),
                            onPressed: () {
                              print('inside clear');
                              contsearch.clear();
                              contsearch.text = null;
                              filterSearchResults(contsearch.text);
                              gettypetotalprice();
                            }),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText:AppLocalizations.of(context).translate('Search') ,
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
    return //docslist.length > 0
    //    ?
    RefreshIndicator(
     // key: refreshKey,
      child:  ListView.builder(
                  itemCount: docslist.length,
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
    return await FirebaseFirestore.instance.collection('Document')
          .where("Docs_user", isEqualTo:Username.toString())
          .get();

  }

  getDatatoken() async {
    return await FirebaseFirestore.instance.collection('OrdersToken')
        .get();

  }

  printlist() {
    if (cars != null) {
        docslist.clear();
        for (var i = 0; i < cars.docs.length; i++) {
          print(cars);
          docslist.add({
            "Docs_id": cars.docs[i].data()['Docs_id'].toString(),
            "Docs_name": cars.docs[i].data()['Docs_name'],
            "Docs_desc": cars.docs[i].data()['Docs_desc'],
            "Docs_price": cars.docs[i].data()['Docs_price'],
            "Docs_fav": cars.docs[i].data()['rod_fav'].toString(),
            "Docs_cat": cars.docs[i].data()['Docs_cat'],
            "Docs_date": cars.docs[i].data()['Docs_entry_date'].toString(),
            "Docs_img": cars.docs[i].data()['Docs_img'],
            "Docs_doc_id": cars.docs[i].id,
          });
        }

      docslist.sort(
          (a, b) => int.parse(a['Docs_id']).compareTo(int.parse(b['Docs_id'])));
      var array_len = docslist.length;
      setState(() {
        Docs_max = ((int.parse(docslist[array_len - 1]['Docs_id']) + 1)
            .toString());
        docslist.sort((b, a) =>
            int.parse(a['Docs_id']).compareTo(int.parse(b['Docs_id'])));

        duplicateItems = docslist;
      });
    } else {
      print("error");
    }
  }


  void printlisttoken(p_token) {
    var cnt =0;
    print('inside printlisttoken${carstoken.docs.length}');
    if (carstoken.docs.length>0) {
      for (var i = 0; i < carstoken.docs.length; i++) {
        if (p_token == carstoken.docs[i].data()['token'].toString()) {
          print('inside if token exits new=0');
          cnt=1;
          return ;

        }
      }
      if(cnt==0)
      {
        print('cnt=0 token not exists');
      addOrdersToken(p_token);
      }

    }
    else
    {
      print('inside else token added =0');
      addOrdersToken(p_token);
    }
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
                    builder: (BuildContext context) => new ProductsDetails(
                          Docs_id: docslist[index]['Docs_id'],
                          Docs_name: docslist[index]['Docs_name'],
                          Docs_desc: docslist[index]['Docs_desc'],
                          Docs_img: docslist[index]['Docs_img'],
                          Docs_price: docslist[index]['Docs_price'],
                          Docs_cat: docslist[index]['Docs_cat'],
                          Docs_date: docslist[index]['Docs_date'],
                          Docs_doc_id:
                              docslist[index]['Docs_doc_id'].toString(),
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
                        height: MediaQuery.of(context).size.height / 5.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  height:
                                      MediaQuery.of(context).size.height / 6.5,
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,

                                          //image: NetworkImage(user_img),
                                          image: docslist[index]
                                                          ['Docs_img']
                                                      .toString() !=
                                                  null
                                              ? NetworkImage(
                                                  docslist[index]
                                                      ['Docs_img'])
                                              : AssetImage('images/chris.jpg')

                                          // image: AssetImage('images/chris.jpg')
                                          )),
                                ),

                                //  SizedBox(width: 10.0),

                                //   SizedBox(width: 20),
                              ],
                            ),
                            SizedBox(width: 10),
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
                                      docslist[index]['Docs_name'],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    SizedBox(width: 15.0),
                                  ],
                                ),
                                SizedBox(height: 0.0),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Id: ' + docslist[index]['Docs_id'],
                                    ),
                                    SizedBox(width: 10.0),
                                  ],
                                ),
                                //SizedBox(height: 7.0),
                                //
                                Text(
                                  'Cost :\$ ' +
                                      docslist[index]['Docs_price'],
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color: Color(0xFFFDD34A)),
                                ),
                                Text(
                                  docslist[index]['Docs_cat'],
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.black),
                                ),
                                Text(
                                  docslist[index]['Docs_date'].length > 19
                                      ? docslist[index]['Docs_date']
                                          .substring(0, 19)
                                      : docslist[index]['Docs_date'],
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('$index'),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_sweep,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          deleteData(docslist[index]
                                                  ['Docs_doc_id']
                                              .toString(),docslist[index]
                                          ['Docs_img'] );
                                          docslist.removeAt(index);
                                          gettypetotalprice();
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.red),
                                      onPressed: () {


                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              new ProductsEditNew(

//                                        Navigator.of(context).push(
//                                          new MaterialPageRoute(
//                                              builder: (BuildContext context) =>
//                                              new ProductsEdit(
//
                          Docs_id: docslist[index]['Docs_id'],
                          Docs_name: docslist[index]['Docs_name'],
                          Docs_desc: docslist[index]['Docs_desc'],
                          Docs_img: docslist[index]['Docs_img'],
                          Docs_price: docslist[index]['Docs_price'],
                          Docs_cat: docslist[index]['Docs_cat'],
                          Docs_date: docslist[index]['Docs_date'],
                          Docs_doc_id: docslist[index]['Docs_doc_id'].toString(),

                                              )),);
//
//                                        );
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )))),
          ),
        ),
        Positioned(
          top: 10,
          left: 20,
          child: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        )

      ],
    );
  }

  deleteData(docId ,imageurl) async {
    if (imageurl != null) {
      StorageReference storageReference =
      await FirebaseStorage.instance.getReferenceFromUrl(imageurl);

      print(storageReference.path);

      await storageReference.delete();

      print('image deleted');
    }
    FirebaseFirestore.instance
        .collection('Document')
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
    //docslist.clear();
    // List<Clients> dummySearchList = List<Clients>();
    dummySearchList = duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      dummyListData.clear();
      // List<Clients> dummyListData = List<Clients>();
      dummySearchList.forEach((item) {
        //print(item['Docs_name']);
        if (item['Docs_name'].toUpperCase().contains(query.toUpperCase()) ||
            item['Docs_name'].contains(query)) {
          print('inside if ${item['Docs_name']}');
          dummyListData.add(item);
        }
      });
      setState(() {
        //  docslist=null;
        docslist = dummyListData;
      });
      print('the list search${docslist}');
      return;
    } else {
      setState(() {
        //docslist.clear();
        docslist = duplicateItems;
      });
    }

    print('the list search${docslist}');
  }
}





