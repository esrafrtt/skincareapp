import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getRoutinesStream() {
    return _db.collection('routines').snapshots();
  }

  Future<void> addRoutine(String routine) {
    return _db
        .collection('routines')
        .add({'routine': routine, 'isChecked': false});
  }

  Future<void> updateRoutine(String docID, String routine) {
    return _db.collection('routines').doc(docID).update({'routine': routine});
  }

  Future<void> updateRoutineStatus(String docID, bool isChecked) {
    return _db
        .collection('routines')
        .doc(docID)
        .update({'isChecked': isChecked});
  }

  Future<void> deleteRoutine(String docID) {
    return _db.collection('routines').doc(docID).delete();
  }

  Stream<QuerySnapshot> getDailyStatusStream() {
    return _db.collection('dailyStatus').snapshots();
  }

  Future<void> updateDailyStatus(DateTime date, int completedSteps) {
    String dateString = date.toIso8601String().split('T')[0];
    if (kDebugMode) {
      print('Updating daily status for $dateString with $completedSteps steps');
    }
    return _db
        .collection('dailyStatus')
        .doc(dateString)
        .set({'date': dateString, 'completedSteps': completedSteps});
  }
}
