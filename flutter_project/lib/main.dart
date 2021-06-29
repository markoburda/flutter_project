import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_project/constants.dart';
import 'package:flutter_project/screens/orders-screen.dart';
import 'package:flutter_project/screens/profile_screen.dart';
import 'package:flutter_project/widgets/auth_service.dart';
import 'package:flutter_project/widgets/auth_wrapper.dart';

import 'package:flutter_project/screens/login-page.dart';
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
          // routes: {
          //   // '/signup': (context) => SignUpScreen(),
          //   '/profile': (context) => ProfileScreen(),
          //   '/myorders': (context) => OrderScreen()
          // },
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
