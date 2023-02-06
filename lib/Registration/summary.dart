import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';

import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';

class summary extends StatefulWidget {
  @override
  _summaryState createState() => _summaryState();
}


class _summaryState extends State<summary> {
  @override
  Widget build(BuildContext context) {
    final double pheight=MediaQuery.of(context).size.height;
    final double pwidth=MediaQuery.of(context).size.width;
    double  pand_10 = pheight/70;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
              ),
              Positioned(
                top:pheight/15,
                left:pwidth/2-(pwidth/1.5)/2,
                child: Container(
                //  color: Colors.orange,
                  width: pwidth/1.5,
                    child: Center(
                      child:
                      Text(AppLocalizations.of(context).translate('Indivilual paln calculated'),
                      style: TextStyle(fontSize: pheight/30, color: Colors.black),
                      ),
                    ))
              ),
              Positioned(
                  top:pheight/8,
                  left:pwidth/20,
                  right: pwidth/20,
                 child: Container(
                    //  color: Colors.orange,
                      width: pwidth/1.5,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),

                        elevation: 12,
                        child: Container(
                          height: pheight/4.7,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                   // text: 'Recommeneded rate = ',
                                   // style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(text: AppLocalizations.of(context).translate('Recommeneded Rate'),
                                               style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color: Colors.black)),
                                      TextSpan(text: '  ' ,
                                          style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:pcolor1 )),

                                      TextSpan(text: '2500' ,
                                               style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:pcolor2 )),
                                      TextSpan(text: '  ' ,
                                          style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:pcolor3 )),

                                      TextSpan(text: AppLocalizations.of(context).translate('Kcal') ,
                                          style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color: Colors.black)),

    ],
                                  ),
                                )
//                                Text('Recommeneded rate = ${2500} Kcal',
//                                  style: TextStyle(fontSize: 20.0, color: Colors.black),)
                            ,
                               // SizedBox(height: pheight/70,),
                                Padding(
                                  padding: const EdgeInsets.all( 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text('65g'  ,         style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:pcolor2 )),
                                          Text(AppLocalizations.of(context).translate('Protien'),           style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:Colors.black )),

                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[

                                          Text('30r'  ,         style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:pcolor2 )),
                                          Text(AppLocalizations.of(context).translate('Fat'),           style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:Colors.black )),


                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text('40r'  ,         style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:pcolor2 )),
                                          Text(AppLocalizations.of(context).translate('Carbohydrat'),           style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:Colors.black )),

                                        ],
                                      )

                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                          //width: MediaQuery.of(context).size.width -40,
                        ),
                      )
                  )
              ),
              Positioned(
                  top:pheight/2.7,
                  left:pwidth/20,
                  right: pwidth/20,
                  child: Container(

                    //  color: Colors.orange,
                      width: pwidth/1.5,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        elevation: 12,
                        child: Container(
                            height: pheight/3,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      // text: 'Recommeneded rate = ',
                                      // style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(text: AppLocalizations.of(context).translate('Recommeneded Plan For You'),
                                            style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color: Colors.black)),
//                                        TextSpan(text: ' 2500' ,
//                                            style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color:paychalet )),
//                                        TextSpan(text: ' Kcal' ,
//                                            style: TextStyle(fontSize:pheight/35,fontWeight: FontWeight.w400,color: Colors.black)),

                                      ],
                                    ),
                                  )
//                                Text('Recommeneded rate = ${2500} Kcal',
//                                  style: TextStyle(fontSize: 20.0, color: Colors.black),)
                                  ,
                                   SizedBox(height: pheight/70,),

                                    Container(
                                      height: pheight/4.2,
                                      width: pwidth/1.2,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                        image:DecorationImage(
                                          image: AssetImage('images/Food2.jpeg'),
                                          fit: BoxFit.fill
                                        )

                                      ),
                                      


                                  )
                                ],
                              ),
                            )
                          //width: MediaQuery.of(context).size.width -40,
                        ),
                      )
                  )
              ),


              Positioned(
                top:pheight/1.2,
                left:pwidth/3.5,
                right: pwidth/3.5,
                child:Container(
                  height: MediaQuery.of(context).size.height / 16,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: pcolor1,
                  ),
                  child: FlatButton(
                    //color: Colors.amber,
                    textColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      print('inside button');
                      //call_func_photo();
                    //  Navigator.pushNamed(context, '/MainPage'); fff
                      Navigator.pushReplacementNamed(context, '/Home');
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('Done'),
                      style: TextStyle(
                          fontSize: pwidth/20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
