import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:paychalet/Calinder/Notes_Class.dart';
import 'dart:math' as Math;
import 'package:paychalet/colors.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:paychalet/Shacks/ProductsMain.dart';
//import 'package:paychalet/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:paychalet/Invoices/Invoices_Class.dart';
import '../main_page.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import  'package:keyboard_actions/keyboard_actions.dart';
import 'package:paychalet/KeyBoard/KeyBoard.dart';

import 'Notes.dart';
//import './Notes_Class.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';


class NotesEdit extends StatefulWidget {
  Noteclass instclass;
  NotesEdit({this.instclass});

  @override
  _NotesEditState createState() => _NotesEditState();
}

QuerySnapshot cars;
QuerySnapshot cars_token;
QuerySnapshot carsproviders;
const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne ;
Color colorTwo ;
Color colorThree ;
User user;
double tfwidth;
double tfheght;
class _NotesEditState extends State<NotesEdit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Use temp variable to only update color when press dialog 'submit' button
  ColorSwatch  _tempMainColor;
  Color  _tempShadeColor;
  Color  _mainColor = Colors.blue;
  Color  _shadeColor = Colors.blue[800];

 String  selectedDoc='0';
  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            RaisedButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            RaisedButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        onBack: () => print("Back button pressed"),
      ),
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Main Color picker",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  void _openAccentColorPicker() async {
    _openDialog(
      "Accent Color picker",
      MaterialColorPicker(
        colors: accentColors,
        selectedColor: _mainColor,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        circleSize: 40.0,
        spacing: 10,
      ),
    );
  }

  void _openFullMaterialColorPicker() async {
    _openDialog(
      "Full Material Color picker",
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: _mainColor,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }
//  add  keyboard action

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(
          focusNode: _nodeText3,
          onTapAction: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Custom Action"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                });
          },
        ),
        KeyboardActionsItem(
          focusNode: _nodeText4,
          // displayCloseWidget: false,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText5,
          toolbarButtons: [
            //button 1
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            //button 2
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DONE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeText6,
          footerBuilder: (_) => PreferredSize(
              child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Custom Footer'),
                  )),
              preferredSize: Size.fromHeight(40)),
        ),
      ],
    );
  }


  /// end add  keyboard action
  //  Color pyellow = Color(red4);
  File _image;
  final ImagePicker _picker = ImagePicker();
  // PickedFile _imageFile;
  File _imageFile;
  DateTime _date = DateTime.now();
  QuerySnapshot carsinvoice;
  final GlobalKey<ScaffoldState> _scaffoldKeysnak = new GlobalKey<ScaffoldState>();



  @override
  void initState() {

    super.initState();

    getCurrentUser();
    //  print("inside init");
    colorOne = Red_deep2;
    colorTwo = Red_deep3;
    colorThree = Red_deep1;
    getData().then((results) {
      setState(() {


        cars = results;
        printlist();
      });
    });






    getDataproviders().then((results) {
      setState(() {
        // print(widget.Docs_max);
        //contNote_no.text = widget.Docs_max;
        carsproviders = results;
        printlistproviders();
      });
    });

    setState(() {
      contNote_no.text=widget.instclass.Note_no.toString();
      contdesc.text=widget.instclass.Note_desc;
      _selectedNoteOwner=widget.instclass.Note_owner_name;
      _date==widget.instclass.Note_modify_date;
      conttitel.text=widget.instclass.titel;
      _mainColor=widget.instclass.note_color;

      selectedDoc=widget.instclass.Note_doc;


    });

  }

/*
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

*/
  String imagename;
  //PickedFile sampleimage;
  File sampleimage;
  var currentdate;
  int state = 0;
  var url2;

  List<String> list_cat = [];


  String _selectedCat = 'Category';


  List<String> list_Providers = [];

  String _selectedProviders = 'Providers';

  List<String> list_currency = ['Shakel','Dollar'];

  String _selectedcurrency = 'Shakel';

  List<String> list_pays_from = ['Emad','Walid','Emad+Walid'];

  String _selectedNoteOwner = 'Emad';



  TextEditingController conttitel = new TextEditingController();
  TextEditingController contNote_no = new TextEditingController();
  TextEditingController contNote_no_ref = new TextEditingController();
  TextEditingController contShackAmt = new TextEditingController();
  TextEditingController contNote_for_name = new TextEditingController();
  TextEditingController contNote_owner_name = new TextEditingController();
  TextEditingController contdesc = new TextEditingController();



  Future getImagecamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleimage = tempImage;
    });

    //  compressImage();
  }

  Future getImagegalary() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleimage = tempImage;
    });

    /// compressImage();
  }

  Widget build(BuildContext context) {

    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;
    tfwidth=MediaQuery.of(context).size.width/90;
    tfheght=MediaQuery.of(context).size.height/47;
    var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      // drawer: Appdrawer(),
      body:  GestureDetector(
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
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(200),
                  //  color: red4,
                ),
                child: CustomPaint(
                  child: Container(
                    height: 400.0,
                  ),
                  painter: _MyPainter(),
                ),
              ),
            ),

            //background color
            Positioned(
              bottom: -125,
              left: -150,
              child: Container(
                height: 250, //MediaQuery.of(context).size.height / 4,
                width: 250, //MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: Red_deep,
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
                    color: Red_deep),
              ),
            ),
            //menu
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  print('inside button');
                  print('inside button');
                  //_scaffoldKey.currentState.openDrawer();
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Note()),
                  );
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 15,
              left: MediaQuery.of(context).size.width / 2 -
                  ('Add Shack'.toString().length * 8),
              child: Text(
                AppLocalizations.of(context).translate('Edit Note'),

                //'Add Shack',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white,),
              ),
            ),
            //body
            Positioned(
                top: 100,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height:pheight+200,
//                          MediaQuery.of(context).size.height >= 775.0
//                              ? MediaQuery.of(context).size.height
//                              : 775.0,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        // color: Colors.red,
                        //   height: MediaQuery.of(context).size.height/2,
                        //   width: MediaQuery.of(context).size.width,

                        child: KeyboardActions(
                            config: _buildConfig(context),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                //no
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
                                          padding: const EdgeInsets.only(left:15,right:15,top:20),
                                          child: Text('${AppLocalizations.of(context).translate('Note no')} :'),
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
                                            controller: contNote_no,
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
                                                suffixIcon: Padding(
                                                  padding: const EdgeInsets.only(top:8.0),
                                                  child: IconButton(
                                                      icon: Icon(Icons.cancel,
                                                          color: Color(getColorHexFromStr('#FEE16D')),
                                                          size: 20.0),
                                                      onPressed: () {
                                                        print('inside clear');
                                                        contNote_no.clear();
                                                        contNote_no.text = null;
                                                      }),
                                                ),
                                                contentPadding:
                                                EdgeInsets.only(left: 5.0, top: 20.0,right:15),
                                                hintText:
                                                AppLocalizations.of(context).translate('Note no'),

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
                                //ref
//                                Row(
//                                  children: [
//                                    Container(
//                                      height: MediaQuery.of(context).size.height / 15,
//                                      width: MediaQuery.of(context).size.width/4,
//                                      child: Material(
//                                        elevation: 5.0,
//                                        borderRadius: BorderRadius.circular(5.0),
//                                        child:
//
//                                        Padding(
//                                          padding: const EdgeInsets.all(15),
//                                          child: Text('${AppLocalizations.of(context).translate('Note no Ref')} :'),
//                                        ),
//                                      ),
//                                    ),
//                                    SizedBox(width:5),
//                                    Container(
//                                      height: MediaQuery.of(context).size.height / 15,
//                                      width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,
//
//                                      child: Material(
//                                        elevation: 5.0,
//                                        borderRadius: BorderRadius.circular(5.0),
//                                        child: TextFormField(
//
//                                            keyboardType: TextInputType.number,
//                                            controller: contNote_no_ref,
//                                            onChanged: (value) {},
//                                            validator: (input) {
//                                              if (input.isEmpty) {
//                                                return 'Please Prod Id ';
//                                              }
//                                            },
//                                            onSaved: (input) => imagename = input,
//                                            decoration: InputDecoration(
//                                                border: InputBorder.none,
//
////                        prefixIcon: Icon(Icons.search,
////                            color: red2),
////                            size: 30.0),
//                                                suffixIcon: Padding(
//                                                  padding: const EdgeInsets.only(top:8.0),
//                                                  child: IconButton(
//                                                      icon: Icon(Icons.cancel,
//                                                          color: Color(getColorHexFromStr('#FEE16D')),
//                                                          size: 20.0),
//                                                      onPressed: () {
//                                                        print('inside clear');
//                                                        contNote_no_ref.clear();
//                                                        contNote_no_ref.text = null;
//                                                      }),
//                                                ),
//                                                contentPadding:
//                                                EdgeInsets.only(left: 5.0, top: 20,right:15),
//                                                hintText:
//                                                AppLocalizations.of(context).translate('Note no Ref'),
//
//                                                hintStyle: TextStyle(
//                                                    color: Colors.grey,
//                                                    fontFamily: 'Quicksand'))),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                                SizedBox(
//                                  height: 5,
//                                ),
                                //date
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
                                          child: Text('${AppLocalizations.of(context).translate('Modify Date')} :'),
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

//                                                  _day = formatDate(date,
//                                                      [ dd]);
//                                                  _due_date = formatDate(
//                                                      date.add(new Duration(
//                                                          days: 30)),
//                                                      [yyyy,'-',M,'-',dd]);
                                                        });
                                                        print('confirm $date');
                                                      },
                                                      currentTime: DateTime.now(),
                                                      locale: LocaleType.ar);
                                                }
                                                ,
                                                color: Colors.white,
                                                //padding: EdgeInsets.only(left: (5.0), top: 5.0),
                                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                                child: Text('${formatDate(_date,
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
//                                                  _day = formatDate(date,
//                                                      [ dd]);
//                                                  _due_date = formatDate(
//                                                      date.add(new Duration(
//                                                          days: 30)),
//                                                      [yyyy,'-',M,'-',dd]);
                                                      });
                                                      print('confirm $date');
                                                    },
                                                    currentTime: DateTime.now(),
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
                               //owner
                                Row(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 12,
                                      width: MediaQuery.of(context).size.width/4,
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(5.0),
                                        child:

                                        Padding(
                                           padding: const EdgeInsets.only(top:20,right: 10,left:10),
                                          child: Text('${AppLocalizations.of(context).translate('Note Owner')} :'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width:5),
                                    Container(
                                      height: MediaQuery.of(context).size.height / 12,
                                      width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/4)-15,

                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Row(
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.only(left:5,right:5,top:10),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5.0),
                                                  child: DropdownButton<String>(
                                                      items: list_pays_from.map((String val) {
                                                        return new DropdownMenuItem<String>(
                                                          value: val,
                                                          child: new Text(val),
                                                        );
                                                      }).toList(),
                                                      hint: Text(_selectedNoteOwner),
                                                      onChanged: (newVal) {
                                                        this.setState(() {
                                                          _selectedNoteOwner = newVal;
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
                                //titel
                                Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / tfheght,
                                      width: MediaQuery.of(context).size.width/tfwidth,
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(5.0),
                                        child:

                                        Padding(
                                          padding: const EdgeInsets.only(top:20,left:5,right:5),
                                          child: Text('${AppLocalizations.of(context).translate('titel')} :'
                                            ,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 12),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width:5),
                                    Container(
                                      height: MediaQuery.of(context).size.height / tfheght,
                                      width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/tfwidth)-15,

                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: TextFormField(maxLines: null,

                                            keyboardType: TextInputType.multiline,
                                            controller: conttitel,
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
                                                      contdesc.clear();contdesc.clear();
                                                      contdesc.text = null;
                                                    }),
                                                contentPadding:
                                                EdgeInsets.only(left: 15.0, top: 20.0,right:5),
                                                hintText:
                                                AppLocalizations.of(context).translate('Note_titel'),

                                                hintStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                    fontFamily: 'Quicksand'))),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                //desc
                                Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / tfheght,
                                      width: MediaQuery.of(context).size.width/tfwidth,
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(5.0),
                                        child:

                                        Padding(
                                          padding: const EdgeInsets.only(top:20,left:5,right:5),
                                          child: Text('${AppLocalizations.of(context).translate('Note_Desc')} :'
                                            ,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 12),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width:5),
                                    Container(
                                      height: MediaQuery.of(context).size.height / tfheght*4,
                                      width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/tfwidth)-15,

                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: TextFormField(maxLines: null,

                                            keyboardType: TextInputType.multiline,
                                            controller: contdesc,
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
                                                      contdesc.clear();contdesc.clear();
                                                      contdesc.text = null;
                                                    }),
                                                contentPadding:
                                                EdgeInsets.only(left: 15.0, top: 20.0,right:5),
                                                hintText:
                                                AppLocalizations.of(context).translate('Note_Desc'),

                                                hintStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                    fontFamily: 'Quicksand'))),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),



                                SizedBox(
                                  height: 25,
                                ),Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: _mainColor,
                              radius: 35.0,
                              child: const Text("Color"),
                            ),
//                            const SizedBox(width: 16.0),
//                            CircleAvatar(
//                              backgroundColor: _shadeColor,
//                              radius: 35.0,
//                              child: const Text("SHADE"),
//                            ),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        RaisedButton(color: _mainColor,
                          onPressed: _openColorPicker,
                          child: const Text('Show'),
                        ),
//                        const SizedBox(height: 16.0),
//                        RaisedButton(
//                          onPressed: _openMainColorPicker,
//                          child: const Text('Show'),
//                        ),
                       // const Text('(only main color)'),
//                        const SizedBox(height: 16.0),
//                        RaisedButton(
//                          onPressed: _openAccentColorPicker,
//                          child: const Text('Show2'),
//                        ),
//                        const SizedBox(height: 16.0),
//                        RaisedButton(
//                          onPressed: _openFullMaterialColorPicker,
//                          child: const Text('Show full'),
//                        ),
                      ],
                    ),

                                //save button
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
                                          Updatedata();

//                                      _scaffoldKey.currentState.showSnackBar
//                                      (SnackBar(
//                                        content: Text("Hay this is it"),
//                                        backgroundColor: Color.fromARGB(255, 255, 0, 0),
//                                        duration: Duration(seconds: 5),
//                                        action: SnackBarAction(
//                                          label: 'UNDO',
//                                          onPressed: _scaffoldKey.,
//                                        ),
//                                      ));
                                        }



                                    ),
                                    RaisedButton(
                                      elevation: 7.0,
                                      child:  Text(AppLocalizations.of(context).translate('Cancel')),

                                      // Text("Upload"),
                                      textColor: Colors.white,
                                      color: Red_deep,
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) => new Note()),
                                        );

                                      },
                                    ),
//                                    RaisedButton(
//                                      elevation: 7.0,
//                                      child: Text("Show"),
//                                      //  Text("Upload"),
//                                      textColor: Colors.white,
//                                      color: Red_deep,
//                                      onPressed: () {
//                                        print('inside save 1');
//                                        // _onPressedone();
//                                        // _onPressedall();
//                                        addisubcollection();
//
//
//                                      },
//                                    ),
//                                    RaisedButton(
//                                      elevation: 7.0,
//                                      child: Text("Read"),
//                                      //  Text("Upload"),
//                                      textColor: Colors.white,
//                                      color: Red_deep,
//                                      onPressed: () {
//                                        print('inside save 1');
//                                        // _onPressedone();
//                                        // _onPressedall();
//                                        // readisubcollection();
//                                        call_get_data_invoice();
//
//
//
//                                      },
//                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),


//                              new Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  IconButton(
//                                    icon: Icon(Icons.camera_roll),
//                                    onPressed: () {
//                                      getImagegalary();
//
//                                      setState(() {
//                                        state = 0;
//                                      });
//                                    },
//                                  ),
//                                  IconButton(
//                                    icon: Icon(Icons.add_a_photo),
//                                    onPressed: () {
//                                      getImagecamera();
//
//                                      setState(() {
//                                        state = 0;
//                                      });
//                                    },
//                                  )
//                                ],
//                              ),

                              ],
                            )),
                      ),
                    ),
                  ),
                )),

            //  ),
          ],
        ),
      ),


    );
  }

  Widget enableupload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(
            sampleimage,
            height: MediaQuery.of(context).size.height/3.5,
            width: MediaQuery.of(context).size.width-20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                elevation: 7.0,
                child: Text("Compressed"),
                //  Text("Upload"),
                textColor: Colors.white,
                color: Red_deep,
                onPressed: () {
                  compressImage();
                  /* final StorageReference fbsr =FirebaseStorage.instance.ref().child('${contimage.text}.jpg');
                   final StorageUploadTask task = fbsr.putFile(sampleimage);
                   var downurl = fbsr.getDownloadURL();
                  print("the URL for image= ${downurl.toString()}");
                   */
                },
              ),
              RaisedButton(
                elevation: 7.0,
                child: setUpButtonChild(),
                //  Text("Upload"),
                textColor: Colors.white,
                color: Red_deep,
                onPressed: () {
                  setState(() {
                    state = 1;
                  });

                  uploadimage();

                  /* final StorageReference fbsr =FirebaseStorage.instance.ref().child('${contimage.text}.jpg');
               final StorageUploadTask task = fbsr.putFile(sampleimage);
               var downurl = fbsr.getDownloadURL();
              print("the URL for image= ${downurl.toString()}");
               */
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

  Future<String> uploadimage() async {
    print('inside upload proc');
    final StorageReference ref =
    FirebaseStorage.instance.ref().child('${contNote_no_ref.text}.jpg');
    print("the pict${sampleimage}");
    final StorageUploadTask task = ref.putFile(sampleimage);
    var downurl = await (await task.onComplete).ref.getDownloadURL();

    var url = downurl.toString();
    url2 = url;
    //print("the URL for image= ${url}");
    setState(() {
      state = 2;
    });

    final todayDate = DateTime.now();
    currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    Updatedata();
    return "";
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


  void addisubcollection() {
    final todayDate = DateTime.now();
    currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);


    FirebaseFirestore.instance.collection("Invoices").add({
      "Invoice_No": "123",
      "Invoice_date": todayDate,
      "Invoice_Details": [
        {"Type_no": 1, "Type_name": "emad", "Type_price": 40},
        {"Type_no": 2, "Type_name": "ddd", "Type_price": 60},
        {"Type_no": 3, "Type_name": "ff", "Type_price": 70},
      ]
    });
  }
//  void readisubcollection() {
//    String temp_no,temp_name,temp_price;
//    Invoices_Class inv ;
//    //Invoiceone invone;
//    FirebaseFirestore.instance.collection("Invoices")
//        .get().then((docSnapshot) =>
//    {
//         temp_no=docSnapshot.docs[0]['Invoice_Details'][0]['Type_no'].toString(),
//         temp_name=docSnapshot.docs[0]['Invoice_Details'][0]['Type_name'],
//         temp_price=docSnapshot.docs[0]['Invoice_Details'][0]['Type_price'].toString(),
//
//print(docSnapshot.docs[0]['Invoice_No']),
//     inv.Invoice_no = docSnapshot.docs[0]['Invoice_No'],
//      inv.Invoice_date = docSnapshot.docs[0]['Invoice_date'],
//      inv.Invoice_Details.add(Invoiceone(Type_no: temp_no,Type_name:temp_name,Type_price:temp_price)),
//
//      //invone.Type_no=docSnapshot.docs[0]['Invoice_Details'][0]['Type_no'],
//      //invone.Type_name=docSnapshot.docs[0]['Invoice_Details'][0]['Type_name'],
//      //invone.Type_price=docSnapshot.docs[0]['Invoice_Details'][0]['Type_price'],
//     // inv.Invoice_Details.add(invone),
//      print (inv),
//
//
//
////      print(docSnapshot.docs[0]),
////      print(docSnapshot.docs[0]['Invoice_No']),
////      print(docSnapshot.docs[0]['Invoice_date']),
////      print(docSnapshot.docs[0]['Invoice_Details'][0]['Type_name'])
//    });
//  }

  getDatainvoice() async {
    // print('inside invoice getdata ');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Invoices').get();

    List<Invoices> _InvoiceList = [];
    snapshot.docs.forEach((document) {
      // print('llll');
      Invoices _invoice = Invoices.fromJson(document.data());
      //print('the list =${document.data()}');
//     print(_invoice.Invoice_no);
//     print(_invoice.Invoice_date);

      _InvoiceList.add(_invoice);
    });

//
    print('last data');
    _InvoiceList.forEach((element) {
      print(element.Invoice_date);
      print(element.Invoice_no);
      element.invoices.forEach((el) {
        print(el.Type_no);
        print(el.Type_name);
        print(el.Type_price);
      });
    });
    print(_InvoiceList[0].Invoice_date);
    print(_InvoiceList[0].Invoice_no);
    print(_InvoiceList[0].invoices[0].Type_name);
  }


  call_get_data_invoice()
  {
    getDatainvoice();
    //.then((resultstoken) {
    //setState(() {
    //carsinvoice = resultstoken;

    // printlistinvoice( );
    //});
    //});
  }

  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser;

    //final uid = user.uid;
    //return user.email;
  }
  void Updatedata(){
    final todayDate = DateTime.now();
    currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);
    Color color =  _mainColor ;//Color(0x12345678);
    String colorString = color.toString(); // Color(0x12345678)

    getCurrentUser();
    FirebaseFirestore.instance
        .collection('Notes')
        .doc(selectedDoc)
        .update({
      'Note_no': int.parse(contNote_no.text),
      'Note_owner_name': _selectedNoteOwner,
     // 'Note_entry_date': DateTime.now(),
      'Note_Modify_date':_date,// currentdate,
      'Note_user':user.email.toString(),
      'Note_desc':contdesc.text ,'titel':conttitel.text,
      'Note_color':colorString//_mainColor.toString(),
    })
    ;



    FirebaseFirestore.instance.collection("NotesHistrory").doc().set({
      'Note_no': int.parse(contNote_no.text),
      'Note_owner_name': _selectedNoteOwner,
    //  'Note_entry_date': DateTime.now(),
      'Note_Modify_date':_date,// currentdate,
      'Note_user':user.email.toString(),
      'Note_desc':contdesc.text,'titel':conttitel.text,
      'Note_color':colorString//_mainColor.toString(),
    });





    

//    Color color = new Color(0x12345678);
//    String colorString = color.toString(); // Color(0x12345678)
//    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
//    int value = int.parse(valueString, radix: 16);
//    Color otherColor = new Color(value);
    _showSnackbar(contNote_no.text);
    setState(() {
     // contNote_no.text = (int.parse(contNote_no.text) + 1).toString();
     // contNote_owner_name.clear();
     // contdesc.clear();
    //  contNote_no_ref.text=(int.parse(contNote_no_ref.text)+1).toString();
     // conttitel.clear();
    });



  }


  
  getData() async {
    //return await FirebaseFirestore.instance.collection("Gym-Proding").snapshots();
    return await FirebaseFirestore.instance.collection('PaymentsCategory').get();
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

  print_data() async {
    return await FirebaseFirestore.instance.collection('users').get();
  }


  print_data_list() {
    print('inside func list');
    if (cars_token != null) {

      for (var i = 0; i < cars_token.docs.length; i++) {
        print('token data ');
        print(cars_token.docs[i].data());
        //list_cat.add(cars.docs[i].data()['cat_name']);
      }
    } else {
      print("error");
    }
  }

  printlist() {
    if (cars != null) {
      list_cat.clear();
      for (var i = 0; i < cars.docs.length; i++) {
        list_cat.add(cars.docs[i].data()['cat_name']);
      }
    } else {
      print("error");
    }
  }


  void _showSnackbar(String name) {
//    final scaff = Scaffold.of(context);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Tranaction ${name} Saved'),
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Done', onPressed: _scaffoldKey.currentState.hideCurrentSnackBar,
      ),
    ));
  }
//  void _onPressed() {
//    print('inside onpreesses');
//    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
//      querySnapshot.docs.forEach((result) {
//        print(result.data);
////        FirebaseFirestore.instance
////            .collection("users")
////            .doc(result.id)
////            .collection("tokens")
////            .get()
////            .then((querySnapshot) {
////          querySnapshot.docs.forEach((result) {
////            print(result.data);
////          });
////        });
//      });
//    });
//  }
//
//
//  void _onPressedone() async{
//    final User _auth = FirebaseAuth.instance.currentUser;
//    FirebaseFirestore.instance
//        .collection("users")
//        .doc(_auth.uid)
//        .collection("tokens")
//        .get().then((value){
//          value.docs.forEach((element) {
//            print(element.data()['token']);
//          });
//
//    });
//  }
//
//  void _onPressedall() async{
//



//    FirebaseFirestore.instance
//        .collection("users")
//        .doc(_auth.uid)
//        .collection("tokens")
//        .get().then((value){
//      print(value.docs[0].data()['token']);
//    });
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

