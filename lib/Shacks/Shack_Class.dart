
class Shacks {
  int Shack_no;
  int Shack_no_ref;
  String Shack_owner_name;
  String Shack_for_name;
  String Shack_cat;
  double Shack_amt;
  DateTime Shack_entry_date;
  DateTime Shack_come_date;
  String Shack_currency;
  String Shack_doc;
  Shacks({this.Shack_no,this.Shack_no_ref,this.Shack_entry_date,this.Shack_cat,this.Shack_come_date,this.Shack_amt,this.Shack_currency,this.Shack_doc,this.Shack_owner_name,this.Shack_for_name});
  Shacks.fromJson(Map<String, dynamic> jsonMap) {
    //print(jsonMap['Shack_Total']);
    this.Shack_no = jsonMap['Shack_no'];
    this.Shack_no_ref = jsonMap['Shack_no_ref'];
    this.Shack_owner_name = jsonMap['Shack_owner_name'].toString();
    this.Shack_cat = jsonMap['Shack_cat'].toString();
    this.Shack_for_name = jsonMap['Shack_for_name'].toString();
    this.Shack_amt = double.parse(jsonMap['Shack_amt'].toString());
    this.Shack_entry_date = jsonMap['Shack_entry_date'];
    this.Shack_come_date = jsonMap['Shack_come_date'];
    this.Shack_currency = jsonMap['Shack_currency'];
    this.Shack_doc = jsonMap['Shack_doc'];
    //  this.executedTime = DateTime.parse(jsonMap['executed_time']);
  }
}