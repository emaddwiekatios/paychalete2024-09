import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:paychalet/Calinder/BookingTabs.dart';
import 'dart:math' as Math;
import 'package:paychalet/colors.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
//import 'package:paychalet/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:paychalet/Invoices/Invoices_Class.dart';
import '../main_page.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import  'package:keyboard_actions/keyboard_actions.dart';
import 'package:paychalet/KeyBoard/KeyBoard.dart';
//import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'Booking.dart';
import 'BookingFull.dart';
import 'package:flutter/cupertino.dart';


class BookingAdd extends StatefulWidget {
  var booking_max;
  DateTime selectedDay ;
  BookingAdd({this.booking_max,this.selectedDay});
  @override
  _BookingAddState createState() => _BookingAddState();
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
String resultString;
class _BookingAddState extends State<BookingAdd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

String Booking_String_start='Start Time';
  String Booking_String_End='End Time';
DateTime Booking_StartTime ;
  DateTime Booking_endTime ;
  @override
  void initState() {

    super.initState();

    _date=widget.selectedDay;
     Booking_StartTime =widget.selectedDay;
     Booking_endTime =widget.selectedDay;
    getCurrentUser();
    //  print("inside init");
    colorOne = Red_deep2;
    colorTwo = Red_deep3;
    colorThree = Red_deep1;
    getData().then((results) {
      setState(() {
        contBookingno.text = widget.booking_max.toString() ;
        cars = results;
        printlist();
      });
    });






    getDataproviders().then((results) {
      setState(() {
        // print(widget.booking_max);
        //contBookingno.text = widget.booking_max;
        carsproviders = results;
        printlistproviders();
      });
    });

  }


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

  List<String> list_currency = ['Shakel'];

  String _selectedcurrency = 'Shakel';

  List<String> list_pays_from = ['Emad','Walid','Emad+Walid'];

  String _selectedpays_from = 'Emad';


  List<String> booking_type = ['Full Day','SubDay'];

  String _selectedbooking_type= 'SubDay';
  List<String> booking_status = ['Inital','Approved'];

  String _selectedbooking_status= 'Inital';

  TextEditingController contBookingno = new TextEditingController();
  TextEditingController contBookingName = new TextEditingController();
  TextEditingController contBookingAmt = new TextEditingController();
  TextEditingController contPaymentfav = new TextEditingController();
  TextEditingController contPaymentcat = new TextEditingController();
  TextEditingController contBookingDesc = new TextEditingController();
  TextEditingController contBookingMobile = new TextEditingController();
  TextEditingController contPaymentdentrydate = new TextEditingController();
  TextEditingController contPaymentTo = new TextEditingController();
  TextEditingController contPaymentdate = new TextEditingController();
  TextEditingController contBookingNotes = new TextEditingController();

  Future getImagecamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleimage = tempImage;
    });

    //  compressImage();
  }


  void _showDatePicker(ctx,String ptime) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: 400,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Container(
                height: 300,
                child: CupertinoDatePicker(

                     initialDateTime: widget.selectedDay,

                    onDateTimeChanged: (val) {
                      setState(() {
                        print(val);
                        if (ptime=='Start') {
                          Booking_String_start = formatDate(val,
                              [yyyy,'-',mm,'-',dd,' ',hh]);
                          Booking_StartTime = val;
                        }
                        else {
                          Booking_String_End = formatDate(val,
                              [yyyy,'-',mm,'-',dd,' ',hh])
                          ;
                          Booking_endTime=val;
                        }

                      //  _chosenDateTime = val;
                      });
                    }),
              ),

              // Close the modal
              CupertinoButton(


                child: Text('OK'),
                onPressed: () {
                  print(Booking_String_start);
                  if (ptime=='Start') {
                    if(Booking_String_start == 'Start Time') {
                      setState(() {
                        Booking_String_start=formatDate(widget.selectedDay,
                            [yyyy,'-',mm,'-',dd,' ',hh]);
                        Booking_StartTime =widget.selectedDay;
                      });

                    }
                  }
                  else {
                    print(Booking_String_End);
                    if(Booking_String_End == 'End Time') {
                      setState(() {
                        Booking_String_End=formatDate(widget.selectedDay,
                            [yyyy,'-',mm,'-',dd,' ',hh]);
                        Booking_endTime =widget.selectedDay;
                      });

                    }


                  }

                  Navigator.of(ctx).pop();
                }
              )
            ],
          ),
        ));
  }
  Future getImagegalary() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleimage = tempImage;
    });

    /// compressImage();
  }

  Widget build(BuildContext context) {
    tfwidth=MediaQuery.of(context).size.width/120;
    tfheght=MediaQuery.of(context).size.height/47;

    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
     // resizeToAvoidBottomPadding: false,
      ////resizeToAvoidBottomInset: false,
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
              top: MediaQuery.of(context).size.height / tfheght-25,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  print('inside button');
                  print('inside button');
                  //_scaffoldKey.currentState.openDrawer();
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Booking()),
                  );
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / tfheght-15,
              left: MediaQuery.of(context).size.width / 2 -
                  ('Add Booking'.toString().length * 8),
              child: Text(
                AppLocalizations.of(context).translate('Add Booking'),

                //'Add Payment',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white,),
              ),
            ),
            //body
            Positioned(
                top: MediaQuery.of(context).size.height / tfheght+15,
                right: 0,
                child:  Container(
                    width: MediaQuery.of(context).size.width,
                    height:pheight,
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
                            child:  SingleChildScrollView(
                              child: Container(
                              width: MediaQuery.of(context).size.width,
                        height:pheight+100,
                        child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    //no
                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_No')} :'
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
                                            child: TextFormField(

                                                keyboardType: TextInputType.number,
                                                controller: contBookingno,
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
                                                          contBookingno.clear();
                                                          contBookingno.text = null;
                                                        }),
                                                    contentPadding:
                                                    EdgeInsets.only(left: 15.0, top: 20.0,right:5),
                                                    hintText:
                                                    AppLocalizations.of(context).translate('Booking_No'),

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
                                    //date
                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Date')} :'
                                                ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
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
                                                        currentTime: _date,
                                                        locale: LocaleType.ar);
                                                  }
                                                  ,
                                                  color: Colors.white,
                                                  //padding: EdgeInsets.only(left: (5.0), top: 5.0),
                                                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                                  child: Text('${formatDate(_date,
                                                      [yyyy,'-',M,'-',dd,' '])}',style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
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
                                                      currentTime: _date,
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


                                    //time
                                    Row(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height / (tfheght-5),
                                          width: MediaQuery.of(context).size.width/tfwidth,
                                          child: Material(
                                            elevation: 5.0,
                                            borderRadius: BorderRadius.circular(5.0),
                                            child:

                                            Padding(
                                              padding: const EdgeInsets.only(top:20,left:5,right:5),
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Time')} :'
                                                ,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width:5),
                                        Container(
                                          height: MediaQuery.of(context).size.height / (tfheght-5) ,
                                          width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/tfwidth)-15,

                                          child:  Material(
                                            elevation: 5.0,
                                            borderRadius: BorderRadius.circular(5.0),
                                            child:
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height / ((tfheght)+10),


                                                child: FlatButton(
                                                  child: Text('Start :${Booking_String_start}'),
                                                  onPressed: () {
                                                    _showDatePicker(context,'Start');
                                                  },
                                                ),
                                              ),
                                                                   SizedBox(
                                              height: MediaQuery.of(context).size.height / ((tfheght)+10),


                                              child: FlatButton(
                                                child: Text('End :${Booking_String_End}'),
                                                onPressed: () {
                                                  _showDatePicker(context,'End');
                                                },
                                              ),
                                          ),
                                            //  Text(resultString ?? "")
                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                   //name
                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Name')} :'
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
                                            child: TextFormField(

                                                keyboardType: TextInputType.text,
                                                controller: contBookingName,
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
                                                          contBookingName.clear();
                                                          contBookingName.text = null;
                                                        }),
                                                    contentPadding:
                                                    EdgeInsets.only(left: 15.0, top: 20.0,right:5),
                                                    hintText:
                                                    AppLocalizations.of(context).translate('Booking_Name'),

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
                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Desc')} :'
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
                                            child: TextFormField(

                                                keyboardType: TextInputType.text,
                                                controller: contBookingDesc,
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
                                                          contBookingDesc.clear();contBookingNotes.clear();
                                                          contBookingDesc.text = null;
                                                        }),
                                                    contentPadding:
                                                    EdgeInsets.only(left: 15.0, top: 20.0,right:5),
                                                    hintText:
                                                    AppLocalizations.of(context).translate('Booking_Desc'),

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
                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Notes')} :'
                                                ,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 12),),
                                            ),
//                                            Padding(
//                                              padding: const EdgeInsets.only(top:20,left:5,right:5),
//                                              child: Text(${AppLocalizations.of(context).translate('Booking_Notes')} :'
//                                                ,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 12),),
//                                            ),
                                          ),
                                        ),
                                        SizedBox(width:5),
                                        Container(
                                          height: MediaQuery.of(context).size.height / tfheght,
                                          width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/tfwidth)-15,

                                          child: Material(
                                            elevation: 5.0,
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: TextFormField(

                                                keyboardType: TextInputType.text,
                                                controller: contBookingNotes,
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
                                                          contBookingDesc.clear();contBookingNotes.clear();
                                                          contBookingDesc.text = null;
                                                        }),
                                                    contentPadding:
                                                    EdgeInsets.only(left: 15.0, top: 20.0,right:5),
                                                    hintText:
                                                    AppLocalizations.of(context).translate('Booking_Notes'),

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

//mobile
//mobile

                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Mobile')} :'
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
                                            child: TextFormField(
                                                focusNode: _nodeText1,
                                                keyboardType: TextInputType.number,
                                                controller: contBookingMobile,
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
                                                          contBookingMobile.clear();
                                                          contBookingMobile.text = null;
                                                        }),
                                                    contentPadding:
                                                    EdgeInsets.only(left: 15.0, top: 20.0,right:5),
                                                    hintText:
                                                    AppLocalizations.of(context).translate('Booking_Mobile'),

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
                                    //amt
                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Amt')} :'
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
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width/1.6,
                                                  child: TextFormField(
                                                      keyboardType: TextInputType.numberWithOptions(),
                                                      focusNode: _nodeText2,
                                                      controller: contBookingAmt,
                                                      onChanged: (value) {},
                                                      validator: (input) {
                                                        if (input.isEmpty) {
                                                          return 'Please Prod Cost ';
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
                                                                contBookingAmt.clear();
                                                                contBookingAmt.text = null;
                                                              }),
                                                          contentPadding:
                                                          EdgeInsets.only( top: 15.0,right:15,left:15),
                                                          hintText: AppLocalizations.of(context).translate('Booking_Amt'),

                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
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
                                    //by
                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_By')} :'
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
                                            child: Row(
                                              children: [

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5.0, top: 5.0,right:5),
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
                                                          hint: Text(_selectedpays_from),
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
                                    //type

                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Type')} :'
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
                                            child: Row(
                                              children: [

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5.0, top: 5.0,right:5),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5.0),
                                                      child: DropdownButton<String>(
                                                          items: booking_type.map((String val) {
                                                            return new DropdownMenuItem<String>(
                                                              value: val,
                                                              child: new Text(val),
                                                            );
                                                          }).toList(),
                                                          hint: Text(_selectedbooking_type),
                                                          onChanged: (newVal) {
                                                            this.setState(() {
                                                              _selectedbooking_type = newVal;
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

                                    //ststus

                                    Row(
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
                                              child: Text('${AppLocalizations.of(context).translate('Booking_Status')} :'
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
                                            child: Row(
                                              children: [

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5.0, top: 5.0,right:5),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5.0),
                                                      child: DropdownButton<String>(
                                                          items: booking_status.map((String val) {
                                                            return new DropdownMenuItem<String>(
                                                              value: val,
                                                              child: new Text(val),
                                                            );
                                                          }).toList(),
                                                          hint: Text(_selectedbooking_status),
                                                          onChanged: (newVal) {
                                                            this.setState(() {
                                                              _selectedbooking_status = newVal;
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




                                    SizedBox(
                                      height: 5,
                                    ),





                                    SizedBox(
                                      height: 5,
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
                                              //['۰', '۱', '۲', '۳', '۴', '۵', '٦', '۷', '۸', '۹']
                                              print('before if }');
                                              if ((contBookingName.text +
                                                  contBookingDesc.text)
                                                  .isEmpty) return;
                                              _save_data(
                                                  int.parse(contBookingno.text),
                                                  _date,
                                                  contBookingName.text,
                                                replacearabictoenglishNumber(contBookingMobile.text),
                                                  contBookingDesc.text,
                                                  _selectedpays_from,
                                                  _selectedbooking_type,
                                                  double.parse(replacearabictoenglishNumber(contBookingAmt.text))
                                                 ,Booking_StartTime,Booking_endTime ,_selectedbooking_status,contBookingNotes.text,);
                                              setState(() {
                                                contBookingno.text= (int.parse(contBookingno.text)+1).toString();

                                              });

                                              }
                                              //addimagedata();






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
                                                  builder: (BuildContext context) => new BookingTabs()),
                                            );
                                          },
                                        ),

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
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),

            ),

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
    FirebaseStorage.instance.ref().child('${contBookingName.text}.jpg');
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

    addimagedata();
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




  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser;

    //final uid = user.uid;
    //return user.email;
  }
  addimagedata() {
    final todayDate = DateTime.now();
    currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);


    getCurrentUser();
    FirebaseFirestore.instance.collection("Payments").doc().set({
      'Payment_id': contBookingno.text,
      'Payment_name': contBookingName.text,
      'Payment_desc': contBookingDesc.text,
      'Payment_amt': contBookingAmt.text,
      'Payment_to': _selectedProviders ,//contPaymentTo.text,
      'Payment_fav': "false",
      'Payment_cat': _selectedCat,
      'Payment_entry_date':_date,// currentdate,
      'Payment_modify_date':todayDate,// currentdate,
      'Payment_img': url2,
      'Booking_By':_selectedpays_from,
      'Payment_user':user.email.toString(),
      'Payment_currency':_selectedcurrency
    })
    ;

    FirebaseFirestore.instance.collection("PaymentsHistory").doc().set({
      'Payment_id': contBookingno.text,
      'Payment_name': contBookingName.text,
      'Payment_desc': contBookingDesc.text,
      'Payment_amt': contBookingAmt.text,
      'Payment_to': contPaymentTo.text,
      'Payment_fav': "false",
      'Payment_cat': _selectedCat,
      'Payment_entry_date': todayDate,//currentdate,
      'Payment_modify_date': todayDate,//currentdate,
      'Payment_img': url2,
      'Booking_By':_selectedpays_from,
      'Payment_user':user.email.toString(),
      'Payment_currency':_selectedcurrency
    });

    _showSnackbar(contBookingName.text);
    setState(() {
      contBookingno.text = (int.parse(contBookingno.text) + 1).toString();
      contBookingName.clear();
      contBookingDesc.clear();contBookingNotes.clear();
      contBookingAmt.clear();
      contPaymentTo.clear();
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


  String replacearabictoenglishNumber(String input) {
 print(input.replaceAll("١","1").replaceAll("٢","2").replaceAll("٣","3")
    .replaceAll("٤","4").replaceAll("٥","5").replaceAll("٦","6").replaceAll("٧","7").replaceAll("٨","8")
    .replaceAll("٩","9").replaceAll("٫",".").replaceAll("٠","0"));
    return input.replaceAll("١","1").replaceAll("٢","2").replaceAll("٣","3")
        .replaceAll("٤","4").replaceAll("٥","5").replaceAll("٦","6").replaceAll("٧","7").replaceAll("٨","8")
        .replaceAll("٩","9").replaceAll("٫",".").replaceAll("٠","0");
  }
  void _save_data(int booking_no,DateTime Booking_date, String cust_name, String cust_mobile,String booking_desc,
  String booking_by,String booking_type,
      double cust_pay, DateTime start,DateTime end,String booking_status,bookingnotes) {
    //print('inside sav firebase');
    FirebaseFirestore.instance.collection("events").doc().set({
      'booking_no': booking_no,
      'cust_name': cust_name,
      'cust_mobile': cust_mobile,
      'booking_desc':booking_desc,
      'booking_by':booking_by,
      'booking_type':booking_type,
      'cust_pay': cust_pay,
      'booking_date': Booking_date,
      'booking_startTime': start,
      'booking_endTime': end,
      'booking_entry_date': DateTime.now(),
      'booking_status':booking_status,'booking_notes':bookingnotes
    });

    FirebaseFirestore.instance.collection("eventshistory").doc().set({
      'booking_no': booking_no,
      'cust_name': cust_name,
      'cust_mobile': cust_mobile,
      'booking_desc':booking_desc,
      'booking_by':booking_by,
      'booking_type':booking_type,
      'cust_pay': cust_pay,
      'booking_date': Booking_date,
      'booking_startTime': start,
      'booking_endTime': end,
      'booking_entry_date': DateTime.now(),
      'booking_status':booking_status,'booking_notes':bookingnotes
    });

    _showSnackbar(contBookingName.text);
    setState(() {
      contBookingno.text = (int.parse(contBookingno.text) + 1).toString();
      contBookingName.clear();
    contBookingDesc.clear();contBookingNotes.clear();
      contBookingAmt.clear();
      contPaymentTo.clear();
      contBookingMobile.clear();
    });


    print('booking save');
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


