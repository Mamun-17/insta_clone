import 'package:cloud_firestore/cloud_firestore.dart';

class MyPostModel
{
  late String description;
  late String uid;
  late String username;
  late String postId;
  late String posturl;
  late String  profImage;
  final datetimepublished;
  final likes;

  MyPostModel({
    required this.description,
    required this.uid,
    required this.datetimepublished,
    required this.username,
    required this.postId,
    required this.posturl,
    required this.profImage,
    required this.likes
  });
  Map<String, dynamic> tojson()=>{
   "description": description,
    "uid":uid,
    "datetimepublished":datetimepublished,
    "username":username,
    "postId":postId,
    "posturl":posturl,
    "profImage":profImage,
    "likes":likes
  };

  static MyPostModel FromSnap(DocumentSnapshot snap){
    var snapshot=snap.data() as Map<String,dynamic>;

    return MyPostModel(
      description: snap["description"],
      uid: snap["uid"],
      datetimepublished: snap["datetimepublished"],
      username: snap["username"],
      postId: snap["postId"],
      posturl: snap["posturl"],
      profImage: snap["profImage"],
      likes: snap["likes"]

    );


  }

}