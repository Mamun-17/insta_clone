import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/chat_model.dart';
import 'package:instagram_clone/models/comment_model.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/screens/post/post_screen.dart';
import 'package:uuid/uuid.dart';

class MyPostProvider extends ChangeNotifier {
   Uint8List? postImage;
MyProvider pro=MyProvider();
FirebaseFirestore store=FirebaseFirestore.instance;
late bool isAnimating=false;
late bool isloading=false;
late bool isusersearch=false;
int profilepostlength=0;
   //int commentlength=0;
   bool isFollowing=false;
   late int NumberOfFollowers=0;
   late int Numberoffollowing=0;
   late var personalchatid=null;

  PickImage()async{
    ImagePicker pickimage=ImagePicker();
    XFile? myfile= await pickimage.pickImage(source: ImageSource.gallery);
    if(myfile!=null){
      postImage = await myfile.readAsBytes();
     notifyListeners();


    }
    else{
      print("image is not selected");
    }


  }

  void clearpostimage(){
    postImage=null;
    notifyListeners();
  }

   Future<void>adData()async{
    await pro.GetUserDetails();
  }


Future<String> UploadPost(
    String username,
    String uid,
    String profImageurl,
    Uint8List postImage,
    String description,

    )async{

    String res="some errror occured";
    isloading=true;
    notifyListeners();
    try{


      String postPhotoUrl= await pro.UploadImagetoStorage("posts", true,postImage );

    String postId=Uuid().v1();

      MyPostModel mypostmodel=MyPostModel(
          description: description,
          uid: uid,
          datetimepublished: DateTime.now(),
          username: username,
          postId: postId,
          posturl: postPhotoUrl,
          profImage: profImageurl,
          likes: []
      );

      await store.collection("posts").doc(postId).set(mypostmodel.tojson());

      res="posted successfully";






    }catch(err){

      res=err.toString();

    }
    isloading=false;
    notifyListeners();
    return res;


}

 Animationtrue(){
  isAnimating=true;
  notifyListeners();

}
Animationfalse(){
    isAnimating=false;
    notifyListeners();
}

Future<void> likefunction(String postId,String uid,List likes)async {
try{
  if(likes.contains(uid)){
    await store.collection('posts').doc(postId).update({
    'likes':FieldValue.arrayRemove([uid])
    });
  }
  else{
    await store.collection('posts').doc(postId).update({
      'likes':FieldValue.arrayUnion([uid])
    });
  }
}catch(err){
  print(err);
}
}



Future<String> PostComment(String postId,String text,String name,String uid,String profurl )async{
    String res="something went wrong";
    try{
     if(text.isNotEmpty){
       String commentId=Uuid().v1();
       MyCommentModel mycommentmodel =MyCommentModel(uid: uid,
           commenttext: text,
           name: name,
           commnetid: commentId,
           date:DateTime.now(),
           profileurl: profurl);
       await store.collection("posts").doc(postId).collection("comments").doc(commentId).set(mycommentmodel.tojson());

       res='comment successfull';
     }else{
       res="text is empty";
     }
      return res;


    }catch(err){
      print(err.toString());
      res=err.toString();
      return res;

    }
}

 Future<void>DeletePost(String posId)async{
    try{
      await store.collection('posts').doc(posId).delete();

    }catch(err){
      print(err.toString());
    }
 }


 MakingSearchUerTrue(){
    isusersearch=true;
    notifyListeners();
 }
 MakingSearchUerFalse(){
     isusersearch=false;
     notifyListeners();
   }

   Future<void>ShowProfilePostLength(String UID)async{
    try{
       QuerySnapshot postsnap= await store.collection('posts').where('uid',isEqualTo: UID).get();
       profilepostlength=postsnap.docs.length;
       notifyListeners();
    }catch(err){
      print(err.toString());
    }

   }


   Future<void>FollowingAndUnFollowingAccount(String uid,String followId)async{

    try{
    DocumentSnapshot  shot= await store.collection('myusers').doc(followId).get();
  List followerslist=  (shot.data()! as dynamic)['followers'];
  if(followerslist.contains(uid)){
   await store.collection("myusers").doc(followId).update({
      'followers':FieldValue.arrayRemove([uid]),
    });
    await store.collection('myusers').doc(uid).update({
      'following':FieldValue.arrayRemove([followId])
    });
    isFollowing=false;
    NumberOfFollowers--;
    notifyListeners();
  }
  else{
    await store.collection('myusers').doc(followId).update({
      'followers':FieldValue.arrayUnion([uid]),
    });
    await store.collection('myusers').doc(uid).update({
      'following':FieldValue.arrayUnion([followId])
    });
    isFollowing=true;
    NumberOfFollowers++;
    notifyListeners();
  }
    
    }catch(err){
      print(err.toString());
    }
   }

   Future<void> FollowerFollowingNumber(String followId,String uid)async{
 try{
   DocumentSnapshot  snapOne=await store.collection('myusers').doc(followId).get();
   // DocumentSnapshot snaptwo=await store.collection('myusers').doc(uid).get();
   NumberOfFollowers=(snapOne.data()! as dynamic)['followers'].length;
   Numberoffollowing=(snapOne.data()! as dynamic)['following'].length;
   List followerList=(snapOne.data()! as dynamic)['followers'];
   notifyListeners();
   if(followerList.contains(uid)){
     isFollowing=true;
     notifyListeners();
   }else{
     isFollowing=false;
     notifyListeners();
   }
 }catch(err){
   print(err.toString());
 }

   }

   Future<String>PostingMessage(String sendingto,String message)async{
    String res ='message sent';

    try{
      QuerySnapshot snapOne= await store.collectionGroup('PairMessage')
          .where('from',isEqualTo: sendingto)
          .where('to', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();


      QuerySnapshot snapTwo= await store.collectionGroup('PairMessage')
          .where('from',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('to', isEqualTo: sendingto).get();


      String pairmessageid=Uuid().v1();




      if(snapOne.docs.length==0  && snapTwo.docs.length==0){
        String messageid=Uuid().v1();

        MyChatModel mychatmodel=MyChatModel(

            from: FirebaseAuth.instance.currentUser!.uid,
            message: message,
            date: DateTime.now(),
            to: sendingto, docid: messageid);


        await store.collection('messages').doc(messageid).collection('PairMessage').doc(pairmessageid).set(mychatmodel.tojson());
        //print(snapOne.docs.toString());

      }

      else if(snapOne.docs.length!=0){
        String mydoc= snapOne.docs[0]['docid'].toString();

        MyChatModel mychatmodel=MyChatModel(

            from: FirebaseAuth.instance.currentUser!.uid,
            message: message,
            date: DateTime.now(),
            to: sendingto, docid: mydoc);

        await store.collection('messages').doc(mydoc).collection('PairMessage').doc(pairmessageid).set(mychatmodel.tojson());
        print(mydoc);
      }

      else if(snapTwo.docs.length!=0 ){
        String mydoc=snapTwo.docs[0]['docid'].toString();
        MyChatModel mychatmodel=MyChatModel(

            from: FirebaseAuth.instance.currentUser!.uid,
            message: message,
            date: DateTime.now(),
            to: sendingto, docid: mydoc);

        //String mydoc=snapTwo.docs[0]['docid'].toString();
        await store.collection('messages').doc(mydoc).collection('PairMessage').doc(pairmessageid).set(mychatmodel.tojson());
        print(mydoc);
      }else{}
      return res;


    }catch(err){
      print(err.toString());
      res='something wrong';
      return res;
    }


   }


Future<void> GettingPersonalChatInfo(String toUid)async{
  QuerySnapshot snapOne= await store.collectionGroup('PairMessage')
      .where('from',isEqualTo: toUid)
      .where('to', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();


  QuerySnapshot snapTwo= await store.collectionGroup('PairMessage')
      .where('from',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('to', isEqualTo: toUid).get();
  if(snapOne.docs.length!=0){
    personalchatid=snapOne.docs[0]['docid'].toString();
    notifyListeners();
  }
  else if(snapTwo.docs.length!=0){
    personalchatid=snapTwo.docs[0]['docid'].toString();
    notifyListeners();
  }
  else{}

  
}


bool turningvariablenull(){
    personalchatid=null;
    notifyListeners();
    return true;

}

}