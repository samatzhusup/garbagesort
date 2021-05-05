import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbagesort/model/User.dart';

class UserService {
  static final UserService _userService =
  UserService._internal();
  Firestore _db = Firestore.instance;

  UserService._internal();

  factory UserService() {
    return _userService;
  }

  Stream<List<User>> getUser() {
    return _db.collection('users').orderBy("point",descending: true).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => User.fromMap(doc.data, doc.documentID),
          ).toList(),
        );
  }

  Stream<List<User>> getSingleUser(String uid) {
    return _db.collection('users').where("uid",isEqualTo: uid).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => User.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Future<void> updatePoint(String userId,status) async {
    Firestore.instance.collection("users").document(userId).updateData(status).catchError((e) {
      print(e);
    });
  }


  Stream<DocumentSnapshot> getGarbageList (String uid) {
    return _db.collection('users').document(uid).snapshots();
  }

  Future<void> updateMyCourse (updateuser,String uid) {
    return _db.collection('users').document(uid).updateData(updateuser);
  }

}
