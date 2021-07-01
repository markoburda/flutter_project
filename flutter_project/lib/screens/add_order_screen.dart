import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_project/components/login_button.dart';
import 'package:provider/provider.dart';

List carriers = ["DHL Express", "FedEx", "UPS", "USPS"];
Map<String, String> slugs = {
  "DHL Express": "dhl",
  "FedEx": "fedex",
  "UPS": "ups",
  "USPS": "usps"
};

class AddOrder extends StatefulWidget {
  static const routeName = '/addorder';
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  List orders = [];
  String item_name = "";
  String? carrier;
  String imageUrl = "";
  String tracknum = "";
  String orderTotal = "";

  createOrder() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Orders").doc(item_name);
    Map<String, String?> orders = {
      "user_id": context.read<User?>()?.uid,
      "item_name": item_name,
      "status": "Unknown",
      "carrier": slugs[carrier],
      "imageUrl": imageUrl,
      "tracknum": tracknum,
      "orderTotal": orderTotal
    };
    documentReference.set(orders).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add Order")),
        body: SingleChildScrollView(
            child: Column(
          children: [
            TextField(
                onChanged: (String val) {
                  item_name = val;
                },
                decoration: InputDecoration(
                    hintText: 'Item name',
                    contentPadding: EdgeInsets.only(left: 10))),
            TextField(
                onChanged: (String val) {
                  imageUrl = val;
                },
                decoration: InputDecoration(
                    hintText: 'Image url',
                    contentPadding: EdgeInsets.only(left: 10))),
            TextField(
                onChanged: (String val) {
                  orderTotal = val;
                },
                decoration: InputDecoration(
                    hintText: 'Price',
                    contentPadding: EdgeInsets.only(left: 10))),
            TextField(
                onChanged: (String val) {
                  tracknum = val;
                },
                decoration: InputDecoration(
                    hintText: 'Tracking number',
                    contentPadding: EdgeInsets.only(left: 10))),
            DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: 'Carrier',
                    contentPadding: EdgeInsets.only(left: 10)),
                isExpanded: true,
                value: carrier,
                onChanged: (value) {
                  setState(() {
                    carrier = value.toString();
                  });
                },
                items: carriers.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList()),
            LoginButton(
              press: () {
                createOrder();
                Navigator.of(context).pop();
              },
              text: "Add order",
            )
          ],
        )));
  }
}
