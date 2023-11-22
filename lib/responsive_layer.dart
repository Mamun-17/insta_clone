import 'package:flutter/material.dart';
import 'package:instagram_clone/global_variable.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:provider/provider.dart';

class MyResponsivelayer extends StatefulWidget {
  Widget mymobile;
  Widget myweb;
   MyResponsivelayer({Key? key,required this.mymobile,required this.myweb}) : super(key: key);

  @override
  State<MyResponsivelayer> createState() => _MyResponsivelayerState();
}

class _MyResponsivelayerState extends State<MyResponsivelayer> {
  @override
  void initState() {
    addData();

    super.initState();
  }

  addData()async{
     await Provider.of<MyProvider>(context,listen: false).GetUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constrains){
      if(constrains.maxWidth>widgetlength){
        return widget.myweb;
      }
      else{
        return widget.mymobile;
      }
    });
  }
}
