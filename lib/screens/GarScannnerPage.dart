import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garbagesort/model/Product.dart';
import 'package:garbagesort/model/Qrlist.dart';
import 'package:garbagesort/service/garbagebag_api.dart';
import 'package:garbagesort/service/product_api.dart';
import 'package:garbagesort/service/qrlist_api.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'HomePage.dart';

class GarScannnerPage extends StatefulWidget {
  String bagId;
  List garbageList;
  String bagtype;

  GarScannnerPage({this.bagId, this.garbageList,this.bagtype});

  @override
  _GarScannnerPageState createState() => _GarScannnerPageState();
}

class _GarScannnerPageState extends State<GarScannnerPage> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QrListService qrListService = new QrListService();
  GarbageBagService garbageBagService = new GarbageBagService();

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
      // appBar: AppBar(title: Text(widget.bagId)),
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          if (result != null)
            Container(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder(
                stream: ProductService().getProduct(result.code),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData)
                    return CircularProgressIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Product garbage = snapshot.data[index];
                      return Container(
                        height: 500,
                        child: showBottomModal(
                            garbage.name, garbage.pid, garbage.pImage,garbage.type),
                      );
                    },
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  showBottomModal(String name, String pid, String pImage, String type) {
    return DraggableScrollableSheet(
        maxChildSize: 0.70,
        initialChildSize: 0.70,
        minChildSize: 0.70,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)]),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 6,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  CachedNetworkImage(
                    width: 140.0,
                    imageUrl: pImage,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Text(
                    "This is " + name + "??",
                    style: TextStyle(fontSize: 24),
                  ),
                  Divider(
                    height: 25.0,
                    color: Colors.black12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 25),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.green)),
                          onPressed: (){
                            if(widget.bagtype !=type){
                              showAlertDialog(context,widget.bagtype,type);
                            }else {
                              addProduct(pid);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Yes',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.yellow)),
                          onPressed: (){
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) => GarScannnerPage(
                                    bagId: widget.bagId,
                                  ),
                                ));
                          },
                          child: Icon(Icons.refresh, color: Colors.white)),
                      SizedBox(height: 25),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  showAlertDialog(BuildContext context, String bagtype,String type) {
    Widget cancelButton = FlatButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Text("Garbage type is "),
          Text(type,style: TextStyle(color: Colors.red),),
        ],
      ),
      content: Row(
        children: [
          Text("add to "),
          Text(bagtype,style: TextStyle(color: Colors.green)),
          Text(" selection"),

        ],
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget showUnUsedAlertDialog(String name, String pid) {
    return Center(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text("This is " + name + "?"),
        actions: [
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              addProduct(pid);
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => GarScannnerPage(
                      bagId: widget.bagId,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }

  addProduct(String pid) async {
    List productList = [];

    if (widget.garbageList != null) {
      productList = widget.garbageList;
    }
    DateTime now = DateTime.now();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    productList.add(pid);

    Map<String, dynamic> bagMap = {
      "garbageList": productList,
    };
    await garbageBagService.updateStatus(widget.bagId, bagMap).then((value) {
      // Navigator.pushReplacement(
      //     context,
      //     new MaterialPageRoute(
      //       builder: (BuildContext context) => HomePage(uid: user.uid),
      //     ));
    });
  }

  Widget showUsedAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text("This is "),
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
