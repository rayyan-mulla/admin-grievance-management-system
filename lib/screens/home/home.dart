import 'package:admin_grievance_management_system/screens/grievance/filter_and_search_grievances.dart';
import 'package:admin_grievance_management_system/screens/profile/profile.dart';
import 'package:admin_grievance_management_system/screens/stats/quick_stats.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final tabs = [
    QuickStats(),
    FilterAndSearchGrievances(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Admin Console'),
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
