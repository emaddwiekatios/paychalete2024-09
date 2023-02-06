import 'package:flutter/material.dart';
//import 'package:firebasetwo/Products/ProductSearch.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
import 'package:paychalet/Payments/PaysMainSummary.dart';
import 'package:paychalet/Payments/PaysMainSummaryfrom.dart';

import 'Payments/PaysMainHistory.dart';
import 'Payments/ProductsMainWork.dart';

class main_page extends StatefulWidget {
  static String tag = 'ana-sayfa';
  @override
  _main_pageState createState() => _main_pageState();
}

class _main_pageState extends State<main_page> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            new PaysMain(),new PaysMainWork(),
            new PaysMainHistory(),//ProductSearch(),
            new PaysMainSummary(),//CartPage(),
            new PaysMainSummaryfrom(),//UserPage(),
          ],
        ),
        bottomNavigationBar: new TabBar(
          indicatorWeight: 2.0,
          tabs: [
            Tab(icon: Icon(Icons.event_seat, color: Colors.grey)), Tab(icon: Icon(Icons.work, color: Colors.grey)),
            Tab(icon: Icon(Icons.history, color: Colors.grey)),
            Tab(icon: Icon(Icons.table_chart, color: Colors.grey)),
            Tab(icon: Icon(Icons.person_outline, color: Colors.grey)),
          ],
          labelColor: Colors.grey,
          unselectedLabelColor: Colors.white30,
          indicatorColor: Colors.yellow,
        ),
      ),
    );
  }
}
