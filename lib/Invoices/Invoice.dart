
class Invoice {
  int Type_no;
  String Type_name;
  double Type_price;
  String Type_unit;
  double Type_qty;
  double Type_Total;
  Invoice({this.Type_no,this.Type_name,this.Type_price,this.Type_qty,this.Type_Total,this.Type_unit});
  Invoice.fromJson(Map<String, dynamic> jsonMap) {
    //print('jsonMap');
   // print(jsonMap);


    //print(jsonMap['Type_Total']);
    this.Type_no = jsonMap['Type_no'];
    this.Type_name = jsonMap['Type_name'].toString();
    this.Type_price = double.parse(jsonMap['Type_price'].toString());
    this.Type_unit = jsonMap['Type_unit'];
    this.Type_qty = jsonMap['Type_qty'];
    this.Type_Total = jsonMap['Type_Total'];
  //  this.executedTime = DateTime.parse(jsonMap['executed_time']);
  }
}


class Type_sum
{
  String Type_name  ;

   double Type_qty;
  double Type_total ;
  double Type_price;
  Type_sum({this.Type_name,this.Type_qty,this.Type_total,this.Type_price});

}