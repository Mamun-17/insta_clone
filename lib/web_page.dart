import 'package:flutter/material.dart';

class MyWebPage extends StatefulWidget {
  const MyWebPage({Key? key}) : super(key: key);

  @override
  State<MyWebPage> createState() => _MyWebPageState();
}

class _MyWebPageState extends State<MyWebPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("this is my web",style: TextStyle(
        fontSize: 40
      ),)),
    );
  }
}
