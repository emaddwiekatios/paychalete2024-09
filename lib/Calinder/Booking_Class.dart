import 'package:flutter/material.dart';
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
      this.booking_status});

}
