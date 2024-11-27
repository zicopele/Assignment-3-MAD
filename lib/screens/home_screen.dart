/// Home screen with navigation to Plan Order, Manage Food Items, and View Saved Orders.

import 'package:flutter/material.dart';
import 'plan_screen.dart';
import 'manage_food_items_screen.dart';
import 'query_plan_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Order Planner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlanScreen()),
                );
              },
              child: Text('Plan Order'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageFoodItemsScreen()),
                );
              },
              child: Text('Manage Food Items'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QueryPlanScreen()),
                );
              },
              child: Text('View Saved Orders'),
            ),
          ],
        ),
      ),
    );
  }
}