class Types_Class {
  int id;
  String TypeName;
  String Typedesc;
  String TypeUnit;
  double TypePrice;
  DateTime TypeEntryDate;
  String Type_doc;


  Types_Class({this.id,this.TypeName,this.Typedesc,this.TypeEntryDate,this.TypePrice,this.TypeUnit,this.Type_doc});

// convenience constructor to create a Types_Class object
//  Types_Class.fromMap(Map<String, dynamic> map) {
//    id = map[columnId];
//    TypeName = map[columnTypeName];
//    Typedesc = map[columnTypedesc];
//    TypeUnit = map[columnTypeUnit];
//    TypePrice = map[columnTypePrice];
//
//    TypeEntryDate = map[columnTypeEntryDate];
//  }
}