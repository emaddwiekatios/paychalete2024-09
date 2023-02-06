import 'package:flutter/material.dart';
//import 'package:firebasetwo/Products/ProductSearch.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
import 'package:paychalet/Payments/PaysMainSummary.dart';
import 'package:paychalet/Payments/PaysMainSummaryfrom.dart';
import 'package:paychalet/Shacks/MainShacksSummary.dart';

import 'MainShacks.dart';
import 'MainShacksSummaryAll.dart';
import 'MainShacks_Future.dart';
import 'MainShacks_Done.dart';
//import 'Payments/PaysMainHistory.dart';

class MainShacksTab extends StatefulWidget {
  static String tag = 'ana-sayfa';
  @override
  _MainShacksTabState createState() => _MainShacksTabState();
}

class _MainShacksTabState extends State<MainShacksTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            new MainShacks(),
            new MainShacks_Done(),//ProductSearch(),
            new MainShacks_Future(),//CartPage(),
            new MainShacksSummary(),
            new MainShacksSummaryALL(),///UserPage(),
          ],
        ),
        bottomNavigationBar: new TabBar(
          indicatorWeight: 2.0,
          tabs: [
            Tab(child: Text('All',style: TextStyle(color: Colors.red),),icon: Icon(Icons.event_seat, color: Colors.grey)),
            //Tab(icon: Icon(Icons.event_seat, color: Colors.grey)),
            Tab(child: Text('Complete',style: TextStyle(color: Colors.red),),icon: Icon(Icons.history, color: Colors.grey)),
            Tab(child: Text('Scheduale',style: TextStyle(color: Colors.red),),icon: Icon(Icons.table_chart, color: Colors.grey)),
            Tab(child: Text('SubAll',style: TextStyle(color: Colors.red),),icon: Icon(Icons.person_outline, color: Colors.grey)),
            Tab(child: Text('All',style: TextStyle(color: Colors.red),),icon: Icon(Icons.person_outline, color: Colors.grey)),

          ],
          labelColor: Colors.grey,
          unselectedLabelColor: Colors.white30,
          indicatorColor: Colors.yellow,
        ),
      ),
    );
  }
}
