import 'package:flutter/material.dart';
import 'package:paychalet/Shacks/MainShacks.dart';
//import 'package:paychalet/Shacks/ProductsMain.dart';
import 'package:paychalet/main_page.dart';
import 'dart:ui';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:paychalet/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:firebase_auth/firebase_auth.dart';

import 'Shack_Class.dart';
import 'package:intl/intl.dart';

class ShackEdit extends StatefulWidget {

  
  Shacks shack_inst =new Shacks();
  ShackEdit({this.shack_inst});
//  final String Shack_id;
//  final String Shack_name;
//  final String Shack_desc;
//  final String Shack_price;
//  final String Shack_fav;
//  final String Shack_cat;
//  final String Shack_img;
//  final String Shack_date;
//  final String Shack_modify_date;
//  final String Shack_entry_date;
//  final String Shack_doc_id;
//  final String Shack_amt;
//  final String Shack_to;
//  final String Shack_from;
//  final String Shack_currency;
//
//  ShackEdit({
//    this.Shack_id,
//    this.Shack_name,
//    this.Shack_desc,
//    this.Shack_price,
//    this.Shack_fav,
//    this.Shack_cat,
//    this.Shack_img,
//    this.Shack_date,
//    this.Shack_modify_date,
//    this.Shack_entry_date,
//    this.Shack_doc_id,
//    this.Shack_amt,
//    this.Shack_to,
//
//    this.Shack_from,
//    this.Shack_currency
//  });
//


  @override
  _ShackEditState createState() => _ShackEditState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Colors.amber;
Color colorTwo = Colors.amber[300];
Color colorThree = Colors.amber[100];
QuerySnapshot cars;
QuerySnapshot cars_token;
QuerySnapshot carsproviders;

class _ShackEditState extends State<ShackEdit> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color pyellow = Color(Colors.amber);
  String imagename;

  TextEditingController contShack_no = new TextEditingController();
  TextEditingController contShack_no_ref = new TextEditingController();
  TextEditingController contShackAmt = new TextEditingController();
  TextEditingController contShack_for_name = new TextEditingController();
  TextEditingController contShack_owner_name = new TextEditingController();
  TextEditingController contShack_entry_date = new TextEditingController();
  TextEditingController contShack_come_date= new TextEditingController();



  List<String> list_Providers = [];

  String _selectedProviders = 'Providers';

  List<String> list_currency = ['Shakel','Dollar'];

  String _selectedcurrency = 'Shakel';

  //String imagename;
  File sampleimage;
  DateTime _date = DateTime.now();
  int state = 0;
  var url2;
  String _selectedCat = ' Category';
  List<String> list_cat = [];

  List<String> list_pays_from = ['Emad','Walid','Emad+Walid'];

  String _selectedpays_from = 'Emad';
  User user;
  void initState() {
    print("inside init");
    setState(() {
      contShack_no.text = widget.shack_inst.Shack_no.toString();
      contShack_no_ref.text = widget.shack_inst.Shack_no_ref.toString();
      contShack_entry_date.text = widget.shack_inst.Shack_entry_date.toString();

      contShack_come_date.text = widget.shack_inst.Shack_come_date.toString();

      _selectedCat = widget.shack_inst.Shack_cat;
      _selectedcurrency=widget.shack_inst.Shack_currency;
      _selectedpays_from=widget.shack_inst.Shack_owner_name.toString();
      _selectedProviders=widget.shack_inst.Shack_for_name.toString();
      contShackAmt.text=widget.shack_inst.Shack_amt.toString();
      colorOne = Red_deep;
      colorTwo = Red_deep2;
      colorThree = Red_deep1;
      getCurrentUser();
    });


    getData().then((results) {
      setState(() {
        cars = results;
        printlist();
      });
    });


    getDataproviders().then((results) {
      setState(() {


        carsproviders = results;
        printlistproviders();
      });
    });


  }
  getDataproviders() async {
    //return await FirebaseFirestore.instance.collection("Gym-Proding").snapshots();
    return await FirebaseFirestore.instance.collection('Providers').get();
  }
  printlistproviders() {
    if (cars != null) {
      list_Providers.clear();
      for (var i = 0; i < carsproviders.docs.length; i++) {
        list_Providers.add(carsproviders.docs[i].data()['Provider_name']);
      }
    } else {
      print("error");
    }
  }



  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    var appLanguage = Provider.of<AppLanguage>(context);

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

            //a
            Positioned(
              bottom: -125,
              left: -150,
              child: Container(
                height: 250, //MediaQuery.of(context).size.height / 4,
                width: 250, //MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: colorTwo,
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
                    color: colorThree),
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
                  // _scaffoldKey.currentState.openDrawer();

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
              top: MediaQuery
                  .of(context)
                  .size
                  .height/8,
              right: 0,
              left:0,
              child:Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height >= 775.0
                      ? MediaQuery.of(context).size.height
                      : 775.0,
                  child:Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      // color: Colors.red,
                      //   height: MediaQuery.of(context).size.height/2,
                      //   width: MediaQuery.of(context).size.width,
                      child: new Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width/4,
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:

                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text('${AppLocalizations.of(context).translate('Shack No')} :'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,

                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: TextFormField(

                                          keyboardType: TextInputType.number,
                                          controller: contShack_no,
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
                                                      color:Red_deep3,
                                                      // Color(getColorHexFromStr('#FEE16D')),
                                                      size: 20.0),
                                                  onPressed: () {
                                                    print('inside clear');
                                                    contShack_no.clear();
                                                    contShack_no.text = null;
                                                  }),
                                              contentPadding:
                                              EdgeInsets.only(left: 15.0, top: 15.0,right:15),
                                              hintText:
                                              AppLocalizations.of(context).translate('Shack No'),

                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand'))),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),


                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width/4,
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:

                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text('${AppLocalizations.of(context).translate('Shack No Ref')} :'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:

                                      TextFormField(
                                          controller: contShack_no_ref,
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
                                                    contShack_no_ref.clear();
                                                    contShack_no_ref.text = null;
                                                  }),
                                              contentPadding:
                                              EdgeInsets.only(left: 15.0, top: 15.0,right:15),
                                              hintText: AppLocalizations.of(context).translate('Shack No Ref'),

                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand'))),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width/4,
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:

                                      Padding(
                                        padding: const EdgeInsets.only(top:20,right: 5,left:5),
                                        child: Text('${AppLocalizations.of(context).translate('Come Date')} :'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,

                                    child:  Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Row(

                                        children: <Widget>[


                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width / 2,
                                            child: RaisedButton(elevation: 0,
                                              onPressed: () {
                                                //  Navigator.of(context).pushReplacementNamed('/MainPage');
                                                DatePicker.showDatePicker(context,
                                                    showTitleActions: true,
                                                    minTime: DateTime(2018,3,5),
                                                    maxTime: DateTime(2025,6,7),
                                                    onChanged: (date) {
                                                      print('change $date');
                                                    },
                                                    onConfirm: (date) {
                                                      setState(() {
                                                        _date = date;
                                                        contShack_come_date.text=date.toString();

//                                                  _day = formatDate(date,
//                                                      [ dd]);
//                                                  _due_date = formatDate(
//                                                      date.add(new Duration(
//                                                          days: 30)),
//                                                      [yyyy,'-',M,'-',dd]);
                                                      });
                                                      print('confirm $date');
                                                    },
                                                    currentTime: DateTime.parse(contShack_come_date.text),
                                                    locale: LocaleType.ar);
                                              }
                                              ,
                                              color: Colors.white,
                                              //padding: EdgeInsets.only(left: (5.0), top: 5.0),
                                              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                              child: Text('${formatDate(DateTime.parse(contShack_come_date.text),
                                                  [yyyy,'-',M,'-',dd,' '])}',style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight
                                                      .bold),),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  minTime: DateTime(2018,3,5),
                                                  maxTime: DateTime(2025,6,7),
                                                  onChanged: (date) {
                                                    print('change $date');
                                                  },
                                                  onConfirm: (date) {
                                                    setState(() {
                                                      _date = date;
                                                      contShack_come_date.text=date.toString();

//                                                  _day = formatDate(date,
//                                                      [ dd]);
//                                                  _due_date = formatDate(
//                                                      date.add(new Duration(
//                                                          days: 30)),
//                                                      [yyyy,'-',M,'-',dd]);
                                                    });
                                                    print('confirm $date');
                                                  },
                                                  currentTime: DateTime.parse(contShack_come_date.text),
                                                  locale: LocaleType.ar);
                                            },
                                            child: Icon(Icons.edit ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width/4,
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:

                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text('${AppLocalizations.of(context).translate('Shack Owner')} :'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,

                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Row(
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left:15.0,right:15),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: DropdownButton<String>(
                                                    items: list_pays_from.map((String val) {
                                                      return new DropdownMenuItem<String>(
                                                        value: val,
                                                        child: new Text(val),
                                                      );
                                                    }).toList(),
                                                    hint: Text(_selectedpays_from == null ? 0 :_selectedpays_from),
                                                    onChanged: (newVal) {
                                                      this.setState(() {
                                                        _selectedpays_from = newVal;
                                                      });
                                                    }),
                                              ),
                                            ),
                                          ),







                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width/4,
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:

                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text('${AppLocalizations.of(context).translate('Shack For')} :'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,

                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Row(
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left:15.0,right:15),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: DropdownButton<String>(
                                                    items: list_Providers.map((String val) {
                                                      return new DropdownMenuItem<String>(
                                                        value: val,
                                                        child: new Text(val),
                                                      );
                                                    }).toList(),
                                                    hint: Text(_selectedProviders),
                                                    onChanged: (newVal) {
                                                      this.setState(() {
                                                        _selectedProviders = newVal;
                                                      });
                                                    }),
                                              ),
                                            ),
                                          ),







//                                    RaisedButton(
//                                        elevation: 7.0,
//                                        child: Text( AppLocalizations.of(context).translate('Add Providers')),
//                                        textColor: Colors.white,
//                                        color: Red_deep,
//                                        onPressed: () {
//                                          Navigator.pushNamed(
//                                              context, '/CategoryAdd');
//                                        }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
//                              Material(
//                                elevation: 5.0,
//                                borderRadius: BorderRadius.circular(5.0),
//                                child: TextFormField(
//                                    controller: contShackTo,
//                                    onChanged: (value) {},
//                                    validator: (input) {
//                                      if (input.isEmpty) {
//                                        return 'Please contShackTo ';
//                                      }
//                                    },
//                                    onSaved: (input) => imagename = input,
//                                    decoration: InputDecoration(
//                                        border: InputBorder.none,
////                        prefixIcon: Icon(Icons.search,
////                            color: red2),
////                            size: 30.0),
//                                        suffixIcon: IconButton(
//                                            icon: Icon(Icons.cancel,
//                                                color: Color(
//                                                    getColorHexFromStr('#FEE16D')),
//                                                size: 20.0),
//                                            onPressed: () {
//                                              print('inside clear');
//                                              contShackTo.clear();
//                                              contShackTo.text = null;
//                                            }),
//                                        contentPadding:
//                                        EdgeInsets.only(left: 15.0, top: 15.0,right:15),
//                                        hintText: AppLocalizations.of(context).translate('Shack_to'),
//
//                                        hintStyle: TextStyle(
//                                            color: Colors.grey,
//                                            fontFamily: 'Quicksand'))),
//                              ),
                              SizedBox(
                                height: 5,
                              ),


                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width/4,
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:

                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text('${AppLocalizations.of(context).translate('Category')} :'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,

                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Row(

                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left:15.0,right:15),
                                            child: Align(
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
                                          ),


//                                    RaisedButton(
//                                        elevation: 7.0,
//                                        child: Text( AppLocalizations.of(context).translate('Add Category')),
//                                        textColor: Colors.white,
//                                        color: Red_deep,
//                                        onPressed: () {
//                                          Navigator.pushNamed(
//                                              context, '/CategoryAdd');
//                                        }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width/4,
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:

                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text('${AppLocalizations.of(context).translate('Shack Amt')} :'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Container(
                                    height: MediaQuery.of(context).size.height / 15,
                                    width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,

                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width/3,
                                            child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                controller: contShackAmt,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input.isEmpty) {
                                                    return 'Please Prod Cost ';
                                                  }
                                                },
                                                onSaved: (input) => imagename = input,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,

                                                    suffixIcon: IconButton(
                                                        icon: Icon(Icons.cancel,
                                                            color: Color(
                                                                getColorHexFromStr('#FEE16D')),
                                                            size: 20.0),
                                                        onPressed: () {
                                                          print('inside clear');
                                                          contShackAmt.clear();
                                                          contShackAmt.text = null;
                                                        }),
                                                    contentPadding:
                                                    EdgeInsets.only(left: 15.0, top: 15.0,right:15),
                                                    hintText: AppLocalizations.of(context).translate('Shack Amt'),

                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: 'Quicksand'))),
                                          ),
                                          Text(AppLocalizations.of(context).translate('Curr')),
                                          SizedBox(width: 5,),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 15.0),
                                              child: DropdownButton<String>(
                                                  items: list_currency.map((String val) {
                                                    return new DropdownMenuItem<String>(
                                                      value: val,
                                                      child: new Text(val),
                                                    );
                                                  }).toList(),
                                                  hint: Text(_selectedcurrency),
                                                  onChanged: (newVal) {
                                                    this.setState(() {
                                                      _selectedcurrency = newVal;
                                                    });
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),



                              SizedBox(
                                height: 25,
                              ),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                    elevation: 7.0,
                                    child: Text(AppLocalizations.of(context).translate('Save')),
                                    // Text("Save"),
                                    textColor: Colors.white,
                                    color: Red_deep,
                                    onPressed: () {
                                      print('inside save');
                                      updateDataonly(widget.shack_inst.Shack_doc);
                                      Navigator.of(context).pushReplacement(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) => new MainShacks()),
                                      );
                                    },
                                  ),
                                  RaisedButton(
                                    elevation: 7.0,
                                    child:  Text(AppLocalizations.of(context).translate('Cancel')),

                                    // Text("Upload"),
                                    textColor: Colors.white,
                                    color: Red_deep,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
//                                RaisedButton(
//                                  elevation: 7.0,
//                                  child: Text("Show"),
//                                  //  Text("Upload"),
//                                  textColor: Colors.white,
//                                  color: Red_deep,
//                                  onPressed: () {
//                                    print('inside save 1');
//                                    // _onPressedone();
//                                    // _onPressedall();
//
//
//
//                                  },
//                                ),
                                ],
                              ),




                            ],
                          )),
                    ),
                  )),

            ),
            //header title
            Positioned(
              top: MediaQuery.of(context).size.height / 15,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: Text(
                AppLocalizations.of(context).translate('Details'),
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold,  color: Colors.white,),
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
//          sampleimage == null
//              ? Image.network(
//            widget.Shack_img,
//            height: MediaQuery.of(context).size.height/4,
//            width: MediaQuery.of(context).size.width-20,
//          )
//              : Image.file(
//            sampleimage,
//            height: MediaQuery.of(context).size.height/4,
//            width: MediaQuery.of(context).size.width-20,
//          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              RaisedButton(
//                elevation: 7.0,
//                child: Text("Compressed"),
//                //  Text("Upload"),
//                textColor: Colors.white,
//                color:Red_deep,
//                onPressed: () {
//                  compressImage();
//                  /* final StorageReference fbsr =FirebaseStorage.instance.ref().child('${contimage.text}.jpg');
//                   final StorageUploadTask task = fbsr.putFile(sampleimage);
//                   var downurl = fbsr.getDownloadURL();
//                  print("the URL for image= ${downurl.toString()}");
//                   */
//                },
//              ),
              RaisedButton(
                elevation: 7.0,
                child: setUpButtonChild(),
                // Text("Upload"),
                textColor: Colors.white,
                color: Red_deep,
                onPressed: () {
                  setState(() {
                    state = 1;
                  });
                  if (sampleimage == null) {
                    print("inside uploadimg  no file update data only");

                    updateDataonly(widget.shack_inst.Shack_doc);

                    Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new main_page()),
                    );
                  }
                  else {
                   // deleteold_image();
                   // uploadimage();
                  }

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


  updateDataonly(selectedDoc) {
    print(selectedDoc);
    print(contShack_come_date.text);
    final todayDate = DateTime.now();
    var currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(contShack_come_date.text);
    print(tempDate);


    FirebaseFirestore.instance
        .collection("Shacks")
        .doc(selectedDoc)
        .update(
        {
          'Shack_no': int.parse(contShack_no.text),
          'Shack_no_ref': int.parse(contShack_no_ref.text),
          'Shack_owner_name': _selectedpays_from,
          'Shack_for_name':_selectedProviders ,
          'Shack_amt':  double.parse(contShackAmt.text),
          'Shack_entry_date':DateTime.parse(contShack_entry_date.text),
          'Shack_come_date':DateTime.parse(contShack_come_date.text),// currentdate,
          'Shack_currency': _selectedcurrency,
          'Shack_cat':_selectedCat
        }
    )

        .catchError((e) {
      print(e);
    });

   // FirebaseFirestore.instance .collection('ShacksHistory').doc().set(
        FirebaseFirestore.instance.collection("ShacksHistory").doc().set({
          'Shack_no': int.parse(contShack_no.text),
          'Shack_no_ref': int.parse(contShack_no_ref.text),
          'Shack_owner_name': _selectedpays_from,
          'Shack_for_name':_selectedProviders ,
          'Shack_amt':  double.parse(contShackAmt.text),
          'Shack_entry_date':DateTime.parse(contShack_entry_date.text),
          'Shack_come_date':DateTime.parse(contShack_come_date.text),// currentdate,
          'Shack_currency': _selectedcurrency,
          'Shack_cat':_selectedCat
        })


        .catchError((e) {
      print('e');

    });




    print('end update');
  }


  updateData(selectedDoc) {
    final todayDate = DateTime.now();
    contShack_entry_date.text = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    FirebaseFirestore.instance
        .collection('Shacks')
        .doc(selectedDoc)
        .update({
      'Shack_no': int.parse(contShack_no.text),
      'Shack_no_ref': int.parse(contShack_no_ref.text),
      'Shack_owner_name': _selectedpays_from,
      'Shack_for_name':_selectedProviders ,
      'Shack_amt':  double.parse(contShackAmt.text),
      'Shack_entry_date':DateTime.parse(contShack_entry_date.text),
      'Shack_come_date':DateTime.parse(contShack_come_date.text),// currentdate,
      'Shack_currency': _selectedcurrency,
      'Shack_cat':_selectedCat
    }).catchError((e) {
      print(e);
    });
  }


//  deleteold_image() async {
//    if (widget.Shack_img != null) {
//      StorageReference storageReference =
//      await FirebaseStorage.instance.getReferenceFromUrl(widget.Shack_img);
//
//      print(storageReference.path);
//
//      await storageReference.delete();
//
//      print('image deleted');
//    }
//  }
  getData() async {
    //return await FirebaseFirestore.instance.collection("Furnit_Products").snapshots();
    return await FirebaseFirestore.instance.collection('PaymentsCategory').get();
  }
  printlist(){
    if (cars != null) {
      for(var i =0 ;i<cars.docs.length;i++)
      {
        list_cat.add(cars.docs[i].data()['cat_name']);
      }
    }
    else
    {
      print("error");
    }


  }

  //void uploadimage() {}


//  Future<String> uploadimage() async {
//
//
//    final StorageReference ref =
//    FirebaseStorage.instance.ref().child('${contShackname.text}.jpg');
//    final StorageUploadTask task = ref.putFile(sampleimage);
//    var downurl = await (await task.onComplete).ref.getDownloadURL();
//
//    var url = downurl.toString();
//    url2 = url;
//    //print("the URL for image= ${url}");
//    setState(() {
//      state = 2;
//    });
//    //addimagedata();
//    updateData(widget.Shack_doc_id);
//    //  Navigator.pushNamed(context, '/productsallcom');
//    return "";
//
//  }

}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = colorOne;
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











