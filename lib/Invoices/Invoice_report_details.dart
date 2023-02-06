

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/colors.dart';
import 'package:date_format/date_format.dart';

import '../AppLocalizations.dart';
import 'Invoices_Class.dart';

class Invoice_report_details extends StatefulWidget {
  Invoices _invoice;
  Invoice_report_details(this._invoice);
  @override
  _Invoice_report_detailsState createState() => _Invoice_report_detailsState();
}

class _Invoice_report_detailsState extends State<Invoice_report_details> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sort = false;
    selectedUsers = [];
    //users = User.getUsers();
   // _readdball();
  }

  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color pyellow = Color(getColorHexFromStr('#4CA6A6'));

  //List<Invoices> users = List<Invoices>();
  List<Invoices> selectedUsers;
  //List<Invoices> listtemp;
  bool sort;

  onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        widget._invoice.invoices.sort((a, b) => a.Type_name.compareTo(b.Type_name));
      } else {
        widget._invoice.invoices.sort((a, b) => b.Type_name.compareTo(a.Type_name));
      }
    }
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:  Padding(
        padding: const EdgeInsets.only(right:0.0),
        child: Padding(
          padding: const EdgeInsets.only(right:0.0),
          child: Padding(
            padding: const EdgeInsets.only(right:5.0),
            child: DataTable(
                  sortAscending: sort,
                  sortColumnIndex: 0,
                  columns: [
                    DataColumn(

                        label:  Text("Product"),
                        numeric: false,
                        tooltip: "Prod",
                        onSort: (columnIndex, ascending) {
                            setState(() {
                          sort = !sort;
                        });
                        onSort(columnIndex, ascending);
                        }
                        ),

                    DataColumn(
                      label: Text("Qty"),
                      numeric: false,
                      tooltip: "Qty",
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSort(columnIndex, ascending);

                        }
                    ),
                    DataColumn(
                      label: Text("Price"),
                      numeric: false,
                      tooltip: "Price",
                    ),

                    DataColumn(
                      label: Text("Total"),
                      numeric: false,
                      tooltip: "Total",
                    ),
                  ],
                  rows: widget._invoice.invoices
                      .map((user) => DataRow(
//
                      cells: [
                        DataCell(
                        Text(user.Type_name),
                          onTap: () {
                            print('Selected ${user.Type_name}');
                          },
                        ),

                        DataCell(
                       Text(user.Type_qty.toString()),
                        ),
                        DataCell(
                          Text(user.Type_price.toString()),
                        ),
                        DataCell(
                          Text(user.Type_Total.toString()),
                        )
                      ],
//                    selected: selectedUsers.contains(user),
//                      onSelectChanged: (b) {
//                        print("Onselect");
//                      //  onSelectedRow(b, user);
//                      },

                  ))
                      .toList(),
                ),
          ),
        ),
      ),

    );
  }


  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      key: _scaffoldKey,
      // drawer: Appdrawer(),
      body: Stack(
        children: <Widget>[
          //header shape

          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 10,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(200),
                color: Red_deep,
              ),
            ),
          ),
          /*  Positioned(
            top: 125,
            left: -150,
            child: Container(
              height: 450, //MediaQuery.of(context).size.height / 4,
              width: 450, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color: Color(getColorHexFromStr(pyellow2)),
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
                  color: Color(
                    getColorHexFromStr(pyellow3),
                  )),
            ),
          ),
          */
          //a
          Positioned(
            bottom: -125,
            left: -150,
            child: Container(
              height: 250, //MediaQuery.of(context).size.height / 4,
              width: 250, //MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color: Red_deep1,
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
                  color: Red_deep3,),
            ),
          ),
          //menu
          Positioned(
            top: MediaQuery.of(context).size.height / 22,
            left: MediaQuery.of(context).size.width / 3.5,//- ('Payments').length,
            right:MediaQuery.of(context).size.width /  3.5,//- ('Payments').length,
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('Invoices'),
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          //menu
          Positioned(
            top: pheight / 30,
            left: pwidth / 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
                //print(('Payments').length);
                //print(('PaymentsHistory').length);
                //print(MediaQuery.of(context).size.width);
               // print('inside menu');
                //_scrffordkey.currentState.openDrawer();
                //   FirebaseAuth.instance.signOut();
                // Navigator.pushReplacementNamed(context, "/RegistrationWelcome");
              },
            ),
          ),
//          Positioned(
//            top: pheight / 30,
//            right: pwidth / 20,
//            child: IconButton(
//              icon: Icon(Icons.add, size: 30),
//              onPressed: () {
//
//                // _scaffoldKey.currentState.openDrawer();
//
////                Navigator.of(context).push(
////                  new MaterialPageRoute(
////                      builder: (BuildContext context) =>
////                      new ProductAddSt(Docs_max:Payment_max ,)),
////                );
//              },
//            ),
//          ),
          //body
          Positioned(
            top: 100,
            right: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
                /* decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.red,
                          Colors.orange

                          //Color(getColorHexFromStr('#FDD100')),
                           //Color(getColorHexFromStr('#FDD120'))
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
*/
                child: Column(
                  children: <Widget>[
                    Container(
                        // color: Colors.red,
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Invoice ',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  Text('#00${widget._invoice.Invoice_no} ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Orginal ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),

                                ],
                              ),
                              Column(
                                children: <Widget>[
                                       Text('${widget._invoice.Invoice_provider.toUpperCase()} ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text('${formatDate(widget._invoice.Invoice_date,
                                      [yyyy,'-',M,'-',dd,' '])} ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        )),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width - 10,
                      color: Colors.grey,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right:0.0),
                        child: dataBody()
                    ),
                    Padding(
                      padding: const EdgeInsets.all( 10),
                      child: Padding(
                        padding: const EdgeInsets.only(right:12.0,left:12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('SubTotal : ',style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                            Text('${(widget._invoice.Invoice_sub_total)} Nis',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                  padding: const EdgeInsets.all( 10),
                  child: Padding(
                    padding: const EdgeInsets.only(right:12.0,left:12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Tax : ',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                        Text('${(widget._invoice.Invoice_sub_total==widget._invoice.Invoice_amt? 0:
                            widget._invoice.Invoice_sub_total*.16).round().toString()} Nis',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                     // emad dwthgfgy
                     widget._invoice.Invoice_disc>0 ?
                    Padding(
                      padding: const EdgeInsets.all( 10),
                      child: Padding(
                        padding: const EdgeInsets.only(right:12.0,left:12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Discount : ',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                             Text('${widget._invoice.Invoice_disc} Nis',
                                 style: TextStyle(
                                 fontSize: 15,
                                 fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ): SizedBox(),
                    Padding(

                      padding: const EdgeInsets.all( 10),

                      child: Container(
                        color: Colors.greenAccent,
                        child: Padding(

                          padding: const EdgeInsets.only(right:12.0,left:12),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Total : ',style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                              Text('${(widget._invoice.Invoice_amt)} Nis',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    (widget._invoice?.Invoice_notes?.isNotEmpty?? true ) ? Padding(

                      padding: const EdgeInsets.all( 10),

                      child: Container(
                        color: Colors.amber,
                        child: Padding(

                          padding: const EdgeInsets.only(right:12.0,left:12),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('',style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                              Text('${(widget._invoice.Invoice_notes)} ',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Red_deep,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ):SizedBox(),

                  ],
                )
/*
FutureBuilder<List<UserModel>>(
future: db.getUserModelData(),
builder: (context, snapshot) {
if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
*/

                ),
          ),
        ],
      ),
    );
  }
}



class User {
  String firstName;
  String lastName;

  User({this.firstName, this.lastName});

  static List<User> getUsers() {
    return <User>[
      User(firstName: "Java", lastName: "James Gosling"),
      User(firstName: "Android", lastName: "-"),
      User(firstName: "Flutter", lastName: "-"),
      User(firstName: "PHP", lastName: "Rasmus Lerdorf"),
      User(firstName: "C", lastName: "Dennis Ritchie"),
      User(firstName: "C++", lastName: "Bjarne Stroustrup")
    ];
  }
}

