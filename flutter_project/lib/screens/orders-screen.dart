import 'package:flutter/material.dart';
import 'package:flutter_project/screens/main_drawer.dart';
import 'package:flutter_project/screens/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

var client = http.Client();

class _OrderScreenState extends State<OrderScreen> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(client);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<Album>(
        future: futureAlbum, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Album> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              // const Icon(
              //   Icons.check_circle_outline,
              //   color: Colors.green,
              //   size: 60,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Result: ${snapshot.data!.data}',
                    style: TextStyle(color: Colors.amber)),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}

Future<Album> fetchAlbum(http.Client client) async {
  final response = await http.get(
    Uri.parse('https://api.aftership.com/v4/trackings?page=1&limit=100'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader:
          'aftership-api-key:  a6d6bd00-ab18-4cb0-9283-69857ae60b97',
      HttpHeaders.contentTypeHeader: 'Content-Type: application/json'
    },
  );
  final responseJson = jsonDecode(response.body);

  return Album.fromJson(responseJson);
}

class Album {
  final String data;

  Album({
    required this.data,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(data: json["meta"]["type"]);
  }
}

class UserAgentClient extends http.BaseClient {
  final String userAgent;
  final http.Client _inner;

  UserAgentClient(this.userAgent, this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['user-agent'] = userAgent;
    return _inner.send(request);
  }
}

class OrderScreen extends StatefulWidget {
  static const routeName = '/myorders';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}
