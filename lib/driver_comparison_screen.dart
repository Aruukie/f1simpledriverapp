// driver_comparison_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'driver_details_screen.dart';

class DriverComparisonScreen extends StatefulWidget {
  @override
  _DriverComparisonScreenState createState() => _DriverComparisonScreenState();
}

class _DriverComparisonScreenState extends State<DriverComparisonScreen> {
  // Replace with your own list of image URLs
  static final List<String> driverImages = [
    'https://cdn.williamsf1.tech/images/fnx611yr/production/8ead46a528e504335dc226a277ac6735978fcf44-1200x1200.png?w=625&h=625&auto=format',
    'https://di-uploads-pod31.dealerinspire.com/astonmartinpalmbeach/uploads/2023/07/Fernando-Alonso-Aston-Martin-F1-banner.jpg',
    'https://www.f1fantasytracker.com/Images/Drivers/Bottas.png',
    'https://e2.365dm.com/f1/drivers/256x256/h_full_1526.png',
    'https://f1tracktalk.com/wp-content/uploads/2021/03/image-7.png',
    'https://static.wikia.nocookie.net/f1-unione-career-by-tirowee/images/9/96/Hamilton23.png/revision/latest?cb=20230616173720',
    'https://e0.365dm.com/f1/drivers/256x256/h_full_1028.png',
    'https://www.kymillman.com/wp-content/uploads/f1/products/f1-signed-photos/liam-lawson/liam-lawson.png',
    'https://cdn.racingnews365.com/Riders/Leclerc/_570x570_crop_center-center_none/f1_2023_cl_fer_lg.png?v=1677514905',
    'https://cdn.racingnews365.com/Riders/Magnussen/_570x570_crop_center-center_none/f1_2023_km_haa_lg.png?v=1677516326',
    'https://static.wikia.nocookie.net/f1-unione-career-by-tirowee/images/e/eb/Norris23.png/revision/latest?cb=20230616171201',
    'https://www.f1fantasytracker.com/Images/Drivers/2021/Headshots/Ocon.png',
    'https://cdn.racingnews365.com/Riders/Perez/_570x570_crop_center-center_none/f1_2023_sp_red_lg.png?v=1677514593',
    'https://cdn-1.motorsport.com/images/mgl/6n9Ba7XY/s200/oscar-piastri-mclaren-1.webp',
    'https://cdn.racingnews365.com/2023/Ricciardo/_570x570_crop_center-center_none/F1-2023-Daniel-Ricciardo-AlphaTauri-lg.png?v=1689231525',
    'https://cdn.sportmonks.com/images/f1/drivers/georgerussell.png',
    'https://e0.365dm.com/f1/drivers/256x256/h_full_1475.png',
    'https://a.espncdn.com/combiner/i?img=/i/headshots/rpm/players/full/5745.png',
    'https://f1tracktalk.com/wp-content/uploads/2021/03/image-22.png',
    'https://www.f1fantasytracker.com/Images/Drivers/Tsunoda.png',
    'https://static.wikia.nocookie.net/f1-unione-career-by-tirowee/images/5/50/Verstappen23.png/revision/latest?cb=20230616141529',
    'https://a.espncdn.com/combiner/i?img=/i/headshots/rpm/players/full/5682.png',
    // Add more URLs as needed
  ];

  final String apiUrl = 'https://ergast.com/api/f1/2023/drivers.json';
  List<dynamic> drivers = [];
  List<dynamic> filteredDrivers = [];

  @override
  void initState() {
    super.initState();
    fetchDriverData();
  }

  Future<void> fetchDriverData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final decodedJsonData = jsonDecode(response.body);
      if (decodedJsonData['MRData'] != null &&
          decodedJsonData['MRData']['DriverTable'] != null &&
          decodedJsonData['MRData']['DriverTable']['Drivers'] != null) {
        setState(() {
          drivers = decodedJsonData['MRData']['DriverTable']['Drivers'];
          filteredDrivers = List.from(drivers); // Copy all drivers initially
        });
      }
    } else {
      print('Failed to load driver data. Status code: ${response.statusCode}');
    }
  }

  void filterDrivers(String query) {
    setState(() {
      filteredDrivers = drivers
          .where((driver) =>
      driver['givenName'].toLowerCase().contains(query.toLowerCase()) ||
          driver['familyName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('F1 Drivers'),
        actions: [],
      ),
      body: Stack(
        children: [
          // Background image of Bahrain International Circuit
          Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4pIXaZnFL0Zyo7JQ7OrIlCWAFE7LHRdKIYQ&usqp=CAU',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: filteredDrivers.length,
            itemBuilder: (context, index) {
              final driver = filteredDrivers[index];
              if (driver != null &&
                  driver['driverId'] != null &&
                  driver['givenName'] != null &&
                  driver['familyName'] != null) {
                // Use the predefined image URLs
                final imageUrl = index < driverImages.length
                    ? driverImages[index]
                    : 'https://example.com/default.jpg'; // Default image if no URL is available

                return Card(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DriverDetailsScreen(
                            driverId: driver['driverId'],
                            driverName:
                            '${driver['givenName']} ${driver['familyName']}',
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        // Image for the driver
                        Image.network(
                          imageUrl,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8.0),
                        // Driver name
                        Text(
                          '${driver['givenName']} ${driver['familyName']}',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
