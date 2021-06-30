import 'package:flutter/material.dart';
import 'package:flutter_project/screens/main_drawer.dart';
import 'package:flutter_project/widgets/shipment_history.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

var client = http.Client();

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

  @override
  void initState() {
    super.initState();

    futureOrderDetails = fetchOrderDetails(
        client, widget.order['carrier'], widget.order['tracknum']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("${widget.order['item_name']}")),
        body: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline2!,
            textAlign: TextAlign.center,
            child: FutureBuilder<OrderDetails>(
                future: futureOrderDetails,
                builder: (BuildContext context,
                    AsyncSnapshot<OrderDetails> snapshot) {
                  List<Widget> children;
                  children = <Widget>[
                    Center(
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: 125,
                            height: 125,
                            child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.order['imageUrl'])))),
                    Text(
                      widget.order['item_name'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                        child: Column(children: [
                          Row(
                            children: [
                              Text(
                                'Tracking state:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                snapshot.data?.delivery_state ?? 'state',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Origin country:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                snapshot.data?.origin_country ?? 'origin',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Destination  country:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                snapshot.data?.destination_country ?? 'dest',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Carrier:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                snapshot.data?.slug ?? 'slug',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Tracking number:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                '${widget.order['tracknum']}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                  child: Text(
                                    'View shipment history',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/shipmentHistory',
                                        arguments: {
                                          'checkpoints':
                                              snapshot.data?.checkpoints
                                        });
                                  }),
                            ],
                          )
                        ]))
                  ];
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    );
                  }

                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                })));
  }
}
