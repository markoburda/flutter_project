import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/input_field.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyOrders extends StatefulWidget {
  static const routeName = '/myorders';
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  // @override
  // void initState() {
  //   super.initState();
  //   orders.add(Order('Headphones', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones2', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones3', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones2', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones3', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones2', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones3', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones2', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  //   orders.add(Order('Headphones3', 'Aftership', 'OK',
  //       'https://www.mytrendyphone.eu/images/Forever-Music-Soul-BHS-300-Bluetooth-Headphones-with-Microphone-Black-5900495738110-17072019-01-p.jpg'));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Orders")),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Orders").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
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
                                        snapshot.data?.docs[index]['status'] ??
                                            'null',
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

class Order {
  final String itemName, status, carrier, imageUrl;
  Order(this.itemName, this.carrier, this.status, this.imageUrl);
}
