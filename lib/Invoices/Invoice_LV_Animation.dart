import 'dart:async';

import 'package:flutter/material.dart';

class Invoice_LV_Animation extends StatefulWidget {
  final Widget child;
  final Duration time;
  Invoice_LV_Animation(this.child, this.time);
  @override
  _Invoice_LV_AnimationState createState() => _Invoice_LV_AnimationState();
}

class _Invoice_LV_AnimationState extends State<Invoice_LV_Animation>
    with SingleTickerProviderStateMixin {
  Timer timer;
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    animation =CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    //animation = new Tween<double>(begin: 10.0,end: 0.0).animate(animationController);
    //animationController.forward();
    timer = Timer(widget.time, animationController.forward);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            //offset: Offset(0.0, (1 - animation.value) * 2),
          offset:Offset(0.0  , ( animation.value-1) * 30),
            child: child,
          ),
        );
      },
    );
  }
}

Timer timer;
Duration duration = Duration();
wait() {
  if (timer == null || !timer.isActive) {
    timer = Timer(Duration(microseconds: 20), () {
      duration = Duration();
    });
  }
  duration += Duration(milliseconds: 100);
  return duration;
}

class WidgetInvoice_LV_Animation extends StatelessWidget {
  final Widget child;
  WidgetInvoice_LV_Animation(this.child);
  @override
  Widget build(BuildContext context) {
    return Invoice_LV_Animation(child, wait());
  }
}
