import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/screens/message/chat_class.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({Key? key}) : super(key: key);

  @override
  State<MyChatScreen> createState() => _MyChatScreenState();
}

class _MyChatScreenState extends State<MyChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor:mobileBackgroundColor,
        title: Center(child: Text("Chat Box",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor
          ),),),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("myusers").where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot) {
          if(snapshot.hasError||snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else{
            return ListView.builder(
                itemCount:snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  return MyChatClass(username: snapshot.data!.docs[index]['username'], profImageurl: snapshot.data!.docs[index]['photourl'], uid: snapshot.data!.docs[index]['uid'],);
                });
          }
        }
      ),
    );
  }
}
