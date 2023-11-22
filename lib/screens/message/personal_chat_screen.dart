import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/providers/post_provider.dart';
import 'package:instagram_clone/widget/snackbar.dart';
import 'package:provider/provider.dart';

class MyPersonalChatScreen extends StatefulWidget {
  String profImageurl;
  String username;
  String uid;
 MyPersonalChatScreen({Key? key,required this.username,required this.profImageurl,required this.uid}) : super(key: key);

  @override
  State<MyPersonalChatScreen> createState() => _MyPersonalChatScreenState();
}

class _MyPersonalChatScreenState extends State<MyPersonalChatScreen> {
  TextEditingController controller=TextEditingController();

  @override
  void initState() {

   Add();
    // TODO: implement initState

  }


  Add()async{
    await Provider.of<MyPostProvider>(context,listen: false).GettingPersonalChatInfo(widget.uid);

  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Consumer<MyPostProvider>(
          builder: (contex,mp,_) {
            return WillPopScope(
              onWillPop: ()async {
                bool rslt=await mp.turningvariablenull();
                return rslt;
              },
              child: Scaffold(
                  backgroundColor: mobileBackgroundColor,
                  appBar: AppBar(
                    backgroundColor:mobileBackgroundColor,

                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 23,
                          backgroundImage: NetworkImage(widget.profImageurl.toString()),
                        ),
                        SizedBox(width: 20,),
                        Text(widget.username.toString(),style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  body: SingleChildScrollView(

                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                              height: MediaQuery.of(context).size.height*.82,
                             // color: Colors.blue,
                            child: mp.personalchatid==null? Center(child: CircularProgressIndicator(),):StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('messages').doc(mp.personalchatid.toString()).collection('PairMessage').orderBy("date", descending: false).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }
                      else {
                        if(snapshot.hasError){
                          return Center(child: Text("something is wrong"),);
                        }
                        else {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context,index){
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Row(
                                    mainAxisAlignment: snapshot.data!.docs[index]["from"]==FirebaseAuth.instance.currentUser!.uid?MainAxisAlignment.end:MainAxisAlignment.start,
                                    children: [
                                      Text("${snapshot.data!.docs[index]['massage']}",style: TextStyle(color: primaryColor),),
                                    ],
                                  ),
                                );
                              });
                        }
                      }

                    },

                  ),
                            ),
                        ),


                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                maxLines: null,
                                maxLength: 10,

                                style: TextStyle(
                                    color: primaryColor
                                ),


                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryColor
                                        )
                                    ),
                                   // contentPadding: EdgeInsets.only(top: 30,bottom: 10,left: 7),
                                    filled: true,
                                    fillColor: Colors.grey,
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(
                                        color: Colors.white38
                                    ),
                                    //hintText: 'Search',
                                    labelText: "write your message",
                                    labelStyle: TextStyle(
                                        color: primaryColor
                                    )


                                ),



                              ),
                            ),
                            TextButton(onPressed: ()async{
                              String result=await mp.PostingMessage(widget.uid, controller.text);
                              controller.clear();
                              snackbar(result, context);
                            }, child: Text("Send"))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            );

          }
        ),
      ),
    );
  }
}
