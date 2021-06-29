import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_project/components/input_field.dart';
import 'package:flutter_project/components/login_button.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddOrder extends StatefulWidget {
  static const routeName = '/addorder';
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  List orders = [];
  String item_name = "";
  String carrier = "";
  String imageUrl = "";
  String tracknum = "";

  createOrder() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Orders").doc(item_name);
    Map<String, String?> orders = {
      "user_id": context.read<User?>()?.uid,
      "item_name": item_name,
      "status": null,
      "carrier": carrier,
      "imageUrl": imageUrl,
      "tracknum": tracknum
    };
    documentReference.set(orders).whenComplete(() {
      print("OK");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add Order")),
        body: Column(
          children: [
            TextField(
                onChanged: (String val) {
                  item_name = val;
                },
                decoration: InputDecoration(hintText: 'Item name')),
            TextField(
                onChanged: (String val) {
                  imageUrl = val;
                },
                decoration: InputDecoration(hintText: 'Image url')),
            TextField(
                onChanged: (String val) {
                  carrier = val;
                },
                decoration: InputDecoration(hintText: 'Carrier')),
            TextField(
                onChanged: (String val) {
                  tracknum = val;
                },
                decoration: InputDecoration(hintText: 'Tracking number')),
            LoginButton(
              press: () {
                createOrder();
                Navigator.of(context).pop();
              },
              text: "Add order",
            )
          ],
        ));
  }
}
