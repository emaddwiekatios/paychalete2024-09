import 'package:flutter/material.dart';
import 'package:paychalet/Types/TypeList.dart';
import 'package:paychalet/colors.dart';
import 'package:date_format/date_format.dart';
import './Type_Class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import  'package:keyboard_actions/keyboard_actions.dart';

class Types extends StatefulWidget {
  @override
  _TypesState createState() => _TypesState();
}

class _TypesState extends State<Types> {

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

  // add on text field  focusNode: _nodeText1,

  ///// end add  keyboard action

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    call_get_datatype();
    getCurrentUser();
    _typeentrydateeditcont.text = formatDate(DateTime.now(),
        [yyyy,'-',M,'-',dd,' ',hh,':',nn,':',ss,' ',am]);
  }

  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _typenameeditcont = TextEditingController();
  TextEditingController _typeentrydateeditcont = TextEditingController();
  TextEditingController _typedesceditcont = TextEditingController();
  TextEditingController _typeuniteeditcont = TextEditingController();
  TextEditingController _typepriceeditcont = TextEditingController();
  List<Types_Class> type;


  List<Types_Class> typelist= [];

  var Type_id_max;

  QuerySnapshot cars;

  User user;
  Widget build(BuildContext context) {
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
                color: Red_deep,
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
                color: Red_deep,),
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
                color: Red_deep,),
            ),
          ),
          //menu
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                print('inside button');
                //_scaffoldKey.currentState.openDrawer();
                Navigator.pop(context);
                //  Navigator.pushNamed(context, "/TypeList");
//                Navigator.of(context).pushReplacement(
//                  new MaterialPageRoute(
//                      builder: (BuildContext context) => new TypeList()),
//                );

              },
            ),
          ),
          //menu
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                print('inside button');
                //_scaffoldKey.currentState.openDrawer();

                Navigator.pushNamed(context,"/TypeList");
              },
            ),
          ),
          //body

          Positioned(
            top: 50,
            left: MediaQuery
                .of(context)
                .size
                .width / 2 - 70,
            child: Text(
              'Add Types',
              style: TextStyle(fontSize: 29,fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 100,
            right: 10,
            left: 10,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 1.4,
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
                    padding: const EdgeInsets.all(30.0),
                    child:   KeyboardActions(
                      config: _buildConfig(context),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 100,
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                              child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _typenameeditcont,
                                  onChanged: (value) {
                                    //   this.phoneNo = value;

                                    // filterSearchResults_new2(value);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) =>
                                                    _typenameeditcont.clear());
                                          });
                                        },
                                      ),
                                      prefixIcon: Icon(Icons.category,
                                          color:
                                          Red_deep,
                                          size: 30.0),
                                      contentPadding:
                                      EdgeInsets.only(left: 15.0,top: 15.0),
                                      hintText: 'Type Name',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Quicksand'))),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 100,
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                              child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _typedesceditcont,
                                  onChanged: (value) {
                                    //   this.phoneNo = value;

                                    // filterSearchResults_new2(value);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) =>
                                                    _typedesceditcont.clear());
                                          });
                                        },
                                      ),
                                      prefixIcon: Icon(Icons.description,
                                          color:
                                          Red_deep,
                                          size: 30.0),
                                      contentPadding:
                                      EdgeInsets.only(left: 15.0,top: 15.0),
                                      hintText: 'Type Desc',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Quicksand'))),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 100,
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                              child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _typeentrydateeditcont,
                                  onChanged: (value) {
                                    //   this.phoneNo = value;

                                    // filterSearchResults_new2(value);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          print("Canceled");
                                          setState(() {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) =>
                                                    _typeentrydateeditcont
                                                        .clear());
                                          });
                                        },
                                      ),
                                      prefixIcon: Icon(Icons.description,
                                          color:
                                          Red_deep,
                                          size: 30.0),
                                      contentPadding:
                                      EdgeInsets.only(left: 15.0,top: 15.0),
                                      hintText: 'Type Date',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Quicksand'))),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 100,
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                              child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  focusNode: _nodeText1,
                                  controller: _typepriceeditcont,
                                  onChanged: (value) {
                                    //   this.phoneNo = value;

                                    // filterSearchResults_new2(value);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          print("Canceled");
                                          setState(() {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) =>
                                                    _typepriceeditcont.clear());
                                          });
                                        },
                                      ),
                                      prefixIcon: Icon(Icons.description,
                                          color:
                                          Red_deep,
                                          size: 30.0),
                                      contentPadding:
                                      EdgeInsets.only(left: 15.0,top: 15.0),
                                      hintText: 'Price',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Quicksand'))),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            height: 40,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 100,
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                              child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _typeuniteeditcont,
                                  onChanged: (value) {
                                    //   this.phoneNo = value;

                                    // filterSearchResults_new2(value);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          print("Canceled");
                                          setState(() {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) =>
                                                    _typeuniteeditcont.clear());
                                          });
                                        },
                                      ),
                                      prefixIcon: Icon(Icons.description,
                                          color:
                                          Red_deep,
                                          size: 30.0),
                                      contentPadding:
                                      EdgeInsets.only(left: 15.0,top: 15.0),
                                      hintText: 'unit',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Quicksand'))),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Colors.black,
                                  child: Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Types_Class _type = new Types_Class()
                                    ..id=Type_id_max
                                      ..TypeName = capitalize(
                                          _typenameeditcont.text.toString())
                                      ..Typedesc = capitalize(
                                          _typedesceditcont.text.toString())
                                      ..TypeUnit = _typeuniteeditcont.text
                                      ..TypePrice = double.parse(_typepriceeditcont.text)

                                      ..TypeEntryDate = DateTime.now();

//                                    formatDate(
//                                        DateTime.now(),[
//                                      yyyy,
//                                      '-',
//                                      M,
//                                      '-',
//                                      dd,
//                                      ' ',
//                                      hh,
//                                      ':',
//                                      nn,
//                                      ':',
//                                      ss,
//                                      ' ',
//                                      am
//                                    ]);

                                    _savedb(_type);
                                    setState(() {
                                      call_get_datatype();
                                      _typenameeditcont.clear();
                                      _typedesceditcont.clear();
                                      _typepriceeditcont.clear();
                                      _typeuniteeditcont.clear();
/*
                                      _typenameeditcont.text = null;
                                      _typedesceditcont.text = null;
                                      _typeuniteeditcont.text = null;
                                      _typepriceeditcont.text = null;
                                      */
                                      _typeentrydateeditcont.text = formatDate(
                                          DateTime.now(),[
                                        yyyy,
                                        '-',
                                        M,
                                        '-',
                                        dd,
                                        ' ',
                                        hh,
                                        ':',
                                        nn,
                                        ':',
                                        ss,
                                        ' ',
                                        am
                                      ]);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Colors.black,
                                  child: Text(
                                    'Canceled',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    //_readdball();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

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

//upper first char
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  ///define methood
  getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser;

    //final uid = user.uid;
    //return user.email;
  }

  getDatatypes() async {
    return await FirebaseFirestore.instance.collection('Types')
        .get();

  }
  call_get_datatype()
  {
    getDatatypes().then((results) {
      setState(() {
        cars = results;

        printlist();
      });
    });
  }
  printlist() {
    if (cars != null) {
      if(typelist.length>0)
      {
      typelist.clear();
      }
      for (var i = 0; i < cars.docs.length; i++) {
        Types_Class _typeone = new Types_Class()
        ..id=cars.docs[i].data()['Type_id']
        ..TypeName=cars.docs[i].data()['Type_name']
        ..Typedesc=cars.docs[i].data()['Type_desc']
        ..TypeEntryDate=cars.docs[i].data()['Type_entry_date'].toDate()
        ..TypePrice=cars.docs[i].data()['Typeprice']
        ..TypeUnit=cars.docs[i].data()['Type_unit'];


       typelist.add(_typeone);

      }

      typelist.sort(
              (a, b) => a.id.compareTo(b.id));
      var array_len = typelist.length;
      setState(() {
        Type_id_max = (typelist[array_len - 1].id + 1);
        typelist.sort((b, a) =>
            a.id.compareTo(b.id));
  print('Type_id_max$Type_id_max');
        //duplicateItems = paymentslist;
      });


    } else {
      print("error");
    }

    //gettypetotalprice();
  }



  _savedb(Types_Class type) async {
    final todayDate = DateTime.now();
    var currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);


    getCurrentUser();

    print('user=$user');
    FirebaseFirestore.instance.collection("Types").doc().set({
      'Type_id': type.id,
      'Type_name': type.TypeName,
      'Type_desc': type.Typedesc,
      'Type_entry_date': type.TypeEntryDate,
      'Type_modify_date': DateTime.now(),
      'Type_unit': type.TypeUnit ,//contPaymentTo.text,
      'Typeprice': type.TypePrice,
      'Type_user':user.email.toString()
    });


    FirebaseFirestore.instance.collection("TypesHistory").doc().set({
      'Type_id': type.id,
      'Type_name': type.TypeName,
      'Type_desc': type.Typedesc,
      'Type_entry_date': type.TypeEntryDate,
      'Type_modify_date': DateTime.now(),
      'Type_unit': type.TypeUnit ,//contPaymentTo.text,
      'Typeprice': type.TypePrice,
      'Type_user':user.email.toString()
    });

    _showSnackbar(type.TypeName);



  }


  void _showSnackbar(String name) {
//    final scaff = Scaffold.of(context);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Tranaction ${name} Saved'),
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Done', onPressed: _scaffoldKey.currentState.hideCurrentSnackBar,
      ),
    ));
  }
  ///read all types
  _readdball() async {
//    DatabaseHelper helper = DatabaseHelper.instance;
//
//    int rowId = 1;
//    //Word word = await helper.queryWord(rowId); //call for one recorsd
//    type = await helper.typelist();
//    for (int c = 0; c < type.length; c++)
//      print(
//          'the element id =${type[c].id} the name id =${type[c].TypeName} the desc id =${type[c].Typedesc} the date id =${type[c].TypeEntryDate}'); // call for one recorsd
//  }
  }
}