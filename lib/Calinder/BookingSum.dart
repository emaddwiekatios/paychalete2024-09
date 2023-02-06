import 'package:flutter/material.dart';
import 'package:paychalet/Calinder/BookingEdit.dart';
import 'dart:ui';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:paychalet/colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Booking.dart';
import 'BookingAdd.dart';
import 'package:date_format/date_format.dart';
//import 'Booking_Class.dart';

class BookingSum extends StatefulWidget {
  @override
  _BookingSumState createState() => _BookingSumState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Colors.amber;
Color colorTwo = Colors.amber[300];
Color colorThree = Colors.amber[100];
List _selectedEvents;
class _BookingSumState extends State<BookingSum> with TickerProviderStateMixin {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // Color pyellow = Color(Colors.amber);

  ////  add  keyboard action
  Map<DateTime, List> _events;

  AnimationController _animationController;
  CalendarController _calendarController;
  List<eventclass> instlist = [];

  List Booking_date = [];

//  List Bookingfrom = [];
  List Bookinggroup = [
    {
      "Booking_total": 7.0,

      "Booking_date": "",
    }
  ];
  String _name_year;

  List Bookingtotal = [
    {
      "Booking_total": 7.0,
      "Booking_from": "7.0",
    }
  ];
   double temp_tempyearly =0.0;
  DateTime _selectedDay;
  DateTime _selectedDay2;
  var Booking_max;
  QuerySnapshot cars;
  TextEditingController _eventController_mobile = new TextEditingController();
  TextEditingController _eventController_name = new TextEditingController();

  TextEditingController _eventController_pay_amt = new TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Bookinggroup.add({
    //   "Booking_date": 0,
    //
    //   "Booking_total": 0,
    // });
    final _selectedDay = DateTime.now();
    _events = {};
    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
      ]
    };

    _selectedEvents = _events[_selectedDay] ?? [];

    call_get_data();

    ;

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day,List events,List holidays) {
    print('CALLBACK: _onDaySelected$day');
    setState(() {
      _selectedDay2 = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first,DateTime last,
      CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first,DateTime last,CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
    //_onDaySelected;
  }



  List Booking_year = [];
//  List Bookingfrom = [];


  List Bookinggroupyearly = [
    {
      "Booking_year": "",
      "Booking_total": 7.0,
    }
  ];
// Example holidays
  final Map<DateTime, List> _holidays = {
    DateTime(2020,1,1): ['New Year\'s Day'],
    DateTime(2020,1,6): ['Epiphany'],
    DateTime(2020,2,14): ['Valentine\'s Day'],
    DateTime(2020,4,21): ['Easter Sunday'],
    DateTime(2020,4,22): ['Easter Monday'],
  };

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
        KeyboardActionsItem(focusNode: _nodeText2,toolbarButtons: [
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
          footerBuilder: (_) =>
              PreferredSize(
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

//note  add  code on text field
//  KeyboardActions(
//  config: _buildConfig(context),
  //child:widget
  // add on text field  focusNode: _nodeText1,

  ///// end add  keyboard action

  Widget build(BuildContext context) {
    var pheight = MediaQuery
        .of(context)
        .size
        .height;
    var pwidth = MediaQuery
        .of(context)
        .size
        .width;

    var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
      key: _scaffoldKey,
      // drawer: Appdrawer(),
      body: GestureDetector(
        onTap: () {
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
            /*
            Positioned(
              top: 125,
              left: -150,
              child: Container(
                height: 450, //MediaQuery.of(context).size.height / 4,
                width: 450, //MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: Colors.amber,
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
                    color: Colors.amber),
              ),
            ),
            */
            //a
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
                    borderRadius: BorderRadius.circular(200),color: Red_deep2),
              ),
            ),
            //menu
            Positioned(
              top: pheight / 25,
              left: pwidth / 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // print('inside button');
                  // _scaffoldKey.currentState.openDrawer();
                  // Navigator.pop(context);
                  Navigator.pushReplacementNamed(context,"/PaysMain");
                },
              ),
            ),
            Positioned(
              top: pheight / 25,
              right: pwidth / 20,
              child: IconButton(
                icon: Icon(Icons.add,size: 30),
                onPressed: () {
                  // _scaffoldKey.currentState.openDrawer();

                  Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new BookingAdd(
                            booking_max:
                            Booking_max != null ? Booking_max : '1',
                            selectedDay: _selectedDay2 != null
                                ? _selectedDay2
                                : DateTime.now())),
                  );
                },
              ),
            ),
            //body
            Positioned(
              top: pheight / 15,
              right: 0,
              bottom: 50,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height >= 775.0
                    ? MediaQuery
                    .of(context)
                    .size
                    .height-20
                    : 705.0,
                /* decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              Colors.red,
                            Colors.orange

                            //Color(getColorHexFromStr('#FDD100')),
                             //Color(getColorHexFromStr('#FDD120'))
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
*/
                child: GridView.builder(
                    itemCount: Bookinggroup.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3
                    ),
                    itemBuilder: (BuildContext context,int index) {
                      return _build_summary(
                        Booking_date: Bookinggroup[index]['Booking_date'],
                        Booking_total: Bookinggroup[index]['Booking_total'],
                       // Shacks_total: Bookinggroup[index]['Payment_total']
                          //  .toString(),
                      );
                    }

                ),
/*
FutureBuilder<List<UserModel>>(
future: db.getUserModelData(),
builder: (context, snapshot) {
if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
*/
              ),
            ),
            //header title
            Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height / 18,
              left: MediaQuery
                  .of(context)
                  .size
                  .width / 2 - 50,
              child: Text(
                AppLocalizations.of(context).translate('Revene'),
                style: TextStyle(fontSize: 29,fontWeight: FontWeight.bold),
              ),
            ),

            Positioned(
              // top: MediaQuery.of(context).size.height / 6,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrange[50],
                  //),
                ),
                child:GridView.builder(
                    scrollDirection:Axis.horizontal,
                    itemCount: Bookinggroupyearly.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1),
                    itemBuilder: (BuildContext context, int index) {

                      return _build_summary_yearly(
                        Booking_year: Bookinggroupyearly[index]['Booking_year'],
                        Booking_total: Bookinggroupyearly[index]['Booking_total'],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.black,
//        child: Icon(Icons.add),
//        onPressed: _showAddDialog,
//      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (_) =>
        new AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery
                  .of(context)
                  .size
                  .height;
              var width = MediaQuery
                  .of(context)
                  .size
                  .width;

              return Container(
                height: height / 2,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Center(child: Text("Add Events")),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: " Name",
                            hintText: "name?",
                          ),
                          controller: _eventController_name,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: " Mobile",
                            hintText: "Mobile?",
                          ),
                          controller: _eventController_mobile,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Pay_amt",
                            hintText: "Pay_amt?",
                          ),
                          controller: _eventController_pay_amt,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.lightBlue,
                        ),
                        RaisedButton(
                          color: Colors.lightBlue,
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            //_eventController.text=_eventController_name.text+_eventController_mobile.text;
                            print('before if');
                            if ((_eventController_name.text +
                                _eventController_mobile.text)
                                .isEmpty) return;
                            if (this.mounted) {
                              setState(() {
                                if (_events[
                                _calendarController.selectedDay] !=
                                    null) {
                                  //  print('inside iss not null');
                                  _events[_calendarController.selectedDay]
                                      .add(' Name : ' +
                                      _eventController_name.text +
                                      ' Mobile :' +
                                      _eventController_mobile.text +
                                      ' Pay_Amt :' +
                                      _eventController_pay_amt.text);
                                  _save_data(
                                      1,
                                      _eventController_name.text,
                                      _eventController_mobile.text,
                                      double.parse(
                                          _eventController_pay_amt.text),
                                      _calendarController.selectedDay);
                                } else {
                                  _events[_calendarController.selectedDay] =
                                  [
                                    ' Name : ' +
                                        _eventController_name.text +
                                        ' Mobile :' +
                                        _eventController_mobile.text +
                                        ' Pay_amt :' +
                                        _eventController_pay_amt.text
                                  ];
                                  _save_data(
                                      1,
                                      _eventController_name.text,
                                      _eventController_mobile.text,
                                      double.parse(
                                          _eventController_pay_amt.text),
                                      _calendarController.selectedDay);
                                }
//                                prefs.setString("events",
//                                    json.encode(encodeMap(_events)));
//                                _eventController.clear();
                                Navigator.pop(context);
                              });
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blueAccent[400],
        todayColor: Colors.deepPurple[200],
        markersColor: Colors.red[700],
        highlightSelected: true,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
        TextStyle().copyWith(color: Colors.white,fontSize: 17.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      // locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      // startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week',
        CalendarFormat.twoWeeks: '2 Week',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.red[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.red[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
        TextStyle().copyWith(color: Colors.white,fontSize: 17.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context,date,_) {
          return FadeTransition(
            opacity: Tween(begin: 0.0,end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0,left: 6.0),
              decoration: BoxDecoration(
                  color: Colors.deepOrange[300],
                  borderRadius: BorderRadius.circular(10.0)),
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context,date,_) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0,left: 6.0),
            decoration: BoxDecoration(
                color: Colors.amber[400],
                borderRadius: BorderRadius.circular(10.0)),
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context,date,events,holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date,events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date,events,holidays) {
        _onDaySelected(date,events,holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date,List events) {
    //  print('ff=${_calendarController.visibleEvents.values.}');


    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),

        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
            ? Colors.brown[300]
            : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year,dateTime.month,dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) =>
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 6,
            decoration: BoxDecoration(
              border: Border.all(width: 0.8),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin:
            const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
            child: ListTile(
                title: Text(event.toString().substring(1,event.length)),
                // leading: Text(event.toString().substring(1,20)),
                trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            dialog_parameter = 0;
                          });
                          LineSplitter ls = new LineSplitter();
                          List<String> lines = ls.convert(event);
                          for (var i = 0; i < instlist.length; i++) {
                            if (instlist[i].booking_no.toString() ==
                                lines[1].substring(6).trim()) {
                              eventclass event1 = instlist[i];
                              showAlertDialog(context,event1,event);
//                                  if (dialog_parameter==1)
//                                  {
//                                  setState(() {
//                                  deleteData(event1.docs_id);
//                                  _selectedEvents.remove(event);
//                                  });
//                                  }
                            }
                          }
                        },
                      ),
                      //  Icon(Icons.delete_forever,color: Colors.red,)
                    ]),

                //   subtitle: Text(event.toString().substring(1,20)),
                onTap: () {
                  LineSplitter ls = new LineSplitter();
                  List<String> lines = ls.convert(event);
                  print("---Result---");
                  for (var i = 0; i < instlist.length; i++) {
                    if (instlist[i].booking_no.toString() ==
                        lines[1].substring(6).trim()) {
                      eventclass event1 = instlist[i];

//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => BookingEdit(
//                          evn: event1,
//                        ),
//                      ));
                    }
                  }
                }),
          ))
          .toList(),
    );
  }

  deleteData(docId) async {
    FirebaseFirestore.instance
        .collection('events')
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });

//    Navigator.of(context).pushReplacement(
//      new MaterialPageRoute(
//          builder: (BuildContext context) => new SocialHome()),
//    );
  }

  void _save_data(int booking_no,String cust_name,String cust_mobile,
      double cust_pay,DateTime Booking_date) {
    //print('inside sav firebase');
    FirebaseFirestore.instance.collection("events").doc().set({
      'booking_no': booking_no,
      'cust_name': cust_name,
      'cust_mobile': cust_mobile,
      'cust_pay': cust_pay,
      'booking_date': Booking_date,
      'booking_entry_date': DateTime.now(),
    });

    print('booking save');
  }

  call_get_data() {
    getData().then((results) {
      if (this.mounted) {
        setState(() {
          cars = results;

          printlist();
        });
      }
    });
  }


  var dialog_parameter = 0;

  getData() async {
    return await FirebaseFirestore.instance
        .collection('events')
    //.orderBy('Payment_id', descending: true)

        .get();
  }

  printlist() {
    if (cars != null) {
      setState(() {
        _events.clear();
        _events = {};
      });

      for (var i = 0; i < cars.docs.length; i++) {

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
        instlist.add(instone);
        _selectedDay = instone.booking_date;
        instone.booking_notes = cars.docs[i].data()['booking_notes'];
      }
    //  var count = instlist.where((c) => c.booking_by == 'Emad').length;

   // print('booking_by ');
     // print( count);
      if (instlist.length > 0) {
        instlist.sort((a, b) => a.booking_no.compareTo(b.booking_no));
        var array_len = instlist.length;
        setState(() {
          instlist.sort(
                  (a, b) => a.booking_startTime.compareTo(b.booking_startTime));

          for (var i = 0; i < instlist.length; i++) {
            Booking_date.add(formatDate(instlist[i].booking_startTime, [
              yyyy,
              '-',
              M,
            ]));

            Booking_year.add(formatDate(instlist[i].booking_startTime, [yyyy
            ]));

          }

          //for month

          Booking_date = Set.of(Booking_date).toList();

          double month_amt_do = 0;
          temp_tempyearly =0;
          double tempyearly = 0;

          Bookinggroup.clear();
          Bookinggroupyearly.clear();
          Bookingtotal.clear();


          for (int c = 0; c < Booking_date.length; c++) {
            month_amt_do = 0.0;
            temp_tempyearly = 0.0;
            Booking_date[c].toString().substring(0, 4);
            _name_year=null;

            for (int j = 0; j < instlist.length; j++) {


              if (formatDate(
                  instlist[j].booking_startTime, [yyyy, '-', M,]) == Booking_date[c]) {
                setState(() {
                  var temp =instlist[j].cust_pay > 0 ? instlist[j].cust_pay : 0;
                  month_amt_do = month_amt_do + temp;
                });
              }

            }
            setState(() {
              if (month_amt_do > 0) {
                Bookinggroup.add({
                  "Booking_date": Booking_date[c],
                  "Booking_total": month_amt_do,
                });
              }
            });

          }
        });


        ///yearly

        Booking_year = Set.of(Booking_year).toList();
        double yearAmt = 0.0;



        // Bookinggroup.clear();
        Bookinggroupyearly.clear();
        Bookingtotal.clear();


        for (int c = 0; c < Booking_year.length; c++) {
          yearAmt = 0.0;

          _name_year=null;

          for (int j = 0; j < instlist.length; j++) {
            if (formatDate(
                instlist[j].booking_startTime, [yyyy]) ==
                Booking_year[c]) {
              setState(() {
                var temp =
                instlist[j].cust_pay > 0 ? instlist[j].cust_pay : 0;
                yearAmt = yearAmt + temp;
              });
            }

          }



          setState(() {
            if (yearAmt > 0) {
              Bookinggroupyearly.add({
                "Booking_year": Booking_year[c],
                "Booking_total": yearAmt,
              });
            }
          });





        }













      }
    }
  }
  showAlertDialog(BuildContext context,eventclass event1,dynamic event) {
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
            deleteData(event1.docs_id);
            _selectedEvents.remove(event);
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



class eventclass {
  int booking_no;
  String cust_name;
  String booking_desc;
  String booking_by;
  String booking_type;
  String cust_mobile;
  double cust_pay;
  DateTime booking_date;
  DateTime booking_entry_date;
  String docs_id;
  DateTime booking_startTime;
  DateTime booking_endTime;
  String booking_status;
  String booking_notes;
  eventclass(
      {this.booking_no,
        this.cust_name,
        this.cust_mobile,
        this.booking_date,
        this.booking_entry_date,
        this.docs_id,
        this.booking_endTime,
        this.booking_startTime,
        this.cust_pay,
        this.booking_type,
        this.booking_by,
        this.booking_desc,
        this.booking_status,this.booking_notes});
}




class _build_summary extends StatelessWidget {
  final String Booking_date;
  //final String Shacks_from;
  final double Booking_total;
  _build_summary({
    this.Booking_date,
    // this.Shacks_from,
    this.Booking_total,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Hero(
        tag: new Text("Hero1") //productname
        ,
        child: Material(
          child: InkWell(
            onTap: () {
              // // print('${cat_date}');
//          Navigator.of(context).push(
//            new MaterialPageRoute(
//                builder:  (BuildContext context) => new categorysdetails(
//
//                  cat_id:cat_id,
//                  cat_name: cat_name,
//                  cat_desc:cat_desc ,
//                  cat_img:cat_img ,
//                  cat_remark:cat_remark ,
//                  cat_date: cat_date,
//                  cat_doc_id: cat_doc_id,
//
//
//                )
//            ),
//          );
            },
            child: GridTile(
              header: Center(
                  child: Container(
                    color: Colors.black12,
                    child: Text(
                      '${Booking_date}',
                      style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  )),

//              footer: Container(
//                  color: Colors.white70,
//                  child: new Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.only(left: 20.0),
//                          child: Center(
//                              child: new Text(
//                                Shacks_from,
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold, fontSize: 16.0),
//                              )),
//                        ),
//                      ),
//                    ],
//                  )
//
//                /*  ListTile(
//                     leading: Text(productname , style: TextStyle(fontWeight: FontWeight.bold),
//
//                     ),
//                     title: Text("\$$prodprice",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800),),
//                       subtitle: Text("\$$prodoldprice",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800,
//                                                                       decoration: TextDecoration.lineThrough),),
//
//                       ),
//                */
//
//              ),
              // child: Image.asset(prodpicture,fit: BoxFit.cover,),
              child: Center(
                  child: Text(
                    "${Booking_total}",
                    style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  )),
              //Image.network(cat_img,fit: BoxFit.cover,),
            ),
          ),
        ),
      ),
    );
  }
}


class _build_summary_yearly extends StatelessWidget {
  final String Booking_year;
  //final String Shacks_from;
  final double Booking_total;
  _build_summary_yearly({
    this.Booking_year,
    // this.Shacks_from,
    this.Booking_total,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Hero(
        tag: new Text("Hero1") //productname
        ,
        child: Material(
          child: InkWell(
            onTap: () {
            },
            child: GridTile(
              header: Center(
                  child: Container(
                    color: Colors.black12,
                    child: Text(
                      '${Booking_year}',
                      style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Center(
                      child: Text(
                        "${Booking_total}",
                        style:
                        TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      )),


                    ],
              ),
              //Image.network(cat_img,fit: BoxFit.cover,),
            ),
          ),
        ),
      ),
    );
  }
}