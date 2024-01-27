import 'package:admin_grievance_management_system/screens/profile/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final tabs = [
    QuickStats(),
    UpdateGrievanceStatus(),
    FilterSearch(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Admin Panel'),
          backgroundColor: Colors.lightBlueAccent[700],
        ),
        backgroundColor: Colors.white,
        body: tabs[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.lightBlueAccent[700],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              title: Text("Quick Stats"),
              backgroundColor: Colors.lightBlueAccent[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_turned_in),
              title: Text("Update Status"),
              backgroundColor: Colors.lightBlueAccent[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Filter/Search"),
              backgroundColor: Colors.lightBlueAccent[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text("Profile"),
              backgroundColor: Colors.lightBlueAccent[700],
            ),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class QuickStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Quick Stats"),
    );
  }
}

class UpdateGrievanceStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Update Grievance Status"),
    );
  }
}

class FilterSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Filter and Search"),
    );
  }
}
