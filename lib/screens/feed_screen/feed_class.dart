import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/post_provider.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/screens/feed_screen/feed_screen_dialogue.dart';

import 'package:instagram_clone/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../color.dart';
import '../comment_screen/comment_screen.dart';

class MyFeedClass extends StatefulWidget {
   final QueryDocumentSnapshot snap;
   MyFeedClass({Key? key,required this.snap}) : super(key: key);

  @override
  State<MyFeedClass> createState() => _MyFeedClassState();
}

class _MyFeedClassState extends State<MyFeedClass> {
  @override
  void initState() {
    if(Provider.of<MyProvider>(context,listen: false).myuser==null){
      Provider.of<MyProvider>(context,listen: false).GetUserDetails();
    }else{}


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer2<MyProvider,MyPostProvider>(
      builder: (context,mp,np,_) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.snap['profImage']),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(widget.snap['username'],style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor
                      ),),
                    ),
                    IconButton(onPressed: (){
                      DeleteDialogue(context,widget.snap['postId']);
                    },
                        icon: Icon(Icons.more_vert,color: primaryColor,))
                  ],
                ),
              ),

              GestureDetector(
                onDoubleTap: (){
                  np.likefunction(widget.snap['postId'], mp.myuser!.uid, widget.snap['likes']);
                  np.Animationtrue();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    Container(
                      //  width: MediaQuery.of(context).size.width*1,
                      height: MediaQuery.of(context).size.height*.35,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.snap['posturl']),
                              fit: BoxFit.contain
                          )
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: np.isAnimating?1:0,
                      duration: const Duration(milliseconds: 200),
                      child: MyLikeAnimation(child: Icon(Icons.favorite,color: primaryColor,size: 120,),
                          isanimating: np.isAnimating,
                          duration: const Duration(milliseconds: 400),
                          onEnd: (){
                        np.Animationfalse();
                          }),
                    )
                  ]
                ),
              ),
              Row(
                children: [
                 MyLikeAnimation(
                   isanimating: widget.snap['likes'].contains(mp.myuser?.uid),
                     smallike: true,
                     onEnd: (){},
                     child: IconButton(onPressed:(){
                       np.likefunction(widget.snap['postId'], mp.myuser!.uid, widget.snap['likes']);

                     },
                         icon:  widget.snap['likes'].contains(mp.myuser?.uid)?Icon(Icons.favorite,color: Colors.red,)
                             :Icon(Icons.favorite_border_outlined,color: Colors.white,))),


                  IconButton(onPressed:(){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyCommentScrean(snap: widget.snap,)));
                  }, icon: Icon(Icons.comment_outlined,color: Colors.white,)),


                  IconButton(onPressed:(){}, icon: Icon(Icons.send,color: Colors.white,)),
                  Expanded(child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: IconButton(onPressed:(){}, icon: Icon(Icons.bookmark_border,color: Colors.white,)),
                      ))),

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text("${widget.snap['likes'].length} likes",style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                )),
              ),
              SizedBox(
                height: 4,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(widget.snap['username'],
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold
                  ),),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(widget.snap['description'],
                  style: TextStyle(
                      color: primaryColor
                  ),),
              ),

              SizedBox(
                height: 4,
              ),

                    Padding(
                     padding: const EdgeInsets.only(left: 15),
                     child: StreamBuilder(
                       stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').snapshots(),
                       builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        else{
                          return Text('view all ${snapshot.data!.docs.length.toString()} comments',
                            style: TextStyle(
                              color: secondaryColor,

                            ),);
                        }
                       }
                     ),
                   ),



              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(DateFormat.yMMMd().format(widget.snap["datetimepublished"].toDate()),
                  style: TextStyle(
                    color: secondaryColor,

                  ),),
              )



            ],
          ),
        );
      }
    );
  }
}
