class PaymentsClass {





  int Payment_id;
  DateTime Payment_modify_date;
  DateTime Payment_entry_date;
  String Payment_currency;
  double Payment_amt;
  String Payment_name;
  String Payment_desc;
  String Payment_Fav;
  String Payment_cat;
  String Payment_to;
  String Payment_from;
  String Payment_doc_id;
  String Payment_img;

  PaymentsClass(
      {this.Payment_id,this.Payment_modify_date,this.Payment_entry_date,this.Payment_amt,this.Payment_currency,this.Payment_cat,this.Payment_desc,this.Payment_Fav,this.Payment_doc_id,this.Payment_img,this.Payment_name});

}
