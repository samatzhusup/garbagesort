class Product {
  String name;
  String pImage;
  String type;
  String weight;
  String pid;

  Product(
      {this.name,
      this.pImage,
      this.type,
      this.weight,
      this.pid});

  Product.fromMap(Map<String, dynamic> data, String pid)
      : name = data['name'],
        pImage = data['pImage'],
        type = data['type'],
        weight = data['weight'],
        pid = pid;

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "pImage": pImage,
      "type": type,
      "weight": weight,
      "pid": pid
    };
  }
}
