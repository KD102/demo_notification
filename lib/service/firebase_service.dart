import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase_notification/chat/home_page.dart';
import 'package:demo_firebase_notification/login/loginPage.dart';
import 'package:demo_firebase_notification/service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat/chat_Model.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final NotificationService notificationService = NotificationService();

  Future<void> signUpEmailWithPass(String emailAddress, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      final data = {
        "email": credential.user?.email,
        "uid": credential.user?.uid,
        "FcmToken": fCMToken,
      };

      await firestore.collection("users").doc(credential.user?.uid).set(data);
      print("this is call 11");
      Get.to(() => HomePage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar("The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInWithEmail(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      final data = {
        "email": credential.user?.email,
        "uid": credential.user?.uid,
        "FcmToken": fCMToken,
      };

      await firestore
          .collection("users")
          .doc(credential.user?.uid)
          .update(data);
      print("this is call 00");
      Get.to(() => HomePage());
    } on FirebaseAuthException catch (e) {
      print("e.code: ${e.code}");
      if (e.code == 'user-not-found') {
        showSnackBar('No user found for that email');
      } else if (e.code == 'wrong-password') {
        showSnackBar('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        showSnackBar('No user found for that email Sign up first');
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    Get.to(() => LoginPage());
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
  String message,
) {
  return ScaffoldMessenger.of(
    Get.context!,
  ).showSnackBar(SnackBar(content: Text(message)));
}

class FirebaseChatService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String message,
    required String email,
  }) async {
    final Timestamp timestamp = Timestamp.now();
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;

    List<String> chatId = [currentUserId, email];
    chatId.sort();
    await _fireStore
        .collection('chat')
        .doc(chatId.join("*"))
        .collection('messages')
        .add(
          MessageModel(
            message: message,
            receiverId: email,
            timestamp: timestamp,
            senderId: currentUserId,
            senderEmail: currentUserEmail,
          ).toMap(),
        );
  }

  Stream<QuerySnapshot> getMessages({
    required String currentUserId,
    required String receiverUserId,
  }) {
    List<String> chatId = [currentUserId, receiverUserId];
    chatId.sort();

    return _fireStore
        .collection('chat')
        .doc(chatId.join("*"))
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
