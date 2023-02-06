

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paychalet/Types/Type_Class.dart';

import 'package:paychalet/colors.dart';
//import 'package:flutter_app_vetagable/DataBaseFile/database_helpers.dart';
////import 'package:flutter_app_vetagable/DataBaseFile/DbHelper.dart';
//import 'package:flutter_app_vetagable/Client/Client_List.dart';
//import 'package:flutter_app_vetagable/Client/Client.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Invoice.dart';
import 'Invoice_LV_Animation.dart';
//import 'package:flutter_app_vetagable/Invoices/Invoice_LV_Animation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//import 'package:date_format/date_format.dart';
//
//import 'package:flutter_app_vetagable/ConstractorObjects/DropDownButton.dart';
//import 'package:flutter_app_vetagable/ConstractorObjects/CheckBox.dart';
//import 'package:flutter_app_vetagable/ConstractorObjects/RadioButton.dart';
//import 'package:flutter_app_vetagable/ConstractorObjects/RadioList.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paychalet/Payments/ProductsMain.dart';

import 'Invoices_Class.dart';
import 'Provider_class.dart';

class Invoice_Sale extends StatefulWidget {

 
  @override
  _Invoice_SaleState createState() => _Invoice_SaleState();

}
List<provider> listprovider = List<provider>();
//List<Clients> listtemp;
//
List<Invoices> _InvoiceList = List<Invoices>();
List<Invoice> _InvoicesubList = List<Invoice>();
Invoice _Invsubone = Invoice();
List<String> _no_row=['+'];

List<Invoices> _InvoiceListtemp;
QuerySnapshot cars;
QuerySnapshot carsmaxinvoice_no;
var Provider_max;
List<int> list_cat = [];



class _Invoice_SaleState extends State<Invoice_Sale> {
  String imagename;
  String _PaymentType='Cash';
  String _subtotal = '0.0';
  String customername2;
  int typenameflag = 0;
  var _now = new DateTime.now();
  String _due_date = DateTime.now().toString();
  String _invoice_no = '0';
  int Max_Invoice_no=0;
  int P_type_no0=0;
  int P_type_no1=0;
  int P_type_no2=0;
  int P_type_no3=0;
  @override
  void initState() {
    call_get_datamaxinvoice_no;
    //print('customername2=${customername2}');
    // TODO: implement initState
    super.initState();
    _entrydateeditcont.text = formatDate(DateTime.now(),
        [yyyy,'-',M,'-',dd,' ',hh,':',nn,':',ss,' ',am]);
    setState(() {
      customername2 = "0";
    });
    _readdball();

    _due_date = formatDate(_now.add(new Duration(days: 30)),
        [yyyy,'-',M,'-',dd]);


    //print('inv_no next${_readdball_inv_MaxNO().toString()}');
    //_readdball_inv_max_no();
    // getDatainvoice();

    getData().then((results) {
      setState(() {
        cars = results;

        printlist();
      });
    });


    call_get_datatype();
  }


  getDatatypes() async {
    return await FirebaseFirestore.instance.collection('Types')
        .get();
  }

  getDatamaxinvoice_no() async {
    return await await FirebaseFirestore.instance
        .collection('Invoices').orderBy('Invoice_No',descending: true).limit(1).get();


  }

  call_get_datamaxinvoice_no() {
    getDatamaxinvoice_no().then((results) {
      setState(() {
        carsmaxinvoice_no = results;

        printlistmaxinv_no();
      });
    });
  }

  printlistmaxinv_no() {
    if (carsmaxinvoice_no != null) {

      for (var i = 0; i < carsmaxinvoice_no.docs.length; i++) {
        setState(() {
          Max_Invoice_no= carsmaxinvoice_no.docs[i].data()['Invoice_No']+1;
          print('Max_Invoice_no');
          print(Max_Invoice_no);
        });
      }

//      typelist.sort(
//              (a, b) => a.id.compareTo(b.id));
//      var array_len = typelist.length;
//      setState(() {
//        Type_id_max = (typelist[array_len - 1].id + 1);
//        typelist.sort((b, a) =>
//            a.id.compareTo(b.id));
//        print('Type_id_max$Type_id_max');
//        //duplicateItems = paymentslist;
//      });


    } else {
      print("error");
    }

    //gettypetotalprice();
  }



  call_get_datatype() {
    getDatatypes().then((results) {
      setState(() {
        cars = results;

        printlisttype();
      });
    });
  }

  printlisttype() {
    if (cars != null) {
      if (typelist.length > 0) {
        typelist.clear();
      }
      for (var i = 0; i < cars.docs.length; i++) {
        var tempprice =cars.docs[i].data()['Typeprice'];
        Types_Class _typeone = new Types_Class()
          ..id = cars.docs[i].data()['Type_id']
          ..TypeName = cars.docs[i].data()['Type_name']
          ..Typedesc = cars.docs[i].data()['Type_desc']
          ..TypeEntryDate = cars.docs[i].data()['Type_entry_date'].toDate()
          ..TypePrice = double.parse(tempprice.toString())
          ..TypeUnit = cars.docs[i].data()['Type_unit'];

        setState(() {
          typelist.add(_typeone);
        });
      }

//      typelist.sort(
//              (a, b) => a.id.compareTo(b.id));
//      var array_len = typelist.length;
//      setState(() {
//        Type_id_max = (typelist[array_len - 1].id + 1);
//        typelist.sort((b, a) =>
//            a.id.compareTo(b.id));
//        print('Type_id_max$Type_id_max');
//        //duplicateItems = paymentslist;
//      });


    } else {
      print("error");
    }

    //gettypetotalprice();
  }


  getDatainvoice() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Invoices').get();

    List<Invoices> _InvoiceList = [];
    snapshot.docs.forEach((document) {
      // print('llll');
      Invoices _invoice = Invoices.fromJson(document.data());
      //print('the list =${document.data()}');
//     print(_invoice.Invoice_no);
//     print(_invoice.Invoice_date);

      _InvoiceList.add(_invoice);
    });

    _InvoiceList.forEach((element) {
      print(element.Invoice_date);
      print(element.Invoice_no);
      element.invoices.forEach((el) {
        print(el.Type_no);
        print(el.Type_name);
        print(el.Type_price);
      });
    });
    print(_InvoiceList[0].Invoice_date);
    print(_InvoiceList[0].Invoice_no);
    print(_InvoiceList[0].invoices[0].Type_name);
  }

  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color pyellow = Color(getColorHexFromStr('#4CA6A6'));

  TextEditingController _customereditcont = TextEditingController();
  TextEditingController _invoicenoeditcont = TextEditingController();
  TextEditingController _entrydateeditcont = TextEditingController();

  TextEditingController _invDet_subTotal = TextEditingController();
  TextEditingController _invDet_tax = TextEditingController();

  TextEditingController _invDet_No0 = TextEditingController();
  TextEditingController _invDet_Prod0 = TextEditingController();
  TextEditingController _invDet_Qty0 = TextEditingController();
  TextEditingController _invDet_Price0 = TextEditingController();
  TextEditingController _invDet_Total0 = TextEditingController();
  TextEditingController _invDet_Unit0 = TextEditingController();


  TextEditingController _invDet_No1 = TextEditingController();
  TextEditingController _invDet_Prod1 = TextEditingController();
  TextEditingController _invDet_Qty1 = TextEditingController();
  TextEditingController _invDet_Price1 = TextEditingController();
  TextEditingController _invDet_Total1 = TextEditingController();
  TextEditingController _invDet_Unit1 = TextEditingController();

  TextEditingController _invDet_No2 = TextEditingController();
  TextEditingController _invDet_Prod2 = TextEditingController();
  TextEditingController _invDet_Qty2 = TextEditingController();
  TextEditingController _invDet_Price2 = TextEditingController();
  TextEditingController _invDet_Total2 = TextEditingController();
  TextEditingController _invDet_Unit2 = TextEditingController();

  TextEditingController _invDet_No3 = TextEditingController();
  TextEditingController _invDet_Prod3 = TextEditingController();
  TextEditingController _invDet_Qty3 = TextEditingController();
  TextEditingController _invDet_Price3 = TextEditingController();
  TextEditingController _invDet_Total3 = TextEditingController();
  TextEditingController _invDet_Unit3 = TextEditingController();
  TextEditingController _invDet_Discount = TextEditingController();
  TextEditingController _invDet_Total_All = TextEditingController();
  TextEditingController _invDet_Invoice_no_ref = TextEditingController();
  List<Types_Class> typelist = [];


  String _day = '+';
  DateTime _date = DateTime.now();


  int _new_row = 1;

  var listdisc = <String>[
    '\$2',
    '\$4',
    '\$10',
  ];

  var listdisc2 = <String>[
    'emad',
    'karam',
    'murad',
  ];

  var listdiscint = <int>[
    1
    ,2
    ,3,4,5,6,7,8
  ];


  bool checkboxres;


  String radiogroup = 'Cash';



//  List<RadioList> RList1 = [
//    RadioList(
//      index: 1,
//      name: "Mangooo",
//    ),
//    RadioList(
//      index: 2,
//      name: "Mangooo2",
//    )
//  ];


  double _leng_client = 100.0;
  bool menu_client = false;
  bool menu_prod = false;

  void addisubcollection() {
//    FirebaseFirestore.instance.collection("Invoices").add({
//      "Invoice_No": "123",
//      "Invoice_date": todayDate,
//      "Invoice_Details": [
//        {"Type_no": 1, "Type_name": "emad", "Type_price": 40},
//        {"Type_no": 2, "Type_name": "ddd", "Type_price": 60},
//        {"Type_no": 3, "Type_name": "ff", "Type_price": 70},
//      ]
//    });
  }

  _readdball() async {
//    print('readdball');
//    DatabaseHelper helper = DatabaseHelper.instance;
//
//    int rowId = 1;
//    //Word word = await helper.queryWord(rowId); //call for one recorsd
//    listtemp = await helper.clientlist();
//    setState(() {
//      list = listtemp;
//    });
    //  print('list=${list}');
  }

  getData() async {
    //return await FirebaseFirestore.instance.collection("Gym-Category").snapshots();


    return await FirebaseFirestore.instance.collection('Providers').get();
  }


  printlist() {
    if (cars != null) {
      listprovider.clear();
      provider provideone = new provider();
      for (var i = 0; i < cars.docs.length; i++) {
        print(cars.docs[i].data()['Provider_name']);
        setState(() {
//          provideone.Provider_id=cars.docs[i].data()['Provider_id'];
//          provideone.Provider_name=cars.docs[i].data()['Provider_name'];
//          provideone.Provider_desc=cars.docs[i].data()['Provider_desc'];

          listprovider.add(
              provider(Provider_id: cars.docs[i].data()['Provider_id'],
                  Provider_name: cars.docs[i].data()['Provider_name'],
                  Provider_desc: cars.docs[i].data()['Provider_desc'])
          );
        });
      }


      for (int i = 0; i < listprovider.length; i++) {
        print('listprovider=$i');
        print(listprovider[i].Provider_name);
      }


//      print('list=====');
//
//      listprovider.sort();
//      print(listprovider);
//      var array_len = listprovider.length;
//      print(array_len);
//      print(listprovider[array_len-1]);
//      setState(() {
//        Provider_max = listprovider[array_len-1]+ 1;
//
//
//        print(Provider_max);
      //duplicateItems = catslist;
      //});
    }

    else {
      print("error");
    }
  }


  Widget build(BuildContext context) {

    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

  //  var appLanguage = Provider.of<AppLanguage>(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        // drawer: Appdrawer(),
        body:

        GestureDetector(
          onTap: (){
            print('ontap');
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child:
          SingleChildScrollView(
            child: Stack(
            children: <Widget>[
              Container(
                height: 1500
                
              ),
              //header shape
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 4,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(200),
                    color: Red_deep, // Color(getColorHexFromStr(pyellow1)),
                  ),
                ),
              ),
              Positioned(
                top: 125,
                left: -150,
                child: Container(
                  height: 450, //MediaQuery.of(context).size.height / 4,
                  width: 450, //MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(250),
                    color: Red_deep, //Color(getColorHexFromStr(pyellow2)),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 115,
                child: Container(
                  height: 350, //MediaQuery.of(context).size.height / 4,
                  width: 350, //MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: Red_deep, //Color(getColorHexFromStr(pyellow3),
                    //      )
                  ),
                ),
              ),
              //footer
              Positioned(
                bottom: -125,
                left: -150,
                child: Container(
                  height: 250, //MediaQuery.of(context).size.height / 4,
                  width: 250, //MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(250),
                    color: Red_deep, //Color(getColorHexFromStr(pyellow2)
                    //  ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                right: -115,
                child: Container(
                  height: 250, //MediaQuery.of(context).size.height / 4,
                  width: 250, //MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: Red_deep,),
                ),
              ),
              //menu
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // print('inside button');
                    // _scaffoldKey.currentState.openDrawer();
                    Navigator.pushNamed(context,"/main_page");
                    // Navigator.pushNamed(context, "/Invoice_Sale");
                  },
                ),
              ),
              Positioned(
                top: pheight / 30,
                right: pwidth / 20,
                child: IconButton(
                  icon: Icon(Icons.add, size: 30),
                  onPressed: () {

                    // _scaffoldKey.currentState.openDrawer();

//                    Navigator.of(context).push(
//                      new MaterialPageRoute(
//                          builder: (BuildContext context) =>
//                          new ProductAddSt(Docs_max:Payment_max ,)),
//                    );
                  },
                ),
              ),
//            Positioned(
//              top: 20,
//              right: 20,
//              child: IconButton(
//                icon: Icon(Icons.menu),
//                onPressed: () {
//                  // print('inside button');
//                  // _scaffoldKey.currentState.openDrawer();
//                  Navigator.pushNamed(context,"/main_page");
//                  // Navigator.pushNamed(context, "/Invoice_Sale");
//                },
//              ),
//            ),
              Positioned(
                top: 30,
                left: MediaQuery
                    .of(context)
                    .size
                    .width / 2 - 80,
                child: Text(
                  'Invoices: $_invoice_no',
                  style: TextStyle(fontSize: 29,fontWeight: FontWeight.bold),
                ),
              ),
              //body

              Positioned(
                top: 65,
                //right: 10,
                //left: 10,

                  child: Column(
                    children: <Widget>[

                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 1,
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 1.0,
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0,right: 10),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      //client
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[

                                          Text('Provider',style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),),
                                          Row(

                                            children: <Widget>[
                                              InkWell(onTap: () {
                                                setState(() {
                                                  getData().then((results) {
                                                    setState(() {
                                                      cars = results;

                                                      printlist();
                                                    });
                                                  });
                                                  menu_client = !menu_client;
                                                });

                                                //  Navigator.of(context).pushNamed('/Client');
                                                //_awaitReturnValueFromClient(context);
                                              },
                                                  child: CircleAvatar(radius: 20,
                                                    child:
                                                    Icon(Icons.menu,),
                                                    backgroundColor: Colors
                                                        .grey[100],)),

                                              InkWell(onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    '/AddProvider');

                                                /// _awaitReturnValueFromClient(context);
                                              },
                                                  child: CircleAvatar(radius: 20,
                                                    child: Text(customername2 != "0"
                                                        ? customername2.substring(0,1)
                                                        .toUpperCase()
                                                        : '+',style: TextStyle(
                                                        color: Colors.black),),
                                                    backgroundColor: Colors
                                                        .grey[100],)),
                                              SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 2.5,
                                                child: RaisedButton(elevation: 0,
                                                  onPressed: () {
                                                    // Navigator.of(context).pushNamed('/Client_List');
                                                    //_awaitReturnValueFromClientLis//context);
                                                  }
                                                  ,
                                                  color: Colors.white,
                                                  //padding: EdgeInsets.only(left: (5.0), top: 5.0),
                                                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                                  child: Text(customername2 != "0"
                                                      ? customername2
                                                      : 'Select',
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight: FontWeight
                                                            .bold),),),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      //day
                                      menu_client ?

                                      WidgetInvoice_LV_Animation(
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 5),
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                  .height/3, //cell
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width - 20, //cells
                                            child: StaggeredGridView.countBuilder(
                                              crossAxisCount: 6,
                                              itemCount: listprovider.length,
                                              itemBuilder: mycont,
                                              staggeredTileBuilder: (int index) =>
                                              new StaggeredTile.count(3,  1),//(2, index.isEven ? 2 : 1),
                                              mainAxisSpacing: 3.0,
                                              crossAxisSpacing: 3.0,
                                            )


//                                        ListView.builder(
//                                          // shrinkWrap: true,
//                                          scrollDirection: Axis.horizontal,
//                                          itemBuilder: mycont,
//                                          itemCount: listprovider.length,
//                                        ),

                                          )
                                      )

                                          : SizedBox(),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width/3.5,
                                            child: Material(
                                              elevation: 5.0,
                                              borderRadius: BorderRadius.circular(5.0),
                                              child:

                                              Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Text('Invoice_ref'),//Text('${AppLocalizations.of(context).translate('Payment Id')} :'),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width:5),
                                          Container(
                                              color:Colors.black12,
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/3)-25,

                                            child: Material(
                                              elevation: 5.0,
                                              borderRadius: BorderRadius.circular(5.0),
                                              child: TextFormField(

                                                  keyboardType: TextInputType.text,
                                                  controller: _invDet_Invoice_no_ref,
                                                  onChanged: (value) {},
                                                  validator: (input) {
                                                    if (input.isEmpty) {
                                                      return 'Please Prod Id ';
                                                    }
                                                  },
                                                  onSaved: (input) => imagename = input,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,

//                        prefixIcon: Icon(Icons.search,
//                            color: red2),
//                            size: 30.0),
                                                      suffixIcon: IconButton(
                                                          icon: Icon(Icons.cancel,
                                                              color:Red_deep3,
                                                              // Color(getColorHexFromStr('#FEE16D')),
                                                              size: 20.0),
                                                          onPressed: () {
                                                            print('inside clear');
                                                            _invDet_Invoice_no_ref.clear();
                                                            _invDet_Invoice_no_ref.text = null;
                                                          }),
                                                      contentPadding: const EdgeInsets.all(10),
                                                      hintText:'Invoice_no_ref',
                                                     // AppLocalizations.of(context).translate('Payment Id'),

                                                      hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily: 'Quicksand'))),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text('Day',style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),),
                                          Row(

                                            children: <Widget>[

                                              InkWell(
                                                onTap: () {
                                                  DatePicker.showDatePicker(context,
                                                      showTitleActions: true,
                                                      minTime: DateTime(2018,3,5),
                                                      maxTime: DateTime(2025,6,7),
                                                      onChanged: (date) {
                                                        print('change $date');
                                                      },
                                                      onConfirm: (date) {
                                                        setState(() {
                                                          _date = date;
                                                          _day = formatDate(date,
                                                              [ dd]);
                                                          _due_date = formatDate(
                                                              date.add(new Duration(
                                                                  days: 30)),
                                                              [yyyy,'-',M,'-',dd]);
                                                        });
                                                        print('confirm $date');
                                                      },
                                                      currentTime: DateTime.now(),
                                                      locale: LocaleType.ar);
                                                },
                                                child: CircleAvatar(radius: 20,
                                                  child: Text(_day,
                                                    style: TextStyle(
                                                        color: Colors.black),),
                                                  backgroundColor: Colors.grey[100],),
                                              ),
                                              SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 2.5,
                                                child: RaisedButton(elevation: 0,
                                                  onPressed: () {
                                                    //  Navigator.of(context).pushReplacementNamed('/MainPage');

                                                  }
                                                  ,
                                                  color: Colors.white,
                                                  //padding: EdgeInsets.only(left: (5.0), top: 5.0),
                                                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                                  child: Text('${formatDate(_date,
                                                      [yyyy,'-',M,'-',dd,' '])}',style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight
                                                          .bold),),),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),

                                      //due
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text('Due',style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),),
                                          Row(

                                            children: <Widget>[
                                              //  CircleAvatar(radius: 20,child: Text('30',style: TextStyle(color: Colors.black),),backgroundColor: Colors.grey[100],),
                                              SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 4,

                                                child: RaisedButton(elevation: 3,
                                                  onPressed: () {
                                                    //  Navigator.of(context).pushReplacementNamed('/MainPage');

                                                  }
                                                  ,
                                                  color: Colors.grey,
                                                  //padding: EdgeInsets.only(left: (5.0), top: 5.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          100)),
                                                  child: Text(
                                                    '30 Days',style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .bold),),),
                                              ),
                                              SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 3,

                                                child: RaisedButton(elevation: 3,
                                                  onPressed: () {
                                                    //  Navigator.of(context).pushReplacementNamed('/MainPage');

                                                  }
                                                  ,
                                                  color: Colors.grey,
                                                  //padding: EdgeInsets.only(left: (5.0), top: 5.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          100)),
                                                  child: Text(_due_date.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight
                                                            .bold),),),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),


                                      Text('PRODUCT',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),),
                                      SizedBox(height: 10,),
                                      _no_row.length >= 1 ?
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text('Product',),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 4.5,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType.text,
                                                      showCursor: true,
                                                      readOnly: true,
                                                      controller: _invDet_Prod0,
                                                      onTap: () {
                                                        setState(() {
                                                          menu_prod = true;
                                                          typenameflag = 0;
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          call_get_datamaxinvoice_no();
                                                          print(Max_Invoice_no);
                                                        });

                                                        //   this.phoneNo = value;

                                                        // filterSearchResults.5_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Product',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),


                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text('Unit'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6.5,
                                                  child: TextField(

                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .text,
                                                      controller: _invDet_Unit0,
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Unit',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),


                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text('Qty'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 7,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType.text,

                                                      controller: _invDet_Qty0,
                                                      onChanged: (value) {
                                                        update_invoice_item();

                                                      },


                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Qty',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand',
                                                              backgroundColor: Colors
                                                                  .white))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text('Price'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      controller: _invDet_Price0,
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Price',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text('Total'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6.5,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,


                                                      keyboardType: TextInputType
                                                          .number,
                                                      controller: _invDet_Total0,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _subtotal = (double.parse(
                                                              _invDet_Total0.text) +
                                                              double.parse(
                                                                  _invDet_Total1
                                                                      .text) +
                                                              double.parse(
                                                                  _invDet_Total2
                                                                      .text) +
                                                              double.parse(
                                                                  _invDet_Total3
                                                                      .text))
                                                              .toString();
                                                        });
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Total',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,

                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(width: 0),
                                          InkWell(
                                            onTap: () {
                                              print('inside row 0');


                                              setState(() {
                                                _invDet_Prod1.clear();
                                                _invDet_Qty1.clear();
                                                _invDet_Price1.clear();
                                                _invDet_Total1.clear();
                                                _invDet_Unit1.clear();


                                                /*  _subtotal=(double.parse(_invDet_Total0.text ?? 0 )+
                                                    double.parse(_invDet_Total1.text ?? 0)+
                                                    double.parse(_invDet_Total2.text ?? 0)+
                                                    double.parse(_invDet_Total3.text ?? 0)).toString();
                                                    */

                                              });
                                              if (_no_row[0] == '+') {
                                                setState(() {
                                                  _no_row[0] = '-';
                                                  _no_row.add('+');
                                                });
                                              }
                                              else if (_no_row[0] == '-') {
                                                setState(() {
                                                  _no_row[0] = '+';
                                                  _no_row.removeAt(0);
                                                });
                                              }
                                            },

                                            child: CircleAvatar(radius: 10,
                                              child: Text(_no_row[0],
                                                style: TextStyle(
                                                    color: Colors.black),),
                                              backgroundColor: Red_deep, // Color(getColorHexFromStr(pyellow3)),
                                            ),
                                          ),
                                        ],
                                      ) :
                                      SizedBox(),

                                      //  SizedBox(height: 50,),
                                      _no_row.length >= 2 ?

                                      Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                //   Text('Product'),
                                                Material(

                                                  elevation: 0.0,
                                                  borderRadius: BorderRadius.circular(
                                                      5.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 4.5,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,
                                                        keyboardType: TextInputType
                                                            .text,
                                                        showCursor: true,
                                                        readOnly: true,
                                                        controller: _invDet_Prod1,
                                                        onTap: () {
                                                          setState(() {
                                                            menu_prod = true;
                                                            typenameflag = 1;
                                                          });
                                                        },
                                                        onChanged: (value) {
                                                          //   this.phoneNo = value;

                                                          // filterSearchResults.5_new2(value);
                                                        },
                                                        decoration: InputDecoration(

                                                            border: InputBorder.none,
                                                            /*
                                                            suffixIcon: IconButton(
                                                              icon: Icon(
                                                                Icons.cancel,
                                                                size: 20,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                 // WidgetsBinding.instance.addPostFrameCallback(
                                                                   //       (_) => _Customernameeditcont.clear());
                                                                });
                                                              },
                                                            ),
                                                            prefixIcon: Icon(Icons.category,
                                                                color:
                                                                Color(getColorHexFromStr(pyellow3)),
                                                                size: 30.0),
                                                        */
                                                            contentPadding:
                                                            EdgeInsets.all(5.0),
                                                            hintText: 'Product',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,
                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),


                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                //  Text('Unit'),
                                                Material(

                                                  elevation: 0.0,
                                                  borderRadius: BorderRadius.circular(
                                                      5.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 6.5,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,
                                                        keyboardType: TextInputType
                                                            .text,
                                                        controller: _invDet_Unit1,
                                                        onChanged: (value) {
                                                          //   this.phoneNo = value;

                                                          // filterSearchResults_new2(value);
                                                        },
                                                        decoration: InputDecoration(

                                                            border: InputBorder.none,
                                                            /*
                                                            suffixIcon: IconButton(
                                                              icon: Icon(
                                                                Icons.cancel,
                                                                size: 20,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                 // WidgetsBinding.instance.addPostFrameCallback(
                                                                   //       (_) => _Customernameeditcont.clear());
                                                                });
                                                              },
                                                            ),
                                                            prefixIcon: Icon(Icons.category,
                                                                color:
                                                                Color(getColorHexFromStr(pyellow3)),
                                                                size: 30.0),
                                                        */
                                                            contentPadding:
                                                            EdgeInsets.all(5.0),
                                                            hintText: 'Unit',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,
                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),


                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                // Text('Qty'),
                                                Material(

                                                  elevation: 0.0,
                                                  borderRadius: BorderRadius.circular(
                                                      5.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 7,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,
                                                        keyboardType: TextInputType
                                                            .number,
                                                        controller: _invDet_Qty1,
                                                        onChanged: (value) {
                                                          //   this.phoneNo = value;
                                                          setState(() {
                                                            _invDet_Total1.text =
                                                                (double.parse(
                                                                    _invDet_Price1
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty1
                                                                            .text))
                                                                    .toString();


                                                            if (_invDet_Price3.text
                                                                .isNotEmpty &&
                                                                _invDet_Price2.text
                                                                    .isNotEmpty &&
                                                                _invDet_Price2.text
                                                                    .isNotEmpty &&
                                                                _invDet_Price0.text
                                                                    .isNotEmpty
                                                                &&
                                                                _invDet_Qty3.text
                                                                    .isNotEmpty &&
                                                                _invDet_Qty2.text
                                                                    .isNotEmpty &&
                                                                _invDet_Qty2.text
                                                                    .isNotEmpty &&
                                                                _invDet_Qty0.text
                                                                    .isNotEmpty
                                                            ) {
                                                              _invDet_subTotal.text =
                                                                  (double.parse(
                                                                      _invDet_Price0
                                                                          .text) *
                                                                      double.parse(
                                                                          _invDet_Qty0
                                                                              .text) +
                                                                      double.parse(
                                                                          _invDet_Price1
                                                                              .text) *
                                                                          double
                                                                              .parse(
                                                                              _invDet_Qty1
                                                                                  .text) +
                                                                      double.parse(
                                                                          _invDet_Price2
                                                                              .text) *
                                                                          double
                                                                              .parse(
                                                                              _invDet_Qty2
                                                                                  .text) +
                                                                      double.parse(
                                                                          _invDet_Price3
                                                                              .text) *
                                                                          double
                                                                              .parse(
                                                                              _invDet_Qty3
                                                                                  .text))
                                                                      .toString();
                                                            }

                                                            else
                                                            if (_invDet_Price2.text
                                                                .isNotEmpty &&
                                                                _invDet_Price1.text
                                                                    .isNotEmpty &&
                                                                _invDet_Price0.text
                                                                    .isNotEmpty
                                                                &&
                                                                _invDet_Qty2.text
                                                                    .isNotEmpty &&
                                                                _invDet_Qty1.text
                                                                    .isNotEmpty &&
                                                                _invDet_Qty0.text
                                                                    .isNotEmpty
                                                            ) {
                                                              _invDet_subTotal.text =
                                                                  (double.parse(
                                                                      _invDet_Price0
                                                                          .text) *
                                                                      double.parse(
                                                                          _invDet_Qty0
                                                                              .text) +
                                                                      double.parse(
                                                                          _invDet_Price1
                                                                              .text) *
                                                                          double
                                                                              .parse(
                                                                              _invDet_Qty1
                                                                                  .text) +
                                                                      double.parse(
                                                                          _invDet_Price2
                                                                              .text) *
                                                                          double
                                                                              .parse(
                                                                              _invDet_Qty2
                                                                                  .text)
                                                                  ).toString();
                                                            }

                                                            else
                                                            if (_invDet_Price1.text
                                                                .isNotEmpty &&
                                                                _invDet_Price0.text
                                                                    .isNotEmpty
                                                                &&
                                                                _invDet_Qty1.text
                                                                    .isNotEmpty &&
                                                                _invDet_Qty0.text
                                                                    .isNotEmpty
                                                            ) {
                                                              _invDet_subTotal.text =
                                                                  (double.parse(
                                                                      _invDet_Price0
                                                                          .text) *
                                                                      double.parse(
                                                                          _invDet_Qty0
                                                                              .text) +
                                                                      double.parse(
                                                                          _invDet_Price1
                                                                              .text) *
                                                                          double
                                                                              .parse(
                                                                              _invDet_Qty1
                                                                                  .text)

                                                                  ).toString();
                                                            }
                                                            else
                                                            if (_invDet_Price0.text
                                                                .isNotEmpty
                                                                &&
                                                                _invDet_Qty0.text
                                                                    .isNotEmpty
                                                            ) {
                                                              _invDet_subTotal.text =
                                                                  (double.parse(
                                                                      _invDet_Price0
                                                                          .text) *
                                                                      double.parse(
                                                                          _invDet_Qty0
                                                                              .text)


                                                                  ).toString();
                                                            }
                                                            _invDet_tax.text =
                                                                (double.parse(
                                                                    _invDet_subTotal
                                                                        .text) * 16 /
                                                                    100).toString();
                                                            _invDet_Total_All.text =
                                                                (double.parse(
                                                                    _invDet_subTotal
                                                                        .text) +
                                                                    double.parse(
                                                                        _invDet_tax
                                                                            .text))
                                                                    .toString();
                                                            print(
                                                                '_invDet_Total_All.text${_invDet_Total_All
                                                                    .text}');
                                                          });
                                                          // filterSearchResults_new2(value);
                                                        },
                                                        decoration: InputDecoration(

                                                            border: InputBorder.none,
                                                            /*
                                                            suffixIcon: IconButton(
                                                              icon: Icon(
                                                                Icons.cancel,
                                                                size: 20,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                 // WidgetsBinding.instance.addPostFrameCallback(
                                                                   //       (_) => _Customernameeditcont.clear());
                                                                });
                                                              },
                                                            ),
                                                            prefixIcon: Icon(Icons.category,
                                                                color:
                                                                Color(getColorHexFromStr(pyellow3)),
                                                                size: 30.0),
                                                        */
                                                            contentPadding:
                                                            EdgeInsets.all(5.0),
                                                            hintText: 'Qty',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,
                                                                fontFamily: 'Quicksand',
                                                                backgroundColor: Colors
                                                                    .white))),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                //  Text('Price'),
                                                Material(

                                                  elevation: 0.0,
                                                  borderRadius: BorderRadius.circular(
                                                      5.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 6,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,
                                                        keyboardType: TextInputType
                                                            .number,
                                                        controller: _invDet_Price1,
                                                        onChanged: (value) {
                                                          //   this.phoneNo = value;

                                                          // filterSearchResults_new2(value);
                                                        },
                                                        decoration: InputDecoration(

                                                            border: InputBorder.none,
                                                            /*
                                                            suffixIcon: IconButton(
                                                              icon: Icon(
                                                                Icons.cancel,
                                                                size: 20,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                 // WidgetsBinding.instance.addPostFrameCallback(
                                                                   //       (_) => _Customernameeditcont.clear());
                                                                });
                                                              },
                                                            ),
                                                            prefixIcon: Icon(Icons.category,
                                                                color:
                                                                Color(getColorHexFromStr(pyellow3)),
                                                                size: 30.0),
                                                        */
                                                            contentPadding:
                                                            EdgeInsets.all(5.0),
                                                            hintText: 'Price',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,
                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                // Text('Total'),
                                                Material(

                                                  elevation: 0.0,
                                                  borderRadius: BorderRadius.circular(
                                                      5.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 6.5,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,


                                                        keyboardType: TextInputType
                                                            .number,
                                                        controller: _invDet_Total1,
                                                        onChanged: (value) {
                                                          _subtotal = (double.parse(
                                                              _invDet_Total0.text) +
                                                              double.parse(
                                                                  _invDet_Total1
                                                                      .text) +
                                                              double.parse(
                                                                  _invDet_Total2
                                                                      .text) +
                                                              double.parse(
                                                                  _invDet_Total3
                                                                      .text))
                                                              .toString();
                                                          //   this.phoneNo = value;

                                                          // filterSearchResults_new2(value);
                                                        },
                                                        decoration: InputDecoration(


                                                            border: InputBorder.none,
                                                            /*
                                                            suffixIcon: IconButton(
                                                              icon: Icon(
                                                                Icons.cancel,
                                                                size: 20,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                 // WidgetsBinding.instance.addPostFrameCallback(
                                                                   //       (_) => _Customernameeditcont.clear());
                                                                });
                                                              },
                                                            ),
                                                            prefixIcon: Icon(Icons.category,
                                                                color:
                                                                Color(getColorHexFromStr(pyellow3)),
                                                                size: 30.0),
                                                        */
                                                            contentPadding:
                                                            EdgeInsets.all(5.0),
                                                            hintText: 'Total',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,

                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _invDet_Prod2.clear();
                                                  _invDet_Qty2.clear();
                                                  _invDet_Price2.clear();
                                                  _invDet_Total2.clear();
                                                  _invDet_Unit2.clear();
                                                });
                                                if (_no_row[1] == '+') {
                                                  setState(() {
                                                    _no_row[1] = '-';
                                                    _no_row.add('+');
                                                  });
                                                }
                                                else if (_no_row[1] == '-') {
                                                  setState(() {
                                                    _no_row[1] = '+';
                                                    _no_row.removeAt(1);
                                                  });
                                                }
                                              },


                                              child: Center(
                                                child: CircleAvatar(radius: 10,
                                                  child: Text(_no_row[1],
                                                    style: TextStyle(
                                                        color: Colors.black),),
                                                  backgroundColor: Red_deep, //Color(getColorHexFromStr(pyellow3)),),  ),
                                                ),

                                              ),),
                                          ]
                                      )

                                          :
                                      SizedBox()
                                      ,
                                      _no_row.length >= 3 ?
                                      Row(
                                        children: <Widget>[
                                          Column(


                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              //   Text('Product'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 4.5,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .text,
                                                      showCursor: true,
                                                      readOnly: true,
                                                      controller: _invDet_Prod2,
                                                      onTap: () {
                                                        setState(() {
                                                          menu_prod = true;
                                                          typenameflag = 2;
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults.5_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Product',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),


                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              //  Text('Unit'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6.5,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .text,
                                                      controller: _invDet_Unit2,
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Unit',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),


                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              // Text('Qty'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 7,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      controller: _invDet_Qty2,
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;
                                                        setState(() {
                                                          _invDet_Total2.text =
                                                              (double.parse(
                                                                  _invDet_Price2
                                                                      .text) *
                                                                  double.parse(
                                                                      _invDet_Qty2
                                                                          .text))
                                                                  .toString();
                                                          if (_invDet_Price3.text
                                                              .isNotEmpty &&
                                                              _invDet_Price2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Price2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Price0.text
                                                                  .isNotEmpty
                                                              &&
                                                              _invDet_Qty3.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty0.text
                                                                  .isNotEmpty
                                                          ) {
                                                            _invDet_subTotal.text =
                                                                (double.parse(
                                                                    _invDet_Price0
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty0
                                                                            .text) +
                                                                    double.parse(
                                                                        _invDet_Price1
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty1
                                                                                .text) +
                                                                    double.parse(
                                                                        _invDet_Price2
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty2
                                                                                .text) +
                                                                    double.parse(
                                                                        _invDet_Price3
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty3
                                                                                .text))
                                                                    .toString();
                                                          }

                                                          else if (_invDet_Price2.text
                                                              .isNotEmpty &&
                                                              _invDet_Price2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Price0.text
                                                                  .isNotEmpty
                                                              &&
                                                              _invDet_Qty2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty0.text
                                                                  .isNotEmpty
                                                          ) {
                                                            _invDet_subTotal.text =
                                                                (double.parse(
                                                                    _invDet_Price0
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty0
                                                                            .text) +
                                                                    double.parse(
                                                                        _invDet_Price1
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty1
                                                                                .text) +
                                                                    double.parse(
                                                                        _invDet_Price2
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty2
                                                                                .text)
                                                                ).toString();
                                                          }

                                                          else if (_invDet_Price2.text
                                                              .isNotEmpty &&
                                                              _invDet_Price0.text
                                                                  .isNotEmpty
                                                              &&
                                                              _invDet_Qty2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty0.text
                                                                  .isNotEmpty
                                                          ) {
                                                            _invDet_subTotal.text =
                                                                (double.parse(
                                                                    _invDet_Price0
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty0
                                                                            .text) +
                                                                    double.parse(
                                                                        _invDet_Price1
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty1
                                                                                .text)

                                                                ).toString();
                                                          }
                                                          else if (_invDet_Price0.text
                                                              .isNotEmpty
                                                              &&
                                                              _invDet_Qty0.text
                                                                  .isNotEmpty
                                                          ) {
                                                            _invDet_subTotal.text =
                                                                (double.parse(
                                                                    _invDet_Price0
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty0
                                                                            .text)


                                                                ).toString();
                                                          }
                                                          _invDet_tax.text =
                                                              (double.parse(
                                                                  _invDet_subTotal
                                                                      .text) * 16 /
                                                                  100).toString();
                                                          _invDet_Total_All.text =
                                                              (double.parse(
                                                                  _invDet_subTotal
                                                                      .text) +
                                                                  double.parse(
                                                                      _invDet_tax
                                                                          .text))
                                                                  .toString();
                                                          print(
                                                              '_invDet_Total_All.text${_invDet_Total_All
                                                                  .text}');
                                                        });
                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Qty',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand',
                                                              backgroundColor: Colors
                                                                  .white))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              //  Text('Price'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      showCursor: true,
                                                      readOnly: true,
                                                      controller: _invDet_Price2,
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Price',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              //   Text('Total'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6.5,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,


                                                      keyboardType: TextInputType
                                                          .number,
                                                      controller: _invDet_Total2,
                                                      onChanged: (value) {
                                                        _subtotal = (double.parse(
                                                            _invDet_Total0.text) +
                                                            double.parse(
                                                                _invDet_Total1.text) +
                                                            double.parse(
                                                                _invDet_Total2.text) +
                                                            double.parse(
                                                                _invDet_Total3.text))
                                                            .toString();
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(


                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Total',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,

                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(width: 0),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _invDet_Prod3.clear();
                                                _invDet_Qty3.clear();
                                                _invDet_Price3.clear();
                                                _invDet_Total3.clear();
                                                _invDet_Unit3.clear();
                                              });


                                              if (_no_row[2] == '+') {
                                                setState(() {
                                                  _no_row[2] = '-';
                                                  _no_row.add('+');
                                                });
                                              }
                                              else if (_no_row[2] == '-') {
                                                setState(() {
                                                  _no_row[2] = '+';
                                                  _no_row.removeAt(2);
                                                });
                                              }
                                            },

                                            child: CircleAvatar(radius: 10,
                                              child: Text(_no_row[2],
                                                style: TextStyle(
                                                    color: Colors.black),),
                                              backgroundColor: Red_deep, //Color(getColorHexFromStr(pyellow3)),),  ),
                                            ),
                                          ),
                                        ],
                                      ) :
                                      SizedBox(),
                                      _no_row.length >= 4 ?
                                      Row(
                                        children: <Widget>[
                                          Column(


                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              //   Text('Product'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 4.5,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .text,
                                                      controller: _invDet_Prod3,
                                                      onTap: () {
                                                        setState(() {
                                                          menu_prod = true;
                                                          typenameflag = 3;
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults.5_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Product',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),


                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              //  Text('Unit'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6.5,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .text,
                                                      controller: _invDet_Unit3,
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Unit',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),


                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              // Text('Qty'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 7,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      controller: _invDet_Qty3,
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;
                                                        setState(() {
                                                          _invDet_Total3.text =
                                                              (double.parse(
                                                                  _invDet_Price3
                                                                      .text) *
                                                                  double.parse(
                                                                      _invDet_Qty3
                                                                          .text))
                                                                  .toString();


                                                          if (_invDet_Price3.text
                                                              .isNotEmpty &&
                                                              _invDet_Price2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Price2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Price0.text
                                                                  .isNotEmpty
                                                              &&
                                                              _invDet_Qty3.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty0.text
                                                                  .isNotEmpty
                                                          ) {
                                                            _invDet_subTotal.text =
                                                                (double.parse(
                                                                    _invDet_Price0
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty0
                                                                            .text) +
                                                                    double.parse(
                                                                        _invDet_Price1
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty1
                                                                                .text) +
                                                                    double.parse(
                                                                        _invDet_Price2
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty2
                                                                                .text) +
                                                                    double.parse(
                                                                        _invDet_Price3
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty3
                                                                                .text))
                                                                    .toString();
                                                          }

                                                          else if (_invDet_Price2.text
                                                              .isNotEmpty &&
                                                              _invDet_Price1.text
                                                                  .isNotEmpty &&
                                                              _invDet_Price0.text
                                                                  .isNotEmpty
                                                              &&
                                                              _invDet_Qty2.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty1.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty0.text
                                                                  .isNotEmpty
                                                          ) {
                                                            _invDet_subTotal.text =
                                                                (double.parse(
                                                                    _invDet_Price0
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty0
                                                                            .text) +
                                                                    double.parse(
                                                                        _invDet_Price1
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty1
                                                                                .text) +
                                                                    double.parse(
                                                                        _invDet_Price2
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty2
                                                                                .text)
                                                                ).toString();
                                                          }

                                                          else if (_invDet_Price1.text
                                                              .isNotEmpty &&
                                                              _invDet_Price0.text
                                                                  .isNotEmpty
                                                              &&
                                                              _invDet_Qty1.text
                                                                  .isNotEmpty &&
                                                              _invDet_Qty0.text
                                                                  .isNotEmpty
                                                          ) {
                                                            _invDet_subTotal.text =
                                                                (double.parse(
                                                                    _invDet_Price0
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty0
                                                                            .text) +
                                                                    double.parse(
                                                                        _invDet_Price1
                                                                            .text) *
                                                                        double.parse(
                                                                            _invDet_Qty1
                                                                                .text)

                                                                ).toString();
                                                          }
                                                          else if (_invDet_Price0.text
                                                              .isNotEmpty
                                                              &&
                                                              _invDet_Qty0.text
                                                                  .isNotEmpty
                                                          ) {
                                                            _invDet_subTotal.text =
                                                                (double.parse(
                                                                    _invDet_Price0
                                                                        .text) *
                                                                    double.parse(
                                                                        _invDet_Qty0
                                                                            .text)


                                                                ).toString();
                                                          }
                                                          _invDet_tax.text =
                                                              (double.parse(
                                                                  _invDet_subTotal
                                                                      .text) * 16 /
                                                                  100).toString();
                                                          _invDet_Total_All.text =
                                                              (double.parse(
                                                                  _invDet_subTotal
                                                                      .text) +
                                                                  double.parse(
                                                                      _invDet_tax
                                                                          .text) - double.parse(_invDet_Discount.text.length==0 ? 0 : _invDet_Discount.text))
                                                                  .toString()

                                                          ;
                                                          print(
                                                              '_invDet_Total_All.text${_invDet_Total_All
                                                                  .text}');
                                                        });
                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Qty',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand',
                                                              backgroundColor: Colors
                                                                  .white))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              //  Text('Price'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      controller: _invDet_Price3,
                                                      onChanged: (value) {
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(

                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Price',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              //   Text('Total'),
                                              Material(

                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 6.5,
                                                  child: TextField(
                                                      textAlign: TextAlign.center,


                                                      keyboardType: TextInputType
                                                          .number,
                                                      controller: _invDet_Total3,
                                                      onChanged: (value) {
                                                        _subtotal = (double.parse(
                                                            _invDet_Total0.text) +
                                                            double.parse(
                                                                _invDet_Total1.text) +
                                                            double.parse(
                                                                _invDet_Total2.text) +
                                                            double.parse(
                                                                _invDet_Total3.text))
                                                            .toString();
                                                        //   this.phoneNo = value;

                                                        // filterSearchResults_new2(value);
                                                      },
                                                      decoration: InputDecoration(


                                                          border: InputBorder.none,
                                                          /*
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                               // WidgetsBinding.instance.addPostFrameCallback(
                                                                 //       (_) => _Customernameeditcont.clear());
                                                              });
                                                            },
                                                          ),
                                                          prefixIcon: Icon(Icons.category,
                                                              color:
                                                              Color(getColorHexFromStr(pyellow3)),
                                                              size: 30.0),
                                                      */
                                                          contentPadding:
                                                          EdgeInsets.all(5.0),
                                                          hintText: 'Total',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,

                                                              fontFamily: 'Quicksand'))),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(width: 0),
                                          InkWell(
                                            onTap: () {
                                              if (_no_row[3] == '+') {
                                                setState(() {
                                                  _no_row[3] = '-';
                                                  _no_row.add('+');
                                                });
                                              }
                                              else if (_no_row[3] == '-') {
                                                setState(() {
                                                  _no_row[3] = '+';
                                                  _no_row.removeAt(3);
                                                });
                                              }
                                            },

                                            child: CircleAvatar(radius: 10,
                                              child: Text(_no_row[2],
                                                style: TextStyle(
                                                    color: Colors.black),),
                                              backgroundColor: Red_deep
                                              //Color(getColorHexFromStr(pyellow3))
                                              ,),),
                                        ],
                                      ) :
                                      SizedBox(),
                                      menu_prod ?

                                      WidgetInvoice_LV_Animation(
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 5),
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height/3, //cell
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width - 20, //cells
                                           child: StaggeredGridView.countBuilder(
                                             crossAxisCount: 6,
                                             itemCount: typelist.length,
                                             itemBuilder: myconttype,
                                             staggeredTileBuilder: (int index) =>
                                             new StaggeredTile.count(3,  1),//(2, index.isEven ? 2 : 1),
                                             mainAxisSpacing: 3.0,
                                             crossAxisSpacing: 3.0,
                                           )
//                                        ListView.builder(
//                                          // shrinkWrap: true,
//                                          scrollDirection: Axis.horizontal,
//                                          itemBuilder: myconttype,
//                                          itemCount: typelist.length,
//                                        ),

                                          )
                                      )


                                          : SizedBox(height: 0,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text('Subtotal',style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),),
                                          Row(

                                            children: <Widget>[
                                              Material(
                                                color: Colors.white,
                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 35.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 4,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,


                                                        keyboardType: TextInputType
                                                            .number,
                                                        controller: _invDet_subTotal,
                                                        onChanged: (value) {
                                                          //   this.phoneNo = value;

                                                          // filterSearchResults_new2(value);
                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,

                                                            contentPadding:
                                                            EdgeInsets.all(5.0),
                                                            hintText: 'Total',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,

                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),
                                              ),

/*
                                              SizedBox(
                                                width: 80,
                                                child: Text('$_subtotal', style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold),),),
                                             */
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              CircleAvatar(radius: 12,
                                                child: Text('T'),
                                              ),

                                              SizedBox(width: 5),
                                              Text('Tax : 16%',style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          Row(

                                            children: <Widget>[
                                              Material(
                                                color: Colors.white,
                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 35.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 4,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,


                                                        keyboardType: TextInputType
                                                            .number,
                                                        controller: _invDet_tax,
                                                        onChanged: (value) {
                                                          update_invoice_total_amt();
                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,

                                                            contentPadding:
                                                            EdgeInsets.all(10.0),
                                                            hintText: 'Tax',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,

                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),
                                              ),

/*
                                              SizedBox(
                                                width: 80,
                                                child: Text('$_subtotal', style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold),),),
                                             */
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              CircleAvatar(radius: 12,
                                                child: Text('D'),
                                              ),

                                              //  SizedBox(width:5),

                                              CircleAvatar(radius: 12,
                                                child: Text("\$"),
                                              ),

                                              // SizedBox(width:5),

                                              Text('Discount :',style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),),

//                                        DropDownButtonString(listdisc,'Choose',(String val){
//                                               print('val=${val}');
//                                               _invDet_Discount.text=val;
//                                               _invDet_Total_All.text=(double.parse(_invDet_Total_All.text) - double.parse(_invDet_Discount.text.substring(1)) ).toString();
//                                               print('_invDet_Total_All.text${_invDet_Total_All.text}');


                                              //  }


                                            ],
                                          ),
                                          Row(

                                            children: <Widget>[
                                              Material(
                                                color: Colors.white,
                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 35.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 4,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,


                                                        keyboardType: TextInputType
                                                            .number,
                                                        controller: _invDet_Discount,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _invDet_Total_All.text =
                                                                (double.parse(
                                                                    _invDet_subTotal
                                                                        .text) +
                                                                    double.parse(
                                                                        _invDet_tax
                                                                            .text) - double.parse(_invDet_Discount.text.length==0 ? 0 : _invDet_Discount.text))
                                                                    .toString();
                                                          });

                                                          // filterSearchResults_new2(value);
                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,

                                                            contentPadding:
                                                            EdgeInsets.all(10.0),
                                                            hintText: 'Discount',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,

                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),
                                              ),

/*
                                              SizedBox(
                                                width: 80,
                                                child: Text('$_subtotal', style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold),),),
                                             */
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[


                                              // SizedBox(width:5),

                                              Text('Total All:',style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),),
                                              // DropdownButtonSpc(),
                                            ],
                                          ),
                                          Row(

                                            children: <Widget>[
                                              Material(
                                                color: Colors.white,
                                                elevation: 0.0,
                                                borderRadius: BorderRadius.circular(
                                                    5.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 35.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 4,
                                                    child: TextField(
                                                        textAlign: TextAlign.center,


                                                        keyboardType: TextInputType
                                                            .number,
                                                        controller: _invDet_Total_All,
                                                        onChanged: (value) {
                                                          //   this.phoneNo = value;

                                                          // filterSearchResults_new2(value);
                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,

                                                            contentPadding:
                                                            EdgeInsets.all(10.0),
                                                            hintText: 'Total',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,

                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),
                                              ),

/*
                                              SizedBox(
                                                width: 80,
                                                child: Text('$_subtotal', style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold),),),
                                             */
                                            ],
                                          ),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[


                                              // SizedBox(width:5),

                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Payment :',style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold),),
                                                  Row(
                                                    children: <Widget>[
                                                      Radio(value: 'Cash',
                                                          groupValue: radiogroup,
                                                          onChanged: (T) {
                                                            print(T);
                                                            setState(() {
                                                              radiogroup = T;
                                                              _PaymentType = T;
                                                            });
                                                          }),
                                                      Text('Cash'),
                                                      Radio(value: 'Palpay',
                                                          groupValue: radiogroup,
                                                          onChanged: (T) {
                                                            print(T);
                                                            setState(() {
                                                              radiogroup = T;
                                                              _PaymentType = T;
                                                            });
                                                          }),
                                                      Text('PayPal'),

                                                      Radio(value: 'Sheck',
                                                          groupValue: radiogroup,
                                                          onChanged: (T) {
                                                            print(T);
                                                            setState(() {
                                                              radiogroup = T;
                                                              _PaymentType = T;
                                                            });
                                                          }),
                                                      Text('Sheck'),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),

                                      //save
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: RaisedButton(
                                                      child:Text(
                                                    'Save',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  color: Red_deep,
                                                  onPressed: () {

                                                    setState(() {
                                                      call_get_datamaxinvoice_no();
                                                      _InvoiceList.clear();
                                                      _InvoicesubList.clear();
                                                      // _readdball_inv_max_no();
                                                    });

                                                    //  ..InvoicesQty = _invDet_Qty2.text
//                                                  ..InvoicePrice = _invDet_Price2.text
//                                                  ..InvoiceTotal = _invDet_Total2.text
//                                                  ..InvoiceUnit = _invDet_Unit2.text;

                                                    //  _Invsubone.
//                                              ..Invoice_no= 12//'${_invoice_no}'
//                                              ..Invoice_date = DateTime.now()
//                                              ..Invoice_provider= customername2
//                                            ..Invoice_amt=100//_invDet_Total_All.text
//                                            ..Invoice_disc=20//_invDet_Discount.text
//                                          //  ..Subtotal=_invDet_subTotal.text
//                                            ..Invoice_pay='Cash';//_PaymentType;
//                                            //_savedb_invoice(_inv);
                                                    //_readdball_inv_max_no();
                                                    // Save details
                                                    //0
                                                    if (_invDet_Prod0.text.length >
                                                        0 &&
                                                        _invDet_Qty0.text.length >
                                                            0 &&
                                                        _invDet_Price0.text.length >
                                                            0 &&
                                                        _invDet_Total0.text.length >
                                                            0 &&
                                                        _invDet_Unit0.text.length >
                                                            0) {
                                                      {
                                                        Invoice _Invsubone0 = Invoice();
                                                        _Invsubone0.Type_no = P_type_no0;
                                                        _Invsubone0.Type_name =
                                                            _invDet_Prod0.text;
                                                        _Invsubone0.Type_price =
                                                            double.parse(
                                                                _invDet_Price0.text);
                                                        _Invsubone0.Type_unit =
                                                            _invDet_Unit0.text;
                                                        _Invsubone0.Type_Total =
                                                            double.parse(
                                                                _invDet_Total0.text);
                                                        _Invsubone0.Type_qty =
                                                            double.parse(_invDet_Qty0.text);
                                                        _InvoicesubList.add(
                                                            _Invsubone0);



//                                                Invoice _invDet = new InvoicesDet()
//                                                  ..InvoiceNoDet = '$_invoice_no'
//                                                  ..InvoicesProdDet = _invDet_Prod0
//                                                      .text
//                                                  ..InvoicesQty = _invDet_Qty0.text
//                                                  ..InvoicePrice = _invDet_Price0.text
//                                                  ..InvoiceTotal = _invDet_Total0.text
//                                                  ..InvoiceUnit = _invDet_Unit0.text;
//
//                                                _invDetList.add(_invDet);
                                                      }
                                                      //1
                                                      if (_invDet_Prod1.text.length >
                                                          0 &&
                                                          _invDet_Qty1.text.length >
                                                              0 &&
                                                          _invDet_Price1.text.length >
                                                              0 &&
                                                          _invDet_Total1.text.length >
                                                              0 &&
                                                          _invDet_Unit1.text.length >
                                                              0) {
                                                        Invoice _Invsubone1 = Invoice();
                                                        _Invsubone1.Type_no = P_type_no1;
                                                        _Invsubone1.Type_name =
                                                            _invDet_Prod1.text;
                                                        _Invsubone1.Type_price =
                                                            double.parse(
                                                                _invDet_Price1.text);
                                                        _Invsubone1.Type_unit =
                                                            _invDet_Unit1.text;
                                                        _Invsubone1.Type_Total =
                                                            double.parse(
                                                                _invDet_Total1.text);
                                                        _Invsubone1.Type_qty =
                                                            double.parse(_invDet_Qty1.text);
                                                        _InvoicesubList.add(
                                                            _Invsubone1);

//                                                InvoicesDet _invDet = new InvoicesDet()
//                                                  ..InvoiceNoDet = '$_invoice_no'
//                                                  ..InvoicesProdDet = _invDet_Prod1
//                                                      .text
//                                                  ..InvoicesQty = _invDet_Qty1.text
//                                                  ..InvoicePrice = _invDet_Price1.text
//                                                  ..InvoiceTotal = _invDet_Total1.text
//                                                  ..InvoiceUnit = _invDet_Unit1.text;
//
//                                                _invDetList.add(_invDet);
                                                      }
                                                      //2
                                                      if (_invDet_Prod2.text.length >
                                                          0 &&
                                                          _invDet_Qty2.text.length >
                                                              0 &&
                                                          _invDet_Price2.text.length >
                                                              0 &&
                                                          _invDet_Total2.text.length >
                                                              0 &&
                                                          _invDet_Unit2.text.length >
                                                              0) {
                                                        Invoice _Invsubone2 = Invoice();
                                                        _Invsubone2.Type_no = P_type_no2;
                                                        _Invsubone2.Type_name =
                                                            _invDet_Prod2.text;
                                                        _Invsubone2.Type_price =
                                                            double.parse(
                                                                _invDet_Price2.text);
                                                        _Invsubone2.Type_unit =
                                                            _invDet_Unit2.text;
                                                        _Invsubone2.Type_Total =
                                                            double.parse(
                                                                _invDet_Total2.text);
                                                        _Invsubone2.Type_qty =
                                                            double.parse(_invDet_Qty2.text);
                                                        _InvoicesubList.add(
                                                            _Invsubone2);
                                                      }
                                                      //3
                                                      if (_invDet_Prod3.text.length >
                                                          0 &&
                                                          _invDet_Qty3.text.length >
                                                              0 &&
                                                          _invDet_Price3.text.length >
                                                              0 &&
                                                          _invDet_Total3.text.length >
                                                              0 &&
                                                          _invDet_Unit3.text.length >
                                                              0) {
                                                        Invoice _Invsubone3 = Invoice();
                                                        _Invsubone3.Type_no = P_type_no3;
                                                        _Invsubone3.Type_name =
                                                            _invDet_Prod3.text;
                                                        _Invsubone3.Type_price =
                                                            double.parse(
                                                                _invDet_Price3.text);
                                                        _Invsubone3.Type_unit =
                                                            _invDet_Unit3.text;
                                                        _Invsubone3.Type_Total =
                                                            double.parse(
                                                                _invDet_Total3.text);
                                                        _Invsubone3.Type_qty =
                                                            double.parse(_invDet_Qty3.text);
                                                        _InvoicesubList.add(
                                                            _Invsubone3);
                                                      }


                                                      setState(() {
//                                              _invDet_Prod0.clear();
//                                              _invDet_Qty0.clear();
//                                              _invDet_Price0.clear();
//                                              _invDet_Total0.clear();
//                                              _invDet_Unit0.clear();
//
//                                              _invDet_Prod1.clear();
//                                              _invDet_Qty1.clear();
//                                              _invDet_Price1.clear();
//                                              _invDet_Total1.clear();
//                                              _invDet_Unit1.clear();
//
//                                              _invDet_Prod2.clear();
//                                              _invDet_Qty2.clear();
//                                              _invDet_Price2.clear();
//                                              _invDet_Total2.clear();
//                                              _invDet_Unit2.clear();
//
//                                              _invDet_Prod3.clear();
//                                              _invDet_Qty3.clear();
//                                              _invDet_Price3.clear();
//                                              _invDet_Total3.clear();
//                                              _invDet_Unit3.clear();
//
//                                              _invDet_Total_All.clear();
//                                              _invDet_Discount.clear();
//                                              _invDet_tax.clear();
//                                              _invDet_subTotal.clear();
//


                                                      });
//                                            if(_no_row[0]=='-') {
//                                              setState(() {
//                                                _no_row[0] = '+';
//                                                _no_row.removeAt(0);
//
//                                              });
//                                            }
//
//                                            if(_no_row[1]=='-') {
//                                              setState(() {
//                                                _no_row[1] = '+';
//                                                _no_row.removeAt(1);
//
//                                              });
//                                            }
//                                            if(_no_row[2]=='-') {
//                                              setState(() {
//                                                _no_row[2] = '+';
//                                                _no_row.removeAt(2);
//
//                                              });
//                                            }
//
//                                            if(_no_row[3]=='-') {
//                                              setState(() {
//                                                _no_row[3] = '+';
//                                                _no_row.removeAt(3);
//
//                                              });
//                                            }
//
                                                      print(_PaymentType);
                                                      Invoices _inv = new Invoices()
                                                        ..Invoice_no = Max_Invoice_no !=null ?Max_Invoice_no :0
                                                        ..Invoice_date = DateTime.now()
                                                        ..Invoice_status = _PaymentType =='Cash' ? 'Close':'Open'
                                                        ..Invoice_pay = _PaymentType
                                                        ..Invoice_disc =_invDet_Discount.text.length==0 ? 0 : int.parse(_invDet_Discount.text)
                                                        ..Invoice_provider = customername2
                                                        ..Invoice_due_date = DateTime
                                                            .now()
                                                        ..Invoice_amt = double.parse(_invDet_Total_All.text)//-double.parse(_invDet_Discount.text!=null ?   _invDet_Discount.text:0.0)
                                                        ..Invoice_sub_total=double.parse(_invDet_subTotal.text)
                                                        ..invoices = _InvoicesubList as List<Invoice>;
                                                      _InvoiceList.add(_inv);


                                                      add_invoice_to_firebase(
                                                          _InvoiceList);

//                                              _InvoiceList.forEach((element) {
//                                                print('inside list${element.invoices.length}');
//                                                print(element.Invoice_date);
//                                                print(element.Invoice_provider);
//                                                element.invoices.forEach((el) {
//                                                  print('inside  type');
//                                                  print(el.Type_no);
//                                                  print(el.Type_name);
//                                                  print(el.Type_Total);
//                                                });
//                                              });

                                                    }

                                                  }),
                                            ),
                                          ),



                                        ],
                                      ),


                                      //add by imad
//                                _no_row.length>=1 ?
//                                Row(
//                                  children: <Widget>[
//                                    Column(
//                                      crossAxisAlignment: CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Text('Product',),
//                                        Material(
//
//                                          elevation: 0.0,
//                                          borderRadius: BorderRadius.circular(5.0),
//                                          child: Container(
//                                            height: 30,
//                                            width: MediaQuery.of(context).size.width/4.5,
//                                            child: TextField(
//                                                textAlign: TextAlign.center,
//                                                keyboardType: TextInputType.text,
//                                                controller: _invDet_Prod0,
//                                                onTap: (){
//                                                  setState(() {
//                                                    menu_prod=true;
//                                                    typenameflag=0;
//                                                  });
//
//                                                },
//                                                onChanged: (value) {
//                                                  //   this.phoneNo = value;
//
//                                                  // filterSearchResults.5_new2(value);
//                                                },
//                                                decoration: InputDecoration(
//
//                                                    border: InputBorder.none,
//                                                    /*
//                                                    suffixIcon: IconButton(
//                                                      icon: Icon(
//                                                        Icons.cancel,
//                                                        size: 20,
//                                                      ),
//                                                      onPressed: () {
//                                                        setState(() {
//                                                         // WidgetsBinding.instance.addPostFrameCallback(
//                                                           //       (_) => _Customernameeditcont.clear());
//                                                        });
//                                                      },
//                                                    ),
//                                                    prefixIcon: Icon(Icons.category,
//                                                        color:
//                                                        Color(getColorHexFromStr(pyellow3)),
//                                                        size: 30.0),
//                                                */
//                                                    contentPadding:
//                                                    EdgeInsets.all(5.0),
//                                                    hintText: 'Product',
//                                                    hintStyle: TextStyle(
//                                                        color: Colors.grey,
//                                                        fontFamily: 'Quicksand'))),
//                                          ),
//                                        ),
//
//
//
//                                      ],
//                                    ),
//                                    Column(
//                                      crossAxisAlignment: CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Text('Unit'),
//                                        Material(
//
//                                          elevation: 0.0,
//                                          borderRadius: BorderRadius.circular(5.0),
//                                          child: Container(
//                                            height: 30,
//                                            width: MediaQuery.of(context).size.width/6.5,
//                                            child: TextField(
//                                                textAlign: TextAlign.center,
//                                                keyboardType: TextInputType.text,
//                                                controller: _invDet_Unit0,
//                                                onChanged: (value) {
//                                                  //   this.phoneNo = value;
//
//                                                  // filterSearchResults_new2(value);
//                                                },
//                                                decoration: InputDecoration(
//
//                                                    border: InputBorder.none,
//                                                    /*
//                                                    suffixIcon: IconButton(
//                                                      icon: Icon(
//                                                        Icons.cancel,
//                                                        size: 20,
//                                                      ),
//                                                      onPressed: () {
//                                                        setState(() {
//                                                         // WidgetsBinding.instance.addPostFrameCallback(
//                                                           //       (_) => _Customernameeditcont.clear());
//                                                        });
//                                                      },
//                                                    ),
//                                                    prefixIcon: Icon(Icons.category,
//                                                        color:
//                                                        Color(getColorHexFromStr(pyellow3)),
//                                                        size: 30.0),
//                                                */
//                                                    contentPadding:
//                                                    EdgeInsets.all(5.0),
//                                                    hintText: 'Unit',
//                                                    hintStyle: TextStyle(
//                                                        color: Colors.grey,
//                                                        fontFamily: 'Quicksand'))),
//                                          ),
//                                        ),
//
//
//
//                                      ],
//                                    ),
//                                    Column(
//                                      crossAxisAlignment: CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Text('Qty'),
//                                        Material(
//
//                                          elevation: 0.0,
//                                          borderRadius: BorderRadius.circular(5.0),
//                                          child: Container(
//                                            height: 30,
//                                            width: MediaQuery.of(context).size.width/7,
//                                            child: TextField(
//                                                textAlign: TextAlign.center,
//                                                keyboardType: TextInputType.number,
//                                                controller: _invDet_Qty0,
//                                                onChanged: (value) {
//
//                                                  //   this.phoneNo = value;
//                                                  setState(() {
//
//
//
//                                                    _invDet_Total0.text= (double.parse(_invDet_Price0.text)* double.parse(_invDet_Qty0.text)).toString();
//
//                                                    if(_invDet_Price3.text.isNotEmpty && _invDet_Price2.text.isNotEmpty && _invDet_Price2.text.isNotEmpty  && _invDet_Price0.text.isNotEmpty
//                                                        &&
//                                                        _invDet_Qty3.text.isNotEmpty && _invDet_Qty2.text.isNotEmpty && _invDet_Qty2.text.isNotEmpty  && _invDet_Qty0.text.isNotEmpty
//                                                    )
//                                                    {
//                                                      _invDet_subTotal.text= ( double.parse(_invDet_Price0.text)* double.parse(_invDet_Qty0.text)+
//                                                          double.parse(_invDet_Price1.text)* double.parse(_invDet_Qty1.text)+
//                                                          double.parse(_invDet_Price2.text)* double.parse(_invDet_Qty2.text)+
//                                                          double.parse(_invDet_Price3.text)* double.parse(_invDet_Qty3.text)).toString();
//
//
//                                                    }
//
//                                                    else if( _invDet_Price2.text.isNotEmpty && _invDet_Price1.text.isNotEmpty  && _invDet_Price0.text.isNotEmpty
//                                                        &&
//                                                        _invDet_Qty2.text.isNotEmpty && _invDet_Qty1.text.isNotEmpty  && _invDet_Qty0.text.isNotEmpty
//                                                    )
//                                                    {
//                                                      _invDet_subTotal.text= ( double.parse(_invDet_Price0.text)* double.parse(_invDet_Qty0.text)+
//                                                          double.parse(_invDet_Price1.text)* double.parse(_invDet_Qty1.text)+
//                                                          double.parse(_invDet_Price2.text)* double.parse(_invDet_Qty2.text)
//                                                      ).toString();
//
//                                                    }
//
//                                                    else if( _invDet_Price1.text.isNotEmpty  && _invDet_Price0.text.isNotEmpty
//                                                        &&
//                                                        _invDet_Qty1.text.isNotEmpty  && _invDet_Qty0.text.isNotEmpty
//                                                    )
//                                                    {
//                                                      _invDet_subTotal.text= ( double.parse(_invDet_Price0.text)* double.parse(_invDet_Qty0.text)+
//                                                          double.parse(_invDet_Price1.text)* double.parse(_invDet_Qty1.text)
//
//                                                      ).toString();
//
//                                                    }
//                                                    else if(  _invDet_Price0.text.isNotEmpty
//                                                        &&
//                                                        _invDet_Qty0.text.isNotEmpty
//                                                    )
//                                                    {
//                                                      _invDet_subTotal.text= ( double.parse(_invDet_Price0.text)* double.parse(_invDet_Qty0.text)
//
//
//                                                      ).toString();
//
//                                                    }
//
//
//                                                    _invDet_tax.text=(double.parse(_invDet_subTotal.text)*16/100).toString();
//                                                    _invDet_Total_All.text=(double.parse(_invDet_subTotal.text)+ double.parse(_invDet_tax.text) ).toString();
//                                                    print('_invDet_Total_All.text${_invDet_Total_All.text}');
//
//                                                  });
//
//
//
//                                                  // filterSearchResults_new2(value);
//                                                },
//                                                decoration: InputDecoration(
//
//                                                    border: InputBorder.none,
//                                                    /*
//                                                    suffixIcon: IconButton(
//                                                      icon: Icon(
//                                                        Icons.cancel,
//                                                        size: 20,
//                                                      ),
//                                                      onPressed: () {
//                                                        setState(() {
//                                                         // WidgetsBinding.instance.addPostFrameCallback(
//                                                           //       (_) => _Customernameeditcont.clear());
//                                                        });
//                                                      },
//                                                    ),
//                                                    prefixIcon: Icon(Icons.category,
//                                                        color:
//                                                        Color(getColorHexFromStr(pyellow3)),
//                                                        size: 30.0),
//                                                */
//                                                    contentPadding:
//                                                    EdgeInsets.all(5.0),
//                                                    hintText: 'Qty',
//                                                    hintStyle: TextStyle(
//                                                        color: Colors.grey,
//                                                        fontFamily: 'Quicksand',
//                                                        backgroundColor: Colors.white))),
//                                          ),
//                                        ),
//
//                                      ],
//                                    ),
//                                    Column(
//                                      crossAxisAlignment: CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Text('Price'),
//                                        Material(
//
//                                          elevation: 0.0,
//                                          borderRadius: BorderRadius.circular(5.0),
//                                          child: Container(
//                                            height: 30,
//                                            width: MediaQuery.of(context).size.width/6,
//                                            child: TextField(
//                                                textAlign: TextAlign.center,
//                                                keyboardType: TextInputType.number,
//                                                controller: _invDet_Price0,
//                                                onChanged: (value) {
//                                                  //   this.phoneNo = value;
//
//                                                  // filterSearchResults_new2(value);
//                                                },
//                                                decoration: InputDecoration(
//
//                                                    border: InputBorder.none,
//                                                    /*
//                                                    suffixIcon: IconButton(
//                                                      icon: Icon(
//                                                        Icons.cancel,
//                                                        size: 20,
//                                                      ),
//                                                      onPressed: () {
//                                                        setState(() {
//                                                         // WidgetsBinding.instance.addPostFrameCallback(
//                                                           //       (_) => _Customernameeditcont.clear());
//                                                        });
//                                                      },
//                                                    ),
//                                                    prefixIcon: Icon(Icons.category,
//                                                        color:
//                                                        Color(getColorHexFromStr(pyellow3)),
//                                                        size: 30.0),
//                                                */
//                                                    contentPadding:
//                                                    EdgeInsets.all(5.0),
//                                                    hintText: 'Price',
//                                                    hintStyle: TextStyle(
//                                                        color: Colors.grey,
//                                                        fontFamily: 'Quicksand'))),
//                                          ),
//                                        ),
//
//                                      ],
//                                    ),
//                                    Column(
//                                      crossAxisAlignment: CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Text('Total'),
//                                        Material(
//
//                                          elevation: 0.0,
//                                          borderRadius: BorderRadius.circular(5.0),
//                                          child: Container(
//                                            height: 30,
//                                            width: MediaQuery.of(context).size.width/6.5,
//                                            child: TextField(
//                                                textAlign: TextAlign.center,
//
//
//                                                keyboardType: TextInputType.number,
//                                                controller: _invDet_Total0,
//                                                onChanged: (value) {
//                                                  setState(() {
//                                                    _subtotal=(double.parse(_invDet_Total0.text)+
//                                                        double.parse(_invDet_Total1.text)+
//                                                        double.parse(_invDet_Total2.text)+
//                                                        double.parse(_invDet_Total3.text)).toString();
//                                                  });
//                                                  //   this.phoneNo = value;
//
//                                                  // filterSearchResults_new2(value);
//                                                },
//                                                decoration: InputDecoration(
//
//                                                    border: InputBorder.none,
//                                                    contentPadding:
//                                                    EdgeInsets.all(5.0),
//                                                    hintText: 'Total',
//                                                    hintStyle: TextStyle(
//                                                        color: Colors.grey,
//
//                                                        fontFamily: 'Quicksand'))),
//                                          ),
//                                        ),
//
//                                      ],
//                                    ),
//                                    SizedBox(width :0),
//                                    InkWell(
//                                      onTap: ()
//                                      {
//                                        print('inside row 0');
//
//
//                                        setState(() {
//                                          _invDet_Prod1.clear();
//                                          _invDet_Qty1.clear();
//                                          _invDet_Price1.clear();
//                                          _invDet_Total1.clear();
//                                          _invDet_Unit1.clear();
//
//
//                                          /*  _subtotal=(double.parse(_invDet_Total0.text ?? 0 )+
//                                              double.parse(_invDet_Total1.text ?? 0)+
//                                              double.parse(_invDet_Total2.text ?? 0)+
//                                              double.parse(_invDet_Total3.text ?? 0)).toString();
//                                              */
//
//                                        });
//                                        if(_no_row[0]=='+') {
//                                          setState(() {
//                                            _no_row[0] = '-';
//                                            _no_row.add('+');
//
//                                          });
//                                        }
//                                        else if(_no_row[0]=='-') {
//                                          setState(() {
//                                            _no_row[0] = '+';
//                                            _no_row.removeAt(0);
//
//                                          });
//                                        }
//
//
//
//                                      },
//
//                                      child: CircleAvatar(radius: 10,
//                                        child: Text(_no_row[0],
//                                          style: TextStyle(color: Colors.black),),
//                                        backgroundColor:Red_deep,// Color(getColorHexFromStr(pyellow3)),
//                                      ),
//                                    ),
//                                  ],
//                                ):
//                                SizedBox(),


                                    ]


                                ),
                              ),
                            ),


                            // SizedBox(height: 10,),

                          ),),
                      ),
                    ],


                ),
              ),


            ],
          ),)
        ),

      ),
    );

    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    ///define methood


    Future<DateTime> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context,Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
  }


  Widget mycont(BuildContext context,int index) {
    print(index);
    print(listprovider[index].Provider_name);


    return InkWell(
      child: WidgetInvoice_LV_Animation(Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, //Color(getColorHexFromStr(pyellow3)),
                  offset: Offset(1.0,5.0),
                  blurRadius: 15,
                  spreadRadius: .2)
            ],

            borderRadius: BorderRadius.circular(5),
          ),
          width: MediaQuery
              .of(context)
              .size
              .width / 12,
          height: MediaQuery
              .of(context)
              .size
              .height/5,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Wrap(
              children: <Widget>[

                Center(
                  child: Container(
                    width: 40.0,
                    height: 5.0,
                    decoration: BoxDecoration(

                      /*
                      image: DecorationImage(
                        // image: NetworkImage(catslist[index]['cat_img']),
                        image: list[index].CustomerName != null
                            ? NetworkImage(catslist[index]['cat_img'])
                            : AssetImage('images/chris.jpg'),
                        fit: BoxFit.cover,
                      ),
                      */
                    ),
                    //AssetImage('images/dressers.png'), fit: BoxFit.cover)
                  ),
                ),

                //SizedBox(height: 20.0),
                Center(
                  //  child: ListTile(

                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(radius: 15,
                          child:
                          Text(listprovider[index].Provider_name.substring(0,1)
                              .toUpperCase()
                            ,style: TextStyle(
                                color: Colors.black),),
                          backgroundColor: Colors.grey[300],),
                        SizedBox(width: 5,),
                        Text(listprovider[index].Provider_name,
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ), //Text("Heading"),
                  //  subtitle: Text(_products[index]), //Text("SubHeading"),
                  //  ),
                )
              ],
            ),
          ))),
      onTap: () {
        // print("inside index ${index.toString()}");
        // print("inside one ${list[index].CustomerName}");
        //filterSearchResults_cat(list[index]['cat_name']);
        setState(() {
          customername2 = listprovider[index].Provider_name;
          menu_client = false;
        });
      },
    );
  }


  Widget myconttype(BuildContext context,int index) {
    return InkWell(
      child: WidgetInvoice_LV_Animation(Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0,5.0),
                  blurRadius: 15,
                  spreadRadius: .5)
            ],

            borderRadius: BorderRadius.circular(5),
          ),
          width: 150.0,
          height: 20.0,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Wrap(
              children: <Widget>[

                Center(
                  child: Container(
                    width: 40.0,
                    height: 5.0,
                    decoration: BoxDecoration(

                      /*
                      image: DecorationImage(
                        // image: NetworkImage(catslist[index]['cat_img']),
                        image: list[index].CustomerName != null
                            ? NetworkImage(catslist[index]['cat_img'])
                            : AssetImage('images/chris.jpg'),
                        fit: BoxFit.cover,
                      ),
                      */
                    ),
                    //AssetImage('images/dressers.png'), fit: BoxFit.cover)
                  ),
                ),

                //SizedBox(height: 20.0),
                Center(
                  //  child: ListTile(

                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(radius: 15,
                          child:
                          Text(typelist[index].TypeName.substring(0,1)
                              .toUpperCase()
                            ,style: TextStyle(
                                color: Colors.black),),
                          backgroundColor: Colors.grey[300],),
                        SizedBox(width: 5,),
                        Text(typelist[index].TypeName,
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ), //Text("Heading"),
                  //  subtitle: Text(_products[index]), //Text("SubHeading"),
                  //  ),
                )
              ],
            ),
          ))),
      onTap: () {
        setState(() {
          call_get_datamaxinvoice_no();
          print(Max_Invoice_no);
        });
        // print("inside index ${index.toString()}");
        // print("inside one ${list[index].CustomerName}");
        //filterSearchResults_cat(list[index]['cat_name']);
        setState(() {
          if (typenameflag == 0) {
            print('typenameflag=0');
           P_type_no0= typelist[index].id;
            _invDet_Prod0.text = typelist[index].TypeName;
            _invDet_Price0.text = typelist[index].TypePrice.toString();
            _invDet_Unit0.text = typelist[index].TypeUnit;
          }
          else if (typenameflag == 1) {
            print('typenameflag=1');
            P_type_no1= typelist[index].id;
            _invDet_Prod1.text = typelist[index].TypeName;
            _invDet_Price1.text = typelist[index].TypePrice.toString();
            _invDet_Unit1.text = typelist[index].TypeUnit;
          }
          else if (typenameflag == 2) {
            print('typenameflag=2');
            P_type_no2= typelist[index].id;
            _invDet_Prod2.text = typelist[index].TypeName;
            _invDet_Price2.text = typelist[index].TypePrice.toString();
            _invDet_Unit2.text = typelist[index].TypeUnit;
          }
          else if (typenameflag == 3) {
            P_type_no3= typelist[index].id;
            print('typenameflag=3');
            _invDet_Prod3.text = typelist[index].TypeName;
            _invDet_Price3.text = typelist[index].TypePrice.toString();
            _invDet_Unit3.text = typelist[index].TypeUnit;
          }
          menu_prod = false;

          /*   if (index == 0) {
            flag = 0;
            main_widget = getCustomContainer(_products[index]);
          } else if (index == 1) {
            flag = 1;
            main_widget = getCustomContainer(_products[index]);
          } else {
            flag = 2;
            main_widget = getCustomContainer(_products[index]);
          }
          */
        });
      },
    );
  }


  Future<void> add_invoice_to_firebase(List<Invoices> ListInvoice) async {
    final todayDate = DateTime.now();
    var currentdate = formatDate(todayDate,
        [yyyy,'-',mm,'-',dd,' ',hh,':',nn,':',ss,' ',am]);
    String Doc_id;

    ListInvoice.forEach((element) {
      var documentId = FirebaseFirestore.instance.collection("Invoices").add(
        {
          "Invoice_No": element.Invoice_no,
          "Invoice_no_ref":_invDet_Invoice_no_ref.text,
          "Invoice_date": _date,
          "Invoice_provider": element.Invoice_provider,
          "Invoice_amt": element.Invoice_amt,
          "Invoice_due_date": element.Invoice_due_date,
          "Invoice_disc": element.Invoice_disc,
          "Invoice_pay": element.Invoice_pay,
          "Invoice_status": element.Invoice_status,
          "Invoice_sub_total":element.Invoice_sub_total
          //"Invoice_Details":   FieldValue.arrayUnion(list),
        },
      );
      documentId.then((value) {
        setState(() {
          Doc_id = value.toString().substring(27,47);
          print('Doc_id=$Doc_id');
          add_invoice_to_firebase_det(ListInvoice,Doc_id);
        });
      });
    });

  }


  Future<void> add_invoice_to_firebase_det(List<Invoices> ListInvoice,
      String Doc_id) async {
    {
      Map<String, dynamic>data = new Map();
      var list = new List<Map<String, dynamic>>();
      ListInvoice.forEach((element) {
        element.invoices.forEach((element2) {
          print('inside for each${element2.Type_name}');
          data['Type_no'] = element2.Type_no;
          data['Type_name'] = element2.Type_name;
          data['Type_Total'] = element2.Type_Total;
          data['Type_unit'] = element2.Type_unit;
          data['Type_qty'] = element2.Type_qty;
          data['Type_price'] = element2.Type_price;
          list.add(data);
          FirebaseFirestore.instance.collection("Invoices").doc(Doc_id).update({
            "Invoice_doc_id":Doc_id,
            "Invoice_Details": FieldValue.arrayUnion(list),
          });
        });
      });
    }
  }

  void update_invoice_item() {
    //   this.phoneNo = value;
    setState(() {
      _invDet_Total0.text =
          (double.parse(
              _invDet_Price0
                  .text) *
              double.parse(
                  _invDet_Qty0
                      .text))
              .toString();

      if (_invDet_Price3.text
          .isNotEmpty &&
          _invDet_Price2.text
              .isNotEmpty &&
          _invDet_Price2.text
              .isNotEmpty &&
          _invDet_Price0.text
              .isNotEmpty
          &&
          _invDet_Qty3.text
              .isNotEmpty &&
          _invDet_Qty2.text
              .isNotEmpty &&
          _invDet_Qty2.text
              .isNotEmpty &&
          _invDet_Qty0.text
              .isNotEmpty
      ) {
        _invDet_subTotal.text =
            (double.parse(
                _invDet_Price0
                    .text) *
                double.parse(
                    _invDet_Qty0
                        .text) +
                double.parse(
                    _invDet_Price1
                        .text) *
                    double.parse(
                        _invDet_Qty1
                            .text) +
                double.parse(
                    _invDet_Price2
                        .text) *
                    double.parse(
                        _invDet_Qty2
                            .text) +
                double.parse(
                    _invDet_Price3
                        .text) *
                    double.parse(
                        _invDet_Qty3
                            .text))
                .toString();
      }

      else if (_invDet_Price2.text
          .isNotEmpty &&
          _invDet_Price1.text
              .isNotEmpty &&
          _invDet_Price0.text
              .isNotEmpty
          &&
          _invDet_Qty2.text
              .isNotEmpty &&
          _invDet_Qty1.text
              .isNotEmpty &&
          _invDet_Qty0.text
              .isNotEmpty
      ) {
        _invDet_subTotal.text =
            (double.parse(
                _invDet_Price0
                    .text) *
                double.parse(
                    _invDet_Qty0
                        .text) +
                double.parse(
                    _invDet_Price1
                        .text) *
                    double.parse(
                        _invDet_Qty1
                            .text) +
                double.parse(
                    _invDet_Price2
                        .text) *
                    double.parse(
                        _invDet_Qty2
                            .text)
            ).toString();
      }

      else if (_invDet_Price1.text
          .isNotEmpty &&
          _invDet_Price0.text
              .isNotEmpty
          &&
          _invDet_Qty1.text
              .isNotEmpty &&
          _invDet_Qty0.text
              .isNotEmpty
      ) {
        _invDet_subTotal.text =
            (double.parse(
                _invDet_Price0
                    .text) *
                double.parse(
                    _invDet_Qty0
                        .text) +
                double.parse(
                    _invDet_Price1
                        .text) *
                    double.parse(
                        _invDet_Qty1
                            .text)

            ).toString();
      }
      else if (_invDet_Price0.text
          .isNotEmpty
          &&
          _invDet_Qty0.text
              .isNotEmpty
      ) {
        _invDet_subTotal.text =
            (double.parse(
                _invDet_Price0
                    .text) *
                double.parse(
                    _invDet_Qty0
                        .text)


            ).toString();
      }


      _invDet_tax.text =
          (double.parse(
              _invDet_subTotal
                  .text) * 16 /
              100).toString();
      _invDet_Total_All.text =
          (double.parse(
              _invDet_subTotal
                  .text) +
              double.parse(
                  _invDet_tax
                      .text))
              .toString();
      print(
          '_invDet_Total_All.text${_invDet_Total_All
              .text}');
    });


    // filterSearchResults_new2(value);

  }
  void update_invoice_total_amt() {
    //   this.phoneNo = value;
    setState(() {
      _invDet_Total0.text =
          (double.parse(
              _invDet_Price0
                  .text) *
              double.parse(
                  _invDet_Qty0
                      .text))
              .toString();

      if (_invDet_Price3.text
          .isNotEmpty &&
          _invDet_Price2.text
              .isNotEmpty &&
          _invDet_Price2.text
              .isNotEmpty &&
          _invDet_Price0.text
              .isNotEmpty
          &&
          _invDet_Qty3.text
              .isNotEmpty &&
          _invDet_Qty2.text
              .isNotEmpty &&
          _invDet_Qty2.text
              .isNotEmpty &&
          _invDet_Qty0.text
              .isNotEmpty
      ) {
        _invDet_subTotal.text =
            (double.parse(
                _invDet_Price0
                    .text) *
                double.parse(
                    _invDet_Qty0
                        .text) +
                double.parse(
                    _invDet_Price1
                        .text) *
                    double.parse(
                        _invDet_Qty1
                            .text) +
                double.parse(
                    _invDet_Price2
                        .text) *
                    double.parse(
                        _invDet_Qty2
                            .text) +
                double.parse(
                    _invDet_Price3
                        .text) *
                    double.parse(
                        _invDet_Qty3
                            .text))
                .toString();
      }

      else if (_invDet_Price2.text
          .isNotEmpty &&
          _invDet_Price1.text
              .isNotEmpty &&
          _invDet_Price0.text
              .isNotEmpty
          &&
          _invDet_Qty2.text
              .isNotEmpty &&
          _invDet_Qty1.text
              .isNotEmpty &&
          _invDet_Qty0.text
              .isNotEmpty
      ) {
        _invDet_subTotal.text =
            (double.parse(
                _invDet_Price0
                    .text) *
                double.parse(
                    _invDet_Qty0
                        .text) +
                double.parse(
                    _invDet_Price1
                        .text) *
                    double.parse(
                        _invDet_Qty1
                            .text) +
                double.parse(
                    _invDet_Price2
                        .text) *
                    double.parse(
                        _invDet_Qty2
                            .text)
            ).toString();
      }

      else if (_invDet_Price1.text
          .isNotEmpty &&
          _invDet_Price0.text
              .isNotEmpty
          &&
          _invDet_Qty1.text
              .isNotEmpty &&
          _invDet_Qty0.text
              .isNotEmpty
      ) {
        _invDet_subTotal.text =
            (double.parse(
                _invDet_Price0
                    .text) *
                double.parse(
                    _invDet_Qty0
                        .text) +
                double.parse(
                    _invDet_Price1
                        .text) *
                    double.parse(
                        _invDet_Qty1
                            .text)

            ).toString();
      }
      else if (_invDet_Price0.text
          .isNotEmpty
          &&
          _invDet_Qty0.text
              .isNotEmpty
      ) {
        _invDet_subTotal.text =
            (double.parse(
                _invDet_Price0
                    .text) *
                double.parse(
                    _invDet_Qty0
                        .text)


            ).toString();
      }


//      _invDet_tax.text =
//          (double.parse(
//              _invDet_subTotal
//                  .text) * 16 /
//              100).toString();
      _invDet_Total_All.text =
          (double.parse(
              _invDet_subTotal
                  .text) +
              double.parse(
                  _invDet_tax
                      .text))
              .toString();
      print(
          '_invDet_Total_All.text${_invDet_Total_All
              .text}');
    });


    // filterSearchResults_new2(value);

  }
}