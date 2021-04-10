class Bag {
  String status;
  String bagId;

  Bag({this.status, this.bagId});

  Bag.fromMap(Map<String, dynamic> data, String bagId)
      : status = data['status'],
        bagId= bagId;

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "bagId": bagId,
    };
  }
}
