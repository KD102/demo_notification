import 'package:demo_firebase_notification/service/firebase_service.dart';
import 'package:demo_firebase_notification/login/signUp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final  FirebaseAuthService firebaseService = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LoginPage"),leading: SizedBox(),actions: [ ElevatedButton(onPressed: ()async{
        Get.to(()=>SignUpPage());
      }, child: Text("Sign Up"))],),
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
           await firebaseService.signInWithEmail(emailController.text, passController.text);
          }, child: Text("Enter")) ,
        ],).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}