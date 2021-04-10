import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbagesort/model/Bag.dart';

class GarbageBagService {
  static final GarbageBagService _categoryService = GarbageBagService._internal();
  Firestore _db = Firestore.instance;

  GarbageBagService._internal();

  factory GarbageBagService() {
    return _categoryService;
  }

  Future<void> addCategory(blogData) async {
    Firestore.instance.collection("hometags").add(blogData).catchError((e) {
      print(e);
    });
  }

  Stream<List<Bag>> getGarbageBag(String bagId) {
    return _db.collection('garbagebag').where("bagId",isEqualTo: bagId).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Bag.fromMap(doc.data, doc.documentID),
      ).toList()
    );
  }

}
