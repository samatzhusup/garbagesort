import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garbagesort/model/Product.dart';
import 'package:garbagesort/model/Qrlist.dart';
import 'package:garbagesort/service/garbagebag_api.dart';
import 'package:garbagesort/service/product_api.dart';
import 'package:garbagesort/service/qrlist_api.dart';
import 'package:garbagesort/service/user_api.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'HomePage.dart';

class ScannnerPage extends StatefulWidget {
  String check;
  String bagId;
  String type;

  ScannnerPage({this.check, this.bagId, this.type});

  @override
  _ScannnerPageState createState() => _ScannnerPageState();
}

class _ScannnerPageState extends State<ScannnerPage> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isLoading = false;
  QrListService qrListService = new QrListService();
  GarbageBagService garbageBagService = new GarbageBagService();
  UserService userService = new UserService();

  get isBagScanMod => widget.check != null;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  addStatusUsed(String badId, String type) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Map<String, String> quizMap = {
      "status": "used",
      "forr": "bag",
      "uId": user.uid,
    };

    Map<String, String> bagMap = {
      "qrId": badId,
      "bagId": widget.bagId,
    };

    await qrListService.updateStatus(badId, quizMap).then((value) async {
      await garbageBagService.updateStatus(widget.bagId, bagMap).then((value) {
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => HomePage(uid: user.uid),
            ));
      });
    });
  }

  addStatusinContainer(String badId) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Map<String, String> quizMap = {
      "status": "container",
      "created": formattedDate,
    };

    Map<String, int> userMap = {
      "point": 10,
    };

    await userService.updatePoint(user.uid, userMap).then((value) async {
      await garbageBagService.updateStatus(widget.bagId, quizMap).then((value) {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.bagId)),
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          if (result != null)
            isBagScanMod
                ? Center(
                  child: StreamBuilder(
                      stream: QrListService().getQrList(result.code),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Qrlist>> snapshot) {
                        if (snapshot.hasError || !snapshot.hasData)
                          return CircularProgressIndicator();
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            Qrlist qrlist = snapshot.data[index];
                            if (qrlist.status == "unused") {
                              addStatusUsed(result.code, "bag");
                            } else if (qrlist.status == "used") {
                             return Container(
                                  height: 100,
                                  width: 100,
                                  margin: EdgeInsets.all(30),
                                  alignment: Alignment.center,
                                  color: Colors.yellow,
                                  child: Text("Qr code used "+qrlist.forr,style: TextStyle(fontSize: 34,color: Colors.white),));
                            }
                            return InkWell(
                                onTap: () {},
                                child: Center(
                                  child: Text("is container"),
                                ));
                          },
                        );
                      },
                    ),
                )
                : Center(
                    child: StreamBuilder(
                      stream: QrListService().getQrList(result.code),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Qrlist>> snapshot) {
                        if (snapshot.hasError || !snapshot.hasData)
                          return CircularProgressIndicator();
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            Qrlist qrlist = snapshot.data[index];
                            if (qrlist.forr == widget.type) {
                              return _isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Center(child: showUnUsedAlertDialog());
                            } else {
                              return Container(
                                  height: 100,
                                  width: 100,
                                  margin: EdgeInsets.all(30),
                                  alignment: Alignment.center,
                                  color: Colors.yellow,
                                  child: Text("Wrong Container",style: TextStyle(fontSize: 34,color: Colors.white),));
                            }
                          },
                        );
                      },
                    ),
                  )
        ],
      ),
    );
  }

  Widget showUnUsedAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text("Сongratulations you put correct container"),
      actions: [
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            addStatusinContainer(widget.bagId);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget showUsedAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text("Qr Code Used"),
      content: Text("Please try other qr code!"),
      actions: [
        FlatButton(),
        FlatButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton()
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
