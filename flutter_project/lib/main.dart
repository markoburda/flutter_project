import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_project/constants.dart';
import 'package:flutter_project/screens/add_order_screen.dart';
import 'package:flutter_project/screens/detailed_order_screen.dart';
import 'package:flutter_project/screens/my_orders.dart';
import 'package:flutter_project/widgets/auth_service.dart';
import 'package:flutter_project/widgets/auth_wrapper.dart';

import 'package:flutter_project/screens/login-page.dart';
import 'package:flutter_project/screens/sign_up_screen.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (context) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null,
          ),
        ],
        child: MaterialApp(
          routes: {
            '/signup': (context) => SignUpScreen(),
            '/myorders': (context) => MyOrders(),
            '/addorder': (context) => AddOrder(),
            '/order': (context) => DetailedOrder()
          },
          debugShowCheckedModeBanner: false,
          title: 'Delivery io',
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: AuthenticationWrapper(),
        ));
  }
}
