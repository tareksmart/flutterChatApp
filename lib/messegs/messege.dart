


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messege extends StatelessWidget {
  const Messege({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat').orderBy('createdAt',descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            final doc = snapshot.data?.docs;

            return ListView.builder(reverse: true,
                itemCount: doc?.length,
                itemBuilder: (ctx, index) => Container(
                      child: Text(doc![index]['text']),
                    ));
          });
  }
}
