class Qrlist {
  String qId;
  String status;
  String type;
  String forr;
  String uId;

  Qrlist(
      {this.qId,
      this.status,
      this.type,
      this.forr,
      this.uId});

  Qrlist.fromMap(Map<String, dynamic> data, String qId)
      : uId = data['uId'],
        status = data['status'],
        type = data['type'],
        forr = data['forr'],
        qId = qId;

  Map<String, dynamic> toMap() {
    return {
      "qId": qId,
      "status": status,
      "type": type,
      "forr": forr,
      "uId": uId
    };
  }
}
