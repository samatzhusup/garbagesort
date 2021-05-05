import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbagesort/model/Garbage.dart';
import 'package:garbagesort/model/Product.dart';

class ProductService {
  static final ProductService _categoryService = ProductService._internal();
  Firestore _db = Firestore.instance;

  ProductService._internal();

  factory ProductService() {
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

  Stream<List<Product>> getProduct(String pId) {
    return _db.collection('product').where("pId",isEqualTo: pId).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Product.fromMap(doc.data, doc.documentID),
      ).toList()
    );
  }

}
