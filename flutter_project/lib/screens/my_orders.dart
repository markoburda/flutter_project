import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_project/components/input_field.dart';
import 'package:flutter_project/screens/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

var client = http.Client();

class MyOrders extends StatefulWidget {
  static const routeName = '/myorders';
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

Future<OrderDetails> fetchAlbum(http.Client client) async {
  final response = await http.get(
    Uri.parse('https://api.aftership.com/v4/trackings?page=1&limit=100'),
    headers: {
      'Accept': 'application/json',
      'aftership-api-key': 'a6d6bd00-ab18-4cb0-9283-69857ae60b97',
      'Content-Type': 'application/json'
    },
  );
  final responseJson = jsonDecode(response.body);

  return OrderDetails.fromJson(responseJson);
}

class OrderDetails {
  final String data;

  OrderDetails({
    required this.data,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(data: json["meta"]["type"]);
  }
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(title: Text("My Orders")),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("user_id", isEqualTo: context.read<User?>()?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/order', arguments: {
                        'item_name': snapshot.data?.docs[index]['item_name'],
                        'imageUrl': snapshot.data?.docs[index]['imageUrl'],
                        'tracknum': snapshot.data?.docs[index]['tracknum']
                      });
                    },
                    key: Key(snapshot.data?.docs[index]['item_name']),
                    child: Card(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 55,
                                      height: 55,
                                      child: CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot
                                              .data?.docs[index]['imageUrl']))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data?.docs[index]['item_name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        'STATUS',
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  );
                },
                itemCount: snapshot.data?.docs.length);
          },
        ));
  }
}
