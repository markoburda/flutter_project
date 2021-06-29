import 'package:flutter/material.dart';
import 'package:flutter_project/screens/main_drawer.dart';

class DetailedOrder extends StatefulWidget {
  static const routeName = '/order';
  @override
  _DetailedOrderState createState() => _DetailedOrderState();
}

class _DetailedOrderState extends State<DetailedOrder> {
  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(title: Text("${order['item_name']}")),
      body: Container(
        child: Column(
          children: [
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
                        'slug:',
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
                        'Delivery date:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'delivery_date:',
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
                        'origin_country:',
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
                        'destination_country:',
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
                        'tracking_state:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
