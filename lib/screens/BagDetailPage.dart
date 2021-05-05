import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbagesort/model/Product.dart';
import 'package:garbagesort/service/garbagebag_api.dart';
import 'package:garbagesort/service/product_api.dart';

import 'BagScannnerPage.dart';

class BagDetailPage extends StatefulWidget {
  String bagId;
  String type;

  BagDetailPage({this.bagId,this.type});

  @override
  _BagDetailPageState createState() => _BagDetailPageState();
}

class _BagDetailPageState extends State<BagDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Plastic Bag"),
        actions: [
          InkWell(
            onTap: (){
              return Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ScannnerPage(bagId: widget.bagId,type: widget.type,),
                  ));
            },
            child: Icon(Icons.restore_from_trash),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: StreamBuilder(
        stream: GarbageBagService().getGarbageList(widget.bagId),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          Map<String, dynamic> documentFields = snapshot.data.data;
          List check = documentFields['garbageList'];
          if (snapshot.hasError || !snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: check.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return StreamBuilder(
                stream: ProductService().getProduct(check[index]),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  return SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Product product = snapshot.data[index];
                        return InkWell(
                            onTap: () async {},
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: SizedBox(
                                  height: 128,
                                  width: 128,
                                  child: CachedNetworkImage(
                                    imageUrl: product.pImage,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                title: Text(
                                  product.name,
                                  style: TextStyle(fontSize: 24),
                                ),
                                trailing: Text(
                                  product.weight,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ));
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
