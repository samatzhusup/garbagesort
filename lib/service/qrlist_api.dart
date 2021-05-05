import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbagesort/model/Garbage.dart';
import 'package:garbagesort/model/Product.dart';
import 'package:garbagesort/model/Qrlist.dart';

class QrListService {
  static final QrListService _listService = QrListService._internal();
  Firestore _db = Firestore.instance;

  QrListService._internal();

  factory QrListService() {
    return _listService;
  }

  Future<void> updateStatus(String bagId,status) async {
    Firestore.instance.collection("qrlist").document(bagId).updateData(status).catchError((e) {
      print(e);
    });
  }

  Stream<List<Qrlist>> getQrList (String qId) {
    return _db.collection('qrlist').where("qId",isEqualTo: qId).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Qrlist.fromMap(doc.data, doc.documentID),
      ).toList()
    );
  }

}
