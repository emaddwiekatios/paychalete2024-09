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

import 'BookingAdd.dart';
import 'package:date_format/date_format.dart';
//import 'Booking_Class.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Colors.amber;
Color colorTwo = Colors.amber[300];
Color colorThree = Colors.amber[100];
List _selectedEvents;
class _BookingState extends State<Booking> with TickerProviderStateMixin {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color pyellow = Color(Colors.amber);

  ////  add  keyboard action
  Map<DateTime, List> _events;

  AnimationController _animationController;
  CalendarController _calendarController;
  List<eventclass> instlist = [];
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

    final _selectedDay = DateTime.now();
    _events = {};
    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
      ]
    };

    _selectedEvents = _events[_selectedDay] ?? [];

    call_get_data();



    _calendarController = CalendarController();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400),);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected$day');
    setState(() {
      _selectedDay2 = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
    //_onDaySelected;
  }

// Example holidays
  final Map<DateTime, List> _holidays = {
    DateTime(2020, 1, 1): ['New Year\'s Day'],
    DateTime(2020, 1, 6): ['Epiphany'],
    DateTime(2020, 2, 14): ['Valentine\'s Day'],
    DateTime(2020, 4, 21): ['Easter Sunday'],
    DateTime(2020, 4, 22): ['Easter Monday'],
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

//note  add  code on text field
//  KeyboardActions(
//  config: _buildConfig(context),
  //child:widget
  // add on text field  focusNode: _nodeText1,

  ///// end add  keyboard action

  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

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
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
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
                    borderRadius: BorderRadius.circular(200), color: Red_deep2),
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
                  Navigator.pushReplacementNamed(context, "/PaysMain");
                },
              ),
            ),
            Positioned(
              top: pheight / 25,
              right: pwidth / 20,
              child: IconButton(
                icon: Icon(Icons.add, size: 30),
                onPressed: () {
                  // _scaffoldKey.currentState.openDrawer();

                  Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new BookingAdd(
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
              top: pheight / 10,
              right: 0,
              bottom: 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // Switch out 2 lines below to play with TableCalendar's settings
                    //-----------------------
                    //_buildTableCalendar(),
                    _buildTableCalendarWithBuilders(),
                    // _buildTableCalendarWithBuilders(),
//          const SizedBox(height: 8.0),
//          _buildButtons(),
                    const SizedBox(height: 8.0),
                    Expanded(child: _buildEventList()),
                  ],
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
              top: MediaQuery.of(context).size.height / 18,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: Text(
                AppLocalizations.of(context).translate('Details'),
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
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
        builder: (_) => new AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

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
            TextStyle().copyWith(color: Colors.white, fontSize: 17.0),
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
            TextStyle().copyWith(color: Colors.white, fontSize: 17.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
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
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
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
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
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
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
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
              DateTime(dateTime.year, dateTime.month, dateTime.day),
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
          .map((event) => Container(
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                    title: Text(event.toString().substring(1, event.length)),
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
                                dialog_parameter=0;
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

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingEdit(
                                  evn: event1,
                                ),
                              ));
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

  void _save_data(int booking_no, String cust_name, String cust_mobile,
      double cust_pay, DateTime Booking_date) {
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


  var dialog_parameter=0;
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
        // print('inside for $i');
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
        //  var temp_date= '${instone.booking_date.year-instone.booking_date.month-instone.booking_date.day}';
        // _selectedDay= DateTime.parse(temp_date);
        //if (this.mounted)

        //  {
        // print('inside set ${_selectedDay}');
        //   print('inside set ${_events[_selectedDay]}');
        if (_events[_selectedDay] != null) {
          // print('inside if add');
          setState(() {
            _events[_selectedDay].add(( '\n No : ' +
                instone.booking_no.toString() +
                '\n Name : ' +
                instone.cust_name +'\n Date :' +
                formatDate(instone.booking_date,[yyyy,'-',M,'-',dd]) +

                '\n Time : '+
                ' ${formatDate(instone.booking_startTime,[dd,':',hh ,' ',am ])}'
                    ' To ${formatDate(instone.booking_endTime,[dd,':',hh ,' ',am ])}'

                    ' \n Pay_amt :' +
                instone.cust_pay.toString() +
                '\n Status:' +
                instone.booking_status.toString()));
          });
        } else {
          //  print('inside else add');
          setState(() {
            _events[_selectedDay] = [
              '\n No : ' +
                  instone.booking_no.toString() +
                  '\n Name : ' +
                  instone.cust_name +'\n Date :' +
                  formatDate(instone.booking_date,[yyyy,'-',M,'-',dd]) +

                  '\n Time : '+
                  ' ${formatDate(instone.booking_startTime,[dd,':',hh ,' ',am ])}'
                  ' To ${formatDate(instone.booking_endTime,[dd,':',hh ,' ',am ])}'

                      ' \n Pay_amt :' +
                  instone.cust_pay.toString() +
                  '\n Status:' +
                  instone.booking_status.toString()
            ];
          });
        }

        // }
      }
      if (instlist.length > 0) {
        instlist.sort((a, b) => a.booking_no.compareTo((b.booking_no)));
        var array_len = instlist.length;
        if (this.mounted) {
          setState(() {
            Booking_max = ((instlist[array_len - 1].booking_no + 1).toString());
            instlist.sort((b, a) => a.booking_no.compareTo((b.booking_no)));
            print('Booking_max===${Booking_max}');
          });
        }
        setState(() {
          // booking_max =
          //((int.parse(_events[array_len - 1]['Payment_id']) + 1)
          //   .toString());
          _selectedEvents.add(_events[_selectedDay]);
          // _onDaySelected;
        });
      }
      //  _selectedEvents.add(_events[DateTime.now()] ?? []);
    }
  }

  showAlertDialog(BuildContext context,eventclass event1,dynamic event) {
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
