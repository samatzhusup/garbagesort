class User {
  final String email;
  final String name;
  final String surname;
  final String type;
  final int point;
  final String uid;

  User({this.email, this.name, this.surname,this.type,this.point, this.uid});

  User.fromMap(Map<String,dynamic> data, String uid):
        email=data["email"],
        name=data['name'],
        surname=data['surname'],
        type=data['type'],
        point=data['point'],
        uid=uid;

  Map<String, dynamic> toMap() {
    return {
      "email" : email,
      "name":name,
      "surname":surname,
      "type":type,
      "point":point,
    };
  }
}