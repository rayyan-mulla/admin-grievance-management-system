import 'package:admin_grievance_management_system/screens/home/home.dart';
import 'package:admin_grievance_management_system/screens/login/login.dart';
import 'package:admin_grievance_management_system/screens/login/user_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  UserSession userSession = UserSession();
  await userSession.checkLoginStatus();

  runApp(
    ChangeNotifierProvider<UserSession>(
      create: (context) => userSession,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserSession userSession = Provider.of<UserSession>(context);

    return MaterialApp(
      title: 'Admin Console',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: userSession.isLoggedIn ? Home() : Login(),
    );
  }
}
