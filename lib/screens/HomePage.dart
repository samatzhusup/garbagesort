import 'package:badges/badges.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:garbagesort/model/Garbage.dart';
import 'package:garbagesort/model/User.dart';
import 'package:garbagesort/service/garbagebag_api.dart';
import 'package:garbagesort/service/user_api.dart';
import 'package:intl/intl.dart';
import 'BagDetailPage.dart';
import 'BagScannnerPage.dart';
import 'GarScannnerPage.dart';
import 'account/ContainterGarPage.dart';
import 'account/RatingPage.dart';

class HomePage extends StatefulWidget {
  String uid;

  HomePage({this.uid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextEditingController _addGarbageController = TextEditingController();

  PageController pageController =
      PageController(initialPage: 0, keepPage: false);
  int pageChanged = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget HomePage() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: () {
                pageController.nextPage(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.decelerate);
              }),
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                pageController.nextPage(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.decelerate);
              })
        ],
      ),
      body: GarbageList(),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child: Icon(Icons.qr_code_scanner),
              label: "Scan Garbage",
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ScannnerPage()))),
          SpeedDialChild(
              child: Icon(Icons.add),
              label: "Add Bag",
              onTap: () {
                showAddBagModal();
              }),
        ],
      ),
    );
  }

  showAddGarbageModal() {
    List iconList = [
      'assets/images/icon/plastic.png',
      'assets/images/icon/metal.png',
      'assets/images/icon/organic.png',
      'assets/images/icon/glass.png',
      'assets/images/icon/paper.png',
      'assets/images/icon/e-waste.png',
    ];
    int secondaryIndex = 0;

    Widget customRadio2(String link, int index, setState) {
      return Container(
        margin: EdgeInsets.all(5),
        child: OutlineButton(
          onPressed: () {
            print(link);
            setState(() {
              secondaryIndex = index;
            });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          borderSide: BorderSide(
              color: secondaryIndex == index ? Colors.blue[700] : Colors.grey),
          child: Container(
            height: 24,
            width: 24,
            child: Image(
              image: AssetImage(link),
            ),
          ),
        ),
      );
    }

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              maxChildSize: 0.40,
              initialChildSize: 0.40,
              minChildSize: 0.10,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10.0)
                      ]),
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
                        // Divider(
                        //   height: 25.0,
                        //   color: Colors.black12,
                        // ),
                        SizedBox(
                          height: 25.0,
                        ),
                        StatefulBuilder(
                            builder: (BuildContext context, setState) {
                          return Column(
                            children: [
                              Wrap(
                                children: <Widget>[
                                  customRadio2(iconList[0], 0, setState),
                                  customRadio2(iconList[1], 1, setState),
                                  customRadio2(iconList[2], 2, setState),
                                  customRadio2(iconList[3], 3, setState),
                                  customRadio2(iconList[4], 4, setState),
                                  customRadio2(iconList[5], 5, setState),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: TextFormField(
                                    controller: _addGarbageController,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.hdr_strong_sharp,
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
                                      hintText: "weight",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    )),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                height: 40.0,
                                width: 120,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue)),
                                    onPressed: () {
                                      // Navigator.pop(context);
                                    },
                                    child: Icon(Icons.add)),
                              ),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                );
              });
        });
  }

  showAddBagModal() {
    String type;
    List iconList = [
      'assets/images/icon/plastic.png',
      'assets/images/icon/metal.png',
      'assets/images/icon/organic.png',
      'assets/images/icon/glass.png',
      'assets/images/icon/paper.png',
      'assets/images/icon/e-waste.png',
    ];
    int secondaryIndex = 0;

    Widget customRadio2(String link, int index, setState) {
      return Container(
        margin: EdgeInsets.all(5),
        child: OutlineButton(
          onPressed: () {
            setState(() {
              secondaryIndex = index;
              if (index == 0) {
                type = "plastic";
              } else if (index == 1) {
                type = "metal";
              } else if (index == 2) {
                type = "organic";
              } else if (index == 3) {
                type = "glass";
              } else if (index == 4) {
                type = "paper";
              } else if (index == 5) {
                type = "e-waste";

              }
            });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          borderSide: BorderSide(
              color: secondaryIndex == index ? Colors.blue[700] : Colors.grey),
          child: Container(
            height: 24,
            width: 24,
            child: Image(
              image: AssetImage(link),
            ),
          ),
        ),
      );
    }

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              maxChildSize: 0.40,
              initialChildSize: 0.40,
              minChildSize: 0.10,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10.0)
                      ]),
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
                        SizedBox(
                          height: 25.0,
                        ),
                        StatefulBuilder(
                            builder: (BuildContext context, setState) {
                          return Column(
                            children: [
                              Wrap(
                                children: <Widget>[
                                  customRadio2(iconList[0], 0, setState),
                                  customRadio2(iconList[1], 1, setState),
                                  customRadio2(iconList[2], 2, setState),
                                  customRadio2(iconList[3], 3, setState),
                                  customRadio2(iconList[4], 4, setState),
                                  customRadio2(iconList[5], 5, setState),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                height: 40.0,
                                width: 120,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue)),
                                    onPressed: () {
                                      DateTime now = DateTime.now();
                                      String cratedDate =
                                      DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                                      print(type);
                                      Firestore.instance
                                          .collection("clinetbag")
                                          .add({
                                        "uid": widget.uid,
                                        "type": type.toString(),
                                        "qrId": "none",
                                        "status": "home",
                                        "created": cratedDate,
                                      }).then((value) =>
                                              Navigator.pop(context));
                                    },
                                    child: Icon(Icons.add)),
                              ),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Widget AccountPage() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
            onTap: () {
              pageController.previousPage(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.decelerate);
            },
            child: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((result) =>
                        Navigator.pushReplacementNamed(context, "/login"))
                    .catchError((err) => print(err));
              })
        ],
      ),
      body: SingleChildScrollView(
        child:StreamBuilder(
            stream: UserService().getSingleUser(widget.uid),
            builder: (BuildContext context,
                AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.hasError || !snapshot.hasData)
                return CircularProgressIndicator();
              User user = snapshot.data[0];
              return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        user.point.toString(),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      Container(
                        height: 500,
                        child: Scaffold(
                          appBar: TabBar(
                            labelColor: Colors.black,
                            controller: _tabController,
                            tabs: [
                              Tab(
                                text: "Status Garbage",
                              ),
                              Tab(
                                text: "Rating",
                              ),
                            ],
                          ),
                          body: TabBarView(
                            controller: _tabController,
                            children: [
                              ContainterGarPage(uId: widget.uid),
                              RatingPage(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            }
                )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        setState(() {
          pageChanged = index;
        });
      },
      children: [HomePage(), AccountPage()],
    );
  }

  Widget GarbageList() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: StreamBuilder(
              stream: GarbageBagService().getClientHomeGarbageBag(widget.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Garbage>> snapshot) {
                if (snapshot.hasError || !snapshot.hasData)
                  return CircularProgressIndicator();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      child: Text(
                        "Help improve environment and save the ecosystem.",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        snapshot.data.length.toString()+" bag found",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Garbage garbage = snapshot.data[index];
                        if (garbage.type == "paper") {
                          return InkWell(
                            onTap: () {
                              if (garbage.qrId != "none"&&garbage.garbageList.length!=null) {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BagDetailPage(
                                        bagId: garbage.bagId,
                                        type: garbage.type,
                                      ),
                                    ));
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                    leading: Badge(
                                      badgeContent: Text("0"),
                                      badgeColor: Colors.red,
                                      child: Image(
                                        image:
                                            AssetImage('assets/images/paper.jpg'),
                                      ),
                                    ),
                                    title: Text(
                                      garbage.type,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    trailing: garbage.qrId == "none"
                                        ? InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                  context, garbage.bagId);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code-scan.png'),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              showScanModal(
                                                  garbage.bagId,
                                                  garbage.garbageList,
                                                  garbage.type);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code.png'),
                                              ),
                                            ),
                                          ))),
                          );
                        } else if (garbage.type == "glass") {
                          return InkWell(
                            onTap: () {
                              if (garbage.qrId != "none") {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BagDetailPage(
                                        bagId: garbage.bagId,
                                        type: garbage.type,
                                      ),
                                    ));
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                    leading: Badge(
                                      badgeContent: Text("0"),
                                      badgeColor: Colors.red,
                                      child: Image(
                                        image:
                                            AssetImage('assets/images/glass.jpg'),
                                      ),
                                    ),
                                    title: Text(
                                      garbage.type,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    trailing: garbage.qrId == "none"
                                        ? InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                  context, garbage.bagId);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code-scan.png'),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              showScanModal(
                                                  garbage.bagId,
                                                  garbage.garbageList,
                                                  garbage.type);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code.png'),
                                              ),
                                            ),
                                          ))),
                          );
                        } else if (garbage.type == "plastic") {
                          return InkWell(
                            onTap: () {
                              if (garbage.qrId != "none"&&garbage.garbageList.length!=null) {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BagDetailPage(
                                        bagId: garbage.bagId,
                                        type: garbage.type,
                                      ),
                                    ));
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                    leading: Badge(
                                      badgeContent: Text("0"),
                                      badgeColor: Colors.red,
                                      child: Image(
                                        image:
                                            AssetImage('assets/images/plastic.jpg'),
                                      ),
                                    ),
                                    title: Text(
                                      garbage.type,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    trailing: garbage.qrId == "none"
                                        ? InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                  context, garbage.bagId);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code-scan.png'),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              showScanModal(
                                                  garbage.bagId,
                                                  garbage.garbageList,
                                                  garbage.type);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code.png'),
                                              ),
                                            ),
                                          ))),
                          );
                        } else if (garbage.type == "metal") {
                          return InkWell(
                            onTap: () {
                              if (garbage.qrId != "none") {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BagDetailPage(
                                        bagId: garbage.bagId,
                                        type: garbage.type,
                                      ),
                                    ));
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                    leading: Badge(
                                      badgeContent: Text("0"),
                                      badgeColor: Colors.red,
                                      child: Image(
                                        image:
                                            AssetImage('assets/images/metal.jpg'),
                                      ),
                                    ),
                                    title: Text(
                                      garbage.type,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    trailing: garbage.qrId == "none"
                                        ? InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                  context, garbage.bagId);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code-scan.png'),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              showScanModal(
                                                  garbage.bagId,
                                                  garbage.garbageList,
                                                  garbage.type);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code.png'),
                                              ),
                                            ),
                                          ))),
                          );
                        } else if (garbage.type == "organic") {
                          return InkWell(
                            onTap: () {
                              if (garbage.qrId != "none") {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BagDetailPage(
                                        bagId: garbage.bagId,
                                        type: garbage.type,
                                      ),
                                    ));
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                    leading: Badge(
                                      badgeContent: Text("0"),
                                      badgeColor: Colors.red,
                                      child: Image(
                                        image:
                                            AssetImage('assets/images/organic.jpg'),
                                      ),
                                    ),
                                    title: Text(
                                      garbage.type,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    trailing: garbage.qrId == "none"
                                        ? InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                  context, garbage.bagId);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code-scan.png'),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              showScanModal(
                                                  garbage.bagId,
                                                  garbage.garbageList,
                                                  garbage.type);
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/qr-code.png'),
                                              ),
                                            ),
                                          ))),
                          );
                        }
                        return InkWell(
                          onTap: () {
                            if (garbage.qrId != "none") {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BagDetailPage(
                                      bagId: garbage.bagId,
                                      type: garbage.type,
                                    ),
                                  ));
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                  leading: Badge(
                                    badgeContent: Text("0"),
                                    badgeColor: Colors.red,
                                    child: Image(
                                      image:
                                          AssetImage('assets/images/e-waste.jpg'),
                                    ),
                                  ),
                                  title: Text(
                                    garbage.type,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  trailing: garbage.qrId == "none"
                                      ? InkWell(
                                          onTap: () {
                                            showAlertDialog(context, garbage.bagId);
                                          },
                                          child: Container(
                                            height: 34,
                                            width: 34,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/qr-code-scan.png'),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            showScanModal(garbage.bagId,
                                                garbage.garbageList, garbage.type);
                                          },
                                          child: Container(
                                            height: 34,
                                            width: 34,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/qr-code.png'),
                                            ),
                                          ),
                                        ))),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String bagId) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget launchButton = FlatButton(
      child: Text("Scan QR Code"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => ScannnerPage(
                check: "isBagScanMod",
                bagId: bagId,
              ),
            ));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("You not specified QR Code"),
      content: Text("Don't have QR Code?"),
      actions: [
        launchButton,
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

  showAddModal(String bagId, List<dynamic> garbageList) {
    List iconList = [
      'assets/images/icon/plastic.png',
      'assets/images/icon/metal.png',
      'assets/images/icon/organic.png',
      'assets/images/icon/glass.png',
      'assets/images/icon/paper.png',
      'assets/images/icon/e-waste.png',
    ];
    int secondaryIndex = 0;

    Widget customRadio2(String link, int index, setState) {
      return Container(
        margin: EdgeInsets.all(5),
        child: OutlineButton(
          onPressed: () {
            print(link);
            setState(() {
              secondaryIndex = index;
            });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          borderSide: BorderSide(
              color: secondaryIndex == index ? Colors.blue[700] : Colors.grey),
          child: Container(
            height: 24,
            width: 24,
            child: Image(
              image: AssetImage(link),
            ),
          ),
        ),
      );
    }

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              maxChildSize: 0.40,
              initialChildSize: 0.40,
              minChildSize: 0.10,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10.0)
                      ]),
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
                        // Divider(
                        //   height: 25.0,
                        //   color: Colors.black12,
                        // ),
                        SizedBox(
                          height: 25.0,
                        ),
                        StatefulBuilder(
                            builder: (BuildContext context, setState) {
                          return Column(
                            children: [
                              Wrap(
                                children: <Widget>[
                                  customRadio2(iconList[0], 0, setState),
                                  customRadio2(iconList[1], 1, setState),
                                  customRadio2(iconList[2], 2, setState),
                                  customRadio2(iconList[3], 3, setState),
                                  customRadio2(iconList[4], 4, setState),
                                  customRadio2(iconList[5], 5, setState),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: TextFormField(
                                    controller: _addGarbageController,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.hdr_strong_sharp,
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
                                      hintText: "weight",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    )),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                height: 40.0,
                                width: 120,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue)),
                                    onPressed: () {
                                      // Navigator.pop(context);
                                    },
                                    child: Icon(Icons.add)),
                              ),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                );
              });
        });
  }

  showScanModal(String bagId, List<dynamic> garbageList, String type) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              maxChildSize: 0.40,
              initialChildSize: 0.40,
              minChildSize: 0.10,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10.0)
                      ]),
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
                        // Divider(
                        //   height: 25.0,
                        //   color: Colors.black12,
                        // ),
                        SizedBox(
                          height: 25.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GarScannnerPage(
                                          bagId: bagId,
                                          garbageList: garbageList,
                                          bagtype: type),
                                ));
                          },
                          child: Container(
                            height: 89,
                            width: 89,
                            child: Image(
                              image: AssetImage('assets/images/scan.png'),
                            ),
                          ),
                        ),
                        Text(
                          "Scan Garbage",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     showAddModal(bagId, garbageList);
                        //   },
                        //   child: Container(
                        //     height: 80,
                        //     width: 80,
                        //     child: Image(
                        //       image: AssetImage('assets/images/add.png'),
                        //     ),
                        //   ),
                        // ),
                        // Text(
                        //   "Add Garbage",
                        //   style: TextStyle(fontSize: 14),
                        //),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
