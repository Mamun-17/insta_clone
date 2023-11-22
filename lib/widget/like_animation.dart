import 'package:flutter/material.dart';

class MyLikeAnimation extends StatefulWidget {
  bool isanimating;
  Duration duration;
  Widget child;
  VoidCallback?onEnd;
  bool smallike;
   MyLikeAnimation({Key? key,
     required this.child,
     this.duration= const Duration(milliseconds: 150),
     required this.isanimating,
     required this.onEnd,
     this.smallike=false}) : super(key: key);

  @override
  State<MyLikeAnimation> createState() => _MyLikeAnimationState();
}

class _MyLikeAnimationState extends State<MyLikeAnimation> with SingleTickerProviderStateMixin{
  late AnimationController controller;

  late Animation<double> scale;
  @override
  void dispose() {
   controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller=AnimationController(vsync: this,duration: Duration(milliseconds:widget.duration.inMilliseconds ~/2 ,));
    scale= Tween<double>(begin: 1,end: 1.2).animate(controller);
    super.initState();
  }
  @override
  void didUpdateWidget(covariant MyLikeAnimation oldWidget) {
    if(widget.isanimating!=oldWidget.isanimating){
      startAnimation();

    }
    super.didUpdateWidget(oldWidget);
  }



  startAnimation()async{
    if(widget.isanimating||widget.smallike){
      await controller.forward();
     await controller.reverse();
     await Future.delayed(const Duration(milliseconds: 200));
     if(widget.onEnd!=null){
       widget.onEnd!();
     }

    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale,child: widget.child,);
  }
}
