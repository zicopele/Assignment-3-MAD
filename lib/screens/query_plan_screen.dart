/// Screen to display saved order plans like notes.

import 'package:flutter/material.dart';
import '../db_helper.dart';

class QueryPlanScreen extends StatefulWidget {
  @override
  _QueryPlanScreenState createState() => _QueryPlanScreenState();
}

class _QueryPlanScreenState extends State<QueryPlanScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> orderPlans = [];

  @override
  void initState() {
    super.initState();
    fetchOrderPlans();
  }

  Future<void> fetchOrderPlans() async {
    final db = await _dbHelper.database;
    final plans = await db.query('OrderPlans');
    setState(() {
      orderPlans = plans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Order Plans')),
      body: orderPlans.isEmpty
          ? Center(
              child: Text(
                'No saved orders found!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: orderPlans.length,
              itemBuilder: (context, index) {
                final plan = orderPlans[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      'Date: ${plan['date'].split('T')[0]}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Target Cost: \$${plan['target']}'),
                        Text('Selected Items: ${plan['selectedItems']}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}