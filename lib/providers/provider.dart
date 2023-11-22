

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/mobile_page.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/responsive_layer.dart';
import 'package:instagram_clone/web_page.dart';
import 'package:uuid/uuid.dart';


class MyProvider extends ChangeNotifier{

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore store=FirebaseFirestore.instance;
FirebaseStorage storage=FirebaseStorage.instance;
Uint8List? selectedImage;
int mobilePageRender=0;


 Users? myuser;
bool isloading=true;
bool issignup=true;
 Future<String>SignUpUser({ required String username,
   required String email,
   required String password,
   required String bio,
   required Uint8List image
 }
     )async{
   String response="some error occured";

   issignup=false;
   notifyListeners();

   try{

     if(username.isNotEmpty||email.isNotEmpty||password.isNotEmpty||bio.isNotEmpty|| image!=null){
      UserCredential cred = await auth.createUserWithEmailAndPassword(email: email, password: password);

      String downloadedurl= await UploadImagetoStorage("ProfilePics", false, image);

      Users myuser=Users(password: password,
          uid: cred.user!.uid,
          email: email,
          username: username,
          bio: bio,
          followers:[],
          following: [], url:downloadedurl );

     await store.collection("myusers").doc(cred.user!.uid).set(myuser.tojson());
     response="success";

     }
     else{
       print(response);
     }


   }catch(err){
     response=err.toString();

   }
   issignup =true;
   notifyListeners();
   return response;
 }

 void OnIconColorChangedOfMobilePage(int num){
   mobilePageRender=num;
   notifyListeners();
 }

  PickImage()async{
   ImagePicker pickimage=ImagePicker();
   XFile? myfile= await pickimage.pickImage(source: ImageSource.gallery);
   if(myfile!=null){
     selectedImage = await myfile.readAsBytes();
     notifyListeners();

     return  selectedImage;

   }
   else{
     print("image is not selected");
   }

 }


 Future<String>UploadImagetoStorage(String childname,bool isPost,Uint8List file)async{
  Reference reference=storage.ref().child(childname).child(auth.currentUser!.uid);
  if(isPost==true){
    String id=Uuid().v1();
    reference =reference.child(id);
  }else{}
  UploadTask uploadtask = reference.putData(file);

  TaskSnapshot snap= await uploadtask;
  String url = await snap.ref.getDownloadURL();
  return url;
 }

 Future<String>LoginUser(String email,String password,BuildContext context)async{
   String res;
   isloading=false;
   notifyListeners();

  try{
    if(email.isNotEmpty||password.isNotEmpty){
      UserCredential cred= await auth.signInWithEmailAndPassword(email: email, password: password);
      res="successfull login";
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyResponsivelayer(mymobile: MyMobilePage(), myweb: MyWebPage())));

      isloading=true;
      notifyListeners();
      return res;
    }
    else{
      res="please enter all the fields";
      isloading=true;
      notifyListeners();
      return res;
    }

  }
  catch(err){
    res=err.toString();
    isloading=true;
    notifyListeners();
    return res;
  }

 }



 Future<void> GetUserDetails()async{
  try{
    User? currentuser = auth.currentUser;
    DocumentSnapshot snap =  await store.collection("myusers").doc(currentuser!.uid).get();
    myuser= Users.FromSnap(snap);
    notifyListeners();
  }catch(err){
    print(err.toString());
  }

 }




Future<String> SignOut()async{
   String res;
 try{
   await auth.signOut();
   res="successfully logged out";
   return res;
 }catch(err){
   print(err.toString());
   res=err.toString();
   return res;
 }

}



}