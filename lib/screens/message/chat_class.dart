import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/message/personal_chat_screen.dart';

class MyChatClass extends StatefulWidget {
  String profImageurl;
  String username;
  String uid;

   MyChatClass({Key? key,required this.username,required this.profImageurl,required this.uid}) : super(key: key);

  @override
  State<MyChatClass> createState() => _MyChatClassState();
}

class _MyChatClassState extends State<MyChatClass> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyPersonalChatScreen(username: widget.username, profImageurl: widget.profImageurl, uid: widget.uid,)));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.profImageurl.toString()),
        ),
        title: Text(widget.username.toString(),style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
