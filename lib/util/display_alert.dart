import 'package:flutter/material.dart';

Widget showProgress(BuildContext context) {
  return Container(
    color: Colors.black.withOpacity(0.5),
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 1,
    child: Center(child: CircularProgressIndicator()),
  );
}
