// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:going_live/providers/user_providers.dart';
import 'package:going_live/resources/storage_methods.dart';
import 'package:going_live/utils/utils.dart';
import 'package:provider/provider.dart';

import '../model/livestream.dart';

class FirestoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final StorageMethods storageMethods = StorageMethods();

  Future<String> startLiveStream(
      BuildContext context, String title, Uint8List? image) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String channelId = '';
    try {
      if (title.isNotEmpty && image != null) {
        if (!((await firestore
                .collection("live stream")
                .doc("${user.user.uid}${user.user.username}")
                .get())
            .exists)) {
          String thumbnailUrl = await storageMethods.uploadImageToStorage(
            "live stream-thumbnails",
            image,
            user.user.uid,
          );
          channelId = "${user.user.uid}${user.user.username}";
          LiveStream liveStream = LiveStream(
            title: title,
            image: thumbnailUrl,
            uid: user.user.uid,
            username: user.user.username,
            viewers: 0,
            channelId: channelId,
            startedAt: DateTime.now(),
          );
          firestore
              .collection("live stream")
              .doc(channelId)
              .set(liveStream.toMap());
        } else {
          showSnackBar(context, "Tow Live Stream Can't Start ");
        }
      } else {
        showSnackBar(context, "Please enter all fields ");
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
      print(e);
    }
    return channelId;
  }

  //  Future<void> chat(String text, String id, BuildContext context) async {
  //   final user = Provider.of<UserProvider>(context, listen: false);

  //   try {
  //     String commentId = const Uuid().v1();
  //     await firestore
  //         .collection('live stream')
  //         .doc(id)
  //         .collection('comments')
  //         .doc(commentId)
  //         .set({
  //       'username': user.user.username,
  //       'message': text,
  //       'uid': user.user.uid,
  //       'createdAt': DateTime.now(),
  //       'commentId': commentId,
  //     });
  //   } on FirebaseException catch (e) {
  //     showSnackBar(context, e.message!);
  //   }
  // }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await firestore.collection('live stream').doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> endLiveStream(String channelId) async {
    try {
      QuerySnapshot snap = await firestore
          .collection('live stream')
          .doc(channelId)
          .collection('comments')
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        await firestore
            .collection('live stream')
            .doc(channelId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }
      await firestore.collection('live stream').doc(channelId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
