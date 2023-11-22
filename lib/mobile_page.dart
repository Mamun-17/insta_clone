import 'package:flutter/material.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/global_variable.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/screens/feed_screen/feed_screen.dart';
import 'package:instagram_clone/screens/post/post_screen.dart';
import 'package:instagram_clone/screens/profile_screen/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen/search_screen.dart';
import 'package:provider/provider.dart';

class MyMobilePage extends StatefulWidget {
  const MyMobilePage({Key? key}) : super(key: key);


  @override
  State<MyMobilePage> createState() => _MyMobilePageState();
}

class _MyMobilePageState extends State<MyMobilePage> {
  PageController pagecontroller= PageController();
  @override
  void initState() {
    if(Provider.of<MyProvider>(context,listen: false).myuser==null){
     AddUserdata();
    }
    else{}

    super.initState();
  }
  AddUserdata()async{
    await Provider.of<MyProvider>(context,listen: false).GetUserDetails();

  }
  @override
  void dispose() {
   pagecontroller.dispose();
    super.dispose();
  }
  void PageOnChanged(int page){
    pagecontroller.jumpToPage(page);
   Provider.of<MyProvider>(context,listen: false).OnIconColorChangedOfMobilePage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context,mp,_) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: PageView(
            controller: pagecontroller,
            physics: NeverScrollableScrollPhysics(),

            children: [
              MyFeedPage(),
              MySearchScreen(),
              MyPostScreen(),
              Center(
                child: Text("fav",
                  style: TextStyle(color: primaryColor,fontSize: 20),),
              ),
              MyProfileScreen(profileurl: mp.myuser!.url, uid: mp.myuser!.uid, username: mp.myuser!.username, following: mp.myuser!.following, followers: mp.myuser!.followers, description: mp.myuser!.bio)
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: mobileBackgroundColor,
            items:  [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,color: mp.mobilePageRender==0?primaryColor:secondaryColor,),
                  label: '',
                  backgroundColor: mobileBackgroundColor),

              BottomNavigationBarItem(icon: Icon(Icons.search,color: mp.mobilePageRender==1?primaryColor:secondaryColor,),
                  label: '',
                  backgroundColor: mobileBackgroundColor),

              BottomNavigationBarItem(icon: Icon(Icons.add_circle,color: mp.mobilePageRender==2?primaryColor:secondaryColor,),
                  label: '',
                  backgroundColor: mobileBackgroundColor),

              BottomNavigationBarItem(icon: Icon(Icons.favorite,color: mp.mobilePageRender==3?primaryColor:secondaryColor,),
                  label: '',
                  backgroundColor: mobileBackgroundColor),

              BottomNavigationBarItem(icon: Icon(Icons.people,color: mp.mobilePageRender==4?primaryColor:secondaryColor,),
                  label: '',
                  backgroundColor: mobileBackgroundColor),
            ],
            onTap: PageOnChanged

          ),


        );
      }
    );
  }
}
