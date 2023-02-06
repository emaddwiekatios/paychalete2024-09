
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'ProductsDetails.dart';

class Products extends StatefulWidget {
  @override
  ProductsState createState() => ProductsState();
}
QuerySnapshot cars;
//import 'package:cloud_firestore/cloud_firestore.dart';
class ProductsState extends State<Products> {
  void initState() {

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


  var productslist
  =[
    {
      "Docs_id":"Weman Dress",
      "Docs_name":"Weman Dress",
      "Docs_desc":"Weman Dress",
      "Docs_price":"7.0",
      "Docs_date":"Weman Dress",
      "Docs_Fav":'True',
      "Docs_cat":"Weman Dress",
      "Docs_img":'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',

    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: productslist.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
        ),
        itemBuilder: (BuildContext context,int index){
          return  Container( //Image.network(productslist[index]['picture'], fit: BoxFit.cover, ),
            child: prodlist(
              Docs_id: productslist[index]['Docs_id'],
              Docs_name: productslist[index]['Docs_name'],
              //prodpicture: Image.network(productslist[index]['picture'], fit: BoxFit.cover, ),

              Docs_img: productslist[index]['Docs_img'],
              Docs_desc: productslist[index]['Docs_desc'],
              Docs_price :productslist[index]['Docs_price'],
              Docs_cat :productslist[index]['Docs_cat'],
              Docs_fav :productslist[index]['Docs_fav'],
              Docs_date: productslist[index]['Docs_date'],
              Docs_doc_id: productslist[index]['Docs_doc_id'],

            ),
          );
        }

    );
  }

  ///
  getData() async {
    //return await FirebaseFirestore.instance.collection("Gym-Products").snapshots();
    return await FirebaseFirestore.instance.collection('Document').get();
  }
  printlist(){
    if (cars != null) {
      for(var i =0 ;i<cars.docs.length;i++)
      {     print(cars);
      productslist.add(
          {
            "Docs_id":cars.docs[i].data()['Docs_id'].toString(),
            "Docs_name":cars.docs[i].data()['Docs_name'],
            "Docs_desc":cars.docs[i].data()['Docs_desc'],
            "Docs_price":cars.docs[i].data()['Docs_price'],
            "Docs_fav":cars.docs[i].data()['rod_fav'].toString(),
            "Docs_cat":cars.docs[i].data()['Docs_cat'],
            "Docs_date":cars.docs[i].data()['Docs_date'].toString(),
            "Docs_img":cars.docs[i].data()['Docs_img'],
            "Docs_doc_id"  : cars.docs[i].documentID,
          });
      }
      productslist.removeAt(0);
      print("the value${productslist}");
    }

    else
    {
      print("error");
    }


  }


///


}


class prodlist extends StatelessWidget {
  final Docs_id;
  final Docs_name;
  final Docs_img;
  final Docs_desc;
  final Docs_price;
  final Docs_fav;
  final Docs_cat;
  final Docs_date;
  final Docs_doc_id;
  prodlist({
    this.Docs_id,
    this.Docs_name,
    this.Docs_img,
    this.Docs_desc,
    this.Docs_price,
    this.Docs_fav,
    this.Docs_cat,
    this.Docs_date,
    this.Docs_doc_id
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),


      child: Hero(
        tag:new Text("Hero1") //productname
        ,child: Material(
        child: InkWell(onTap: (){
          //  print(Docs_doc_id);
//                    Navigator.of(context).push(
//                        new MaterialPageRoute(
//                          builder:  (BuildContext context) => new Productsdetails(
//
//                               Docs_id:Docs_id,
//                               Docs_name: Docs_name,
//                               Docs_desc:Docs_desc ,
//                               Docs_img:Docs_img ,
//                               Docs_price:Docs_price ,
//                               Docs_fav:Docs_fav ,
//                               Docs_cat:Docs_cat ,
//                               Docs_date: Docs_date,
//                               Docs_doc_id: Docs_doc_id,
//
//
//                            )
//                           ),
//                  );

        },

          child: GridTile(
            footer: Container(
                color: Colors.white70,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:20.0),
                        child: new Text(Docs_name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:20.0),
                      child: Text("${Docs_cat.toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                    )
                    ,
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
            child: Image.network(Docs_img,fit: BoxFit.cover,),
          ),
        ),
      ),),
    );
  }
}



