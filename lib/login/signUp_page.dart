
import 'package:demo_firebase_notification/service/firebase_service.dart';
import 'package:demo_firebase_notification/login/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final  FirebaseAuthService firebaseService = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignUp Page"),leading: SizedBox(),actions: [ElevatedButton(onPressed: (){
        Get.to(()=>LoginPage());
      }, child: Text("Login"))],),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          TextFormField(
            controller: emailController,
            decoration:  InputDecoration(label: Text("Email")),
          ) ,TextFormField(
            controller: passController,
            decoration:  InputDecoration(label: Text("PassWord")),
          ),

          ElevatedButton(onPressed: ()async{
            await firebaseService.signUpEmailWithPass(emailController.text, passController.text);
          }, child: Text("Enter")) ,
        ],).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}