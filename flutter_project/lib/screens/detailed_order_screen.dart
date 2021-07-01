import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';
import 'package:flutter_project/screens/main_drawer.dart';
import 'package:flutter_project/widgets/shipment_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

var client = http.Client();
TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
TextStyle normalStyle = TextStyle(fontSize: 18);

Future<OrderDetails> fetchOrderDetails(
    http.Client client, String carrier, String tracknum) async {
  final response = await http.get(
    Uri.parse('https://api.aftership.com/v4/trackings/$carrier/$tracknum'),
    headers: {
      'Accept': 'application/json',
      //  'aftership-api-key': '980e9270-c4e3-4847-9bbe-5e44ab449029',
      'aftership-api-key': '16a597e2-6273-4e81-98b2-f9f5db9e9f23',
      'Content-Type': 'application/json'
    },
  );
  final responseJson = jsonDecode(response.body);
  return OrderDetails.fromJson(responseJson);
}

class OrderDetails {
  final String origin_country;
  final String tracking_number;
  final String slug;
  // final String delivery_date;
  final String destination_country;
  final String delivery_state;
  final String shipment_picked_up;
  final List<dynamic> checkpoints;

  OrderDetails(
      {required this.origin_country,
      required this.destination_country,
      required this.tracking_number,
      required this.slug,
      // required this.delivery_date,
      required this.delivery_state,
      required this.shipment_picked_up,
      required this.checkpoints});

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    print(json["data"]["tracking"]["slug"]);
    if (json["data"].containsKey("tracking")) {
      return OrderDetails(
          origin_country: json["data"]["tracking"]["origin_country_iso3"],
          tracking_number: json["data"]["tracking"]["tracking_number"],
          slug: json["data"]["tracking"]["slug"],
          // delivery_date: json["data"]["tracking"]["order_promised_delivery_date"],
          destination_country: json["data"]["tracking"]
              ["destination_country_iso3"],
          delivery_state: json["data"]["tracking"]["tag"],
          shipment_picked_up: json["data"]["tracking"]["shipment_pickup_date"],
          checkpoints: json["data"]["tracking"]["checkpoints"]);
    } else {
      return OrderDetails(
          origin_country: "None",
          tracking_number: "None",
          slug: "None",
          // delivery_date: "None",
          destination_country: "None",
          delivery_state: "None",
          shipment_picked_up: "None",
          checkpoints: []);
    }
  }
}

class DetailedOrder extends StatefulWidget {
  static const routeName = '/order';
  late Map order;

  DetailedOrder(Object? args) {
    order = args as Map;
  }

  @override
  _DetailedOrderState createState() => _DetailedOrderState();
}

class _DetailedOrderState extends State<DetailedOrder> {
  late Future<OrderDetails> futureOrderDetails;

  deleteOrder(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Orders").doc(item);

    documentReference.delete().whenComplete(() {});
  }

  @override
  void initState() {
    super.initState();

    futureOrderDetails = fetchOrderDetails(
        client, widget.order['carrier'], widget.order['tracknum']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkGrayColor,
        appBar: AppBar(
          title: Text("${widget.order['item_name']}"),
          actions: [
            InkWell(
              child: Container(
                child: Icon(Icons.delete),
                padding: EdgeInsets.only(right: 10),
              ),
              onTap: () {
                deleteOrder(widget.order['item_name']);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline2!,
            textAlign: TextAlign.center,
            child: FutureBuilder<OrderDetails>(
                future: futureOrderDetails,
                builder: (BuildContext context,
                    AsyncSnapshot<OrderDetails> snapshot) {
                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection("Orders")
                      .doc(widget.order['item_name']);
                  documentReference.update({
                    'status': snapshot.data?.delivery_state ?? 'Unknown'
                  }).whenComplete(() {});

                  List<Map<String, String>> details = [
                    {
                      'label': 'Order total: ',
                      'data': snapshot.data?.delivery_state ?? 'Unknown',
                    },
                    {
                      'label': 'Origin contry: ',
                      'data': snapshot.data?.origin_country ?? 'Unknown',
                    },
                    {
                      'label': 'Destination country: ',
                      'data': snapshot.data?.destination_country ?? 'Unknown',
                    },
                    {
                      'label': 'Carrier: ',
                      'data': snapshot.data?.slug ?? 'Unknown',
                    },
                    {
                      'label': 'Tracking number: ',
                      'data': snapshot.data?.tracking_number ?? 'Unknown',
                    },
                  ];
                  var cardList = ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: details.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: kBlackColor,
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
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
                                    Text(
                                      details[index]['label']!,
                                      style: boldStyle,
                                    ),
                                    Text(
                                      details[index]['data']!,
                                      style: normalStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                  List<Widget> children;
                  children = <Widget>[
                    Container(
                        child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.25),
                                    BlendMode.dstATop),
                                child: Image.network(
                                  widget.order['imageUrl'],
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Center(
                              child: Container(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // alignment: Alignment.center,
                              children: <Widget>[
                                Text(
                                  widget.order['item_name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'STATUS: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    Text(
                                      snapshot.data?.delivery_state
                                              .toUpperCase() ??
                                          'UNKNOWN',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: delivery_state[snapshot
                                                  .data?.delivery_state
                                                  .toUpperCase() ??
                                              'UNKNOWN']),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    )),
                    Column(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: DefaultTextStyle(
                                style: TextStyle(
                                  color: kLightGrayColor,
                                ),
                                child: cardList)),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/shipmentHistory',
                                arguments: {
                                  'checkpoints': snapshot.data?.checkpoints
                                });
                          },
                          child: Card(
                            color: kPrimaryColor,
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width - 25,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text('Shipment history',
                                          style: boldStyle),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ];
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: children,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: children,
                      ),
                    );
                  }

                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                })));
  }
}
