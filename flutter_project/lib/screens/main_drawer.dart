import 'package:flutter/material.dart';
import 'package:flutter_project/screens/add_order_screen.dart';
import 'package:flutter_project/screens/my_orders.dart';
import 'package:flutter_project/widgets/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: new AssetImage(
                              'assets/images/default-profile-icon.jpg',
                            ),
                            fit: BoxFit.fill)),
                  ),
                  Text(context.read<User?>()?.email ?? 'Unknown email',
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                ],
              )),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
              'My orders',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyOrders.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text(
              'Add order',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AddOrder.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              context.read<AuthenticationService>().signOut();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
