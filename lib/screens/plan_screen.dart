/// Screen for planning a food order.
/// Users can add/remove items dynamically and save the plan.

import 'package:flutter/material.dart';
import '../db_helper.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final DBHelper _dbHelper = DBHelper();
  double? targetCost;
  DateTime? selectedDate;
  List<Map<String, dynamic>> foodItems = [];
  List<Map<String, dynamic>> selectedItems = [];

  double get totalCost =>
      selectedItems.fold(0.0, (sum, item) => sum + item['price']);

  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    final items = await _dbHelper.fetchFoodItems();
    setState(() {
      foodItems = items;
    });
  }

  void saveOrderPlan() async {
    if (selectedDate != null && targetCost != null && selectedItems.isNotEmpty) {
      await _dbHelper.insertOrderPlan({
        'date': selectedDate!.toIso8601String(),
        'target': targetCost,
        'selectedItems': selectedItems.map((item) => item['name']).join(', '),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order Plan Saved!')));
      setState(() {
        selectedItems.clear();
        targetCost = null;
        selectedDate = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plan Order')),
      body: Column(
        children: [
          ListTile(
            title: Text('Target Cost'),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() {
                  targetCost = double.tryParse(value);
                }),
              ),
            ),
          ),
          ListTile(
            title: Text('Select Date'),
            trailing: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
          if (selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected Date: ${selectedDate!.toIso8601String().split('T')[0]}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Text(
              'Select Food Items (Total: \$${totalCost.toStringAsFixed(2)} / Limit: \$${targetCost?.toStringAsFixed(2) ?? "N/A"})'),
          Expanded(
            child: ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final item = foodItems[index];
                final isSelected = selectedItems.contains(item);
                return ListTile(
                  title: Text('${item['name']} - \$${item['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedItems.remove(item);
                            });
                          },
                        ),
                      if (!isSelected && (totalCost + item['price']) <= (targetCost ?? 0))
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              selectedItems.add(item);
                            });
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),
          if (selectedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Items:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...selectedItems.map(
                    (item) => ListTile(
                      title: Text('${item['name']} - \$${item['price']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            selectedItems.remove(item);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ElevatedButton(
            onPressed: saveOrderPlan,
            child: Text('Save Plan'),
          ),
        ],
      ),
    );
  }
}