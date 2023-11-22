

class MyCommentModel{
  late String profileurl;
  late String name;
  late String commenttext;
  late String commnetid;
  late String uid;
  final  date ;

  MyCommentModel({
    required this.uid,
    required this.commenttext,
    required this.name,
    required this.commnetid,
    required this.date,
    required this.profileurl
});

  Map<String,dynamic> tojson()=>{
    "username":name,
    "profileurl":profileurl,
  "commenttext":commenttext,
  "commentId":commnetid,
  "uid":uid,
  "datetime":date

  };




}