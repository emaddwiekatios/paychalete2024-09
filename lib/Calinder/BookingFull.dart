import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BookingFull extends StatefulWidget {
  @override
  _BookingFullState createState() => _BookingFullState();
}

class _BookingFullState extends State<BookingFull> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;
  DateTime _selectedDay ;
  QuerySnapshot cars;
  TextEditingController _eventController_mobile = new TextEditingController();
  TextEditingController _eventController_name = new TextEditingController();

  TextEditingController _eventController_pay_amt = new TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();

    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];

    prefsData();
    call_get_data();
  }

  prefsData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text('Flutter Dynamic Event Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Colors.orange,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events,holidays) {
                setState(() {
                  _selectedEvents = events;
                });
              },

              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            ),
            Container(
                height: MediaQuery.of(context).size.height,
               width: MediaQuery.of(context).size.width,
                child: _buildEventList()),

//            ..._selectedEvents.map((event) => Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Container(
//                height: MediaQuery.of(context).size.height/5,
//                width: MediaQuery.of(context).size.width,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(30),
//                    color: Colors.white,
//                    border: Border.all(color: Colors.grey)
//                ),
//                child: _BuildList()
//
////                Center(
////                    child: Text(event,
////                      style: TextStyle(color: Colors.blue,
////                          fontWeight: FontWeight.bold,fontSize: 16),)
////                ),
//              ),
//            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
    );
  }

//  _showAddDialog() async {
//    await showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//          backgroundColor: Colors.white70,
//          title: Text("Add Events"),
//          content: TextField(
//            controller: _eventController,
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text("Save",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
//              onPressed: () {
//                if (_eventController.text.isEmpty) return;
//                setState(() {
//                  if (_events[_controller.selectedDay] != null) {
//                    _events[_controller.selectedDay]
//                        .add(_eventController.text);
//                  } else {
//                    _events[_controller.selectedDay] = [
//                      _eventController.text
//                    ];
//                  }
//                  prefs.setString("events", json.encode(encodeMap(_events)));
//                  _eventController.clear();
//                  Navigator.pop(context);
//                });
//
//              },
//            )
//          ],
//        ));
//  }
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
                                if (_events[_controller.selectedDay] !=
                                    null) {
                                  print('inside iss not null');
                                  _events[_controller.selectedDay].add(
                                      ' Name : ' +
                                          _eventController_name.text +
                                          ' Mobile :' +
                                          _eventController_mobile.text+
                                      ' Pay_Amt :' +
                                      _eventController_pay_amt.text);
                                  _save_data(
                                      1,
                                      _eventController_name.text,
                                      _eventController_mobile.text,
                                      double.parse(
                                          _eventController_pay_amt.text),
                                      _controller.selectedDay);
                                } else {
                                  _events[_controller.selectedDay] = [
                                    ' Name : ' +
                                        _eventController_name.text +
                                        ' Mobile :' +
                                        _eventController_mobile.text
                                        +
                                        ' Pay_amt :' +
                                        _eventController_pay_amt.text
                                  ];
                                  _save_data(
                                      1,
                                      _eventController_name.text,
                                      _eventController_mobile.text,
                                      double.parse(
                                          _eventController_pay_amt.text),
                                      _controller.selectedDay);
                                }
                                prefs.setString("events",
                                    json.encode(encodeMap(_events)));
                                _eventController.clear();
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

  void _save_data(int booking_no, String cust_name, String cust_mobile,
      double cust_pay, DateTime _booking_date) {
    print('inside sav firebase');
    FirebaseFirestore.instance.collection("events").doc().set({
      'booking_no': booking_no,
      'cust_name': cust_name,
      'cust_mobile': cust_mobile,
      'cust_pay': cust_pay,
      'booking_date': _booking_date,
      'booking_entry_date': DateTime.now(),
    });

    print('booking save');
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


  getData() async {
    return await FirebaseFirestore.instance
        .collection('events')
    //.orderBy('Payment_id', descending: true)

        .get();
  }

  printlist() {
    if (cars != null) {
      _events.clear();
      _events={};
      List<eventclassFull> instlist = [];
      for (var i = 0; i < cars.docs.length; i++) {
        eventclassFull instone = new eventclassFull();
        instone.booking_no = cars.docs[i].data()['booking_no'];
        instone.cust_name = cars.docs[i].data()['cust_name'];
        instone.cust_mobile = cars.docs[i].data()['cust_mobile'];
        instone.cust_pay = cars.docs[i].data()['cust_pay'];
        instone.booking_date = cars.docs[i].data()['booking_date'].toDate();
        instone.booking_entry_date = cars.docs[i].data()['booking_entry_date'].toDate();
        instone.docs_id = cars.docs[i].id;
        instlist.add(instone);
        _selectedDay=instone.booking_date;
        if (this.mounted) {
          setState(() {

            if (_events[_selectedDay] !=
                null) {
              print('inside if add');
              _events[_selectedDay].add(
                  ('Name : ' +
                      instone.cust_name +
                      ' Mobile :' +
                      instone.cust_mobile +
                      ' Pay_Amt :' +
                      instone.cust_pay.toString()).toString());
//              _save_data(
//                  1,
//                  _eventController_name.text,
//                  _eventController_mobile.text,
//                  double.parse(
//                      _eventController_pay_amt.text),
//                  _controller.selectedDay);
            }
            else {
              print('inside else add');
              _events[_selectedDay] = [
                'Name : ' +
                    instone.cust_name +
                    ' Mobile :' +
                    instone.cust_mobile
                    +
                    ' Pay_amt :' +
                    instone.cust_pay.toString()
              ];
            }

           print('new sletected day ${_selectedDay}');
            print('new sletected day 2 ${_events[_selectedDay]}');
            print('new sletected day 2 ${_events}');
            _selectedEvents.add(_events[_selectedDay]);
            prefs.setString("events",
                json.encode(encodeMap(_events)));
            _eventController.clear();
           // call_get_data();
          });
        }
      }
    }
  }
  Widget _BuildList() {
    return //paymentslist.length > 0
      //    ?
      RefreshIndicator(
        // key: refreshKey,
          child:  ListView.builder(
              itemCount: _events.length,
              itemBuilder: (BuildContext context, int index) {
                print('list length=${_events.length}');
                return build_item(context, index);
              }),
          onRefresh: refreshList
      );
    // : Center(child: CircularProgressIndicator());
  }
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

//    setState(() {
////      getUser().then((user) {
////        if (user != null) {
////          setState(() {
////            //Username = user.email;
////            // print('Username0= ${Username}');
////            call_get_data();
////          });
////
////        };
////      });
//    });

    return null;
  }

  Widget build_item(BuildContext context, int index) {
    //print(_events.length);
    //print(_events);
    print('seleted day${_events[_controller.selectedDay]}');
    return Stack(
      children: <Widget>[
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: InkWell(
            onTap: () {
              print('${_events[index]}');
//              Navigator.of(context).push(
//                new MaterialPageRoute(
//                    builder: (BuildContext context) => new PaysDetails(
//                      Payment_id: paymentslist[index]['Payment_id'],
//                      Payment_name: paymentslist[index]['Payment_name'],
//                      Payment_desc: paymentslist[index]['Payment_desc'],
//                      Payment_img: paymentslist[index]['Payment_img'],
//                      Payment_amt: paymentslist[index]['Payment_amt'],
//                      Payment_cat: paymentslist[index]['Payment_cat'],
//                      // Payment_date: paymentslist[index]['Payment_date'],
//                      Payment_entry_date: paymentslist[index]['Payment_entry_date'],
//                      Payment_modify_date: paymentslist[index]['Payment_modify_date'],
//                      Payment_doc_id: paymentslist[index]['Payment_doc_id'].toString(),
//                      Payment_currency: paymentslist[index]['Payment_currency'],
//                      Payment_to: paymentslist[index]['Payment_to'],
//                      Payment_from: paymentslist[index]['Payment_from'],
//
//
//                    )),
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
                                        _events[_controller.selectedDay].toString(),
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
                                  Text('ii',
//                                    '${AppLocalizations.of(context).translate('Amount') }: '  +
//                                        paymentslist[index]['Payment_amt'] + (paymentslist[index]['Payment_currency']=='Dollar' ? ' \$':' sh'),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                        color: Color(0xFFFDD34A)),
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
                                          Text('tt',
                                            //paymentslist[index]['Payment_from']!=null ? paymentslist[index]['Payment_from'] : '0',
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                              'No :' //+ paymentslist[index]['Payment_id'],
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
//                                          setState(() {
////                                            print(paymentslist[index]
////                                            ['Payment_doc_id']
////                                                .toString());
////
////                                            deleteData(paymentslist[index]
////                                            ['Payment_doc_id']
////                                                .toString()
////                                              //paymentslist[index]['Payment_img']
////                                            );
////                                            paymentslist.removeAt(index);
////                                            gettypetotalprice();
//                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.history, color: Colors.red),
                                        onPressed: () {
//                                          Navigator.of(context).push(
//                                            new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new PaysMainHistoryOne(
//                                                  Payment_id: paymentslist[index]['Payment_id'],
//
//                                                )),);


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


  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin:
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }
}


class eventclassFull {
  int booking_no;
  String cust_name;
  String cust_mobile;
  double cust_pay;
  DateTime booking_date;
  DateTime booking_entry_date;
  String docs_id;
  eventclassFull(
      {this.booking_no,
        this.cust_name,
        this.cust_mobile,
        this.booking_date,
        this.booking_entry_date,
        this.docs_id});

}
