import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/post_provider.dart';

DeleteDialogue(BuildContext context,String post){
  return showDialog(context: context, builder:(context){
    return  SimpleDialog(
      title: Text("Want to delete The post?"),
      children: [
        SimpleDialogOption(
          padding: EdgeInsets.all(20),
          child: Text("Delete"),
          onPressed: ()async{
           await Provider.of<MyPostProvider>(context,listen: false).DeletePost(post);
           Navigator.of(context).pop();


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