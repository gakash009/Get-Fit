import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getfit_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final uid = user!.uid;
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data?.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs!.length,
                itemBuilder: (context, index) => MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['userId'] == uid,
                  ValueKey(chatDocs[index].id),
                  //chatDocs[index]['userId'],
                  //newCodeBelow
                  chatDocs[index]['username'],
                  chatDocs[index]['userImage'],
                ),
              );
            });
      },
    );
  }
}
