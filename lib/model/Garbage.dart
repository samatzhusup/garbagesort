class Garbage {
  String status;
  String bagId;
  List garbageList = [];
  String uid;
  String qrId;
  String type;
  String created;
  String updated;

  Garbage(
      {this.status,
      this.bagId,
      this.garbageList,
      this.uid,
      this.qrId,
      this.type,
      this.created,
      this.updated});

  Garbage.fromMap(Map<String, dynamic> data, String bagId)
      : status = data['status'],
        created = data['created'],
        garbageList = data['garbageList'],
        uid = data['uid'],
        qrId = data['qrId'],
        type = data['type'],
        updated = data['updated'],
        bagId = bagId;

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "bagId": bagId,
      "garbageList": garbageList,
      "uid": uid,
      "qrId": qrId,
      "type": type,
      "created": created,
      "updated": updated,
    };
  }
}
