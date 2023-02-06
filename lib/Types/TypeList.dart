import 'package:flutter/material.dart';
import 'package:paychalet/Payments/ProductsMain.dart';
import 'package:paychalet/colors.dart';

import './Type_Class.dart';
import 'package:paychalet/colors.dart';
import 'package:paychalet/Types/TypeEdit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';



class TypeList extends StatefulWidget {
  @override
  _TypeListState createState() => _TypeListState();
}

List<Types_Class> list = List<Types_Class>();
List<Types_Class> listtemp;
List<Types_Class> duplicateItems = List<Types_Class>();
List<Types_Class> duplicateItems2 = List<Types_Class>();


QuerySnapshot cars;
//List<Types_Class> typelist= [];

class _TypeListState extends State<TypeList> {



  void filterSearchResults(String query) {
    List<Types_Class> dummySearchList = List<Types_Class>();
    dummySearchList=duplicateItems;
    if (query.isNotEmpty) {
      print('inside if');
      List<Types_Class> dummyListData = List<Types_Class>();
      dummySearchList.forEach((item) {
        if (item.TypeName.toUpperCase().contains(query.toUpperCase())) {
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
      if(list.length>0)
      {
        list.clear();
      }
      for (var i = 0; i < cars.docs.length; i++) {
      var tempprice =cars.docs[i].data()['Typeprice'];
        Types_Class _typeone = new Types_Class()
          ..id=cars.docs[i].data()['Type_id']
          ..TypeName=cars.docs[i].data()['Type_name']
          ..Typedesc=cars.docs[i].data()['Type_desc']
          ..TypeEntryDate=cars.docs[i].data()['Type_entry_date'].toDate()
          ..TypePrice=double.parse(tempprice.toString())
          ..TypeUnit=cars.docs[i].data()['Type_unit']
          ..Type_doc=cars.docs[i].id;

setState(() {
  list.add(_typeone);
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

//      });
print(list);
setState(() {
  duplicateItems = list;
});
    } else {
      print("error");
    }

    //gettypetotalprice();
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    call_get_datatype();
   // _readdball();
  }

  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color pyellow = Color(getColorHexFromStr('#4CA6A6'));




  Widget build(BuildContext context) {
    var pheight = MediaQuery.of(context).size.height;
    var pwidth = MediaQuery.of(context).size.width;

/*
    FloatingActionButton(
      mini: true,
      onPressed: () {
        setState(() {
          // _canShowfloating = !_canShowfloating;
        });
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor:
      Color(getColorHexFromStr('#FDD100')),
      child: Icon(
        Icons.details,
        size: 26.0,
        color: Colors.white,
      ),
      heroTag: null,
    );
    */
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
                color:Red_deep,
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
                color:Red_deep,
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
               // _scaffoldKey.currentState.openDrawer();
                //Navigator.pushNamed(context, "/MainPage");
                // Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new PaysMain()),
                );
              },
            ),
          ),
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: Text(
              'List Types',
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),
          //body
          Positioned(
            top: 100,
            left: 15,
            right: 15,

            // left: MediaQuery.of(context).size.width / 2 - 70,
            child:

            SingleChildScrollView(
              child: Container(
                height: 50,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 30,
                child: Material(

                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(5.0),
                  child: TextField(
                      onChanged: (value) {
                        print('inside change');
                        filterSearchResults(value);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search,
                              color:
                             Red_deep,
                              size: 30.0),
                          contentPadding:
                          EdgeInsets.only(left: 15.0, top: 15.0),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Quicksand'))),
                ),
              ),
            ),

          ),
          Positioned(
            top: 135,
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
            child: list.length > 0 ? ItemList(

               )
                : new Center(
              child: new CircularProgressIndicator(),
               ),
              /*  child: new FutureBuilder<List>(
                  future: helperglobel.typelist(),
                  builder: (context, snapshot) {
                   // print('the snapshot.hasData =${snapshot.data}');
                    return snapshot.hasData
                        ? new ItemList(
                      list: snapshot.data,
                    )
                        : new Center(
                      child: new CircularProgressIndicator(),
                    );
                  },
                )
                */
/*
FutureBuilder<List<UserModel>>(
future: db.getUserModelData(),
builder: (context, snapshot) {
if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
*/


            ),
          ),

          Positioned(
            top: pheight / 30,
            right: pwidth / 20,
            child: IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () {

                // _scaffoldKey.currentState.openDrawer();

                Navigator.pushNamed(context, "/Types");
              },
            ),
          ),




        ],
      ),
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            // Add your onPressed code here!
//            Navigator.pushNamed(context, "/Types");
//          },
//          child: Icon(Icons.add,color: Colors.white,),
//          backgroundColor: Colors.green,
//        ),

    );



  }

}



class ItemList extends StatefulWidget {


 // final List<Types_Class> list;
  //ItemList({this.list});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
   //Comparator<Types_Class> seqComparator = (b,a) => a.id.compareTo(b.id);
  //  list.sort(seqComparator);

    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context,i) {
        //   locationController.text=list[i]['address_name'];
        // destinationController.text=list[i]['address_name_to'];

        final item = list[i].id;
        return Dismissible(
          key: Key(item.toString()),

          onDismissed: (DismissDirection direction) =>
          {
            if (direction == DismissDirection.endToStart){
              setState(() {
                //   helperglobel.deleteAllWords();
                print(' From:${ list[i].id}');
                deletetype(list[i].Type_doc.toString());
                list.removeAt(i);
                Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text("Item dismissed"),),
                );
              }),
            },
            if (direction == DismissDirection.startToEnd){

              //helperglobel. deleteWordWithId(list[i].id),
              list.removeAt(i),
              Scaffold.of(context).showSnackBar(
                new SnackBar(content: new Text("Item no action"),),
              ),
            },
          },
          secondaryBackground:
          new Container(
              height: 50,
              width: 50,
              color: Colors.blue,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  <Widget>[
                    // Text("delete"),
                    IconButton(icon: Icon(Icons.delete),onPressed: null)
                  ])
          ),
          background: new Container(color: Colors.red,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  <Widget>[
                    // Text("delete"),
                    IconButton(icon: Icon(Icons.delete),onPressed: null)
                  ])
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: new GestureDetector(
                child: new GestureDetector(
                  //  onTap:()=> print('id=${widget.list[i].id}'),
                  onTap: () =>
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new TypeEdit(list[i])
                          // builder: (BuildContext context)=> new Details(list: list,index:i)
                        ),
                      ),

                  //  child : new Card(
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                      color: Colors.white,

                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(1.0,5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 6,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 30,

                    // child: Card(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,top: 0),
                          child: Row(
                              children:
                              <Widget>[
                                Icon(Icons.date_range,color: Red_deep,),

                                //  Text('Seq : ${list[i]['seq']}'),
                                Text('${ list[i].TypeName}',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(width: 20,),

                              ]),
                        ),

                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,top: 5),
                          child: Row(
                              children:
                              <Widget>[
                                Icon(Icons.format_indent_decrease,
                                  color: Red_deep,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Price :${ list[i].TypePrice}'),
                                ),
                                SizedBox(width: 10,),

                                Icon(Icons.date_range,color: Red_deep,),
                                Text('Desc :${ list[i].Typedesc}'),



                              ]),

                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 20,top: 5),
                          child: Row(
                            children: [
                              Icon(Icons.date_range,color: Red_deep,),
                              Text('${formatDate(list[i].TypeEntryDate,
                                  [yyyy,'-',M,'-',dd,' '])


                              }',
                                  style: TextStyle(fontSize: 17)),
                            ],
                          ),
                        ),

                      ],
                    ),
                    // )


                  ),

                  /*
                  new Card(
                    child: new ListTile(
                      leading: Icon(Icons.widgets),
                      title: Text(list[i]['speed']),
                      subtitle: Text(list[i]['seq']),

                      trailing: Text(list[i]['id']),
                    ),
                  ),
                  */
                ),
              ),
            ),
          ),
        );
      },
    );
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