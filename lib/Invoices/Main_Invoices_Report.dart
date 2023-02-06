import 'package:flutter/material.dart';
import 'package:paychalet/Invoices/Invoice_Report_Table.dart';
//import 'package:firebasetwo/Products/ProductSearch.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
import 'package:paychalet/Payments/PaysMainSummary.dart';

import 'Invoice_Report_Type.dart';
import 'Invoice_Report_Type_GP.dart';
import 'Invoice_Report_Type_Sum.dart';
import 'Invoice_Sale.dart';
import 'Invoice_report.dart';
//import 'Payments/PaysMainHistory.dart';

class Main_Invoices extends StatefulWidget {
  static String tag = 'ana-sayfa';
  @override
  _Main_InvoicesState createState() => _Main_InvoicesState();
}

class _Main_InvoicesState extends State<Main_Invoices> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            new Invoice_Report_Type(),
            new Invoice_Report_Type_GP(),//ProductSearch(),
            new Invoice_Report_Type_Sum(),//CartPage(),
            new Invoice_Report_Table(),//UserPage(),
          ],
        ),
        bottomNavigationBar: new TabBar(
          indicatorWeight: 2.0,
          tabs: [
            Tab(icon: Icon(Icons.event_seat, color: Colors.grey)),
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
