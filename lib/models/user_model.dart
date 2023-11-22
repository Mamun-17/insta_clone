
import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
 late String username;
   late String email;
  late String bio;
  late String password;
  late String uid;
  late List followers;
  late List following;
  late String url;

  Users({
   required this.password,
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.url
});
  Map<String, dynamic> tojson()=>{
 "username":username,
 "email":email,
 "password":password,
 "bio":bio,
 "uid":uid,
 "followers":[],
 "following":[],
 "photourl":url
 };

 static Users FromSnap(DocumentSnapshot snap){
     var snapshot=snap.data() as Map<String,dynamic>;

     return Users(password: snapshot['password'],
         uid: snapshot['uid']
         , email: snapshot['email']
         , username: snapshot['username']
         , bio: snapshot['bio']
         , followers: snapshot['followers']
         , following: snapshot['following']
         , url: snapshot['photourl']);


  }

}