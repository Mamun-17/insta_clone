import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/providers/post_provider.dart';
import 'package:instagram_clone/screens/profile_screen/profile_screen.dart';
import 'package:provider/provider.dart';

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({Key? key}) : super(key: key);

  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  TextEditingController controller=TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    //Provider.of<MyPostProvider>(context,listen: true).MakingSearchUerFalse();


    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Consumer<MyPostProvider>(
          builder: (context,mp,_) {
            return Scaffold(

              backgroundColor: mobileBackgroundColor,
              appBar:mp.isusersearch==true?PreferredSize(

                preferredSize: Size.fromHeight(60),
                child: AppBar(
                    backgroundColor: mobileBackgroundColor,
                    leading: IconButton(onPressed: (){
                      mp.MakingSearchUerFalse();
                      controller.clear();
                    }, icon: Icon(Icons.arrow_back,color: Colors.grey,)),
                    title: TextFormField(
                        controller: controller,

                        style: TextStyle(
                            color: primaryColor
                        ),


                        decoration: InputDecoration(
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(
                             color: secondaryColor
                           )
                         ),
                          contentPadding: EdgeInsets.only(top: 10,bottom: 10,left: 7),
                          filled: true,
                          fillColor: Colors.grey,
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.white38
                            ),
                            //hintText: 'Search',
                            labelText: "search for users",
                            labelStyle: TextStyle(
                                color: primaryColor
                            )


                        ),
                        onFieldSubmitted: (String _){
                          mp.MakingSearchUerTrue();

                        },



                      ),

                  ),

              ):
              AppBar(
                backgroundColor: mobileBackgroundColor,
                title: GestureDetector(
                  onTap: (){
                    mp.MakingSearchUerTrue();
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width*.9,

                    decoration: BoxDecoration(
                        color: Colors.white38,
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(Icons.search,color: Colors.grey,size: 20,),
                        ),
                        SizedBox(width: 7,),
                        Text('Search',style: TextStyle(color: Colors.grey,fontSize: 18),)
                      ],
                    ),
                  ),
                )


              ),
              body: mp.isusersearch==true?FutureBuilder(
                future:  FirebaseFirestore.instance.collection("myusers").where('username',isEqualTo: controller.text).get(),
                  builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot){
                  if(snapshot.hasError||snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else{

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>
                                    MyProfileScreen(
                                        profileurl: snapshot.data!.docs[index]['photourl'],
                                        uid: snapshot.data!.docs[index]['uid'],
                                        username: snapshot.data!.docs[index]['username'],
                                        following:snapshot.data!.docs[index]['following'],
                                     followers: snapshot.data!.docs[index]['followers'],
                                        description: snapshot.data!.docs[index]['bio'])));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!.docs[index]['photourl']),
                            ),
                            title: Text(snapshot.data! .docs[index]['username'],
                            style: TextStyle(
                              color: primaryColor
                            ),),
                          ),
                        );
                        });
                  }
                  }): FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").get(),
                  builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot){
                  if(!snapshot.hasData||snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  else{
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){
                        return Image.network(snapshot.data!.docs[index]['posturl']);
                        },
                    staggeredTileBuilder: (index)=>StaggeredTile.count(
                        (index % 7==0)?2:1,
                        (index % 7 ==0)?2:1
                    ),
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,);
                  }
                  })

            );
          }
        ),
      ),
    );
  }
}
