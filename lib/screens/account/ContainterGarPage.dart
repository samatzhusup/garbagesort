import 'package:flutter/material.dart';
import 'package:garbagesort/model/Garbage.dart';
import 'package:garbagesort/service/garbagebag_api.dart';

import '../BagDetailPage.dart';

class ContainterGarPage extends StatefulWidget {
  String uId;

  ContainterGarPage({this.uId});

  @override
  _ContainterGarPageState createState() => _ContainterGarPageState();
}

class _ContainterGarPageState extends State<ContainterGarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: GarbageBagService().getClientGarbageBaginCon(widget.uId),
        builder: (BuildContext context, AsyncSnapshot<List<Garbage>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Garbage garbage = snapshot.data[index];
              if (garbage.type == "paper") {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/images/paper.png'),
                    ),
                    title: Text(
                      garbage.type,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              } else if (garbage.type == "glass") {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/images/glass.png'),
                    ),
                    title: Text(
                      garbage.type,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              } else if (garbage.type == "plastic") {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BagDetailPage(bagId: garbage.bagId),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Image(
                        image: AssetImage('assets/images/plastic.png'),
                      ),
                      title: Text(
                        garbage.type,
                        style: TextStyle(fontSize: 24),
                      ),
                      trailing: InkWell(
                        onTap: () {},
                        child: Stack(children: [
                          Container(
                              height: 46,
                              width: 46,
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),
                                  value: 0.5)),
                          Container(
                              margin: EdgeInsets.only(top: 18,left: 7),
                              child: Text("Contai..",style: TextStyle(fontSize: 9),))
                        ]),
                      ),
                    ),
                  ),
                );
              } else if (garbage.type == "metal") {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/images/metal.png'),
                    ),
                    title: Text(
                      garbage.type,
                      style: TextStyle(fontSize: 24),
                    ),
                    trailing: InkWell(
                      onTap: () {},
                      child: Stack(children: [
                        Container(
                            height: 46,
                            width: 46,
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                                value: 1.0)),
                        Container(
                            margin: EdgeInsets.only(top: 18,left: 10),
                            child: Text("finish",style: TextStyle(fontSize: 9),))
                      ]),
                    ),
                  ),
                );
              } else if (garbage.type == "organic") {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/images/organic.png'),
                    ),
                    title: Text(
                      garbage.type,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Image(
                    image: AssetImage('assets/images/e-waste.png'),
                  ),
                  title: Text(
                    garbage.type,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
