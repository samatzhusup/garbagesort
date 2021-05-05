import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbagesort/model/Garbage.dart';

class GarbageBagService {
  static final GarbageBagService _categoryService = GarbageBagService._internal();
  Firestore _db = Firestore.instance;

  GarbageBagService._internal();

  factory GarbageBagService() {
    return _categoryService;
  }

  Future<void> createBag(String bagId,status) async {
    Firestore.instance.collection("garbagebag").document(bagId).updateData(status).catchError((e) {
      print(e);
    });
  }

  Future<void> updateStatus(String bagId,status) async {
    Firestore.instance.collection("garbagebag").document(bagId).updateData(status).catchError((e) {
      print(e);
    });
  }

  Stream<List<Garbage>> getClientGarbageBag(String clientId) {
    return _db.collection('garbagebag').where("clientId",isEqualTo: clientId).snapshots().map(
            (snapshot) => snapshot.documents.map(
              (doc) => Garbage.fromMap(doc.data, doc.documentID),
        ).toList()
    );
  }

  Stream<List<Garbage>> getGarbageBag(String bagId) {
    return _db.collection('garbagebag').where("bagId",isEqualTo: bagId).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Garbage.fromMap(doc.data, doc.documentID),
      ).toList()
    );
  }

}
