import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/screens/feed_screen/feed_class.dart';
import 'package:instagram_clone/screens/message/chat_screen.dart';

class MyFeedPage extends StatefulWidget {
  const MyFeedPage({Key? key}) : super(key: key);

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(

        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset("assets/ic_instagram.svg",height: 32,),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyChatScreen()));
          },
              icon: Icon(Icons.messenger_outline,color: primaryColor,))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index)=>MyFeedClass(
                  snap: snapshot.data!.docs[index],
                ),
            );
          }
        },
      )
    );
  }
}
