/// Screen for managing food items (Add, Edit, and Delete).
import 'package:flutter/material.dart';
import '../db_helper.dart';

class ManageFoodItemsScreen extends StatefulWidget {
  @override
  _ManageFoodItemsScreenState createState() => _ManageFoodItemsScreenState();
}

class _ManageFoodItemsScreenState extends State<ManageFoodItemsScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> foodItems = [];

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

  void showAddEditDialog({Map<String, dynamic>? item}) {
    final _nameController = TextEditingController(text: item?['name'] ?? '');
    final _priceController = TextEditingController(
        text: item != null ? item['price'].toString() : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Food Item' : 'Edit Food Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Food Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final price = double.tryParse(_priceController.text.trim());
                if (name.isNotEmpty && price != null) {
                  if (item == null) {
                    // Add new item
                    await _dbHelper.database.then((db) {
                      db.insert('FoodItems', {'name': name, 'price': price});
                    });
                  } else {
                    // Update existing item
                    await _dbHelper.updateFoodItem(
                      item['id'],
                      {'name': name, 'price': price},
                    );
                  }
                  fetchFoodItems();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid data')),
                  );
                }
              },
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteFoodItem(int id) async {
    await _dbHelper.deleteFoodItem(id);
    fetchFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Food Items')),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${foodItems[index]['name']} - \$${foodItems[index]['price']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showAddEditDialog(item: foodItems[index]),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteFoodItem(foodItems[index]['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}