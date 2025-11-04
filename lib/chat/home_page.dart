// aH0VB7t5q84OsT5slQ5eCCdqmCuLr0vT0o-lx0Nlp20

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase_notification/chat/chat_page.dart';
import 'package:demo_firebase_notification/service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/notification_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"),actions: [IconButton(
        icon: const Icon(
          Icons.logout,
          color: Colors.red,
        ),
        onPressed: () async {
          // await FirebaseAuthService().signOut();
          NotificationService().sendMessage(fCMToken);
        },
      ),],),

      body: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection("users").snapshots(), builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong',
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          );
        }
        return ListView(children: snapshot.data!.docs
            .where((doc) =>
        doc['email'] != FirebaseAuth.instance.currentUser!.email)
            .map<Widget>((doc) => ListTile(
          onTap: (){
            Get.to(() => ChatScreen(receiverEmail:doc['email'] , receiverUserId: doc['uid'] ,receiverFcmToken:  doc['FcmToken'],));
          },
          leading: CircleAvatar(
            backgroundColor:
            Theme.of(context).colorScheme.primaryContainer,
            child: Text(doc['email'][0].toString().toUpperCase() +
                doc['email']
                    .toString()
                    .split('@')[1][0]
                    .toUpperCase()),
          ),
          title: Text(
            doc['email'].toString().split('@')[0][0].toUpperCase() +
                doc['email']
                    .toString()
                    .split('@')[0]
                    .substring(1)
                    .toLowerCase(),

          ),
          subtitle: Text(
            doc['email'],

          ),
        ))
            .toList(),);
      },),
    );
  }
}
