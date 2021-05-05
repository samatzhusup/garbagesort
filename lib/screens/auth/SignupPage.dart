import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbagesort/util/display_alert.dart';
import 'package:intl/intl.dart';

import '../HomePage.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isHidden = true;
  bool isPass = false;
  String selectedName = "";
  var member = false;
  var isLoading = false;

  static String validNumber = r'(^(?:[+0]9)?[0-9]{10}$)';
  static String validEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  RegExp regValidNumber = new RegExp(validNumber);
  RegExp regEmail = new RegExp(validEmail);

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.white,
            appBar: _appbar(),
            body: MediaQuery.of(context).size.width > 800
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        _body(context, size)
                      ],
                    ),
                  )
                : _body(context, size)),
        isLoading ? showProgress(context) : Container()
      ],
    );
  }

  Widget _body(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _titleText(),
              _subtitle(),
              _textFormField(
                size: size,
                hintText: "Name",
                controller: _nameController,
                icon: Icons.person,
                type: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty || value.trim().isEmpty) {
                    return "Please Enter Your Name";
                  }
                  return null;
                },
              ),
              _textFormField(
                size: size,
                hintText: "Surname",
                controller: _surnameController,
                icon: Icons.person,
                type: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty || value.trim().isEmpty) {
                    return "Please Enter Your Surname";
                  }
                  return null;
                },
              ),
              _textFormField(
                size: size,
                controller: _emailController,
                hintText: "Email ID",
                icon: Icons.email,
                type: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty || value.trim().isEmpty) {
                    return "Please Enter Email id";
                  } else if (!regEmail.hasMatch(value.trim())) {
                    return "Please Enter Valid Email id";
                  }
                  return null;
                },
              ),
              _passTextField(size),
              signInButton(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return AppBar(
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _titleText() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "Signup",
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _subtitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "Welcome aboard! Please Enter All Details to Complate Process",
        //  textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.caption.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _passTextField(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _isHidden,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
          ),
          suffixIcon: GestureDetector(
            child: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
            onTap: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Please Enter Password";
          } else if (value.length < 6) {
            return "password should be at least 6 characters long";
          }
          return null;
        },
      ),
    );
  }

  Widget _textFormField(
      {TextEditingController controller,
      Size size,
      String hintText,
      IconData icon,
      TextInputType type,
      String validator(String)}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: TextFormField(
            controller: controller,
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 16.0,
                ),
            keyboardType: type,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            validator: validator));
  }

  Widget signInButton(Size size) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: MaterialButton(
            shape: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8)),
            color: Colors.blue,
            height: 50,
            minWidth: double.infinity,
            child: Text(
              "Signup",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              loadProgress();
              DateTime now = DateTime.now();
              String cratedDate =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

              if (_formKey.currentState.validate()) {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text)
                    .then((currentUser) => Firestore.instance
                        .collection("users")
                        .document(currentUser.uid)
                        .setData({
                          "uid": currentUser.uid,
                          "name": _nameController.text.trim(),
                          "surname": _nameController.text.trim(),
                          "email": _emailController.text.trim(),
                          "point": 0,
                          "created": cratedDate
                        })
                        .then((result) => {
                              Firestore.instance.collection("clinetbag").add({
                                "uid": currentUser.uid,
                                "type": "plastic",
                                "qrId": "none",
                                "status": "home",
                                "created": cratedDate,
                              }).then((value) {
                                Firestore.instance.collection("clinetbag").add({
                                  "uid": currentUser.uid,
                                  "type": "glass",
                                  "qrId": "none",
                                  "status": "home",
                                  "created": cratedDate,

                                }).then((value) {
                                  Firestore.instance
                                      .collection("clinetbag")
                                      .add({
                                    "uid": currentUser.uid,
                                    "type": "paper",
                                    "qrId": "none",
                                    "status": "home",
                                    "created": cratedDate,

                                  }).then((value) {
                                    Firestore.instance
                                        .collection("clinetbag")
                                        .add({
                                      "uid": currentUser.uid,
                                      "type": "organic",
                                      "qrId": "none",
                                      "status": "home",
                                      "created": cratedDate,

                                    }).then((value) {
                                      Firestore.instance
                                          .collection("clinetbag")
                                          .add({
                                        "uid": currentUser.uid,
                                        "type": "metal",
                                        "qrId": "none",
                                        "status": "home",
                                        "created": cratedDate,

                                      }).then((value) {
                                        Firestore.instance
                                            .collection("clinetbag")
                                            .add({
                                          "uid": currentUser.uid,
                                          "type": "e-waste",
                                          "qrId": "none",
                                          "status": "home",
                                          "created": cratedDate,

                                        }).then((value) {
                                          Navigator.pop(context);
                                        }).catchError((e) {
                                          print(e);
                                        });
                                      }).catchError((e) {
                                        print(e);
                                      });
                                    }).catchError((e) {
                                      print(e);
                                    });
                                  }).catchError((e) {
                                    print(e);
                                  });
                                }).catchError((e) {
                                  print(e);
                                });
                              }).catchError((e) {
                                print(e);
                              })
                            })
                        .catchError((err) => print(err)))
                    .catchError((err) => print(err));
              }
            }),
      ),
    );
  }

  stopProgress() {
    setState(() {
      isLoading = false;
    });
    print("loading");
  }

  loadProgress() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
