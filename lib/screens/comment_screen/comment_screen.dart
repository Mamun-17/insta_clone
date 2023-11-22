import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/providers/post_provider.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/screens/comment_screen/comment_card.dart';
import 'package:instagram_clone/widget/snackbar.dart';
import 'package:provider/provider.dart';

class MyCommentScrean extends StatefulWidget {
  final QueryDocumentSnapshot snap;
  const MyCommentScrean({Key? key,required this.snap}) : super(key: key);

  @override
  State<MyCommentScrean> createState() => _MyCommentScreanState();
}

class _MyCommentScreanState extends State<MyCommentScrean> {
  TextEditingController controller =TextEditingController();

  @override
  void initState() {
   if(Provider.of<MyProvider>(context,listen: false).myuser==null){
     Provider.of<MyProvider>(context,listen: false).GetUserDetails();
   }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },

      child: Consumer2<MyPostProvider,MyProvider>(
        builder: (context,mp,np,_) {
          return Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: Icon(Icons.arrow_back_ios_new,color: primaryColor,),
              title: Text("Comment",style: TextStyle(color: primaryColor),),
            ),
            body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("posts").doc(widget.snap["postId"]).collection("comments").snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }else{
                  return ListView.builder(

                    itemCount: snapshot.data!.docs!.length,
                      itemBuilder: (context,index){
                      return MyCommentCard(snap: snapshot.data?.docs[index],);
                      });
                }
              },
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                height: kToolbarHeight,

                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                    CircleAvatar(
                     backgroundImage: NetworkImage('https://www.cleverfiles.com/howto/wp-content/uploads/2018/03/minion.jpg'),
                      radius: 20,
                    ),

                      Expanded(child: Padding(
                        padding: const EdgeInsets.only(left: 18,right: 7),
                        child: TextField(
                          controller: controller,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(

                            hintStyle: TextStyle(
                              color: Colors.white38
                            ),


                            hintText: 'comment something',
                            border: InputBorder.none
                          ),
                        ),
                      )),

                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: InkWell(
                          onTap: ()async{
                            String result=await mp.PostComment(widget.snap['postId'], controller.text,np.myuser!.username , np.myuser!.uid, np.myuser!.url);
                            controller.clear();
                            snackbar(result, context);
                          },
                          child: Text("Post",style: TextStyle(color: blueColor,fontWeight: FontWeight.bold),),
                        ),
                      )



                  ],),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
