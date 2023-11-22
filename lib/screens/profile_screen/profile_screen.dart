//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/providers/post_provider.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/widget/snackbar.dart';
import 'package:provider/provider.dart';

import '../login_screen.dart';

class MyProfileScreen extends StatefulWidget {
  String uid;
  List followers;
  List following;
  String username;
  String description;
  String profileurl;
   MyProfileScreen({Key? key,required this.profileurl,required this.uid,required this.username,required this.following,required this.followers,required this.description}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  @override
  void initState() {
    Provider.of<MyPostProvider>(context,listen: false).ShowProfilePostLength(widget.uid);
    Provider.of<MyPostProvider>(context,listen: false).FollowerFollowingNumber(widget.uid, FirebaseAuth.instance.currentUser!.uid);




    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer2<MyProvider,MyPostProvider>(
      builder: (context,mp,np,_) {
        return Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title:  Row( children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.username.toString(),style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),),
                      Icon(Icons.keyboard_arrow_down,color: primaryColor,)
                    ],
                  ),
                ),



                Expanded(
                  child: Container(
                    child:widget.uid==FirebaseAuth.instance.currentUser!.uid? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor,width: 2),
                            borderRadius: BorderRadius.circular(8),

                          ),
                          child: Center(child: Icon(Icons.add,color:primaryColor,size: 18,)),

                        ),
                        SizedBox(width: 20,),

                        GestureDetector(
                          onTap: (){
                            showModalBottomSheet(
                              isDismissible: false,
                              
                              backgroundColor: secondaryColor.withOpacity(.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                              ),
                                context: context,
                                builder: (_){
                                  return Column(
                                    children: [
                                      SizedBox(height: 13,),

                                     Container(
                                       height: 5,
                                       width: 45,

                                       decoration: BoxDecoration(
                                           color: primaryColor,
                                         borderRadius: BorderRadius.horizontal(right: Radius.circular(10),left: Radius.circular(10))
                                       ),
                                     ),
                                      SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8,right: 8),
                                        child: Divider(color: secondaryColor.withOpacity(.4),thickness: 1,),
                                      ),
                                      TextButton(

                                          onPressed: ()async{

                                             String result = await mp.SignOut();

                                            if(result=="successfully logged out"){


                                              snackbar(result, context);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyLoginScreen()));

                                            }else{
                                              snackbar(result, context);
                                            }

                                                },
                                          child: Text('log Out',style: TextStyle(color: blueColor),))
                                    ],
                                  );
                                });
                          },
                            child: Icon(Icons.menu,color: primaryColor,size: 33,))
                      ],
                    ):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(


                          ),
                          child: Center(child: Icon(Icons.notifications_none_rounded,color:primaryColor,size: 25,)),

                        ),
                        SizedBox(width: 20,),

                        Icon(Icons.more_vert,color: primaryColor,size: 25,)
                      ],
                    )
                  ),
                )

              ],),

          ),
          body:  SingleChildScrollView(
            child: Column(


                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:26),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: mobileBackgroundColor,
                            child: CircleAvatar(
                              radius: 43,

                              backgroundImage: NetworkImage(widget.profileurl.toString()),

                            ),
                          ),
                        ),
                      ),
                      Container(
                        child:Column(
                          children: [
                            Text(np.profilepostlength.toString(),style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            SizedBox(height: 4,),
                            Text('Posts',style: TextStyle(color: primaryColor),)
                          ],
                        ),
                      ),
                     Container(
                       child:Column(
                         children: [
                           Text(np.NumberOfFollowers.toString(),style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                           SizedBox(height: 4,),
                           Text("followers",style: TextStyle(color: primaryColor),)
                         ],
                       ),
                     ),
                      Container(
                        child:Column(
                          children: [
                            Text(np.Numberoffollowing.toString(),style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            SizedBox(height: 4,),
                            Text("following",style: TextStyle(color: primaryColor),)
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Padding(
                    padding: const EdgeInsets.only(left:18),
                    child: Text(widget.username.toString(),style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(widget.description.toString(),style: TextStyle(color: primaryColor),),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 7),
                    child:   widget.uid==FirebaseAuth.instance.currentUser!.uid?

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Container(
                          height: 28,
                          width: MediaQuery.of(context).size.width*.40,
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(.4),
                            borderRadius: BorderRadius.circular(6),

                          ),
                          child: Center(child: Text("Edit Profile",style: TextStyle(color: primaryColor,fontSize: 14,fontWeight: FontWeight.w500),),),
                        ),
                        Container(
                          height: 28,
                          width: MediaQuery.of(context).size.width*.40,
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(.4),
                            borderRadius: BorderRadius.circular(6),

                          ),
                          child: Center(child: Text("Share Profile",style: TextStyle(color: primaryColor,fontSize: 14,fontWeight: FontWeight.w500),),),
                        ),
                        Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(.4),

                            borderRadius: BorderRadius.circular(7),

                          ),
                          child: Center(child: Icon(Icons.manage_accounts_outlined,color:primaryColor,size: 19,)),

                        ),
                      ],
                    )
                        :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async{
                            await np.FollowingAndUnFollowingAccount(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                           },
                          child: np.isFollowing==true?Container(
                            height: 28,
                            width: MediaQuery.of(context).size.width*.40,
                            decoration: BoxDecoration(
                              color:  secondaryColor.withOpacity(.4),
                              borderRadius: BorderRadius.circular(6),

                            ),
                            child: Center(child: Text("Following",style: TextStyle(color: primaryColor,fontSize: 14,fontWeight: FontWeight.w500),),),
                          ):
                          Container(
                            height: 28,
                            width: MediaQuery.of(context).size.width*.40,
                            decoration: BoxDecoration(
                              color: blueColor,
                              borderRadius: BorderRadius.circular(6),

                            ),
                            child: Center(child: Text("Follow",style: TextStyle(color: primaryColor,fontSize: 14,fontWeight: FontWeight.w500),),),
                          ),


                        ),
                        Container(
                          height: 28,
                          width: MediaQuery.of(context).size.width*.40,
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(.4),
                            borderRadius: BorderRadius.circular(6),

                          ),
                          child: Center(child: Text("Message",style: TextStyle(color: primaryColor,fontSize: 14,fontWeight: FontWeight.w500),),),
                        ),
                        Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(.4),

                            borderRadius: BorderRadius.circular(7),

                          ),
                          child: Center(child: Icon(Icons.manage_accounts_outlined,color:primaryColor,size: 19,)),

                        ),
                      ],
                    )

                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8),
                    child: Divider(thickness: 1,color: Colors.white38,),
                  ),
                 FutureBuilder(
                   future: FirebaseFirestore.instance.collection("posts").where("uid", isEqualTo: widget.uid).get(),
                   builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
                     if(snapshot.hasError|| snapshot.connectionState==ConnectionState.waiting){
                       return Center(child: CircularProgressIndicator(),);
                     }else{
                       return Padding(
                         padding: const EdgeInsets.only(left: 8,right: 8),
                         child: GridView.builder(
                             physics: NeverScrollableScrollPhysics(),
                             itemCount: snapshot.data!.docs!.length,
                             // scrollDirection: Axis.vertical,
                             shrinkWrap: true,

                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                               mainAxisSpacing: 7,
                               crossAxisSpacing: 7,
                               crossAxisCount: 3,

                             ),
                             itemBuilder: (cont,index){
                               return Container(
                                 height: 30,
                                 width:30,
                                // color: Colors.blue,
                                 decoration: BoxDecoration(
                                   image: DecorationImage(
                                     image: NetworkImage(snapshot.data!.docs[index]['posturl'].toString()),
                                     fit: BoxFit.cover
                                   )
                                 ),
                               );

                             }),
                       );
                     }
                   }
                 ),


                ],
              ),
          ),


        );
      }
    );
  }
}
