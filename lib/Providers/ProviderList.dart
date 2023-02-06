import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ProviderDetails.dart';
//import './ProviderListdetails.dart';
//import 'productdetails.dart';
//import 'package:cloudfirestore/cloudfirestore.dart';

class ProviderList extends StatefulWidget {
  @override
  ProviderListState createState() => ProviderListState();
}
QuerySnapshot cars;
class ProviderListState extends State<ProviderList> {
  void initState() {
      print("inside init");
    getData().then((results) {
      setState(() {

        cars = results;

        printlist();
      });
    });
    setState(() {
      //  printlist();
    });

    //   print("after init");

    super.initState();
  }
  var Provider_max;

  var providerslist
  =[
    {
      "Provider_id":"Weman Dress",
      "Provider_name":"Weman Dress",
      "Provider_desc":"Weman Dress",
      "Provider_remark":"Weman Dress",
      "Provider_date":"Weman Dress",

      "Provider_img":'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',

    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: providerslist.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3
        ),
        itemBuilder: (BuildContext context,int index){
          print('pass remark=');
          print(providerslist[index]['Provider_remark']);
          return  Container( //Image.network(productslist[index]['picture'], fit: BoxFit.cover, ),
            child:catprod(
              Provider_id: providerslist[index]['Provider_id'],
              Provider_name: providerslist[index]['Provider_name'],
              //prodpicture: Image.network(productslist[index]['picture'], fit: BoxFit.cover, ),

              Provider_img: providerslist[index]['Provider_img'],
              Provider_desc: providerslist[index]['Provider_desc'],
              Provider_remark :providerslist[index]['Provider_remark'],
              Provider_date: providerslist[index]['Provider_date'],
              Provider_doc_id: providerslist[index]['Provider_doc_id'],

            ),
          );
        }

    );
  }

  ///
  getData() async {
    return await FirebaseFirestore.instance.collection('Providers').get();
  }


  printlist(){
    print('inside printlist');
    if (cars != null) {

      for(var i =0 ;i<cars.docs.length;i++)
      {
  print(cars.docs[i].data()['Provider_remark']);

        providerslist.add(
            {
              "Provider_id":cars.docs[i].data()['Provider_id'],
              "Provider_name":cars.docs[i].data()['Provider_name'],
              "Provider_desc":cars.docs[i].data()['Provider_desc'],
              "Provider_remark":cars.docs[i].data()['Provider_remark'],
              "Provider_date":cars.docs[i].data()['Provider_date'].toString(),

              "Provider_img":cars.docs[i].data()['Provider_img'],
              "Provider_doc_id"  : cars.docs[i].id.toString(),


            }

        );


      }
      providerslist.removeAt(0);

print(providerslist);
    }

    else
    {
      print("error");
    }


  }


///


}


class catprod extends StatelessWidget {
  final Provider_id;
  final Provider_name;
  final Provider_img;
  final Provider_desc;
  final Provider_remark;
  final Provider_date;
  final Provider_doc_id;
  catprod({
    this.Provider_id,
    this.Provider_name,
    this.Provider_img,
    this.Provider_desc,
    this.Provider_remark,
    this.Provider_date,
    this.Provider_doc_id
  });
  @override
  Widget build(BuildContext context) {
    print(Provider_remark);
    return Card(
      clipBehavior: Clip.antiAlias,
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),


      child: Hero(
        tag:new Text("Hero1") //productname
        ,child: Material(
        child: InkWell(onTap: (){
          print('Provider_remark=');
          print(Provider_name);
//          Navigator.of(context).push(
//            new MaterialPageRoute(
//                builder:  (BuildContext context) => new providersdetails(
//
//                  Provider_id:Provider_id,
//                  Provider_name: Provider_name,
//                  Provider_desc:Provider_desc ,
//                  Provider_img:Provider_img ,
//                  Provider_remark:Provider_remark ,
//                  Provider_date: Provider_date,
//                  Provider_doc_id: Provider_doc_id,
//
//
//                )
//            ),
//          );
        },

          child:     GridTile(
               header: Center(child: Text('${Provider_desc.toString()}',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),

            footer: Container(
                color: Colors.white70,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:20.0),
                        child: Center(child: new Text(Provider_name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),)),
                      ),
                   ),
//                       Padding(
//                         padding: const EdgeInsets.only(right:20.0,left:20),
//                         child: Text("\$${Provider_remark.toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
//                       )
//                       ,
                    // Text("\$${prodoldprice}",
                    // style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,
                    // decoration: TextDecoration.lineThrough
                    // )
                    // ,)
                  ],
                )

              /*  ListTile(
                     leading: Text(productname , style: TextStyle(fontWeight: FontWeight.bold),

                     ),
                     title: Text("\$$prodprice",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800),),
                       subtitle: Text("\$$prodoldprice",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800,
                                                                       decoration: TextDecoration.lineThrough),),

                       ),
                */

            ),
            // child: Image.asset(prodpicture,fit: BoxFit.cover,),
            child: Center(child: Text("${Provider_remark.toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
            //Image.network(cat_img,fit: BoxFit.cover,),
          ),
//          GridTile(
//            footer: Container(
//                color: Colors.white70,
//                child: new Row(
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.only(right:20.0),
//                      child: Text("\$${Provider_desc.toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
//                    )
////                    ,  Expanded(
////                      child: Padding(
////                        padding: const EdgeInsets.only(left:20.0),
////                        child: new Text(Provider_name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
////                      ),
////                    ),
//
//                    // Text("\$${prodoldprice}",
//                    // style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,
//                    // decoration: TextDecoration.lineThrough
//                    // )
//                    // ,)
//                  ],
//                )
//
//              /*  ListTile(
//                     leading: Text(productname , style: TextStyle(fontWeight: FontWeight.bold),
//
//                     ),
//                     title: Text("\$$prodprice",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800),),
//                       subtitle: Text("\$$prodoldprice",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800,
//                                                                       decoration: TextDecoration.lineThrough),),
//
//                       ),
//                */
//
//            ),
//            // child: Image.asset(prodpicture,fit: BoxFit.cover,),
//            child:Container() //Image.network(Provider_img,fit: BoxFit.cover,),
//          ),
        ),
      ),
      ),
    );
  }
}