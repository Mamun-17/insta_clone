


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/color.dart';
import 'package:instagram_clone/mobile_page.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/widget/snackbar.dart';
import 'package:instagram_clone/widget/textfield.dart';
import 'package:provider/provider.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({Key? key}) : super(key: key);

  @override
  State<MyLoginScreen> createState() => _MyLogin_ScreenState();
}

class _MyLogin_ScreenState extends State<MyLoginScreen> {
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  @override
  void dispose() {
  emailcontroller.dispose();
  passwordcontroller.dispose();
    super.dispose();
  }

  void clearcontrller(){
    emailcontroller.clear();
    passwordcontroller.clear();
}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Consumer<MyProvider>(
        builder: (context,np,_) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
                child:Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     Flexible(child: Container(),flex: 2,),
                      SvgPicture.asset('assets/ic_instagram.svg',color: primaryColor,height: 64,),
                      SizedBox(
                        height: 64,
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
                      GestureDetector(
                        onTap: ()async{
                         String result= await np.LoginUser(emailcontroller.text, passwordcontroller.text,context);

                         snackbar(result.toString(), context);
                         clearcontrller();
                        },
                        child: Container(
                          child: np.isloading==true?Center(child: Text("Log In",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold
                          ),))
                              :
                          Center(child: CircularProgressIndicator(color: primaryColor,),),

                          width: double.infinity,
                         padding: EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(3)

                          ),
                        ),
                      ),
                     Flexible(child: Container(),flex: 2,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Didn't have an account ?",
                          style: TextStyle(
                            color: Colors.white
                          ),),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MySignUpScreen()));
                            },
                            child: Text("Sign Up.",
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

                ) )
          );
        }
      ),
    );
  }
}

