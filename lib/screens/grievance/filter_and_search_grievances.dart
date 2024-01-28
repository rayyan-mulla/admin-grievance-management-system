import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FilterAndSearchGrievances extends StatefulWidget {
  @override
  _FilterAndSearchGrievancesState createState() =>
      _FilterAndSearchGrievancesState();
}

class _FilterAndSearchGrievancesState extends State<FilterAndSearchGrievances> {
  DatabaseReference _reference =
      FirebaseDatabase.instance.reference().child('Grievances');

  bool isLoading = true;
  bool dataAvailable = false;
  Map<String, Map<String, dynamic>> grievanceData = {};
  String selectedStatus = 'All';
  String selectedCategory = 'All';
  TextEditingController searchController = TextEditingController();

  bool showNoGrievanceMessage = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    DataSnapshot snapshot = await _reference.once();

    bool hasData = snapshot.value != null;

    setState(() {
      isLoading = false;
      dataAvailable = hasData;
      showNoGrievanceMessage = !hasData;
    });

    if (hasData) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value);

      grievanceData.clear();

      for (var userId in userData.keys) {
        Map<String, dynamic> userGrievances =
            Map<String, dynamic>.from(userData[userId]);

        for (var grievanceKey in userGrievances.keys) {
          Map<String, dynamic> grievanceDetails =
              Map<String, dynamic>.from(userGrievances[grievanceKey]);

          grievanceData[grievanceKey] = grievanceDetails;
        }
      }

      setState(() {
        isLoading = false;
        dataAvailable = true;
        showNoGrievanceMessage = grievanceData.isEmpty;
      });
    } else {
      // Set the flag here when no data is available
      setState(() {
        isLoading = false;
        dataAvailable = false;
        showNoGrievanceMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent[700],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by Title',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                            });
                          },
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    _showFilterDialog();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : grievanceData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: grievanceData.length,
                          itemBuilder: (context, index) {
                            var grievanceKey =
                                grievanceData.keys.elementAt(index);
                            var grievanceDetails = grievanceData[grievanceKey];

                            if ((selectedStatus == 'All' ||
                                    grievanceDetails['status'].toLowerCase() ==
                                        selectedStatus.toLowerCase()) &&
                                (selectedCategory == 'All' ||
                                    grievanceDetails['category']
                                            .toLowerCase() ==
                                        selectedCategory.toLowerCase()) &&
                                (searchController.text.isEmpty ||
                                    grievanceDetails['title']
                                        .toLowerCase()
                                        .contains(searchController.text
                                            .toLowerCase()))) {
                              return buildGrievanceCard(
                                grievanceKey,
                                grievanceDetails['title'],
                                grievanceDetails['description'],
                                grievanceDetails['category'],
                                grievanceDetails['date'],
                                grievanceDetails['other_category'],
                                grievanceDetails['status'],
                              );
                            }
                            return Center(
                              child: Text("No Grievance Found"),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text("No Grievance Found"),
                      ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Status: '),
                            SizedBox(width: 8),
                            Expanded(
                              child: DropdownButton<String>(
                                value: selectedStatus,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value;
                                  });
                                },
                                items: [
                                  'All',
                                  'Under Process',
                                  'Rejected',
                                  'Approved',
                                  'New Complaint',
                                  'Affected'
                                ].map<DropdownMenuItem<String>>(
                                  (String status) {
                                    return DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text('Category: '),
                            SizedBox(width: 8),
                            Expanded(
                              child: DropdownButton<String>(
                                value: selectedCategory,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                },
                                items: [
                                  'All',
                                  'Academic',
                                  'Hostel',
                                  'Faculty',
                                  'Infrastructure',
                                  'Other'
                                ].map<DropdownMenuItem<String>>(
                                  (String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _fetchData();
                        },
                        child: Text("Apply"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildGrievanceCard(
    String grievanceKey,
    String title,
    String description,
    String category,
    String date,
    String otherCategory,
    String status,
  ) {
    Color statusColor = _getStatusColor(status);

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Divider(color: Colors.grey[400]),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      category ?? '',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      date ?? '',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      status ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (otherCategory != null) ...[
              SizedBox(height: 8),
              Text(
                'Other Category:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                otherCategory,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Deletion"),
                          content: Text(
                              "Are you sure you want to delete this grievance?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status?.toLowerCase()) {
      case 'under process':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'approved':
        return Colors.green;
      case 'affected':
        return Colors.orange;
      case 'new complaint':
        return Colors.purple;
      default:
        return Colors.grey[800];
    }
  }
}
