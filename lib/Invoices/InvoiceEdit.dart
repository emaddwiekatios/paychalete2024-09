import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paychalet/Types/Type_Class.dart';
import 'dart:ui';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:paychalet/colors.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'Invoice.dart';
import 'Invoice_Add_Item.dart';
import 'Invoices_Class.dart';
import 'SelectionProvider.dart';
import  'package:keyboard_actions/keyboard_actions.dart';


class InvoiceEdit extends StatefulWidget {
  Invoices Invoicepass = Invoices();
  InvoiceEdit(this.Invoicepass);
  @override
  _InvoiceEditState createState() => _InvoiceEditState();
}

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color colorOne = Colors.amber;
Color colorTwo = Colors.amber[300];
Color colorThree = Colors.amber[100];

class _InvoiceEditState extends State<InvoiceEdit> {
  List<Invoices> _InvoiceList = List<Invoices>();
  List<Invoice> _InvoicesubList = List<Invoice>();
  List<Invoice> _InvoicesubListFinal = List<Invoice>();
  List<String> _no_row = ['+'];
  String _day = formatDate(DateTime.now(), [dd]);
  double subtotal = 0;
  List<String> list_pays = ['Cash', 'Sheck', 'Visa'];
  TextEditingController _invDet_Invoice_no_ref = TextEditingController();
  TextEditingController contnotes = TextEditingController();
  List<TextEditingController> contqty = [];
  String imagename;
  String _selectedpays = 'Cash';
  double vat_amt = 1;
  TextEditingController contDisc = TextEditingController();
  String _information = 'No Info Yet';
  Types_Class _Invsubone = Types_Class();

  DateTime _date = DateTime.now();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List<Invoices> _InvoiceListtemp;
  QuerySnapshot cars;
  QuerySnapshot carsmaxinvoice_no;
  var Provider_max;
  List<int> list_cat = [];
  int Max_Invoice_no = 0;
  List<double> _QTY = [];
  final _formKey = GlobalKey<FormState>();
  void updateInformation(String information) {
    setState(() => _information = information);
  }

  void updateInformationTypes(Types_Class _Invsubone) {
    if (_Invsubone.TypeName != null) {
      setState(() {
        print('_Invsubone.id${_Invsubone.id}');
        Invoice _Invoiceone = Invoice();
        _Invoiceone.Type_name = _Invsubone.TypeName;
        _Invoiceone.Type_no = _Invsubone.id;
        _Invoiceone.Type_price = _Invsubone.TypePrice;
        _Invoiceone.Type_unit = _Invsubone.TypeUnit;

        _InvoicesubList.add(_Invoiceone);
        //_InvoicesubList.insert(0, _Invoiceone);
        _QTY.add(1);
        contqty.add(TextEditingController());
        GetSubitemSubtotal();
      });
    }
  }

  void moveToSecondPage() async {
    final information = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => SelectionProvider()),
    );
    updateInformation(information);
  }

  void moveToTypes() async {
    final _Invsubone = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => Invoice_Add_Item()),
    );
    updateInformationTypes(_Invsubone);
  }


  Future<void> edit_invoice_to_firebase(List<Invoices> ListInvoice ) async {
    final todayDate = DateTime.now();
    var currentdate = formatDate(todayDate,
        [yyyy,'-',mm,'-',dd,' ',hh,':',nn,':',ss,' ',am]);
    String Doc_id;
    print('length =====${ListInvoice.length}');
    ListInvoice.forEach((element) {

//      FirebaseFirestore.instance
//          .collection('Payments')
//          .doc(selectedDoc)
//          .update(
//          {
//            'Payment_id': contPaymentid.text,
//            'Payment_name': contPaymentname.text,
//            'Payment_desc': contPaymentdesc.text,
//            'Payment_amt': contPaymentamt.text,
//            'Payment_to': _selectedProviders ,//contPaymentTo.text,
//            'Payment_fav': "false",
//            'Payment_cat': _selectedCat,
//            //'Payment_entry_date':todayDate,// currentdate,
//            'Payment_modify_date':todayDate,// currentdate,
//            'Payment_img': url2,
//            'Payment_from':_selectedpays_from,
//            'Payment_user':user.email.toString(),
//            'Payment_currency':_selectedcurrency
//          }
    print('element.Invoice_doc_id');
print(widget.Invoicepass.Invoice_doc_id);
       FirebaseFirestore.instance.collection("Invoices").doc(widget.Invoicepass.Invoice_doc_id).update(
        {
          "Invoice_No": element.Invoice_no,
          "Invoice_no_ref":element.Invoice_no_ref,
          "Invoice_date": _date,
          "Invoice_provider": element.Invoice_provider,
          "Invoice_amt": element.Invoice_amt,
          "Invoice_due_date": element.Invoice_due_date,
          "Invoice_disc": element.Invoice_disc,
          "Invoice_pay": element.Invoice_pay,
          "Invoice_status": element.Invoice_status,
          "Invoice_sub_total":element.Invoice_sub_total,
          "Invoice_notes":element.Invoice_notes
          //"Invoice_Details":   FieldValue.arrayUnion(list),
        },
      );

        setState(() {
          Doc_id=widget.Invoicepass.Invoice_doc_id;

          edit_invoice_to_firebase_det(ListInvoice,Doc_id);

      });
    });

  }




  Future<void> edit_invoice_to_firebase_det(List<Invoices> ListInvoice,
      String Doc_id) async {
    {


      FirebaseFirestore.instance.collection('Invoices').doc(Doc_id).update({'Invoice_Details': FieldValue.delete()}).whenComplete((){
        print('Field Deleted${Doc_id}');
      });


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
           // "Invoice_doc_id":Doc_id,
            "Invoice_Details": FieldValue.arrayUnion(list),
          });
        });
      });
    }
  }



  getDatamaxinvoice_no() async {
    return await await FirebaseFirestore.instance
        .collection('Invoices')
        .orderBy('Invoice_No', descending: true)
        .limit(1)
        .get();
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
          Max_Invoice_no = carsmaxinvoice_no.docs[i].data()['Invoice_No'] + 1;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _information=widget.Invoicepass.Invoice_provider;
      _date=widget.Invoicepass.Invoice_date;
      _invDet_Invoice_no_ref.text=widget.Invoicepass.Invoice_no_ref;
       contnotes.text=widget.Invoicepass.Invoice_notes;
      for (int i=0; i<widget.Invoicepass.invoices.length;i++)
      {
        print('type_name');
        print(widget.Invoicepass.invoices[i].Type_name);

      _InvoicesubList.add(widget.Invoicepass.invoices[i]);

      _QTY.add(widget.Invoicepass.invoices[i].Type_qty);
      contqty.add(TextEditingController());
      contqty[i].text=(widget.Invoicepass.invoices[i].Type_qty).toString();

      }
      Max_Invoice_no=widget.Invoicepass.Invoice_no;
      print('Invoicepass');
      print(widget.Invoicepass.Invoice_doc_id);
    //  call_get_datamaxinvoice_no();
    });
    GetSubitemSubtotal();
  }

  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color pyellow = Color(Colors.amber);
  ////  add  keyboard action

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(
          focusNode: _nodeText3,
          onTapAction: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Custom Action"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                });
          },
        ),
        KeyboardActionsItem(
          focusNode: _nodeText4,
          // displayCloseWidget: false,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText5,
          toolbarButtons: [
            //button 1
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            //button 2
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DONE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeText6,
          footerBuilder: (_) => PreferredSize(
              child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Custom Footer'),
                  )),
              preferredSize: Size.fromHeight(40)),
        ),
      ],
    );
  }

//note  add  code on text field
//  KeyboardActions(
//  config: _buildConfig(context),
  //child:widget
  // add on text field  focusNode: _nodeText1,

  ///// end add  keyboard action

  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    var appLanguage = Provider.of<AppLanguage>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        // drawer: Appdrawer(),
        body: GestureDetector(
          onTap: () {
            print('ontap');
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                    height: pheight

                ),
                //header shape
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(200),
                      //  color: Colors.amber,
                    ),
                    child: CustomPaint(
                      child: Container(
                        height: 400.0,
                      ),
                      painter: _MyPainter(),
                    ),
                  ),
                ),
                /*
                Positioned(
                  top: 125,
                  left: -150,
                  child: Container(
                    height: 450, //MediaQuery.of(context).size.height / 4,
                    width: 450, //MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(250),
                      color: Colors.amber,
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
                        color: Colors.amber),
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
                      color: pcolor1,
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
                        borderRadius: BorderRadius.circular(200), color: pcolor2),
                  ),
                ),
                //menu
                Positioned(
                  top: pheight / 30,
                  left: pwidth / 20,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      print('inside button');
                      // _scaffoldKey.currentState.openDrawer();

                      Navigator.pushReplacementNamed(context, "/main_page");
                    },
                  ),
                ),
                Positioned(
                  top: pheight / 30,
                  right: pwidth / 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      print('inside button');
                      // FirebaseAuth.instance.signOut();
                     // Navigator.pop(context);
                      //  Navigator.popAndPushNamed(context, "/SignIn");

                      Navigator.pushReplacementNamed(context, "/Invoice_report");
                    },
                  ),
                ),
                //body
                Positioned(
                  top: pheight / 13,
                  right: 0,
                  bottom: 20,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: InkWell(
                              onTap: () {
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Material(
                                      borderRadius: BorderRadius.circular(10.0),
                                      elevation: 20,
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 0.0, right: 5.0),
                                          width: MediaQuery.of(context).size.width -
                                              20.0,
                                          height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(10.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        moveToSecondPage();
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          IconButton(
                                                              icon: Icon(
                                                                  Icons.group_add)),
                                                          Text(
                                                            'Provider :${_information}',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Montserrat',
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                fontSize: 20.0),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(Icons.edit),
                                                            onPressed: () async {
                                                              //                                                        Navigator.of(context).push(
                                                              moveToSecondPage();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Invoice Ref No',
                                                          // paymentslist[index]['Payment_name'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Montserrat',
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 20.0),
                                                        ),
                                                        SizedBox(height:5),
                                                        Container(
                                                          color:Colors.black12,
                                                          height: MediaQuery.of(context).size.height / 23,
                                                          width: MediaQuery.of(context).size.width/2.5,

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
                                                                            color:Red_deep,
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
                                                                        color: Color(
                                                                            0xFFFDD34A),

                                                                        fontFamily: 'Quicksand'))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
//                            Row(
//                              children: <Widget>[
////                                Container(
////                                  alignment: Alignment.topLeft,
////                                  height:
////                                      MediaQuery.of(context).size.height / 6.5,
////                                  width:
////                                      MediaQuery.of(context).size.width / 3.5,
////                                  decoration: BoxDecoration(
////                                      borderRadius: BorderRadius.circular(10.0),
////                                      image: DecorationImage(
////                                          fit: BoxFit.cover,
////
////                                          //image: NetworkImage(user_img),
////                                          image: paymentslist[index]
////                                                          ['Payment_img']
////                                                      .toString() !=
////                                                  null
////                                              ? NetworkImage(
////                                                  paymentslist[index]
////                                                      ['Payment_img'])
////                                              : AssetImage('images/chris.jpg')
////
////                                           //image: AssetImage('images/chris.jpg')
////                                          )),
////                                ),
//
//                                //  SizedBox(width: 10.0),
//
//                                //   SizedBox(width: 20),
//                              ],
//                            ),
                                                    //SizedBox(width: .4),
                                                    //name
//                                                Column(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment.start,
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    Text(
//                                                      'Invoice Pay',
//                                                      // paymentslist[index]['Payment_name'],
//                                                      style: TextStyle(
//                                                          fontFamily:
//                                                              'Montserrat',
//                                                          fontWeight:
//                                                              FontWeight.bold,
//                                                          fontSize: 20.0),
//                                                    ),
//
//                                                    //SizedBox(height: 7.0),
//                                                    //
//                                                    DropdownButton<String>(
//                                                        items: list_pays
//                                                            .map((String val) {
//                                                          return new DropdownMenuItem<
//                                                                  String>(
//                                                              value: val,
//                                                              child: new Text(
//                                                                val,
//                                                                style:
//                                                                    TextStyle(
//                                                                  fontFamily:
//                                                                      'Montserrat',
//                                                                  fontWeight:
//                                                                      FontWeight
//                                                                          .bold,
//                                                                  fontSize:
//                                                                      17.0,
//                                                                  color: Color(
//                                                                      0xFFFDD34A),
//                                                                ),
//                                                              ));
//                                                        }).toList(),
//                                                        hint:
//                                                            Text(_selectedpays),
//                                                        onChanged: (newVal) {
//                                                          this.setState(() {
//                                                            _selectedpays =
//                                                                newVal;
//                                                          });
//                                                        }),
//                                                  ],
//                                                ),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Invoice Date',
                                                          // paymentslist[index]['Payment_name'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Montserrat',
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 20.0),
                                                        ),

                                                        //SizedBox(height: 7.0),
                                                        //

//                                                        InkWell(
//                                                          onTap: () {
//                                                            DatePicker.showDatePicker(context,
//                                                                showTitleActions: true,
//                                                                minTime: DateTime(2018,3,5),
//                                                                maxTime: DateTime(2025,6,7),
//                                                                onChanged: (date) {
//                                                                  print('change $date');
//                                                                },
//                                                                onConfirm: (date) {
//                                                                  setState(() {
//                                                                    _date = date;
//                                     _day = formatDate(date,
//                                                                        [ dd]);
////                                                                    _due_date = formatDate(
////                                                                        date.add(new Duration(
////                                                                            days: 30)),
////                                                                        [yyyy,'-',M,'-',dd]);
//                                                                  });
//                                                                  print('confirm $date');
//                                                                },
//                                                                currentTime: DateTime.now(),
//                                                                locale: LocaleType.ar);
//                                                          },
//                                                          child: CircleAvatar(radius: 20,
//                                                            child: Text(_day,
//                                                              style: TextStyle(
//                                                                  color: Colors.black),),
//                                                            backgroundColor: Colors.grey[100],),
//                                                        ),
                                                        SizedBox(
                                                          width: pwidth / 2.5,
                                                          child: RaisedButton(
                                                            elevation: 2,
                                                            onPressed: () {
                                                              DatePicker.showDatePicker(
                                                                  context,
                                                                  showTitleActions:
                                                                  true,
                                                                  minTime: DateTime(
                                                                      2018, 3, 5),
                                                                  maxTime: DateTime(
                                                                      2025, 6, 7),
                                                                  onChanged:
                                                                      (date) {
                                                                    print(
                                                                        'change $date');
                                                                  }, onConfirm: (date) {
                                                                setState(() {
                                                                  _date = date;
                                                                  _day = formatDate(
                                                                      date, [dd]);
//                                                                    _due_date = formatDate(
//                                                                        date.add(new Duration(
//                                                                            days: 30)),
//                                                                        [yyyy,'-',M,'-',dd]);
                                                                });
                                                                print(
                                                                    'confirm $date');
                                                              },
                                                                  currentTime:
                                                                  DateTime
                                                                      .now(),
                                                                  locale: LocaleType
                                                                      .ar);
                                                            },
                                                            color: Colors.white,
                                                            //padding: EdgeInsets.only(left: (5.0), top: 5.0),
                                                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                                            child: Text(
                                                                '${formatDate(_date, [
                                                                  yyyy,
                                                                  '-',
                                                                  M,
                                                                  '-',
                                                                  dd,
                                                                  ' '
                                                                ])}',
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                  'Montserrat',
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 17.0,
                                                                  color: Color(
                                                                      0xFFFDD34A),
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
//                                            Row(
//                                              mainAxisAlignment:
//                                              MainAxisAlignment.end,
//                                              children: <Widget>[
//                                                Column(
//                                                  mainAxisAlignment:
//                                                  MainAxisAlignment.center,
//                                                  children: <Widget>[
//                                                    IconButton(
//                                                        icon: Icon(
//                                                          Icons.delete_sweep,
//                                                          color: Colors.red,
//                                                        ),
//                                                        onPressed: () {
//                                                          setState(
//                                                                () {
////                                                          print(paymentslist[index]
////                                                          ['Payment_doc_id']
////                                                              .toString());
////
////                                                          deleteData(paymentslist[index]
////                                                          ['Payment_doc_id']
////                                                              .toString()
////                                                            //paymentslist[index]['Payment_img']
////                                                          );
////                                                          paymentslist.removeAt(index);
////                                                          gettypetotalprice();
////                                                        });
//                                                            },
//                                                          );
//
//                                                          IconButton(
//                                                            icon: Icon(
//                                                                Icons.history,
//                                                                color:
//                                                                Colors.red),
//                                                            onPressed: () {
////                                                        Navigator.of(context).push(
////                                                          new MaterialPageRoute(
////                                                              builder: (BuildContext context) =>
////                                                              new PaysMainHistoryOne(
////                                                                Payment_id: paymentslist[index]['Payment_id'],
////
////                                                              )),
////                                                        );
////
//
////                                          Navigator.of(context).push(
////                                            new MaterialPageRoute(
////                                                builder: (BuildContext context) =>
////                                                new ProductsEditNew(
////                            Payment_id: paymentslist[index]['Payment_id'],
////                            Payment_name: paymentslist[index]['Payment_name'],
////                            Payment_desc: paymentslist[index]['Payment_desc'],
////                            Payment_img: paymentslist[index]['Payment_img'],
////                            Payment_amt: paymentslist[index]['Payment_amt'],
////                            Payment_to: paymentslist[index]['Payment_to'],
////                            Payment_cat: paymentslist[index]['Payment_cat'],
////                           Payment_entry_date: paymentslist[index]['Payment_entry_date'],
////                           Payment_modify_date: paymentslist[index]['Payment_modify_date'],
////                            Payment_doc_id: paymentslist[index]['Payment_doc_id'].toString(),
////                                                )),);
//
////                                        );
//                                                            },
//                                                          );
//                                                        })
//                                                  ],
//                                                ),
//                                              ],
//                                            ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          )))),
                            ),
                          ),
                          Card(

                            clipBehavior: Clip.antiAlias,
                            elevation: 20.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),

                            child: Container(
                              decoration: BoxDecoration(
                                  color: pcolor1,
                                  borderRadius:
                                  BorderRadius.circular(10.0)),

                              child: TabBar(
                                labelColor: Colors.redAccent,
                                unselectedLabelColor: Colors.white,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Colors.white),

//                              indicatorWeight: 3,
//                              unselectedLabelColor: Colors.grey,
//                              labelColor: Red_deep,
//                              indicatorColor: Colors.black,
                                tabs: [
                                  // Tab(icon: Icon(Icons.content_copy,color:Red_deep),child: Text('Invoice'),),
                                  Tab(child:
                                  Row(
                                      children:
                                      [ SizedBox(width: 10,),
                                        Icon(Icons.content_copy,color:Red_deep),
                                        SizedBox(width: 5,),
                                        Text('Invoice')]),),
                                  Tab(child:
                                  Row(
                                      children:
                                      [
                                        SizedBox(width: 10,),
                                        Icon(Icons.note_add,color:Red_deep),
                                        SizedBox(width: 5,),
                                        Text('Notes')]),),

                                  Tab(child:
                                  Row(
                                      children:
                                      [ SizedBox(width: 10,),
                                        Icon(Icons.access_time,color:Red_deep),
                                        SizedBox(width: 5,),
                                        Text('Others')]),),


//                                Tab(icon: Icon(Icons.note_add,color:Red_deep),child: Text('Note'),),
//                                Tab(icon: Icon(Icons.access_time,color:Red_deep),child: Text('Others'),),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                             flex: 3,
                            child: TabBarView(
                              children: [

                                Card(

                                  clipBehavior: Clip.antiAlias,
                                  elevation: 20.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: InkWell(
                                    onTap: () {
//                            print('${paymentslist[index]['Payment_from']}');
//                            Navigator.of(context).push(
//                              new MaterialPageRoute(
//                                  builder: (BuildContext context) => new PaysDetails(
//                                    Payment_id: paymentslist[index]['Payment_id'],
//                                    Payment_name: paymentslist[index]['Payment_name'],
//                                    Payment_desc: paymentslist[index]['Payment_desc'],
//                                    Payment_img: paymentslist[index]['Payment_img'],
//                                    Payment_amt: paymentslist[index]['Payment_amt'],
//                                    Payment_cat: paymentslist[index]['Payment_cat'],
//                                    // Payment_date: paymentslist[index]['Payment_date'],
//                                    Payment_entry_date: paymentslist[index]['Payment_entry_date'],
//                                    Payment_modify_date: paymentslist[index]['Payment_modify_date'],
//                                    Payment_doc_id: paymentslist[index]['Payment_doc_id'].toString(),
//                                    Payment_currency: paymentslist[index]['Payment_currency'],
//                                    Payment_to: paymentslist[index]['Payment_to'],
//                                    Payment_from: paymentslist[index]['Payment_from'],
//
//
//                                  )),
//                            );
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Material(
                                            color: pcolor6,

                                            //color: Colors.red,
                                            borderRadius: BorderRadius.circular(10.0),
                                            elevation: 20,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child:

                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, right: 0.0),
                                                  width: MediaQuery.of(context).size.width -
                                                      20.0,
                                                  height: MediaQuery.of(context).size.height /5,
                                                  decoration: BoxDecoration(
                                                    //color: Colors.yellow,
                                                       color: pcolor1,
                                                      borderRadius:
                                                      BorderRadius.circular(10.0)),
                                                  child: _BuildList()),
                                            ))),
                                  ),
                                ),

                                Card(

                                  clipBehavior: Clip.antiAlias,
                                  elevation: 20.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: InkWell(
                                    onTap: () {
//                            print('${paymentslist[index]['Payment_from']}');
//                            Navigator.of(context).push(
//                              new MaterialPageRoute(
//                                  builder: (BuildContext context) => new PaysDetails(
//                                    Payment_id: paymentslist[index]['Payment_id'],
//                                    Payment_name: paymentslist[index]['Payment_name'],
//                                    Payment_desc: paymentslist[index]['Payment_desc'],
//                                    Payment_img: paymentslist[index]['Payment_img'],
//                                    Payment_amt: paymentslist[index]['Payment_amt'],
//                                    Payment_cat: paymentslist[index]['Payment_cat'],
//                                    // Payment_date: paymentslist[index]['Payment_date'],
//                                    Payment_entry_date: paymentslist[index]['Payment_entry_date'],
//                                    Payment_modify_date: paymentslist[index]['Payment_modify_date'],
//                                    Payment_doc_id: paymentslist[index]['Payment_doc_id'].toString(),
//                                    Payment_currency: paymentslist[index]['Payment_currency'],
//                                    Payment_to: paymentslist[index]['Payment_to'],
//                                    Payment_from: paymentslist[index]['Payment_from'],
//
//
//                                  )),
//                            );
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Material(
                                            color: pcolor6,

                                            //color: Colors.red,
                                            borderRadius: BorderRadius.circular(10.0),
                                            elevation: 20,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, right: 0.0),
                                                  width: MediaQuery.of(context).size.width -
                                                      20.0,
                                                  height: MediaQuery.of(context).size.height /5,
                                                  decoration: BoxDecoration(
                                                    //color: Colors.amber,
                                                      color: pcolor1,
                                                      borderRadius:
                                                      BorderRadius.circular(10.0)),
                                                  child: _BuildListnote()),
                                            ))),
                                  ),
                                ),
                                Icon(Icons.directions_bike),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:0.0,right:0),
                            child: Card(
                              color: pcolor6,
                              clipBehavior: Clip.antiAlias,
                              elevation: 20.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: InkWell(
                                onTap: () {
//                            print('${paymentslist[index]['Payment_from']}');
//                            Navigator.of(context).push(
//                              new MaterialPageRoute(
//                                  builder: (BuildContext context) => new PaysDetails(
//                                    Payment_id: paymentslist[index]['Payment_id'],
//                                    Payment_name: paymentslist[index]['Payment_name'],
//                                    Payment_desc: paymentslist[index]['Payment_desc'],
//                                    Payment_img: paymentslist[index]['Payment_img'],
//                                    Payment_amt: paymentslist[index]['Payment_amt'],
//                                    Payment_cat: paymentslist[index]['Payment_cat'],
//                                    // Payment_date: paymentslist[index]['Payment_date'],
//                                    Payment_entry_date: paymentslist[index]['Payment_entry_date'],
//                                    Payment_modify_date: paymentslist[index]['Payment_modify_date'],
//                                    Payment_doc_id: paymentslist[index]['Payment_doc_id'].toString(),
//                                    Payment_currency: paymentslist[index]['Payment_currency'],
//                                    Payment_to: paymentslist[index]['Payment_to'],
//                                    Payment_from: paymentslist[index]['Payment_from'],
//
//
//                                  )),
//                            );
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Material(
                                        borderRadius: BorderRadius.circular(10.0),
                                        elevation: 20,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 0.0, right: 0.0),
                                            width: MediaQuery.of(context).size.width -
                                                10.0,
                                            height:
                                            MediaQuery.of(context).size.height /
                                               7,
                                            decoration: BoxDecoration(
                                                color: pcolor1,
                                                borderRadius:
                                                BorderRadius.circular(10.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10,top:5),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'SubTotal :',
                                                        style: TextStyle(
                                                            fontFamily: 'Montserrat',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                      Text(
                                                        '${subtotal.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            fontFamily: 'Montserrat',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                      Text(
                                                        'Total:',
                                                        style: TextStyle(
                                                            fontFamily: 'Montserrat',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),

                                                      Text(
                                                        '${(subtotal * vat_amt).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            fontFamily: 'Montserrat',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.0),
                                                      )
                                                    ],
                                                  ),
//                                            Row(
//                                              mainAxisAlignment:
//                                                  MainAxisAlignment
//                                                      .spaceBetween,
//                                              children: [
//                                                Text(
//                                                  'Vat 16%:',
//                                                  style: TextStyle(
//                                                      fontFamily: 'Montserrat',
//                                                      fontWeight:
//                                                          FontWeight.bold,
//                                                      fontSize: 15.0),
//                                                ),
//                                                RaisedButton(
//                                                  child: Text('No  Vat'),
//                                                  onPressed: () {
//                                                    setState(() {
//                                                      vat_amt = 0;
//                                                    });
//                                                  },
//                                                ),
//                                                Text(
//                                                  '${subtotal * .16}',
//                                                  style: TextStyle(
//                                                      fontFamily: 'Montserrat',
//                                                      fontWeight:
//                                                          FontWeight.bold,
//                                                      fontSize: 15.0),
//                                                )
//                                              ],
//                                            ),
//                                            Row(
//                                              mainAxisAlignment:
//                                                  MainAxisAlignment
//                                                      .spaceBetween,
//                                              children: [
//                                                Text(
//                                                  'Discount :',
//                                                  style: TextStyle(
//                                                      fontFamily: 'Montserrat',
//                                                      fontWeight:
//                                                          FontWeight.bold,
//                                                      fontSize: 15.0),
//                                                ),
//
//                                                Container(
//                                                  height: pheight / 30,
//                                                  width: pwidth / 3,
//                                                  child: TextField(
//                                                      // controller: contDisc,
//                                                      textAlign:
//                                                          TextAlign.center,
//                                                      keyboardType:
//                                                          TextInputType.number,
//                                                      // controller: _invDet_Discount,
//                                                      onChanged: (value) {}),
//                                                ),
//
//                                                // filterSearchResults_new2(value);
//                                              ],
//                                            ),
//                                                  Row(
//                                                    mainAxisAlignment:
//                                                    MainAxisAlignment
//                                                        .spaceBetween,
//                                                    children: [
//                                                      Text(
//                                                        'Total:',
//                                                        style: TextStyle(
//                                                            fontFamily: 'Montserrat',
//                                                            fontWeight:
//                                                            FontWeight.bold,
//                                                            fontSize: 15.0),
//                                                      ),
//                                                      RaisedButton(
//                                                        child: Text('No  Vat'),
//                                                        onPressed: () {
//                                                          setState(() {
//                                                            vat_amt = 1;
//                                                          });
//                                                        },
//                                                      ),
//                                                      Text(
//                                                        '${(subtotal * vat_amt).toStringAsFixed(2)}',
//                                                        style: TextStyle(
//                                                            fontFamily: 'Montserrat',
//                                                            fontWeight:
//                                                            FontWeight.bold,
//                                                            fontSize: 15.0),
//                                                      )
//                                                    ],
//                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.all(2.0),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(0.0),
                                                                                                             child: RaisedButton(
                                                            child: Text(
                                                              'Save Edit',
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                            color: Red_deep,
                                                            onPressed: () {
                                                              print(contnotes.text);
                                                              _InvoicesubListFinal
                                                                  .clear();
                                                              _InvoiceList.clear();
                                                              for (int i = 0;
                                                              i <
                                                                  _InvoicesubList
                                                                      .length;
                                                              i++) {Invoice _Invsubone =
                                                                Invoice();
                                                                _Invsubone.Type_no =
                                                                    _InvoicesubList[i]
                                                                        .Type_no;
                                                                _Invsubone.Type_name =
                                                                    _InvoicesubList[i]
                                                                        .Type_name;
                                                                _Invsubone.Type_price =
                                                                    _InvoicesubList[i]
                                                                        .Type_price; //double.parse(_invDet_Price0.text);
                                                                _Invsubone.Type_unit =
                                                                    _InvoicesubList[i]
                                                                        .Type_unit;
                                                                _Invsubone.Type_Total =_QTY[i] * _InvoicesubList[i].Type_price;
                                                                _Invsubone.Type_qty =double.parse(_QTY[i].toString());
                                                                //  _InvoicesubList[i]
                                                                //    .Type_qty;
                                                                _InvoicesubListFinal
                                                                    .add(_Invsubone);
                                                              }

//
                                                              Invoices _inv =
                                                              new Invoices()
                                                                ..Invoice_no =
                                                                Max_Invoice_no !=
                                                                    null
                                                                    ? Max_Invoice_no
                                                                    : 0
                                                                ..Invoice_date =
                                                                    _date
                                                                ..Invoice_status =
                                                                _selectedpays ==
                                                                    'Cash'
                                                                    ? 'Close'
                                                                    : 'Open'
                                                                ..Invoice_pay =
                                                                    _selectedpays
                                                                ..Invoice_disc = contDisc
                                                                    .text
                                                                    .length ==
                                                                    0
                                                                    ? 0
                                                                    : int.parse(
                                                                    contDisc
                                                                        .text)
                                                                ..Invoice_provider =
                                                                    _information
                                                                ..Invoice_due_date =
                                                                DateTime.now()
                                                                ..Invoice_amt = double.parse((subtotal *
                                                                    (vat_amt > 0
                                                                        ? vat_amt
                                                                        : 1)).toStringAsFixed(2))//-double.parse(_invDet_Discount.text!=null ?   _invDet_Discount.text:0.0)
                                                                ..Invoice_sub_total =
                                                                    subtotal
                                                                ..Invoice_notes=contnotes.text
                                                                ..Invoice_no_ref=_invDet_Invoice_no_ref.text
                                                                ..invoices = _InvoicesubListFinal
                                                                as List<Invoice>;
                                                              _InvoiceList.add(_inv);

                                                              edit_invoice_to_firebase(
                                                                  _InvoiceList);
                                                              setState(() {
                                                               // Max_Invoice_no=Max_Invoice_no+1;
                                                              });

                                                              Navigator.pushReplacementNamed(context, "/Invoice_report");
                                                            }

                                                            ),




                                                        ),
                                                      ),
                                                      RaisedButton(
                                                        child: Text('Vat'),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (vat_amt==1.16)
                                                              vat_amt=1;
                                                            else
                                                              vat_amt = 1.16;

                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )))),
                              ),
                            ),
                          ),
//                          Card(
//                            clipBehavior: Clip.antiAlias,
//                            elevation: 0.0,
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(10.0)),
//                            child: InkWell(
//                              onTap: () {
////                            print('${paymentslist[index]['Payment_from']}');
////                            Navigator.of(context).push(
////                              new MaterialPageRoute(
////                                  builder: (BuildContext context) => new PaysDetails(
////                                    Payment_id: paymentslist[index]['Payment_id'],
////                                    Payment_name: paymentslist[index]['Payment_name'],
////                                    Payment_desc: paymentslist[index]['Payment_desc'],
////                                    Payment_img: paymentslist[index]['Payment_img'],
////                                    Payment_amt: paymentslist[index]['Payment_amt'],
////                                    Payment_cat: paymentslist[index]['Payment_cat'],
////                                    // Payment_date: paymentslist[index]['Payment_date'],
////                                    Payment_entry_date: paymentslist[index]['Payment_entry_date'],
////                                    Payment_modify_date: paymentslist[index]['Payment_modify_date'],
////                                    Payment_doc_id: paymentslist[index]['Payment_doc_id'].toString(),
////                                    Payment_currency: paymentslist[index]['Payment_currency'],
////                                    Payment_to: paymentslist[index]['Payment_to'],
////                                    Payment_from: paymentslist[index]['Payment_from'],
////
////
////                                  )),
////                            );
//                              },
//                              child: Padding(
//                                  padding: EdgeInsets.all(2.0),
//                                  child: Material(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                      elevation: 20,
//                                      child: Container(
//                                          padding: EdgeInsets.only(
//                                              left: 10.0, right: 5.0),
//                                          width: MediaQuery.of(context).size.width -
//                                              20.0,
//                                          height:
//                                          MediaQuery.of(context).size.height /
//                                              7,
//                                          decoration: BoxDecoration(
//                                              color: Colors.white,
//                                              borderRadius:
//                                              BorderRadius.circular(10.0)),
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(
//                                                left: 20.0, right: 20),
//                                            child: Column(
//                                              mainAxisAlignment:
//                                              MainAxisAlignment.start,
//                                              children: [
//                                                Row(
//                                                  mainAxisAlignment:
//                                                  MainAxisAlignment
//                                                      .spaceBetween,
//                                                  children: [
//                                                    Text(
//                                                      'SubTotal :',
//                                                      style: TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight:
//                                                          FontWeight.bold,
//                                                          fontSize: 15.0),
//                                                    ),
//                                                    Text(
//                                                      '${subtotal}',
//                                                      style: TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight:
//                                                          FontWeight.bold,
//                                                          fontSize: 15.0),
//                                                    )
//                                                  ],
//                                                ),
////                                            Row(
////                                              mainAxisAlignment:
////                                                  MainAxisAlignment
////                                                      .spaceBetween,
////                                              children: [
////                                                Text(
////                                                  'Vat 16%:',
////                                                  style: TextStyle(
////                                                      fontFamily: 'Montserrat',
////                                                      fontWeight:
////                                                          FontWeight.bold,
////                                                      fontSize: 15.0),
////                                                ),
////                                                RaisedButton(
////                                                  child: Text('No  Vat'),
////                                                  onPressed: () {
////                                                    setState(() {
////                                                      vat_amt = 0;
////                                                    });
////                                                  },
////                                                ),
////                                                Text(
////                                                  '${subtotal * .16}',
////                                                  style: TextStyle(
////                                                      fontFamily: 'Montserrat',
////                                                      fontWeight:
////                                                          FontWeight.bold,
////                                                      fontSize: 15.0),
////                                                )
////                                              ],
////                                            ),
////                                            Row(
////                                              mainAxisAlignment:
////                                                  MainAxisAlignment
////                                                      .spaceBetween,
////                                              children: [
////                                                Text(
////                                                  'Discount :',
////                                                  style: TextStyle(
////                                                      fontFamily: 'Montserrat',
////                                                      fontWeight:
////                                                          FontWeight.bold,
////                                                      fontSize: 15.0),
////                                                ),
////
////                                                Container(
////                                                  height: pheight / 30,
////                                                  width: pwidth / 3,
////                                                  child: TextField(
////                                                      // controller: contDisc,
////                                                      textAlign:
////                                                          TextAlign.center,
////                                                      keyboardType:
////                                                          TextInputType.number,
////                                                      // controller: _invDet_Discount,
////                                                      onChanged: (value) {}),
////                                                ),
////
////                                                // filterSearchResults_new2(value);
////                                              ],
////                                            ),
//                                                Row(
//                                                  mainAxisAlignment:
//                                                  MainAxisAlignment
//                                                      .spaceBetween,
//                                                  children: [
//                                                    Text(
//                                                      'Total:',
//                                                      style: TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight:
//                                                          FontWeight.bold,
//                                                          fontSize: 15.0),
//                                                    ),
//                                                    RaisedButton(
//                                                      child: Text('No  Vat'),
//                                                      onPressed: () {
//                                                        setState(() {
//                                                          vat_amt = 1;
//                                                        });
//                                                      },
//                                                    ),
//                                                    Text(
//                                                      '${(subtotal * vat_amt).toStringAsFixed(2)}',
//                                                      style: TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight:
//                                                          FontWeight.bold,
//                                                          fontSize: 15.0),
//                                                    )
//                                                  ],
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                  const EdgeInsets.all(2.0),
//                                                  child: Padding(
//                                                    padding:
//                                                    const EdgeInsets.all(0.0),
//                                                    child: RaisedButton(
//                                                        child: Text(
//                                                          'Save Edit',
//                                                          style: TextStyle(
//                                                              color: Colors.white),
//                                                        ),
//                                                        color: Red_deep,
//                                                        onPressed: () {
//                                                          print(contnotes.text);
//                                                          _InvoicesubListFinal
//                                                              .clear();
//                                                          _InvoiceList.clear();
//                                                          for (int i = 0;
//                                                          i <
//                                                              _InvoicesubList
//                                                                  .length;
//                                                          i++) {Invoice _Invsubone =
//                                                            Invoice();
//                                                            _Invsubone.Type_no =
//                                                                _InvoicesubList[i]
//                                                                    .Type_no;
//                                                            _Invsubone.Type_name =
//                                                                _InvoicesubList[i]
//                                                                    .Type_name;
//                                                            _Invsubone.Type_price =
//                                                                _InvoicesubList[i]
//                                                                    .Type_price; //double.parse(_invDet_Price0.text);
//                                                            _Invsubone.Type_unit =
//                                                                _InvoicesubList[i]
//                                                                    .Type_unit;
//                                                            _Invsubone.Type_Total =_QTY[i] * _InvoicesubList[i].Type_price;
//                                                            _Invsubone.Type_qty =double.parse(_QTY[i].toString());
//                                                            //  _InvoicesubList[i]
//                                                            //    .Type_qty;
//                                                            _InvoicesubListFinal
//                                                                .add(_Invsubone);
//                                                          }
//
////
//                                                          Invoices _inv =
//                                                          new Invoices()
//                                                            ..Invoice_no =
//                                                            Max_Invoice_no !=
//                                                                null
//                                                                ? Max_Invoice_no
//                                                                : 0
//                                                            ..Invoice_date =
//                                                                _date
//                                                            ..Invoice_status =
//                                                            _selectedpays ==
//                                                                'Cash'
//                                                                ? 'Close'
//                                                                : 'Open'
//                                                            ..Invoice_pay =
//                                                                _selectedpays
//                                                            ..Invoice_disc = contDisc
//                                                                .text
//                                                                .length ==
//                                                                0
//                                                                ? 0
//                                                                : int.parse(
//                                                                contDisc
//                                                                    .text)
//                                                            ..Invoice_provider =
//                                                                _information
//                                                            ..Invoice_due_date =
//                                                            DateTime.now()
//                                                            ..Invoice_amt = double.parse((subtotal *
//                                                                (vat_amt > 0
//                                                                    ? vat_amt
//                                                                    : 1)).toStringAsFixed(2))//-double.parse(_invDet_Discount.text!=null ?   _invDet_Discount.text:0.0)
//                                                            ..Invoice_sub_total =
//                                                                subtotal
//                                                            ..Invoice_notes=contnotes.text
//                                                            ..Invoice_no_ref=_invDet_Invoice_no_ref.text
//                                                            ..invoices = _InvoicesubListFinal
//                                                            as List<Invoice>;
//                                                          _InvoiceList.add(_inv);
//
//                                                          edit_invoice_to_firebase(
//                                                              _InvoiceList);
//                                                          setState(() {
//                                                           // Max_Invoice_no=Max_Invoice_no+1;
//                                                          });
//                                                        }),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
//                                          )))),
//                            ),
//                          ),
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
                //header title
                Positioned(
                  top: MediaQuery.of(context).size.height / 28,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: Text(
                    '${AppLocalizations.of(context).translate('Invoices')} : $Max_Invoice_no',
                    style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),



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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:5.0,right:5),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0,right:8),
                    child: Container(
                      height: pheight / 18,
                      width: pwidth,
                      decoration: BoxDecoration(
                        //  color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Invoice Item',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                            Text(
                              'No of Item ${_InvoicesubList.length}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                moveToTypes();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
               // color:Colors.red,
                height: pheight / 3,
                width: pwidth,
                child: ListView.builder(
                    itemCount: _InvoicesubList.length,
                    //  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
//                    Navigator.of(context).push(
//                      new MaterialPageRoute(
//                          builder: (BuildContext context)=> new Invoice_report_details(list[index])
//                        // builder: (BuildContext context)=> new Details(list: list,index:i)
//                      ),
//                    );
                        },
                        child: (Container(
                            height: pheight / 6.5,
                            width: pwidth,
                            child:   KeyboardActions(
  config: _buildConfig(context),
                              child: Card(
                                  elevation: 20,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0, left: 10, top: 5),
                                            child: Text(
                                                _InvoicesubList[index]
                                                    .Type_name,
                                                // child: Text('Customer :${list[index].Invoice_provider}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0, left: 10, top: 5),
                                            child: Text(
                                                'Total :${(_QTY[index] * _InvoicesubList[index].Type_price).toStringAsFixed(2)}',
                                                // child: Text('Customer :${list[index].Invoice_provider}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0, left: 10, top: 15),
                                            child: Text(
                                                '${_QTY[index]} X ${_InvoicesubList[index].Type_price}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ),
                                          Row(
                                            //  mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
//                                              Padding(
//                                                padding: const EdgeInsets.only(
//                                                    right: 0.0,
//                                                    left: 0,
//                                                    top: 0),
//                                                child: Text('QTY:',
//                                                    style: TextStyle(
//                                                        fontSize: 15,
//                                                        fontWeight:
//                                                            FontWeight.bold)),
//                                              ),

//                                              SizedBox(
//                                                height:30,
//                                                width:30,
//                                                child: IconButton(
//                                                  iconSize: 20,
//                                                  icon: Icon(
//                                                    Icons.fast_rewind,
//                                                    color: Colors.red,
//                                                  ),
//                                                  onPressed: () {
//                                                    if (_QTY[index] >= 10) {
//                                                      setState(() {
//                                                        _QTY[index] =
//                                                            _QTY[index] - 10;
//                                                        GetSubitemSubtotal();
//                                                      });
//                                                    }
//                                                  },
//                                                ),
//                                              ),
                                              SizedBox(
                                                height:30,
                                                width:30,
                                                child: IconButton(
                                                  color: Colors.lightBlue,
                                                  iconSize: 20,
                                                  icon: Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    if (_QTY[index] > 0 ) {
                                                      setState(() {
                                                        _QTY[index] = (_QTY[index] )- 1;
                                                        contqty[index].text=(_QTY[index]).toString();

                                                        GetSubitemSubtotal();
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
//                                              Padding(
//                                                padding: const EdgeInsets.all(10.0),
//                                                child: Text('${_QTY[index]}',
//                                                    style: TextStyle(
//                                                        fontSize: 15,
//                                                        fontWeight:
//                                                        FontWeight.bold)),
//
//
//                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: MediaQuery.of(context).size.height / 30,
                                                  width: MediaQuery.of(context).size.width/5,

                                                  child: Material(
                                                    elevation: 5.0,
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    child: TextFormField(
                                                      focusNode: _nodeText1,

                                                        keyboardType: TextInputType.numberWithOptions(),
                                                        controller: contqty[index],//==null ? _QTY[index].toString(): "1" as TextEditingController,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            print('kkjkk');
                                                            print(value);
                                                            var temp=double.parse(value);
                                                            _QTY[index]= temp;
                                                            GetSubitemSubtotal();

                                                          });

                                                        },
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
//                                                          suffixIcon: IconButton(
//                                                              icon: Icon(Icons.cancel,
//                                                                  color:Red_deep3,
//                                                                  // Color(getColorHexFromStr('#FEE16D')),
//                                                                  size: 20.0),
//                                                              onPressed: () {
//                                                                print('inside clear');
//                                                                contqty[index].clear();
//                                                                contqty[index].text = null;
//                                                              }),
                                                            contentPadding:
                                                            EdgeInsets.all(12),
                                                            hintText:
                                                            AppLocalizations.of(context).translate('Qty'),

                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,
                                                                fontFamily: 'Quicksand'))),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:30,
                                                width:30,
                                                child: IconButton(
                                                  iconSize: 20,
                                                  icon: Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    if (_QTY[index] >=0 ) {
                                                      setState(() {
                                                        print('contqty[index].text');
                                                        print(contqty[index].text);
                                                        if (contqty[index].text.length==0)
                                                        {
                                                          print('inside if null');
                                                          contqty[index].text=(_QTY[index]).toString();

                                                        }
                                                        else {

                                                          _QTY[index] =
                                                              _QTY[index] + 1;
                                                          contqty[index].text =
                                                              (_QTY[index])
                                                                  .toString();

                                                        }

                                                        GetSubitemSubtotal();
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
//                                              SizedBox(
//                                                height:30,
//                                                width:30,
//                                                child: IconButton(
//                                                  color: Colors.yellow,
//
//                                                  iconSize: 20,
//                                                  icon: Icon(
//                                                    Icons.fast_forward,
//                                                    color: Colors.red,
//                                                  ),
//                                                  onPressed: () {
//                                                    if (_QTY[index] >= 0) {
//                                                      setState(() {
//                                                        _QTY[index] =
//                                                            _QTY[index] + 10;
//                                                        GetSubitemSubtotal();
//                                                      });
//                                                    }
//                                                  },
//                                                ),
//                                              ),


                                            ],
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0,
                                                  left: 10,
                                                  top: 0),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _InvoicesubList.removeAt(
                                                        index);
                                                    _QTY.removeAt(index);
                                                    GetSubitemSubtotal();
                                                  });
                                                },
                                              )),
                                        ],
                                      ),
                                    ],
                                  )),
                            ))),
                      );
                    }),
              ),
            ],
          ),
          onRefresh: refreshList);
    // : Center(child: CircularProgressIndicator());
  }
  Widget _BuildListnote() {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

    return  Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              //color: Colors.yellow,
              height: pheight / 4,
              width: pwidth,
              child:   Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width/3,
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(5.0),
                      child:

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('${AppLocalizations.of(context).translate('Notes')} :'),
                      ),
                    ),
                  ),
                  SizedBox(height:5),
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width-15,

                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(5.0),
                      child: TextFormField(


                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: contnotes,
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
                                    contnotes.clear();
                                    contnotes.text = null;
                                  }),
                              contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0,right:15),
                              hintText:
                              AppLocalizations.of(context).translate('Payment Id'),

                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Quicksand'))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
    );
  }

  ///

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      //  call_get_data_invoice();
    });

    return null;
  }

  void GetSubitemSubtotal() {
    subtotal = 0;
    for (int i = 0; i < _InvoicesubList.length; i++) {
      setState(() {
        subtotal = subtotal + _InvoicesubList[i].Type_price * _QTY[i];
      });
    }
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = pcolor3;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width / 2, size.height / 1, size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
