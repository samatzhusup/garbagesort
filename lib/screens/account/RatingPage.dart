import 'package:flutter/material.dart';
import 'package:garbagesort/model/User.dart';
import 'package:garbagesort/service/user_api.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: UserService().getUser(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              User user = snapshot.data[index];
              if(index==0){
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow,
                        blurRadius: 2,
                        offset: Offset(1, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/images/plastic.png'),
                    ),
                    title: Text(
                      user.surname+" "+user.name,
                      style: TextStyle(fontSize: 24),
                    ),
                    trailing: Text(
                      user.point.toString(),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              }
              if(index==1){
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        offset: Offset(1, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/images/plastic.png'),
                    ),
                    title: Text(
                      user.surname+" "+user.name,
                      style: TextStyle(fontSize: 24),
                    ),
                    trailing: Text(
                      user.point.toString(),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              }
              if(index==2){
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange,
                        blurRadius: 2,
                        offset: Offset(1, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/images/plastic.png'),
                    ),
                    title: Text(
                      user.surname+" "+user.name,
                      style: TextStyle(fontSize: 24),
                    ),
                    trailing: Text(
                      user.point.toString(),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: ListTile(
                  leading: Image(
                    image: AssetImage('assets/images/plastic.png'),
                  ),
                  title: Text(
                    user.surname+" "+user.name,
                    style: TextStyle(fontSize: 24),
                  ),
                  trailing: Text(
                    user.point.toString(),
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
