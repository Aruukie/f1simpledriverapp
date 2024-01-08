// driver_details_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DriverDetailsScreen extends StatefulWidget {
  final String driverId;
  final String driverName;

  DriverDetailsScreen({required this.driverId, required this.driverName});

  @override
  _DriverDetailsScreenState createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  final String apiUrlBase = 'https://ergast.com/api/f1/drivers/';
  Map<String, dynamic> driverDetails = {};

  @override
  void initState() {
    super.initState();
    fetchDriverDetails();
  }

  Future<void> fetchDriverDetails() async {
    final response =
    await http.get(Uri.parse('$apiUrlBase${widget.driverId}.json'));
    if (response.statusCode == 200) {
      final decodedJsonData = jsonDecode(response.body);
      if (decodedJsonData['MRData'] != null &&
          decodedJsonData['MRData']['DriverTable'] != null &&
          decodedJsonData['MRData']['DriverTable']['Drivers'] != null &&
          decodedJsonData['MRData']['DriverTable']['Drivers'].isNotEmpty) {
        setState(() {
          driverDetails =
          decodedJsonData['MRData']['DriverTable']['Drivers'][0];
        });
      }
    } else {
      print(
          'Failed to load driver details. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driverName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Driver Details:',
              style: TextStyle(
                fontSize: 24.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            if (driverDetails.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nationality: ${driverDetails['nationality']}',
                    style: TextStyle(fontSize: 20.0), // Adjust the font size as needed
                  ),
                  Text(
                    'Date of Birth: ${driverDetails['dateOfBirth']}',
                    style: TextStyle(fontSize: 20.0), // Adjust the font size as needed
                  ),
                  if (driverDetails['permanentNumber'] != null)
                    Text(
                      'Permanent Number: ${driverDetails['permanentNumber']}',
                      style: TextStyle(fontSize: 20.0), // Adjust the font size as needed
                    ),
                  // Add more details as needed
                ],
              )
            else
              Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 20.0, // Adjust the font size as needed
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
