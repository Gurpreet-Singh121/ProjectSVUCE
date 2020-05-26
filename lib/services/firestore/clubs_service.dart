import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:svuce_app/app/locator.dart';
import 'package:svuce_app/models/club.dart';

class ClubsService {
  static Firestore _firestore = locator<Firestore>();

  static CollectionReference _clubsRef = _firestore.collection("clubs");

  final StreamController<List<Club>> _clubStreamController =
      StreamController<List<Club>>.broadcast();

  Stream getClubs() {
    // Register the handler for when the posts data changes
    _clubsRef.snapshots().listen((snapshots) {
      if (snapshots.documents.isNotEmpty) {
        var posts = snapshots.documents
            .map((snapshot) => Club.fromSnapshot(snapshot))
            .toList();

        // Add the [items] onto the controller
        _clubStreamController.add(posts);
      }
    });

    return _clubStreamController.stream;
  }

  Future followClub(String clubId, String userId) async {
    try {
      await _clubsRef
          .document(clubId)
          .collection("followers")
          .document(userId)
          .setData({
        "id": userId,
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}