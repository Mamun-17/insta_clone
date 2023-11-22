
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/provider.dart';

 dialogue(BuildContext context)async{
  return showDialog(context: context, builder:(context){
    return  SimpleDialog(
          title: Text("Creat a post"),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Take a Photo"),
              onPressed: ()async{
                Navigator.of(context).pop();
                await Provider.of<MyPostProvider>(context,listen: false).PickImage();
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Cancel"),
              onPressed: (){
                Navigator.of(context).pop();

              },
            )

          ],
        );
      }

  );
 }
