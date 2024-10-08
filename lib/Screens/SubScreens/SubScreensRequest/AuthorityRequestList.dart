import 'package:flutter/material.dart';
import 'AuthorityRequestDatabase.dart'; // Import the SQLite helper class

class AuthorityRequestsScreen extends StatelessWidget {
  const AuthorityRequestsScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    final requests = await DatabaseHelper.instance.getAllRequests();
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchRequests(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No requests found.'));
          } else {
            final requests = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone Number')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Authority')),
                    DataColumn(label: Text('Incident Date')),
                    DataColumn(label: Text('Details')),
                  ],
                  rows: requests.map((request) {
                    return DataRow(
                      cells: [
                        DataCell(Text(request['id'].toString())),
                        DataCell(Text(request['name'] ?? 'N/A')),            // Name field
                        DataCell(Text(request['email'] ?? 'N/A')),           // Email field
                        DataCell(Text(request['phonenumber'] ?? 'N/A')),     // Phone Number field
                        DataCell(Text(request['address'] ?? 'N/A')),         // Address field
                        DataCell(Text(request['authority'])),                // Authority field
                        DataCell(Text(request['incident_date'])),            // Incident Date field
                        DataCell(Text(request['details'])),                  // Details field
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
