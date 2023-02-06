import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:paychalet/Calinder/BookingEdit.dart';
import 'Booking.dart';

List<Appointment> meetings = <Appointment>[];
List<eventclass> instlist = [];
QuerySnapshot cars;
class Booking_MS_project extends StatefulWidget {
  Booking_MS_project({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _Booking_MS_projectState createState() => _Booking_MS_projectState();
}

class _Booking_MS_projectState extends State<Booking_MS_project> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();

//    final DateTime today = DateTime.now();
//    final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
//    final DateTime endTime = startTime.add(const Duration(hours: 10));
// setState(() {
//    meetings.add(Appointment(
//        startTime: startTime,
//        endTime: endTime,
//        subject: 'rrrrrrr',
//        color: Colors.red,
//        recurrenceRule: 'FREQ=DAILY;COUNT=1',
//        isAllDay: false));
//  });

    call_get_data();
  }
  @override
  Widget build(BuildContext context) {
    return SfCalendar(

      monthViewSettings: MonthViewSettings(showAgenda: true),

      onTap: (CalendarTapDetails details) {

        if (details.targetElement == CalendarElement.appointment) {
          print("pressed");
        }DateTime date = details.date;
        print(date);
        dynamic appointments = details.appointments;
        print(appointments);
        print(meetings);
        CalendarElement view = details.targetElement;
        print(view);
    for (var i = 0; i < instlist.length; i++) {
          if (instlist[i].booking_startTime ==date
              ) {
            eventclass event1 = instlist[i];

//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => BookingEdit(
//                   evn: event1,
//                  ),
//                ));
          }
        }
      },

      view: CalendarView.week,
      firstDayOfWeek: 7,
      //initialDisplayDate: DateTime(2021, 07, 15, 08, 30),
      //initialSelectedDate: DateTime(2021, 03, 01, 08, 30),
      dataSource:  MeetingDataSource(meetings),//getAppointments()),
    );
  }
void calendarTapped(CalendarTapDetails details) {
  if (details.targetElement == CalendarElement.appointment ||
      details.targetElement == CalendarElement.agenda) {print(meetings);
//    final Appointment appointmentDetails = details.appointments![0];
//    _subjectText = appointmentDetails.subject;
//    _dateText = DateFormat('MMMM dd, yyyy')
//        .format(appointmentDetails.startTime)
//        .toString();
//    _startTimeText =
//        DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();
//    _endTimeText =
//        DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();
//    if (appointmentDetails.isAllDay) {
//      _timeDetails = 'All day';
//    } else {
//      _timeDetails = '$_startTimeText - $_endTimeText';
//    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(child: new Text('_subjectText')),
            content: Container(
              height: 80,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'ggg',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(''),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('ggg',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15)),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text('close'))
            ],
          );
        });
  }
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
}  getData() async {
  return await FirebaseFirestore.instance
      .collection('events')
  //.orderBy('Payment_id', descending: true)

      .get();
}

printlist() {int cnt=0;
  if (cars != null) {
    setState(() {
      meetings.clear();
    });

    for (var i = 0; i < cars.docs.length; i++) {cnt=cnt+1;
      print('inside for $i');
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
     //final DateTime today = DateTime.now();final DateTime startTime = DateTime(instone.booking_startTime.year, instone.booking_endTime.month, instone.booking_endTime.day, instone.booking_endTime.hour, 0, 0);
      //      final DateTime endTime = DateTime(instone.booking_endTime.year, instone.booking_endTime.month, instone.booking_endTime.day, instone.booking_endTime.hour, 0, 0);
      final DateTime startTime = instone.booking_startTime;//, instone.booking_endTime.month, instone.booking_endTime.day, instone.booking_endTime.hour, 0, 0);
      final DateTime endTime = instone.booking_endTime;//.year, instone.booking_endTime.month, instone.booking_endTime.day, instone.booking_endTime.hour, 0, 0);

//      final DateTime startTime = DateTime(instone.booking_startTime.year, instone.booking_endTime.month, instone.booking_endTime.day, instone.booking_endTime.hour, 0, 0);
//      final DateTime endTime = DateTime(instone.booking_endTime.year, instone.booking_endTime.month, instone.booking_endTime.day, instone.booking_endTime.hour, 0, 0);
      if(endTime.day>startTime.day) {
        final DateTime starttimenew =startTime.add( Duration(hours: (24-startTime.hour)));
         final DateTime endtimenew =starttimenew;//startTime.add( Duration(hours: (24-starttimenew.hour)));
//final DateTime endTime = startTime.add(const Duration(hours: 23));
        setState(() {

    Color pcolor=cnt % 2 == 0 ? Colors.red : Colors.blue;
           meetings.add(Appointment(
              startTime: startTime,
              endTime: starttimenew,
              subject: instone.cust_name,
              color: pcolor,
              recurrenceRule: 'FREQ=DAILY;COUNT=1',
              isAllDay: false));
              meetings.add(Appointment(
              startTime: endtimenew,
              endTime: endTime,
              subject: instone.cust_name,
              color: pcolor,
              recurrenceRule: 'FREQ=DAILY;COUNT=1',
              isAllDay: false));
        });
}
       else {
        setState(() {
          meetings.add(Appointment(
              startTime: startTime,
              endTime: endTime,
              subject: instone.cust_name,
              color: Colors.green,
              recurrenceRule: 'FREQ=DAILY;COUNT=1',
              isAllDay: false));
        });
      }
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
          //deleteData(event1.docs_id);
         // _selectedEvents.remove(event);
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

}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(today.year, today.month, today.day, 1, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 23));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Board Meeting',
      color: Colors.red,
      recurrenceRule: 'FREQ=DAILY;COUNT=1',
      isAllDay: false));



  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}