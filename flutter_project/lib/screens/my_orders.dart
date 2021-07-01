import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';
import 'package:flutter_project/screens/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

var client = http.Client();

class MyOrders extends StatefulWidget {
  static const routeName = '/myorders';
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkGrayColor,
        drawer: MainDrawer(),
        appBar: AppBar(title: Text("My Orders")),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("user_id", isEqualTo: context.read<User?>()?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            var ordersList = ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/order', arguments: {
                        'item_name':
                            snapshot.data?.docs[index]['item_name'] ?? "",
                        'imageUrl':
                            snapshot.data?.docs[index]['imageUrl'] ?? "",
                        'carrier': snapshot.data?.docs[index]['carrier'] ?? "",
                        'tracknum': snapshot.data?.docs[index]['tracknum'] ?? ""
                      });
                    },
                    key: Key(snapshot.data!.docs[index]['item_name']),
                    child: Card(
                      color: kDarkGrayColor,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width - 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Row(
                                      children: [
                                        Container(
                                            width: 55,
                                            height: 55,
                                            child: snapshot.data?.docs[index]
                                                        ['imageUrl'] !=
                                                    ""
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                                .data
                                                                ?.docs[index]
                                                            ['imageUrl']))
                                                : CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/logo_icon.jpg'))),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 55,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data?.docs[index]
                                                    ['item_name'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                snapshot.data?.docs[index]
                                                    ['orderTotal'],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                    Icon(
                                      state_icons[snapshot
                                          .data?.docs[index]['status']
                                          .toString()
                                          .toUpperCase()],
                                      color: delivery_state[snapshot
                                          .data?.docs[index]['status']
                                          .toString()
                                          .toUpperCase()],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  );
                },
                itemCount: snapshot.data?.docs.length);
            if (snapshot.hasData) {
              return ordersList;
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
