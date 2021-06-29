import 'package:flutter/material.dart';
import 'package:flutter_project/screens/main_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

var client = http.Client();

Future<OrderDetails> fetchOrderDetails(http.Client client) async {
  final response = await http.get(
    Uri.parse('https://api.aftership.com/v4/trackings/dhl-global-mail/GM295352282106647664'),
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
  final String origin_country;
  final String tracking_number;
  final String slug;
  // final String delivery_date;
  final String destination_country;
  final String delivery_state;

  OrderDetails({
    required this.origin_country,
    required this.destination_country,
    required this.tracking_number,
    required this.slug,
    // required this.delivery_date,
    required this.delivery_state,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    if(json["data"].containsKey("tracking")){
      return OrderDetails(
        origin_country: json["data"]["tracking"]["origin_country_iso3"],
        tracking_number: json["data"]["tracking"]["tracking_number"],
        slug: json["data"]["tracking"]["slug"],
        // delivery_date: json["data"]["tracking"]["order_promised_delivery_date"],
        destination_country: json["data"]["tracking"]["destination_country_iso3"],
        delivery_state: json["data"]["tracking"]["tag"]
        );
    }
    else{
      return OrderDetails(
        origin_country: "None",
        tracking_number: "None",
        slug: "None",
        // delivery_date: "None",
        destination_country: "None",
        delivery_state: "None");
    }
  }
}

class DetailedOrder extends StatefulWidget {
  static const routeName = '/order';
  @override
  _DetailedOrderState createState() => _DetailedOrderState();
}

class _DetailedOrderState extends State<DetailedOrder> {
  late Future<OrderDetails> futureOrderDetails;

  @override
  void initState() {
    super.initState();
    futureOrderDetails = fetchOrderDetails(client);
  }


  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as Map;
    return DefaultTextStyle(
    style: Theme.of(context).textTheme.headline2!,
    textAlign: TextAlign.center,
    child: FutureBuilder<OrderDetails>(
        future: futureOrderDetails,
        builder: (BuildContext context, AsyncSnapshot<OrderDetails> snapshot) {
          List<Widget> children;
          children = <Widget>[
            Center(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: 125,
                    height: 125,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(order['imageUrl'])))),
            Text(
              order['item_name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Order ID:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'order_id:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Slug:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        snapshot.data!.slug,
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
                        '${order['tracknum']}:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
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
                        snapshot.data!.origin_country,
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
                        snapshot.data!.destination_country,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Tracking state:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        snapshot.data!.delivery_state,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
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
              return CircularProgressIndicator();}));}
  }