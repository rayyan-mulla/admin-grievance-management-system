import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class QuickStats extends StatefulWidget {
  @override
  _QuickStatsState createState() => _QuickStatsState();
}

class _QuickStatsState extends State<QuickStats> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final Map<String, Color> statusColors = {
    'Under Process': Colors.blue,
    'Rejected': Colors.red,
    'Approved': Colors.green,
    'Affected': Colors.orange,
    'New Complaint': Colors.purple,
  };

  final Map<String, Color> categoryColors = {
    'Academic': Colors.blue,
    'Hostel': Colors.red,
    'Faculty': Colors.green,
    'Infrastructure': Colors.orange,
    'Other': Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildChartCard(
              'Grievance Category Distribution',
              () => fetchGrievanceCategoryData(),
              categoryColors,
            ),
            SizedBox(height: 16.0),
            buildChartCard(
              'Grievance Status Distribution',
              () => fetchGrievanceStatusData(),
              statusColors,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChartCard(
    String title,
    Future<Map<String, int>> Function() fetchData,
    Map<String, Color> colors,
  ) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            FutureBuilder<Map<String, int>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Center(child: Text('No data available.'));
                } else {
                  return Container(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 60,
                        startDegreeOffset: 180,
                        sections: generateSections(
                          snapshot.data,
                          colors.keys.toList(),
                          colors,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, int>> fetchGrievanceCategoryData() async {
    Map<String, int> data = {};

    try {
      User user = _auth.currentUser;
      DataSnapshot snapshot =
          await _database.reference().child('Grievances').once();

      Map<dynamic, dynamic> allGrievances = snapshot.value;

      if (allGrievances != null) {
        allGrievances.forEach((userId, grievances) {
          if (grievances is Map) {
            grievances.forEach((key, value) {
              String category = value['category'];
              data.update(category, (count) => count + 1, ifAbsent: () => 1);
            });
          }
        });
      }
    } catch (e) {
      print('Error fetching category data: $e');
    }

    return data;
  }

  Future<Map<String, int>> fetchGrievanceStatusData() async {
    Map<String, int> data = {};

    try {
      User user = _auth.currentUser;
      DataSnapshot snapshot =
          await _database.reference().child('Grievances').once();

      Map<dynamic, dynamic> allGrievances = snapshot.value;

      if (allGrievances != null) {
        allGrievances.forEach((userId, grievances) {
          if (grievances is Map) {
            grievances.forEach((key, value) {
              String status = value['status'];
              data.update(status, (count) => count + 1, ifAbsent: () => 1);
            });
          }
        });
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }

    return data;
  }

  List<PieChartSectionData> generateSections(
    Map<String, int> data,
    List<String> labels,
    Map<String, Color> colors,
  ) {
    List<PieChartSectionData> sections = [];

    for (int i = 0; i < labels.length; i++) {
      String label = labels[i];
      int value = data[label] ?? 0;
      Color color = colors[label] ?? Colors.grey;

      sections.add(
        PieChartSectionData(
          color: color,
          value: value.toDouble(),
          title: '$label\n$value',
          radius: 100,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }
}
