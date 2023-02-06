import 'package:paychalet/Invoices/Invoices_Class.dart';
import 'package:paychalet/Payments/PaysEditNew.dart';
import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/Invoices/Invoice_LV_Animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:date_format/date_format.dart';
import 'dart:io' as plat;
import 'NotesAdd.dart';
import 'NotesEdit.dart';
import 'Notes_Class.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class Note extends StatefulWidget {
  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  DateTime datetime;
  //////device info
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  String _messageTitle = "Waiting for Title...";
  String g_token;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String Username;
  var Note_max;
  var DEL_FLG=0;
  var Note_max_ref;
  QuerySnapshot cars;
  double sumprice = 0.0;
  QuerySnapshot carstoken;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  void subscripetotoken() {
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
      }
      ;
    });
  }

/*
  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser;

    return user;
    //return user.email;
  }
*/




  call_get_data() {
    getData().then((results) {
      setState(() {
        cars = results;

        printlist();
      });
    });
  }

  /*
  var Notelist = [
    {
      "Payment_id": "Weman Dress",
      "Payment_name": "WemanƒΩ Dress",
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

  List<Noteclass> Notelist = List<Noteclass>();
  List<Noteclass> listtemp;
  List<Noteclass> dummyListData = List<Noteclass>();
  List<Noteclass> duplicateItems2 = List<Noteclass>();
  List<Noteclass> duplicateItems = List<Noteclass>();
  List<Noteclass> dummySearchList = List<Noteclass>();

  TextEditingController contsearch = new TextEditingController();

//  void gettypetotalprice() {
//    sumprice = 0.0;
//    int len = Notelist.length;
//    double loc_sum = 0.0;
//    for (int i = 0; i < len; i++) {
//      // print(Notelist[i]['Payment_amt']);
//      var temp = (Notelist[i].Note_amt) != null ? Notelist[i].Note_amt : 0.0;
//      loc_sum = loc_sum + temp;
//    }
//    setState(() {
//      sumprice = loc_sum;
//    });
//  }

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
                color: Red_deep2, // Color(getColorHexFromStr('#FDD110')),
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
                color: Red_deep1, //red2,
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
                color: Red_deep2, //red2,
                //),
              ),
            ),
          ),
//title
          Positioned(
            top: MediaQuery.of(context).size.height / 22,
            left: MediaQuery.of(context).size.width / 3.5, //- ('Note').length,
            right:
                MediaQuery.of(context).size.width / 3.5, //- ('Note').length,
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('Booking_Notes'),
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
                print(('Note').length);
                print(('NoteHistory').length);
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
                      builder: (BuildContext context) => new NoteAdd(
                            Docs_max: Note_max,
                            Docs_max_ref: Note_max_ref,
                          )),
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
                children: [
                  Text('Order By:'),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //   color:Colors.red
                      //),
                    ),
                    height: MediaQuery.of(context).size.height / 22,
                    width: MediaQuery.of(context).size.width / 6,
                    child: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
//                        setState(() {
//                          Notelist.sort((a, b) =>
//                              a.Note_modify_date.compareTo(b.Note_modify_date));
//
//                          print(Notelist);
//                          for (int i = 0; i < Notelist.length; i++) {
//                            print(Notelist[i].Note_modify_date);
//                            print(Notelist[i].Note_no);
//                          }
//                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color:Colors.red
                      //),
                    ),
                    height: MediaQuery.of(context).size.height / 22,
                    width: MediaQuery.of(context).size.width / 6,
                    child: IconButton(
                      icon: Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        setState(() {
                          Notelist.sort(
                              (b, a) => a.Note_no.compareTo(b.Note_no));
                          print(Notelist);
                          for (int i = 0; i < Notelist.length; i++) {
                          //  print(Notelist[i].Note_modify_date);
                            print(Notelist[i].Note_no);
                          }
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red
                        //),
                        ),
                    height: MediaQuery.of(context).size.height / 22,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Center(
                        child: Text(
                            '${AppLocalizations.of(context).translate('Total')}' +
                                ' : ${sumprice}')),
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
                      //gettypetotalprice();
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon:
                            Icon(Icons.search, color: Red_deep, size: 30.0),
                        suffixIcon: IconButton(
                            icon:
                                Icon(Icons.cancel, color: Red_deep, size: 30.0),
                            onPressed: () {
                              print('inside clear');
                              contsearch.clear();
                              contsearch.text = null;
                              filterSearchResults(contsearch.text);
                            //  gettypetotalprice();
                            }),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText: AppLocalizations.of(context)
                            .translate('Search by Name'),
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
    return //Notelist.length > 0

        RefreshIndicator(child :   Container(
                                                    margin: EdgeInsets.symmetric(vertical: 5),
                                                    height: MediaQuery
                                                        .of(context)
                                                        .size
                                                          .height, //cell
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width , //cells
                                                    child:GridView.builder(
                                                      itemCount:Notelist.length,
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: MediaQuery.of(context).orientation ==
                                                            Orientation.landscape ? 3: 2,
                                                        crossAxisSpacing: 2,
                                                        mainAxisSpacing: 2,
                                                        childAspectRatio: (.6 / 1),
                                                      ),
                                                      itemBuilder: mycont
                                                    )



// StaggeredGridView.countBuilder(
//                                                      crossAxisCount: 4,
//                                                      itemCount: Notelist.length,
//                                                      itemBuilder: mycont,
//                                                      staggeredTileBuilder: (int index) =>
//                                                      new StaggeredTile.count(2, index.isEven ? 3 : 2),
//                                                      mainAxisSpacing: 2.0,
//                                                      crossAxisSpacing: 2.0,
//                                                    )




                                                  ),

            onRefresh: refreshList);
    // : Center(child: CircularProgressIndicator());
  }

  ///
  Widget mycont(BuildContext context,int index) {

    return InkWell(
      child: WidgetInvoice_LV_Animation(


       Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, //Color(getColorHexFromStr(pyellow3)),
                  offset: Offset(1.0,5.0),
                  blurRadius: 10,
                  spreadRadius: .2)
            ],

            borderRadius: BorderRadius.circular(5),
          ),
          width: MediaQuery
              .of(context)
              .size
              .width / 15,
          height: MediaQuery
              .of(context)
              .size
              .height/5,

      child: Card(color: Notelist[index].note_color.toString().length==0 ? Colors.blue :Notelist[index].note_color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: <Widget>[

          //  child: ListTile(

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(radius: 15,
                  child:
                  Text(Notelist[index].Note_desc.substring(0,1)
                      .toUpperCase()
                    ,style: TextStyle(
                        color: Colors.black),),
                  backgroundColor: Colors.grey[300],),
                Flexible(child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(Notelist[index].titel

                    ,style: TextStyle(
                        color: Colors.black),),
                ),),
                IconButton(
                  icon: Icon(
                    Icons.delete_sweep,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    showAlertDialog(context,index);
                  },
                ),

              ],
            ),
          ), //Text("Heading"),
          //  subtitle: Text(_products[index]), //Text("SubHeading"),
          //  ), final todayDate = DateTime.now();
          //    currentdate = formatDate(todayDate,
          //        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);
          // Flexible(
          //   child:

          Text('${formatDate(Notelist[index].Note_entry_date,[yyyy, '-', mm, '-', dd ])}',
              style: TextStyle(fontSize: 12)
          ),
          //),
          Divider(height: 7,color: Colors.black, endIndent: 10,thickness: 2,indent: 10,),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[

                Flexible(
                  child: Text(Notelist[index].Note_desc,
                      style: TextStyle(fontSize: 20)
                  ),
                ),


              ],
            ),
          ), //Text("Heading"),
          //  subtitle: Text(_products[index]), //Text("SubHeading"),
          //  ),

        ],
      ),
    ),
    )),
      onTap: () {
         print("inside index rrr${index.toString()}");
         Navigator.of(context).push(
           new MaterialPageRoute(
               builder: (BuildContext context) => new NotesEdit(instclass: Notelist[index],

               )),
         );

        // print("inside one ${list[index].CustomerName}");
        //filterSearchResults_cat(list[index]['cat_name']);
        setState(() {
         // customername2 = Notelist[index].Note_desc;
         // menu_client = false;
        });
      },
    );
  }

  Future<Null> refreshList() async {print('update list');
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
        }
        ;
      });
    });

    return null;
  }

  getData() async {
    return await FirebaseFirestore.instance
        .collection('Notes')
        //.orderBy('Payment_id', descending: true)
        .where("Note_user", isEqualTo: Username.toString())
        .get();
  }
//    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
//    int value = int.parse(valueString, radix: 16);
//    Color otherColor = new Color(value);
  printlist() {
    if (cars != null) {
      Notelist.clear();
      for (var i = 0; i < cars.docs.length; i++) {
        print(cars.docs[i].data()['Note_owner_name']);



       String valueString = cars.docs[i].data()['Note_color'].split('(0x')[1].split(')')[0]; // kind of hacky..
        int value = int.parse(valueString, radix: 16);
        Color otherColor = new Color(value);



        Noteclass _Noteone = new Noteclass()
          ..Note_no = cars.docs[i].data()['Note_no']

          ..Note_entry_date = cars.docs[i].data()['Note_entry_date'].toDate()
          ..Note_modify_date = cars.docs[i].data()['Note_Modify_date'].toDate()
          ..note_color = otherColor//Color(cars.docs[i].data()['Note_color'])
          ..titel = cars.docs[i].data()['titel']
          ..Note_desc = cars.docs[i].data()['Note_desc']
          ..Note_owner_name = cars.docs[i].data()['Note_owner_name']

          ..Note_doc = cars.docs[i].id;

        setState(() {
          Notelist.add(_Noteone);
        });
      }
      if (Notelist.length > 0) {
        Notelist.sort((a, b) => a.Note_no.compareTo(b.Note_no));
        var array_len = Notelist.length;
        setState(() {
          Note_max = ((Notelist[array_len - 1].Note_no + 1).toString());

          Note_max_ref =
              ((Notelist[array_len - 1].Note_no + 1).toString());

          Notelist.sort(
              (a, b) => a.Note_modify_date.compareTo(b.Note_modify_date));

          duplicateItems = Notelist;
        });
      }
    } else {
      print("error");
    }

 //   gettypetotalprice();
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
//              Navigator.of(context).push(
//                new MaterialPageRoute(
//                    builder: (BuildContext context) => new NoteDetails(
//                          Note_inst: Notelist[index],
//                        )),
//              );
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
                           color: Colors.white,
                           // borderRadius: BorderRadius.circular(10.0),
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
////                                          image: Notelist[index]
////                                                          ['Payment_img']
////                                                      .toString() !=
////                                                  null
////                                              ? NetworkImage(
////                                                  Notelist[index]
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
                                          Notelist[index]
                                              .Note_desc
                                              .toString(),
                                          style: TextStylemedium(
                                              pheight, Colors.black)),
                                      SizedBox(width: 15.0),
                                    ],
                                  ),
                                  SizedBox(height: 0.0),

                                  //SizedBox(height: 7.0),
                                  //
                                  Text(
                                    '${AppLocalizations.of(context).translate('Amount')}: ' +
                                        (Notelist[index].Note_no)
                                            .toString() +
                                        (Notelist[index].Note_no==
                                                'Dollar'
                                            ? ' \$'
                                            : ' sh'),
                                    style:
                                        TextStylesmall(pheight, Colors.amber),
                                  ),

                                  Text(
                                    '${formatDate(Notelist[index].Note_modify_date, [
                                      yyyy,
                                      '-',
                                      M,
                                      '-',
                                      dd
                                    ])}',
                                    style:
                                        TextStylesmall(pheight, Colors.black),
                                  ),
                                  Text(
                                    Notelist[index].Note_desc.toString(),
//                                      ( Notelist[index]['Payment_to'].length > 19)
//                                        ? Notelist[index]['Payment_to']
//                                        .substring(0, 19)
//                                        : Notelist[index]['Payment_to'],
                                    style:
                                        TextStylesmall(pheight, Colors.black),
                                  ),
                                  Container(
                                      height: 25,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Notelist[index]
                                                .Note_modify_date
                                                .isAfter(DateTime.now())
                                            ? Colors.lightBlue
                                            : Colors.green,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text('complete'),
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            Notelist[index].Note_desc,
                                            style: TextStylesmall(
                                                pheight, Colors.black),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            Notelist[index]
                                                .Note_no
                                                .toString(),
                                            style: TextStylesmall(
                                                pheight, Colors.black),
                                          ),
                                          SizedBox(width: 10.0), IconButton(
                                            icon: Icon(
                                              Icons.delete_sweep,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              MyDialog();}
                                              //showAlertDialog(context, index);if(DEL_FLG==1){
                                              //  print(DEL_FLG);setState(() {
                                                //  Notelist.removeAt(index);DEL_FLG=0;
                                                //});

                                            //},
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.history,
                                                color: Colors.red),
                                            onPressed: () {
//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new NoteHistoryOne(
//                                                  Payment_id: Notelist[index]['Payment_id'],
//
//                                                )),);

//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new ProductsEditNew(
//                            Payment_id: Notelist[index]['Payment_id'],
//                            Payment_name: Notelist[index]['Payment_name'],
//                            Payment_desc: Notelist[index]['Payment_desc'],
//                            Payment_img: Notelist[index]['Payment_img'],
//                            Payment_amt: Notelist[index]['Payment_amt'],
//                            Payment_to: Notelist[index]['Payment_to'],
//                            Payment_cat: Notelist[index]['Payment_cat'],
//                           Payment_entry_date: Notelist[index]['Payment_entry_date'],
//                           Payment_modify_date: Notelist[index]['Payment_modify_date'],
//                            Payment_doc_id: Notelist[index]['Payment_doc_id'].toString(),
//                                                )),);

//                                        );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.history,
                                                color: Colors.red),
                                            onPressed: () {
//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new NoteHistoryOne(
//                                                  Payment_id: Notelist[index]['Payment_id'],
//
//                                                )),);

//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new ProductsEditNew(
//                            Payment_id: Notelist[index]['Payment_id'],
//                            Payment_name: Notelist[index]['Payment_name'],
//                            Payment_desc: Notelist[index]['Payment_desc'],
//                            Payment_img: Notelist[index]['Payment_img'],
//                            Payment_amt: Notelist[index]['Payment_amt'],
//                            Payment_to: Notelist[index]['Payment_to'],
//                            Payment_cat: Notelist[index]['Payment_cat'],
//                           Payment_entry_date: Notelist[index]['Payment_entry_date'],
//                           Payment_modify_date: Notelist[index]['Payment_modify_date'],
//                            Payment_doc_id: Notelist[index]['Payment_doc_id'].toString(),
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

   deleteData(docId) async {
    FirebaseFirestore.instance
        .collection('Notes')
        .doc(docId)
        .delete().then((value) { setState(() {
      DEL_FLG=1;
        });  print('DEL_FLG indside delete ='); print(DEL_FLG);}).catchError((e) {
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
    //Notelist.clear();

    // List<Clients> dummySearchList = List<Clients>();
    dummySearchList = duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      dummyListData.clear();
      // List<Clients> dummyListData = List<Clients>();
      dummySearchList.forEach((item) {
        //print(item['Payment_name']);
        if (item.Note_desc.toUpperCase().contains(query.toUpperCase()) ||
            item.Note_desc.contains(query)) {
          // print('inside if ${item['Payment_name']}');
          dummyListData.add(item);
        }
      });
      setState(() {
        //  Notelist=null;
        Notelist = dummyListData;
      });
      print('the list search${Notelist}');
      return;
    } else {
      setState(() {
        //Notelist.clear();
        Notelist = duplicateItems;
      });
    }

    print('the list search${Notelist}');
  }

  showAlertDialog(BuildContext context, int index) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Comfired"),
        onPressed: () {

          setState(() {
            deleteData(Notelist[index].Note_doc
              //paymentslist[index]['Payment_img']
            );
            Notelist.removeAt(index);
           // gettypetotalprice();
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




            deleteData(Notelist[index].Note_doc
                .toString());
            print('DEL_FLG=');
            print(DEL_FLG);
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


}





class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  Color _c = Colors.redAccent;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: _c,
        height: 20.0,
        width: 20.0,
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Switch'),
            onPressed: () => setState(() {
              _c == Colors.redAccent
                  ? _c = Colors.blueAccent
                  : _c = Colors.redAccent;
            }))
      ],
    );
  }
}
