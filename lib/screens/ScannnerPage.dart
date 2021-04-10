import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garbagesort/model/Bag.dart';
import 'package:garbagesort/service/garbagebag_api.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannnerPage extends StatefulWidget {
  @override
  _ScannnerPageState createState() => _ScannnerPageState();
}

class _ScannnerPageState extends State<ScannnerPage> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          if (result != null)
            Center(
              child: StreamBuilder(
                stream: GarbageBagService().getGarbageBag(result.code),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Bag>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData)
                    return CircularProgressIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Bag bag = snapshot.data[index];
                      if (bag.status == "unused") {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: Text("Qr Code Unused"),
                          content: Text("Are you want use? "),
                          actions: [
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Yes"),
                              onPressed: () {},
                            ),
                          ],
                        );
                      } else if (bag.status == "used") {
                        return InkWell(
                            onTap: () {},
                            child: ListTile(
                              title: Text("lesson.title"),
                            ));
                      }
                      return InkWell(
                          onTap: () {},
                          child: ListTile(
                            title: Text("lesson.title"),
                          ));
                    },
                  );
                },
              ),
            )
          else
            Text('Scan a code'),
        ],
      ),
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
