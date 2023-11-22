import 'package:flutter/material.dart';
//import 'package:instagram_clone/providers/post_provider.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/screens/feed_screen/feed_screen.dart';
import 'package:instagram_clone/screens/post/post_screen.dart';
import 'package:instagram_clone/screens/profile_screen/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen/search_screen.dart';

import 'color.dart';


const widgetlength=600;
const HomeScreen=[
  MyFeedPage(),
 MySearchScreen(),
 MyPostScreen(),
  Center(
    child: Text("fav",
      style: TextStyle(color: primaryColor,fontSize: 20),),
  ),
  ];