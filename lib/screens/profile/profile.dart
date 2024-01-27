import 'package:admin_grievance_management_system/screens/login/login.dart';
import 'package:admin_grievance_management_system/screens/login/user_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                maxRadius: 80.0,
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage(
                    'https://freesvg.org/img/abstract-user-flat-4.png'),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.email_rounded),
                title: Text(
                  'Email',
                  style: TextStyle(color: Colors.black54),
                ),
                subtitle: Text(
                  'admin@gmail.com',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.verified_user_rounded),
                title: Text(
                  'Role',
                  style: TextStyle(color: Colors.black54),
                ),
                subtitle: Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Provider.of<UserSession>(context, listen: false).setLoggedIn(false);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        },
        child: Icon(Icons.logout_rounded),
      ),
    );
  }
}
