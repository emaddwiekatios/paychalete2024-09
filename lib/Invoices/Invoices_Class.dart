//class Invoices_Class
//{
//   String Invoice_no;
//   DateTime Invoice_date;
//   List<Invoiceone> Invoice_Details=[];
//  Invoices_Class({
//    this.Invoice_no,
//    this.Invoice_date,
//    this.Invoice_Details
//
//  });
//}
//
//
//class Invoiceone
//{
//  String Type_no;
//  String Type_name;
//  String Type_price;
//  Invoiceone({this.Type_no,this.Type_name,this.Type_price});
//
//  @override
//  String toString() {
//    return '{ ${this.Type_no}, ${this.Type_name} ,${this.Type_price} }';
//  }
//}


import 'package:flutter/material.dart';

import 'Invoice.dart';

//class InvoicesList {
//     String Invoice_no;
//   DateTime Invoice_date;
//     List<Invoice> Invoice_Details =[];
//
////     InvoicesList(
////     this.Invoice_no,
////     this.Invoice_date,
////     [this.Invoice_Details]
////);
//
////     InvoicesList.fromMap(Map<String, dynamic> data) {
////      //print( data);
////      print( data['Invoice_No']);
////      print( data['Invoice_date'].toDate());
////      print( data['Invoice_Details']);
////       Invoice_no = data['Invoice_No'];
////       Invoice_date = data['Invoice_date'].toDate();
////      Invoice_Details = data['Invoice_Details'] ;
////
////
////     }
////
////     Map<String, dynamic> toMap() {
////       return {
////         'Invoice_No': Invoice_no,
////         'Invoice_date': Invoice_date,
////        'Invoice_Details': Invoice_Details,
////
////       };
////     }
//}
//

class Invoices {
  int Invoice_no;
  String Invoice_no_ref;
  DateTime Invoice_date;
  String Invoice_provider;
  double Invoice_amt;
  int Invoice_disc;
  String Invoice_pay;
  String Invoice_status;
  DateTime Invoice_due_date;
  String Invoice_doc_id;
  double Invoice_sub_total;
  String Invoice_notes;
  List<Invoice> invoices =[];
  Invoices(
  {this.Invoice_no,this.Invoice_date,this.invoices,this.Invoice_provider,this.Invoice_amt,this.Invoice_disc,this.Invoice_pay,this.Invoice_status,this.Invoice_due_date,this.Invoice_doc_id,this.Invoice_sub_total,this.Invoice_no_ref,this.Invoice_notes});
  Invoices.fromJson(Map<String, dynamic> _map)
  {
   // print('inside invoices');
//   print(_map);
//    print(_map['Invoice_No']);
//    print(_map['Invoice_date'].toDate());
//    print(_map['Invoice_Details'][0]['Type_name']);
    this.Invoice_no = _map['Invoice_No'];
    this.Invoice_no_ref = _map['Invoice_no_ref'];
    this.Invoice_date = _map['Invoice_date'].toDate();
    this.Invoice_provider = _map['Invoice_provider'];
    this.Invoice_amt=_map['Invoice_amt'];
    this.Invoice_sub_total=_map['Invoice_sub_total'];
    this.Invoice_disc=_map['Invoice_disc'];
    this.Invoice_pay=_map['Invoice_pay'];
    this.Invoice_status=_map['Invoice_status'];
    this.Invoice_doc_id=_map['Invoice_doc_id'];
    this.Invoice_notes=_map['Invoice_notes'];
    this.Invoice_due_date = _map['Invoice_due_date'].toDate();
    this.invoices = [];
    final _invoicesList = _map['Invoice_Details'];
    //print(_map['Invoice_No']);
  // print('_invoicesList==');
 //print(_map['Invoice_Details']);
//  print(_map['Invoice_Details']);
  //print(_map['Invoice_No']);
  //  print('the length=${_invoicesList.length}');
    if(_invoicesList !=null) {
      if (_invoicesList.length != null && _invoicesList.length > 0) {
        for (var i = 0; i < (_invoicesList.length); i++) {
          //  print('before add=');
          // print(_invoicesList[i]);
          this.invoices.add(new Invoice.fromJson(_invoicesList[i]));
          //  print('after add');
        }
      }
    }
  }

}




class Invoices_Type {
  int Invoice_no;
  String Invoice_no_ref;
  DateTime Invoice_date;
  String Invoice_provider;
  double Invoice_amt;
  int Invoice_disc;
  String Invoice_pay;
  String Invoice_status;
  DateTime Invoice_due_date;
  String Invoice_doc_id;
  double Invoice_sub_total;
  String Invoice_notes;
  int Type_no;
  String Type_name;
  double Type_price;
  String Type_unit;
  double Type_qty;
  double Type_Total;

  Invoices_Type(
      {this.Invoice_no,this.Invoice_date,this.Invoice_provider,this.Invoice_amt,this.Invoice_disc,this.Invoice_pay,this.Invoice_status,this.Invoice_due_date,this.Invoice_doc_id,this.Invoice_sub_total,this.Invoice_no_ref,this.Invoice_notes,this.Type_no,this.Type_name,this.Type_price,this.Type_qty,this.Type_Total,this.Type_unit});



}