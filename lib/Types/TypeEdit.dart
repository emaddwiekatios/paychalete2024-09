import 'package:flutter/material.dart';
import 'package:paychalet/Types/TypeList.dart';
import 'package:paychalet/colors.dart';
import 'package:date_format/date_format.dart';
import './Type_Class.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

class TypeEdit extends StatefulWidget {
  Types_Class type;

  @override
  TypeEdit(this.type);
  _TypeEditState createState() => _TypeEditState();
}

class _TypeEditState extends State<TypeEdit> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.type.TypePrice);
    _typenameeditcont.text = widget.type.TypeName;

    _typedesceditcont.text = widget.type.Typedesc;

    _typeentrydateeditcont.text = widget.type.TypeEntryDate.toString();
    _typeuniteeditcont.text = widget.type.TypeUnit;

    _typepriceeditcont.text = widget.type.TypePrice.toString();
  }

  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _typenameeditcont = TextEditingController();
  TextEditingController _typeentrydateeditcont = TextEditingController();
  TextEditingController _typedesceditcont = TextEditingController();
  TextEditingController _typeuniteeditcont = TextEditingController();
  TextEditingController _typepriceeditcont = TextEditingController();
  // DatabaseHelper helperglobel = DatabaseHelper.instance;

  List<Types_Class> type;

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
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
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
                color: Red_deep,
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
                color: Red_deep,
              ),
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

                Navigator.pushNamed(context, "/TypeList");
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

                Navigator.pushNamed(context, "/TypeList");
              },
            ),
          ),
          //body

          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: Text(
              'Edit Types',
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 100,
            right: 10,
            left: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.3,
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
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 100,
                          child: Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: TextField(
                                keyboardType: TextInputType.number,
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
                                        print("Canceled name");
                                        setState(() {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) =>
                                                  _typenameeditcont.clear());
                                        });
                                      },
                                    ),
                                    prefixIcon: Icon(Icons.category,
                                        color: Red_deep, size: 30.0),
                                    contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
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
                          width: MediaQuery.of(context).size.width - 100,
                          child: Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: TextField(
                                keyboardType: TextInputType.number,
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
                                        print("Canceled desc ");
                                        //  _typedesceditcont.clear();
                                        setState(() {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) =>
                                                  _typedesceditcont.clear());
                                        });
                                      },
                                    ),
                                    prefixIcon: Icon(Icons.description,
                                        color: Red_deep, size: 30.0),
                                    contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
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
                          width: MediaQuery.of(context).size.width - 100,
                          child: Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: TextField(
                                keyboardType: TextInputType.number,
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

                                        // _typeentrydateeditcont.clear();
                                      },
                                    ),
                                    prefixIcon: Icon(Icons.description,
                                        color: Red_deep, size: 30.0),
                                    contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
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
                          width: MediaQuery.of(context).size.width - 100,
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
                                              .addPostFrameCallback((_) =>
                                                  _typeuniteeditcont.clear());
                                        });
                                      },
                                    ),
                                    prefixIcon: Icon(Icons.description,
                                        color: Red_deep, size: 30.0),
                                    contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
                                    hintText: 'unit',
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
                          width: MediaQuery.of(context).size.width - 100,
                          child: Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                              .addPostFrameCallback((_) =>
                                                  _typepriceeditcont.clear());
                                        });
                                      },
                                    ),
                                    prefixIcon: Icon(Icons.description,
                                        color: Red_deep, size: 30.0),
                                    contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
                                    hintText: 'Price',
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
                              padding: const EdgeInsets.all(2.0),
                              child: RaisedButton(
                                color: Colors.black,
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  widget.type.TypeName = capitalize(
                                      _typenameeditcont.text.toString());
                                  widget.type.Typedesc = capitalize(
                                      _typedesceditcont.text.toString());
                                  widget.type.TypeUnit = capitalize(
                                      _typeuniteeditcont.text.toString());
                                  widget.type.TypePrice =
                                      double.parse(_typepriceeditcont.text);
                                  widget.type.TypeEntryDate = DateTime.now();

                                  updateType(widget.type, widget.type.Type_doc);

                                  setState(() {
                                    _typenameeditcont.clear();
                                    _typedesceditcont.clear();

                                    _typenameeditcont.text = null;
                                    _typedesceditcont.text = null;
                                    _typeentrydateeditcont.text = formatDate(
                                        DateTime.now(), [
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
                                  //   Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new TypeList()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: RaisedButton(
                                color: Colors.black,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  deletetype(widget.type.Type_doc.toString());
                                  //  helperglobel.deleteWordWithobjects(widget.type);;

                                  // Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new TypeList()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: RaisedButton(
                                color: Colors.black,
                                child: Text(
                                  'Canceled',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  // helperglobel.deleteWordWithobjects(widget.type);
                                  // widget.type.removeAt(i);
                                  Navigator.pop(context);
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
  _savedb(Types_Class type) async {
    //DatabaseHelper helper = DatabaseHelper.instance;
    //int id = await helper.insert(type);
    //print('inserted row: $id');
  }

  ///define methood
  updateType(Types_Class type, String selectedDoc) async {
    final todayDate = DateTime.now();
    var currentdate = formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);

    FirebaseFirestore.instance.collection('Types').doc(selectedDoc).update({
      'Type_id': type.id,
      'Type_name': type.TypeName,
      'Type_desc': type.Typedesc,
      // 'Type_entry_date': type.TypeEntryDate,
      'Type_modify_date': DateTime.now(),
      'Type_unit': type.TypeUnit, //contPaymentTo.text,
      'Typeprice': type.TypePrice,
    }).catchError((e) {
      print(e);
    });
  }

  ///read all types
  _readdball() async {
//    DatabaseHelper helper = DatabaseHelper.instance;
//
//    int rowId = 1;
//    //Word word = await helper.queryWord(rowId); //call for one recorsd
//    type = await helper.typelist();
//    for (int c = 0; c < type.length; c++)
//      print('the element id =${type[c].id} the name id =${type[c].TypeName} the desc id =${type[c].Typedesc } the date id =${type[c].TypeEntryDate }'); // call for one recorsd
  }

  deletetype(String docId) async {
    FirebaseFirestore.instance
        .collection('Types')
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });

//    Navigator.of(context).pushReplacement(
//      new MaterialPageRoute(
//          builder: (BuildContext context) => new SocialHome()),
//    );
  }
}
