import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Animation1 extends StatefulWidget {
  @override
  _Animation1State createState() => _Animation1State();
}

class _Animation1State extends State<Animation1> with SingleTickerProviderStateMixin{

   AnimationController _animationController;
   Animation _animation;


   @override
   void dispose() {
     _animationController.dispose();
     super.dispose();
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: Duration( seconds: 3), vsync: this)..addListener((){
          setState(() {

          });
        })..addStatusListener((status){
          if(status==AnimationStatus.completed)
            {
              _animationController.reverse();
            }
          else if (status ==AnimationStatus.dismissed)
            {
              _animationController.forward();
            }
        });
    _animationController.forward();

    _animation =Tween <double>(begin: -200.0,end: 200.0).
    animate(CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));

  }
   @override


  Widget build(BuildContext context) {
    final double width =MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context,Widget child)
    {
      return
      Scaffold(
          body: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            //  crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(_animation.value,10),
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                  ),
                ),
              ),
            /*  SizedBox(height: 150,),
              Center(
                child: Transform.rotate(
                  angle: _animation.value,
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 150,),
              Center(
                child: Transform.scale(

                  //   origin: Offset(0, 5),
                  scale: _animation.value / 1000,
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.green,
                  ),
                ),
              )
              */

            ],
          )
      );
    });
  }
}
