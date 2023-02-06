import 'package:flutter/material.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
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
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ProductsEditNew extends StatefulWidget {

  final String Payment_id;
  final String Payment_name;
  final String Payment_desc;
  final String Payment_price;

  final String Payment_fav;
  final String Payment_cat;
  final String Payment_img;
  final String Payment_date;
  final String Payment_modify_date;
  final String Payment_entry_date;
  final String Payment_doc_id;
  final String Payment_amt;
  final String Payment_to;
  final String Payment_from;
  final String Payment_currency;

  ProductsEditNew({
    this.Payment_id,
    this.Payment_name,
    this.Payment_desc,
    this.Payment_price,
    this.Payment_fav,
    this.Payment_cat,
    this.Payment_img,
    this.Payment_date,
    this.Payment_modify_date,
    this.Payment_entry_date,
    this.Payment_doc_id,
    this.Payment_amt,
    this.Payment_to,

    this.Payment_from,
    this.Payment_currency
  });



  @override
  _ProductsEditNewState createState() => _ProductsEditNewState();
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

class _ProductsEditNewState extends State<ProductsEditNew> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color pyellow = Color(Colors.amber);
  String imagename;

  TextEditingController contPaymentid = new TextEditingController();
  TextEditingController contPaymentname = new TextEditingController();

  TextEditingController contPaymentset = new TextEditingController();
  TextEditingController contPaymentcat = new TextEditingController();

  TextEditingController contPaymentdesc = new TextEditingController();
  TextEditingController contPaymentimg = new TextEditingController();
  TextEditingController contPaymententrydate = new TextEditingController();

  TextEditingController contPaymentamt = new TextEditingController();
  TextEditingController contPaymentto = new TextEditingController();
  TextEditingController contPaymentcurrency = new TextEditingController();


  List<String> list_Providers = [];

  String _selectedProviders = 'Providers';

  List<String> list_currency = ['Shakel','Dollar'];

  String _selectedcurrency = 'Shakel';

  //String imagename;
  File sampleimage;
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
      contPaymentid.text = widget.Payment_id;
      contPaymentname.text = widget.Payment_name;
      contPaymentamt.text = widget.Payment_amt.toString();
      contPaymentto.text = widget.Payment_to.toString();
      contPaymentset.text = widget.Payment_fav.toString();
      _selectedCat = widget.Payment_cat;

      contPaymentdesc.text = widget.Payment_desc;
      contPaymentimg.text = widget.Payment_img;
      contPaymententrydate.text = widget.Payment_entry_date;
      contPaymentcurrency.text=widget.Payment_currency;
      _selectedcurrency=widget.Payment_currency;
      _selectedpays_from=widget.Payment_from;
      _selectedProviders=widget.Payment_to;
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
                                      child: Text('${AppLocalizations.of(context).translate('Payment Id')} :'
                                        ,style: new TextStyle(
                                        fontSize: pheight/70,
                                      ),),
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
                                        controller: contPaymentid,
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
                                                    size: pheight/70,),
                                                onPressed: () {
                                                  print('inside clear');
                                                  contPaymentid.clear();
                                                  contPaymentid.text = null;
                                                }),
                                            contentPadding:
                                            EdgeInsets.only(left: 15.0, top: 15.0,right:15),
                                            hintText:
                                            AppLocalizations.of(context).translate('Payment Id'
                                            
                                            ),

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
                                      child: Text('${AppLocalizations.of(context).translate('Payment_name')} :'),
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
                                        controller: contPaymentname,
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
                                                    size: pheight/70,),
                                                onPressed: () {
                                                  print('inside clear');
                                                  contPaymentname.clear();
                                                  contPaymentname.text = null;
                                                }),
                                            contentPadding:
                                            EdgeInsets.only(left: 15.0, top: 15.0,right:15),
                                            hintText: AppLocalizations.of(context).translate('Payment_name'),
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
                                      child: Text('${AppLocalizations.of(context).translate('Payment_desc')} :'),
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
                                        controller: contPaymentdesc,
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
                                                    size: pheight/70,),
                                                onPressed: () {
                                                  print('inside clear');
                                                  contPaymentdesc.clear();
                                                  contPaymentdesc.text = null;
                                                }),
                                            contentPadding:
                                            EdgeInsets.only(left: 15.0, top: 15.0,right:15),
                                            hintText: AppLocalizations.of(context).translate('Payment_desc'),

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
                                      child: Text('${AppLocalizations.of(context).translate('Payment_from')} :'),
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
                                      child: Text('${AppLocalizations.of(context).translate('Payment_to')} :'),
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
//                                    controller: contPaymentTo,
//                                    onChanged: (value) {},
//                                    validator: (input) {
//                                      if (input.isEmpty) {
//                                        return 'Please contPaymentTo ';
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
//                                                size: pheight/70,),
//                                            onPressed: () {
//                                              print('inside clear');
//                                              contPaymentTo.clear();
//                                              contPaymentTo.text = null;
//                                            }),
//                                        contentPadding:
//                                        EdgeInsets.only(left: 15.0, top: 15.0,right:15),
//                                        hintText: AppLocalizations.of(context).translate('Payment_to'),
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
                                      child: Text('${AppLocalizations.of(context).translate('Payment_amt')} :'),
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
                                              controller: contPaymentamt,
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
                                                          size: pheight/70,),
                                                      onPressed: () {
                                                        print('inside clear');
                                                        contPaymentamt.clear();
                                                        contPaymentamt.text = null;
                                                      }),
                                                  contentPadding:
                                                  EdgeInsets.only(left: 15.0, top: 15.0,right:15),
                                                  hintText: AppLocalizations.of(context).translate('Payment_amt'),

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
                                    updateDataonly(widget.Payment_doc_id);
                                    updatedatasql();
                                    Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) => new main_page()),
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
//            widget.Payment_img,
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

                    updateDataonly(widget.Payment_doc_id);
                    updatedatasql();

                    Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new main_page()),
                    );
                  }
                  else {
                    deleteold_image();
                    uploadimage();
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

  Future<void> updatedatasql() async {
  print('inside update sql');
    final todayDate = DateTime.now();
    var currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh]);


    var url = ("http://emaddwiekat.atwebpages.com/Sales/Flutter/edit_payments.php");

  var response = await   http.post(url,body:
    {
      'Payment_id': contPaymentid.text,
      'Payment_name': contPaymentname.text,
      'Payment_desc': contPaymentdesc.text,
      'Payment_amt': contPaymentamt.text,
      'Payment_to': _selectedProviders ,//contPaymentTo.text,
      'Payment_fav': "false",
      'Payment_cat': _selectedCat,
      //'Payment_entry_date':todayDate,// currentdate,
      'Payment_modify_date':currentdate  ?? "",// currentdate,
      'Payment_img': url2  ?? "",
      'Payment_from':_selectedpays_from,
      'Payment_user':user.email.toString(),
      'Payment_currency':_selectedcurrency
    });
  print("${response.statusCode}");
  print("${response.body}");
  return response;
  }
  updateDataonly(selectedDoc) {
    final todayDate = DateTime.now();
    var currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    FirebaseFirestore.instance
        .collection('Payments')
        .doc(selectedDoc)
        .update(
        {
          'Payment_id': contPaymentid.text,
          'Payment_name': contPaymentname.text,
          'Payment_desc': contPaymentdesc.text,
          'Payment_amt': contPaymentamt.text,
          'Payment_to': _selectedProviders ,//contPaymentTo.text,
          'Payment_fav': "false",
          'Payment_cat': _selectedCat,
          //'Payment_entry_date':todayDate,// currentdate,
          'Payment_modify_date':todayDate,// currentdate,
          'Payment_img': url2,
          'Payment_from':_selectedpays_from,
          'Payment_user':user.email.toString(),
          'Payment_currency':_selectedcurrency
        }
    )

        .catchError((e) {
      print(e);
    });

    FirebaseFirestore.instance
        .collection('PaymentsHistory').doc().set(
        {
          'Payment_id': contPaymentid.text,
          'Payment_name': contPaymentname.text,
          'Payment_desc': contPaymentdesc.text,
          'Payment_amt': contPaymentamt.text,
          'Payment_to': contPaymentto.text,
          'Payment_fav': "false",
          'Payment_cat': _selectedCat,
          'Payment_entry_date': todayDate,//currentdate,
          'Payment_modify_date': todayDate,//currentdate,
          'Payment_img': url2,
          'Payment_from':_selectedpays_from,
          'Payment_user':user.email.toString(),
          'Payment_currency':_selectedcurrency
        }
    )


        .catchError((e) {
      print(e);
    });

    setState(() {
      state = 2;
    });
  }


  updateData(selectedDoc) {
    final todayDate = DateTime.now();
    contPaymententrydate.text = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    FirebaseFirestore.instance
        .collection('Payments')
        .doc(selectedDoc)
        .update({
      'Payment_id': contPaymentid.text,
      'Payment_name': contPaymentname.text,
      'Payment_desc': contPaymentdesc.text,
      'Payment_amt': contPaymentamt.text,
      'Payment_to': contPaymentto.text,
      'Payment_fav': "false",
      'Payment_cat': _selectedCat,
      'Payment_entry_date': Timestamp.fromDate(DateTime.parse(contPaymententrydate.text)),
      'Payment_modify_date': todayDate,
      'Payment_img': url2,
      'Payment_user':user.email.toString(),
      'Payment_currency':_selectedcurrency
    }).catchError((e) {
      print(e);
    });
  }


  deleteold_image() async {
    if (widget.Payment_img != null) {
      StorageReference storageReference =
      await FirebaseStorage.instance.getReferenceFromUrl(widget.Payment_img);

      print(storageReference.path);

      await storageReference.delete();

      print('image deleted');
    }
  }
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


  Future<String> uploadimage() async {


    final StorageReference ref =
    FirebaseStorage.instance.ref().child('${contPaymentname.text}.jpg');
    final StorageUploadTask task = ref.putFile(sampleimage);
    var downurl = await (await task.onComplete).ref.getDownloadURL();

    var url = downurl.toString();
    url2 = url;
    //print("the URL for image= ${url}");
    setState(() {
      state = 2;
    });
    //addimagedata();
    updateData(widget.Payment_doc_id);
    //  Navigator.pushNamed(context, '/productsallcom');
    return "";

  }

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











