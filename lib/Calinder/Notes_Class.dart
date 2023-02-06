import 'package:flutter/material.dart';
class Noteclass {
  int Note_no;
  DateTime Note_entry_date;
  DateTime Note_modify_date;
  String Note_desc;
  String Note_user;
  String Note_owner_name;
  String Note_doc;String titel;Color note_color;
  Noteclass(
      {this.Note_no,
        this.Note_entry_date,
        this.Note_modify_date,this.Note_owner_name,
        this.Note_desc,this.Note_user,this.titel,this.note_color});
  Noteclass.fromJson(Map<String, dynamic> jsonMap) {
    //print(jsonMap['Note_Total']);
    this.Note_no = jsonMap['Note_no'];
    this.Note_entry_date = jsonMap['Note_entry_date'];
    this.Note_modify_date = jsonMap['Note_modify_date'];
    this.titel = jsonMap['titel']; this.Note_owner_name = jsonMap['Note_owner_name'];
    this.Note_desc = jsonMap['Note_desc']; this.Note_user = jsonMap['Note_user'];
    this.Note_doc = jsonMap['Note_doc'];
    this.note_color = jsonMap['note_color'];
    //  this.executedTime = DateTime.parse(jsonMap['executed_time']);
  }
}
