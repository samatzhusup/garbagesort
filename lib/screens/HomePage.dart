import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'ScannnerPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Center(
        child: Text("GG"),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child: Icon(Icons.qr_code_scanner_rounded),
              label: "Scan Garbage Bag",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ScannnerPage()))),
          SpeedDialChild(
            child: Icon(Icons.qr_code_scanner),
            label: "Scan Garbage",
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ScannnerPage()))
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Add Garbage",
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) =>
            //             CreateAssignmentLesson(courseId: widget.courseId)))
          ),
        ],
      ),
    );
  }
}
