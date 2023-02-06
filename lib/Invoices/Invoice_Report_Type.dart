import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paychalet/Invoices/Invoice_report.dart';
import 'DropDownButton.dart';
import 'InvoiceAdd.dart';
import 'InvoiceEdit.dart';
import 'Invoice_report_details.dart';
import 'Invoices_Class.dart';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';

import 'Invoices_Class.dart';


//import 'package:paychalet/Pages/colors.dart';
//import 'package:paychalet/DataBaseFile/database_helpers.dart';
//import 'package:paychalet/ConstractorObjects/DropDownButton.dart';
//import 'package:paychalet/Invoices/Invoice_Report_Type_details.dart';
class Invoice_Report_Type extends StatefulWidget {
  @override
  _Invoice_Report_TypeState createState() => _Invoice_Report_TypeState();
}


var refreshKey = GlobalKey<RefreshIndicatorState>();

List<Invoices> list = List<Invoices>();
List<Invoices> listtemp;
List<Invoices_Type> duplicateItems = List<Invoices_Type>();
List<Invoices_Type> Invoices_Type1 = List<Invoices_Type>();
double sumprice = 0.0;

List<Invoices_Type> listtype = List<Invoices_Type>();


class _Invoice_Report_TypeState extends State<Invoice_Report_Type> {

  var listdisc = <String>[
    'Types',


  ];
  String listval;

  void gettypetotalprice() {
    sumprice = 0.0;

    print('type length${listtype.length}');
    double loc_sum = 0.0;
    for (int i = 0; i < listtype.length; i++) {
//print(listtype[i].Type_name);
      loc_sum = loc_sum + listtype[i].Type_Total;

    }
    setState(() {
      sumprice = loc_sum;
    });
    print('inside totl${sumprice}');
  }
  delete_invoice(docId ) async {
    FirebaseFirestore.instance
        .collection('Invoices')
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }


  void filterSearchResultsCustomer(String query) {
    List<Invoices_Type> dummySearchList = List<Invoices_Type>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
   //   print('inside if');
      List<Invoices_Type> dummyListData = List<Invoices_Type>();
      dummySearchList.forEach((item) {

        if (item.Invoice_provider.toUpperCase().contains(query.toUpperCase())) {

          dummyListData.add(item);

        }

      });
      setState(() {
        listtype = dummyListData;
      });
      return;
    }
    else {
      setState(() {
        listtype=duplicateItems;
        print('list=${list}');
      });
    }
  }

  void filterSearchResultsPayment(String query) {
    List<Invoices_Type> dummySearchList = List<Invoices_Type>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if payment');
      List<Invoices_Type> dummyListData = List<Invoices_Type>();
      dummySearchList.forEach((item) {
        if(item.Invoice_pay.length>0)
        {
          if (item.Invoice_pay.toUpperCase().contains(query.toUpperCase())) {
            print('inside if payment cond true');

            dummyListData.add(item);
          }

        }

      });
      setState(() {
        listtype = dummyListData;
      });
      return;
    }
    else {
      setState(() {
        listtype=duplicateItems;
        print('list=${list}');
      });
    }
  }

  void filterSearchResultsTotal(String query) {
    List<Invoices_Type> dummySearchList = List<Invoices_Type>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices_Type> dummyListData = List<Invoices_Type>();
      dummySearchList.forEach((item) {

        if (item.Invoice_amt>=double.parse(query)) {
          dummyListData.add(item);

        }

      });
      setState(() {
       listtype = dummyListData;
      });
      return;
    }
    else {
      setState(() {
        listtype=duplicateItems;
      });
    }
  }


  void filterSearchResultsNotes(String query) {
    List<Invoices_Type> dummySearchList = List<Invoices_Type>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices_Type> dummyListData = List<Invoices_Type>();
      dummySearchList.forEach((item) {
        if ((item?.Invoice_notes?.isNotEmpty?? true)) {
          //  if (item.Invoice_no_ref.toUpperCase().contains(query.toUpperCase())) {
          if (item.Invoice_notes.toUpperCase().contains(query.toUpperCase())) {
            print('inside if if ');
            dummyListData.add(item);
            print(item.Invoice_notes);
            print(dummyListData);
            setState(() {
             listtype = dummyListData;
              print('list=${list}');
            });
          }
        }
      });
      print('after loop;');
      setState(() {
       listtype = dummyListData;
        print('list=${list}');
      });
      // return;
    }
    else {
      setState(() {
        listtype=duplicateItems;
        print('list=${list}');
      });
    }
    print('list finall=${list}');

  }

  void filterSearchResultsInvoiceNo(String query) {
    List<Invoices_Type> dummySearchList = List<Invoices_Type>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices_Type> dummyListData = List<Invoices_Type>();
      dummySearchList.forEach((item) {

        if (item.Invoice_no_ref.toUpperCase().contains(query.toUpperCase())) {

          dummyListData.add(item);

        }

      });
      setState(() {
       listtype = dummyListData;
        print('list=${list}');
      });
      return;
    }
    else {
      setState(() {
        listtype=duplicateItems;
        print('list=${list}');
      });
    }
  }

  void filterSearchResultsTypes(String query) {
    List<Invoices_Type> dummySearchList = List<Invoices_Type>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices_Type> dummyListData = List<Invoices_Type>();
      dummySearchList.forEach((item) {

          if (item.Type_name.toUpperCase().contains(query.toUpperCase())) {

            dummyListData.add(item);


        }
      });
      setState(() {
       listtype = dummyListData;
      });
      return;
    }
    else {
      setState(() {
        listtype=duplicateItems;
        print('list=${list}');
      });
    }
  }


  call_get_data_invoice()
  {
    getDatainvoice();

  }

  getDatainvoice() async {
    list.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Invoices').get();
    // print('inside get data');

    // List<Invoices> _InvoiceList = [];
    snapshot.docs.forEach((document) {
      setState(() {
        Invoices _invoice = Invoices.fromJson(document.data());

//     print(_invoice.Invoice_no);
//     print(_invoice.Invoice_date);

        list.add(_invoice);
      });
      //  print('thelisttype =${list}');
    });


    setState(() {
      list.sort((b,a) =>
          a.Invoice_no.compareTo(b.Invoice_no));
    });


    loaddata_type();
      gettypetotalprice();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    call_get_data_invoice();
    listval='Types';
   print('inside init tttt');


  }

  loaddata_type()
  {
    listtype.clear();

    for (int i=0; i<list.length;i++)
      {
        for (int j=0;j<list[i].invoices.length;j++)
          {
            print(list[i].Invoice_no);
            Invoices_Type _invoicetype_one = Invoices_Type();
            _invoicetype_one.Invoice_no=list[i].Invoice_no;
            _invoicetype_one.Invoice_notes=list[i].Invoice_notes;
            _invoicetype_one.Invoice_amt=list[i].Invoice_amt;
            _invoicetype_one.Invoice_date=list[i].Invoice_date;
            _invoicetype_one.Invoice_disc=list[i].Invoice_disc;
            _invoicetype_one.Invoice_doc_id=list[i].Invoice_doc_id;
            _invoicetype_one.Invoice_due_date=list[i].Invoice_due_date;
            _invoicetype_one.Invoice_no_ref=list[i].Invoice_no_ref;
            _invoicetype_one.Invoice_pay=list[i].Invoice_pay;
            _invoicetype_one.Invoice_provider=list[i].Invoice_provider;
            _invoicetype_one.Invoice_status=list[i].Invoice_status;
            _invoicetype_one.Invoice_sub_total=list[i].Invoice_sub_total;

            _invoicetype_one.Type_name=list[i].invoices[j].Type_name;
            _invoicetype_one.Type_Total=list[i].invoices[j].Type_Total;
            _invoicetype_one.Type_no=list[i].invoices[j].Type_no;
            _invoicetype_one.Type_price=list[i].invoices[j].Type_price;
            _invoicetype_one.Type_qty=list[i].invoices[j].Type_qty;
            _invoicetype_one.Type_unit=list[i].invoices[j].Type_unit;
            listtype.add(_invoicetype_one);

          }
      }
    setState(() {
      duplicateItems = listtype;
    });
    print('length of type=${listtype.length}');
  }
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color pyellow = Red_deep;


  Color paymentcolor = Colors.yellow;


  Widget build(BuildContext context) {

    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;
    var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
      key: _scaffoldKey,
      // drawer: Appdrawer(),
      body:
      Stack(
        children: <Widget>[
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
                color: Red_deep,
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
                color: Red_deep2,
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
                  color: Red_deep2
              ),
            ),
          ),
          //a
          Positioned(
            bottom: -125,
            left: -150,
            child: Container(
              height: 250, //MediaQuery.of(context).size.height / 4,
              width: 250, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color: Red_deep,
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
                  color: Red_deep1),
            ),
          ),
          //menu
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // print( 'inside button');
                //_scaffoldKey.currentState.openDrawer();

                Navigator.pushNamed(context, "/main_page");
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

                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new InvoiceAdd()),
                );
              },
            ),
          ),
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: Text(
              'Invoices',
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),
          //body
          Positioned(
            top: 70,
            left: 5,
            right: 5,

            // left: MediaQuery.of(context).size.width / 2 - 70,
            child:

            Row(
              children: <Widget>[

                Container(
                  height: 40,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 150,
                  child: Material(

                    elevation: 5.0,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                    child: TextField(
                        onChanged: (value) {
                          //print('inside change');
                          if(listval=='Customer') {
                            filterSearchResultsCustomer(value);
                          }
                          else if(listval=='Payment') {
                            // print('inside Payment');
                            filterSearchResultsPayment(value);
                          }
                          else if(listval=='Total') {
                            filterSearchResultsTotal(value);
                          }
                          else if(listval=='Invoice No') {
                            filterSearchResultsInvoiceNo(value);
                          }
                          else if(listval=='Types') {
                            filterSearchResultsTypes(value);
                          }
                          else if(listval=='Notes') {
                            filterSearchResultsNotes(value);
                          }

                          gettypetotalprice();
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            //  suffixIcon:

                            prefixIcon: Icon(Icons.search,
                                color:
                                Red_deep2,
                                size: 30.0),
                            contentPadding:
                            EdgeInsets.only(left: 10.0, top: 10.0),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Quicksand'))),
                  ),
                ),
                Container(
                  height: 40,
                  width:  140,
                  child: Material(

                    elevation: 5.0,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                    child:  Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 8),
                      child:

                      DropDownButtonString(listdisc,'${listdisc[0]}',(String val){
                        //print('val=${val}');

                        listval=val;

                        // _invDet_Discount.text=val;
                        // _invDet_Total_All.text=(double.parse(_invDet_Total_All.text) - double.parse(_invDet_Discount.text.substring(1)) ).toString();
                        // print('_invDet_Total_All.text${_invDet_Total_All.text}');


                      }),

                    ),
                  ),
                ),

              ],
            ),

          ),
          Positioned(
            top: 95,
            right: 0,
            child: Container(

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0
                  ? MediaQuery.of(context).size.height
                  : 775.0,

              child: _BuildList(),


            ),
          ),



          Positioned(
            // top: MediaQuery.of(context).size.height / 6,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width,


              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.deepOrange[50],
                //),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 150,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.red
                      //),
                    ),



                    height: MediaQuery.of(context).size.height / 22,
                    width: MediaQuery.of(context).size.width/3,

                    child: Center(child: Text('${AppLocalizations.of(context).translate('Total')}'+ ': ${(sumprice).toStringAsFixed(2)}')
                    ),
                  ),
                ],
              ),

            ),
          ),

        ],
      ),
    );
  }


  Widget _BuildList() {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    return //paymentslist.length > 0
      //    ?
      RefreshIndicator(
        // key: refreshKey,
          child:  ListView.builder(

              itemCount: listtype.length,
              //  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
//                print(listtype[index].Invoice_no);
//                print(listtype[index].Invoice_notes);
                if  (listtype[index].Invoice_pay.toString()=='Cash')
                {
                  paymentcolor=Colors.blueAccent;
                }
                else if  (listtype[index].Invoice_pay.toString()=='Sheck')
                {
                  paymentcolor=Colors.red;
                }
                else
                {
                  paymentcolor=Colors.yellow;
                }
                return GestureDetector(
                  onTap: ()
                  {
                    print('inside ontap${listtype[index].Invoice_no}');
                    print('inside ontap${listtype[index].Invoice_provider}');
                    Invoices _selected =new Invoices();
                    listtype[index].Invoice_no;

                    for (int i =0; i<list.length;i++)
                    {
                     if(list[i].Invoice_no_ref==listtype[index].Invoice_no_ref)
                       {
                         _selected=list[i];
                         print('cust======');
                         print(_selected.Invoice_provider);
                       }
                    }
//                    print(listtype[index].Invoice_no_ref);
//                    print(listtype[index].Invoice_notes);
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context)=> new Invoice_report_details(_selected)//list[index])
                        // builder: (BuildContext context)=> new Details(list: list,index:i)
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: (
                        Container(

                            height:pheight/4.5,
                            width: pwidth,
                            child:
                            ///start_stack
                            ///
                            Stack(
                              children: [
                                Positioned(
                                  child: Card(
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right:10.0,left:10,top:5),
                                                child: Text('${listtype[index].Type_name}',
                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:10.0,left:10,top:5),
                                                child: Text('${(listtype[index].Type_qty).toStringAsFixed(2)} * ${(listtype[index].Type_price).toStringAsFixed(2)}',
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:10.0,left:10,top:5),
                                                child: Text('${(listtype[index].Type_Total).toStringAsFixed(2)}',
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [


                                                    Padding(
                                                      padding: const EdgeInsets.only(right:10.0,left:10),
                                                      child: Align( alignment: Alignment.topLeft,

                                                          child: Text('Date :${formatDate(listtype[index].Invoice_date,
                                                              [yyyy,'-',M,'-',dd,' '])}',
                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right:10.0,left:10),
                                                      child: Text('SubTotal :${listtype[index].Invoice_sub_total.round()}',
                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
                                                      ,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right:10.0,left:10),
                                                      child: Text('Total :${(listtype[index].Invoice_amt).toStringAsFixed(2)}',
                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.amber)),
                                                    ),

                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [

                                                    Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child:Center(child: Text('Invoice No :${listtype[index].Invoice_no}',
                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),)),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child:Center(child: Text('No ref:${listtype[index].Invoice_no_ref}',
                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),)),
                                                    ),

//                                                    Padding(
//                                                      padding: const EdgeInsets.only(right:10.0,left:10),
//                                                      child: Text('Status : ${listtype[index].Invoice_status}',
//                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
//                                                    ),

                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right:10.0,left:10),
                                            child: Align( alignment: Alignment.topLeft,

                                                child: Text('Notes :${listtype[index].Invoice_notes}',
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color:Colors.grey[200],
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
                                            ),
                                            height:pheight/22,
                                            width: pwidth,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom:5.0,top:5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  IconButton(onPressed: (){
                                                    setState(() {
                                                   //   print(listtype[index].Invoice_doc_id);
                                                      delete_invoice((listtype[index].Invoice_doc_id));
                                                      list.removeAt(index);
                                                     // print('record deleted');
                                                    });

                                                  },
                                                      icon:Icon(Icons.delete, color: Colors.green)),
                                                  IconButton(onPressed: (){
//                                                    print('listtype[index]===');
//                                                    print(listtype[index].Invoice_no);
//                                                    print(listtype[index].Invoice_notes);
//                                                    print(listtype[index].invoices[0].Type_name);
                                                    Navigator.of(context).push(
                                                      new MaterialPageRoute(
                                                          builder: (BuildContext context)=> new InvoiceEdit(list[index])
                                                        // builder: (BuildContext context)=> new Details(list: list,index:i)
                                                      ),
                                                    );
                                                    // Navigator.pushNamed(context, "/Invoice_Report_Type_details");

                                                  },
                                                      icon:Icon(Icons.edit, color: Colors.green)),
                                                  IconButton(onPressed: null,
                                                      icon:Icon(Icons.details, color: Colors.green)),

                                                ],
                                              ),
                                            ),


                                          ),


                                        ],
                                      )

                                  ),
                                ),
                                Positioned(
                                    top: 5,
                                    right: 5,
                                    child:  (listtype[index]?.Invoice_notes?.isNotEmpty?? true) ? Icon(Icons.favorite,color: Red_deep,):SizedBox()



                                ),
                              ],
                            )
                        )),

                  ),
                );


              }

          ),
          onRefresh: refreshList
      );
    // : Center(child: CircularProgressIndicator());
  }
  ///

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      call_get_data_invoice();
    });

    return null;
  }






}


