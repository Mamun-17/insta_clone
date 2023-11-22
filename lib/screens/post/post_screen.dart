import 'package:flutter/material.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/providers/post_provider.dart';
import 'package:instagram_clone/widget/snackbar.dart';
import 'package:instagram_clone/widget/textfield.dart';
import 'package:provider/provider.dart';

import '../../providers/provider.dart';
import 'dialogue.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({Key? key}) : super(key: key);

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {

  TextEditingController control=TextEditingController();
  @override
  void dispose() {
  control.dispose();
    super.dispose();
  }
  @override
  void initState() {
 Provider.of<MyPostProvider>(context,listen: false).adData();
    super.initState();
  }
  /*getUserdataFromMyProvider()async{
    await Provider.of<MyProvider>(context,listen: false).GetUserDetails();
  }*/
  @override
  Widget build(BuildContext context) {


    return  Provider.of<MyPostProvider>(context,listen: true).postImage==null?Center(
      child: GestureDetector(
        onTap: ()async{
         await dialogue(context);
        },
          child: Icon(Icons.upload,color: primaryColor,)),
    ):

  GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Consumer2<MyProvider,MyPostProvider>(
            builder: (context,mp,np,_) {
              return Scaffold(
                        backgroundColor: mobileBackgroundColor,
                        appBar:  AppBar(
                          backgroundColor: mobileBackgroundColor,
                          leading: GestureDetector(
                            onTap: (){
                              np.clearpostimage();
                              control.clear();
                            },
                              child: Icon(Icons.arrow_back,color: primaryColor,)),

                          title: Text("Post to",
                          style: TextStyle(fontWeight: FontWeight.bold),),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child:  TextButton(onPressed: ()async{

                                if(control.text.isNotEmpty && np.postImage!=null){

                                  String result=await np.UploadPost(mp.myuser!.username, mp.myuser!.uid, mp.myuser!.url, np.postImage!, control.text);

                                  control.clear();

                                  snackbar(result, context);

                                }else{
                                  String error="description is empty or didn't select image";
                                  snackbar(error, context);
                                }
                                  }, child: Text("Post",style: TextStyle(fontWeight: FontWeight.bold,color: blueColor,fontSize: 16),))

                            )
                          ],
                        ),
                        body: Column(


                          children: [
                            np.isloading==true?LinearProgressIndicator():Container(),

                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(mp.myuser!.url),
                                      ),
                                    ),
                                    SizedBox(width:MediaQuery.of(context).size.width*.6,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextField(
                                        controller: control,
                                        style: TextStyle(
                                          color: Colors.white
                                        ),

                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              color: Colors.white38
                                          ),
                                          hintText: 'write a caption...',
                                          border: OutlineInputBorder(),

                                        ),
                                        maxLines: 3,
                                      ),
                                    ),),
                                   SizedBox(width: 17,),

                                   Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: MemoryImage(np.postImage!),
                                              fit: BoxFit.cover
                                            )
                                          ),
                                        ),
                                    Divider(),









                                  ]
                                ),
                            ),

                          ],
                        ),
                      );
            }
          )




        );
     }

  }

