import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/mobile_page.dart';
import 'package:instagram_clone/providers/post_provider.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/responsive_layer.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/profile_screen/profile_screen.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/web_page.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_)=> MyProvider()),
        ChangeNotifierProvider(create: (_)=>MyPostProvider())
      ],
        child: MyApp(),

      )

  );

}
      
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      color: Colors.black,
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:
      StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.hasData){
              return MyResponsivelayer(mymobile: MyMobilePage(), myweb: MyWebPage());
            }else if(snapshot.hasError){
              return Center(child: Text("${snapshot.error}"),);
            }else{
              return MyLoginScreen();
            }


          }else if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator(color: primaryColor,));
          }
          return MyLoginScreen();
        },
      )
    );
  }
}

