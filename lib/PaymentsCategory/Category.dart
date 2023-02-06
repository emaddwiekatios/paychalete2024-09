import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './Categorydetails.dart';
//import 'productdetails.dart';
//import 'package:cloudfirestore/cloudfirestore.dart';

class Category extends StatefulWidget {
  @override
  CategoryState createState() => CategoryState();
}
QuerySnapshot cars;
class CategoryState extends State<Category> {
    void initState() {
  //  print("inside init");
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
    var cat_max;

  var catslist
   =[
    {
      "cat_id":"Weman Dress",
      "cat_name":"Weman Dress",
      "cat_desc":"Weman Dress",
      "cat_remark":"Weman Dress",
      "cat_date":"Weman Dress",

      "cat_img":'https://firebasestorage.googleapis.com/v0/b/fir-3af1c.appspot.com/o/t-shirt.jpg?alt=media&token=18e2c978-8386-4aaa-880c-dc8d0a5252eb',
   
    }
   ];
   
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: catslist.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:3
      ),
      itemBuilder: (BuildContext context,int index){
            return  Container( //Image.network(productslist[index]['picture'], fit: BoxFit.cover, ),
              child:
            catprod(
                cat_id: catslist[index]['cat_id'],
                cat_name: catslist[index]['cat_name'],
               //prodpicture: Image.network(productslist[index]['picture'], fit: BoxFit.cover, ),
               
                cat_img: catslist[index]['cat_img'],
                cat_desc: catslist[index]['cat_desc'],
                 cat_remark :catslist[index]['cat_remark'],
                  cat_date: catslist[index]['cat_date'],
                  cat_doc_id: catslist[index]['cat_doc_id'],
                  
             ),
            );
      }
      
      );
  }

///
     getData() async {
     //return await FirebaseFirestore.instance.collection("Gym-Category").snapshots();
    

    return await FirebaseFirestore.instance.collection('PaymentsCategory').get();

           }
           

    printlist(){
       if (cars != null) {
     
        for(var i =0 ;i<cars.docs.length;i++)
        { 
         print('${cars.docs[i].data()['cat_date'].toString()}');

             catslist.add(
            {
            "cat_id":cars.docs[i].data()['cat_id'],
      "cat_name":cars.docs[i].data()['cat_name'],
      "cat_desc":cars.docs[i].data()['cat_desc'],
      "cat_remark":cars.docs[i].data()['cat_remark'],
      "cat_date":cars.docs[i].data()['cat_date'].toString(),

      "cat_img":cars.docs[i].data()['cat_img'],
       "cat_doc_id"  : cars.docs[i].id.toString(),

   
         }

          );
         
         
        }  
           catslist.removeAt(0);


       }
    
        else
      {
        print("error");
      }


    }


///


}


class catprod extends StatelessWidget {
  final cat_id;
  final cat_name;
  final cat_img;
  final cat_desc;
  final cat_remark;
  final cat_date;
  final cat_doc_id;
  catprod({
    this.cat_id,
    this.cat_name,
    this.cat_img,
    this.cat_desc,
    this.cat_remark,
    this.cat_date,
     this.cat_doc_id
  });
  @override
  Widget build(BuildContext context) {
    return Card(
       clipBehavior: Clip.antiAlias,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
   

     child:
      Hero(
        tag:new Text("Hero1") //productname
        ,child: Material(
               child: InkWell(onTap: (){
                 print('${cat_date}');
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder:  (BuildContext context) => new categorysdetails(

                               cat_id:cat_id,
                               cat_name: cat_name,
                               cat_desc:cat_desc ,
                               cat_img:cat_img ,
                               cat_remark:cat_remark ,
                               cat_date: cat_date,
                               cat_doc_id: cat_doc_id,


                            )
                           ),
                  );
               },

               child:

               GridTile(
              //   header: Center(child: Text("\${cat_desc.toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),

                 footer: Container(
                   color: Colors.white70,
                   child: new Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.only(left:20.0),
                           child: Center(child: new Text(cat_name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),)),
                         ),
                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right:20.0),
//                         child: Text("\$${cat_desc.toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
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
                child: Center(child: Text("${cat_desc.toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                 //Image.network(cat_img,fit: BoxFit.cover,),
                        ),
               ),
      ),
      ),
    );
  }
}