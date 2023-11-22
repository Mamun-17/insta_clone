import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController controlOne=TextEditingController();
  bool isPass=false;
  String hinttext;
  TextInputType inputtype;
   MyTextField({Key? key,required this.inputtype,required this.hinttext,required this.controlOne,required this.isPass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputborder =OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      style: TextStyle(
        color: Colors.white
      ),

      controller:controlOne,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: Colors.white38
        ),
        fillColor: Colors.grey.withOpacity(.4),

        border: inputborder,
        focusedBorder: inputborder,
        enabledBorder: inputborder,
        filled: true,
        contentPadding: EdgeInsets.all(8),
        hintText:hinttext ,

      ),
      keyboardType:inputtype ,
      obscureText:isPass ,
    );
  }
}




