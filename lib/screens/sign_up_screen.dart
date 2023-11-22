import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/mobile_page.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/responsive_layer.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/web_page.dart';
import 'package:instagram_clone/widget/snackbar.dart';
import 'package:instagram_clone/widget/textfield.dart';
import 'package:provider/provider.dart';

class MySignUpScreen extends StatefulWidget {
  const MySignUpScreen({Key? key}) : super(key: key);

  @override
  State<MySignUpScreen> createState() => _MySignUp_ScreenState();
}

class _MySignUp_ScreenState extends State<MySignUpScreen> {
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController namecontroller=TextEditingController();
  TextEditingController biocontroller=TextEditingController();
  void ClearController(){
    namecontroller.clear();
    passwordcontroller.clear();
    emailcontroller.clear();
    biocontroller.clear();
  }
  @override

  void dispose() {

    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    biocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Consumer<MyProvider>(
        builder: (context,mp,_) {
          return Scaffold(

                backgroundColor: Colors.black,

                body:  SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30,right: 30),
                          child: Column(

                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),

                                  SvgPicture.asset('assets/ic_instagram.svg',color: primaryColor,height: 64,),
                                  SizedBox(
                                    height: 64,
                                  ),
                                  Stack(
                                    children: [

                                      mp.selectedImage!=null?CircleAvatar(
                                          radius: 64,
                                          backgroundImage:MemoryImage( mp.selectedImage!)
                                      ):CircleAvatar(
                                          radius: 64,
                                          backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt1ceyneFkZchgkrwN7dZxWNl_C5Dctvc5BzNh_rEzPQ&s")
                                      ),
                                      Positioned(
                                        bottom: 7,
                                        left: 100,
                                        child: GestureDetector(
                                          onTap: ()async{
                                         await mp.PickImage();


                                          },
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  MyTextField(inputtype: TextInputType.text,
                                    hinttext: "Enter your Username",
                                    controlOne: namecontroller, isPass: false, ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  MyTextField(inputtype: TextInputType.emailAddress,
                                    hinttext: "Enter your Email",
                                    controlOne: emailcontroller, isPass: false, ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  MyTextField(inputtype: TextInputType.text,
                                    hinttext: "Enter your Password",
                                    controlOne: passwordcontroller, isPass: true
                                    ,),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  MyTextField(inputtype: TextInputType.text,
                                    hinttext: "Enter your Bio",
                                    controlOne: biocontroller, isPass: false, ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  GestureDetector(
                                    onTap:() async {

                                     if(mp.selectedImage!=null){
                                       String res= await mp.SignUpUser(
                                           image: mp.selectedImage!,
                                           username: namecontroller.text,
                                           email: emailcontroller.text,
                                           password: passwordcontroller.text,
                                           bio: biocontroller.text);
                                       if(res!="success") {
                                         snackbar(res.toString(), context);

                                            }
                                      else{
                                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyResponsivelayer(mymobile: MyMobilePage(), myweb: MyWebPage())));
                                         snackbar(res.toString(), context);
                                       }
                                       ClearController();

                                       print(res);

                                     }
                                     else{
                                       snackbar("Image is not selected", context);
                                     }

                                    },
                                    child: Container(

                                      child: mp.issignup==true? Center(child: Text("Sign up",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold
                                        ),)): Center(child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),),

                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 13),
                                      decoration: BoxDecoration(

                                          color: blueColor,
                                          borderRadius: BorderRadius.circular(3)

                                      ),
                                    ),
                                  ),
                               SizedBox(
                                 height: 115,
                               ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Didn't have an account ?",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyLoginScreen()));
                                        },
                                        child: Text("Log in.",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 24,)

                                ],
                              ),
                        ),
                      ),


                       ),

            );
        }
      ),
    );
    
  }
}

