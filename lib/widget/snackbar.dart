import 'package:flutter/material.dart';

 snackbar(String text,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text))
  );
}
