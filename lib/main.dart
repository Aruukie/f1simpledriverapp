// main.dart
import 'package:flutter/material.dart';
import 'driver_comparison_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 Drivers',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DriverComparisonScreen(),
    );
  }
}
