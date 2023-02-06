import 'package:flutter/material.dart';
import 'DropDownButton.dart';
import 'InvoiceAdd.dart';
import 'InvoiceEdit.dart';
import 'Invoice_report_details.dart';
import 'Invoices_Class.dart';
import 'package:paychalet/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
//import 'package:paychalet/Pages/colors.dart';
//import 'package:paychalet/DataBaseFile/database_helpers.dart';
//import 'package:paychalet/ConstractorObjects/DropDownButton.dart';
//import 'package:paychalet/Invoices/Invoice_report_details.dart';
class Invoice_report extends StatefulWidget {
  @override
  _Invoice_reportState createState() => _Invoice_reportState();
}


var refreshKey = GlobalKey<RefreshIndicatorState>();

List<Invoices> list = List<Invoices>();
List<Invoices> listtemp;
List<Invoices> duplicateItems = List<Invoices>();
List<Invoices> duplicateItems2 = List<Invoices>();


class _Invoice_reportState extends State<Invoice_report> {

  var listdisc = <String>[
    'Customer',
    'Invoice No',
    'Types',
    'Payment',
    'Total',
    'Notes'

  ];
  String listval;


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
    List<Invoices> dummySearchList = List<Invoices>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices> dummyListData = List<Invoices>();
      dummySearchList.forEach((item) {

        if (item.Invoice_provider.toUpperCase().contains(query.toUpperCase())) {

          dummyListData.add(item);

        }

      });
      setState(() {
        list = dummyListData;
      });
      return;
    }
    else {
      setState(() {
        list=duplicateItems;
        print('list=${list}');
      });
    }
  }

  void filterSearchResultsPayment(String query) {
    List<Invoices> dummySearchList = List<Invoices>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if payment');
      List<Invoices> dummyListData = List<Invoices>();
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
        list = dummyListData;
      });
      return;
    }
    else {
      setState(() {
        list=duplicateItems;
        print('list=${list}');
      });
    }
  }

  void filterSearchResultsTotal(String query) {
    List<Invoices> dummySearchList = List<Invoices>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices> dummyListData = List<Invoices>();
      dummySearchList.forEach((item) {

          if (item.Invoice_amt>=double.parse(query)) {
            dummyListData.add(item);

        }

      });
      setState(() {
        list = dummyListData;
      });
      return;
    }
    else {
      setState(() {
        list=duplicateItems;
      });
    }
  }


  void filterSearchResultsNotes(String query) {
    List<Invoices> dummySearchList = List<Invoices>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices> dummyListData = List<Invoices>();
      dummySearchList.forEach((item) {
        if ((item?.Invoice_notes?.isNotEmpty?? true)) {
          //  if (item.Invoice_no_ref.toUpperCase().contains(query.toUpperCase())) {
          if (item.Invoice_notes.toUpperCase().contains(query.toUpperCase())) {
            print('inside if if ');
            dummyListData.add(item);
            print(item.Invoice_notes);
            print(dummyListData);
            setState(() {
              list = dummyListData;
              print('list=${list}');
            });
          }
        }
      });
      print('after loop;');
      setState(() {
        list = dummyListData;
        print('list=${list}');
      });
     // return;
    }
    else {
      setState(() {
        list=duplicateItems;
        print('list=${list}');
      });
    }
    print('list finall=${list}');

  }

    void filterSearchResultsInvoiceNo(String query) {
    List<Invoices> dummySearchList = List<Invoices>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices> dummyListData = List<Invoices>();
      dummySearchList.forEach((item) {

        if (item.Invoice_no_ref.toUpperCase().contains(query.toUpperCase())) {

          dummyListData.add(item);

        }

      });
      setState(() {
        list = dummyListData;
        print('list=${list}');
      });
      return;
    }
    else {
      setState(() {
        list=duplicateItems;
        print('list=${list}');
      });
    }
  }

  void filterSearchResultsTypes(String query) {
    List<Invoices> dummySearchList = List<Invoices>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Invoices> dummyListData = List<Invoices>();
      dummySearchList.forEach((item) {
        item.invoices.forEach((element) {
        if (element.Type_name.toUpperCase().contains(query.toUpperCase())) {

          dummyListData.add(item);

        }
         });
      });
      setState(() {
        list = dummyListData;
      });
      return;
    }
    else {
      setState(() {
        list=duplicateItems;
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

   // List<Invoices> _InvoiceList = [];
    snapshot.docs.forEach((document) {
       setState(() {
         print(document.data());
         Invoices _invoice = Invoices.fromJson(document.data());
        // print('the list =${document.data()}');

         list.add(_invoice);
       });
       });





    setState(() {
      print('sort list');
      list.sort((b, a) =>
          a.Invoice_no.compareTo(b.Invoice_no));

      duplicateItems = list;
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    call_get_data_invoice();
    listval='Customer';
  }
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color pyellow = Red_deep;


  Color paymentcolor = Colors.yellow;


  Widget build(BuildContext context) {

    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

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
                          print('val=${val}');

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

              itemCount: list.length,
            //  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
//                print(list[index].Invoice_no);
//                print(list[index].Invoice_notes);
                if  (list[index].Invoice_pay.toString()=='Cash')
                {
                  paymentcolor=Colors.blueAccent;
                }
                else if  (list[index].Invoice_pay.toString()=='Sheck')
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
//                    print(list[index].Invoice_no_ref);
//                    print(list[index].Invoice_notes);
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context)=> new Invoice_report_details(list[index])
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

                            height:pheight/4,
                            width: pwidth,
                            child:
                            ///start_stack
                            ///
                            Stack(
                              children: [ 
                            Positioned(
                              child: Card(
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right:10.0,left:10,top:5),
                                            child: Text('${list[index].Invoice_provider}',
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

                                                          child: Text('Date :${formatDate(list[index].Invoice_date,
                                                              [yyyy,'-',M,'-',dd,' '])}',
                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right:10.0,left:10),
                                                      child: Text('SubTotal :${list[index].Invoice_sub_total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
                ,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right:10.0,left:10),
                                                      child: Text('Total :${(list[index].Invoice_amt).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.amber)),
                                                    ),

                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [

                                                  Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child:Center(child: Text('Invoice No :${list[index].Invoice_no}',
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child:Center(child: Text('No  ref:${list[index].Invoice_no_ref}',
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                                                  ),


                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right:10.0,left:10),
                                            child: Align( alignment: Alignment.topLeft,

                                                child: Text('Notes :${list[index].Invoice_notes}',
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color:Colors.grey[200],
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
                                            ),
                                            height:pheight/20,
                                            width: pwidth,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom:5.0,top:5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  IconButton(onPressed: (){
                                                    setState(() {
                                                      print(list[index].Invoice_doc_id);
                                                      delete_invoice((list[index].Invoice_doc_id));
                                                      list.removeAt(index);
                                                      print('record deleted');
                                                    });

                                                  },
                                                      icon:Icon(Icons.delete, color: Colors.green)),
                                                  IconButton(onPressed: (){
//                                                    print('list[index]===');
//                                                    print(list[index].Invoice_no);
//                                                    print(list[index].Invoice_notes);
//                                                    print(list[index].invoices[0].Type_name);
                                                    Navigator.of(context).push(
                                                      new MaterialPageRoute(
                                                          builder: (BuildContext context)=> new InvoiceEdit(list[index])
                                                        // builder: (BuildContext context)=> new Details(list: list,index:i)
                                                      ),
                                                    );
                                                    // Navigator.pushNamed(context, "/Invoice_report_details");

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
                                  top: 10,
                                  right: 10,
                                  child:  (list[index]?.Invoice_notes?.isNotEmpty?? true) ? Icon(Icons.favorite,color: Red_deep,):SizedBox()



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


