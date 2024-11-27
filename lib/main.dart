/// Entry point of the app.
/// Navigates to the HomeScreen to access all features.
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(FoodOrderApp());
}

class FoodOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Order Planner',
      theme: ThemeData(
                        brightness: Brightness.dark,),
      home: HomeScreen(),
    );
  }
}