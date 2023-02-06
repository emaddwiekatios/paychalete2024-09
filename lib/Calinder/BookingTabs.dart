import 'package:flutter/material.dart';
import 'package:paychalet/Calinder/BookingSumBy.dart';
//import 'package:firebasetwo/Products/ProductSearch.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
import 'package:paychalet/Payments/PaysMainSummary.dart';
import 'package:paychalet/Payments/PaysMainSummaryfrom.dart';

import 'Booking.dart';
import 'BookingSum.dart';
import 'Booking_MS_project.dart';
import 'Booking_all.dart';

class BookingTabs extends StatefulWidget {
  static String tag = 'ana-sayfa';
  @override
  _BookingTabsState createState() => _BookingTabsState();
}

class _BookingTabsState extends State<BookingTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            new Booking(),
         new Booking_MS_project(),

         new Booking_all(),
          new BookingSum(),
            new BookingSumBy(),
            //new PaysMainHistory(),//ProductSearch(),
            //new PaysMainSummary(),//CartPage(),
            // PaysMainSummaryfrom(),//UserPage(),
          ],
        ),
        bottomNavigationBar: new TabBar(
          indicatorWeight: 2.0,
          tabs: [
            Tab(icon: Icon(Icons.event_seat, color: Colors.grey)),
            Tab(icon: Icon(Icons.history, color: Colors.grey)),
            Tab(icon: Icon(Icons.table_chart, color: Colors.grey)),
            Tab(icon: Icon(Icons.person_outline, color: Colors.grey)),
            Tab(icon: Icon(Icons.hdr_on, color: Colors.grey)),
          ],
          labelColor: Colors.grey,
          unselectedLabelColor: Colors.white30,
          indicatorColor: Colors.yellow,
        ),
      ),
    );
  }
}
