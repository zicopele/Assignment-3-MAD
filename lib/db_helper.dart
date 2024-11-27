/// Database Helper for managing SQLite database.
/// Contains methods to initialize the database and perform CRUD operations.

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'food_order.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Creates the required tables for the app.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE FoodItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE OrderPlans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        target REAL NOT NULL,
        selectedItems TEXT NOT NULL
      )
    ''');

    // Prepopulate food items
    await db.insert('FoodItems', {'name': 'Pizza Pie', 'price': 10.50});
    await db.insert('FoodItems', {'name': 'Pizza Slice', 'price': 3.75});
    await db.insert('FoodItems', {'name': 'Burger', 'price': 8.00});
    await db.insert('FoodItems', {'name': 'Fries', 'price': 2.50});
    await db.insert('FoodItems', {'name': 'Salad', 'price': 5.50});
    await db.insert('FoodItems', {'name': 'Pasta Bowl', 'price': 7.00});
    await db.insert('FoodItems', {'name': 'Soda', 'price': 1.50});
    await db.insert('FoodItems', {'name': 'Sushi', 'price': 8.00});
    await db.insert('FoodItems', {'name': 'Sandwich', 'price': 3.00});
    await db.insert('FoodItems', {'name': 'Ice Cream', 'price': 1.75});
    await db.insert('FoodItems', {'name': 'Chicken Wings', 'price': 6.50});
    await db.insert('FoodItems', {'name': 'Steak', 'price': 12.00});
    await db.insert('FoodItems', {'name': 'Tacos', 'price': 5.00});
    await db.insert('FoodItems', {'name': 'Burrito', 'price': 6.00});
    await db.insert('FoodItems', {'name': 'Smoothie', 'price': 3.50});
    await db.insert('FoodItems', {'name': 'Bagel', 'price': 2.50});
    await db.insert('FoodItems', {'name': 'Omelet', 'price': 4.25});
    await db.insert('FoodItems', {'name': 'Wrap', 'price': 4.75});
    await db.insert('FoodItems', {'name': 'Muffin', 'price': 1.50});
    await db.insert('FoodItems', {'name': 'Coffee', 'price': 2.25});
  }

  /// Fetches all food items from the database.
  Future<List<Map<String, dynamic>>> fetchFoodItems() async {
    final db = await database;
    return db.query('FoodItems');
  }

  /// Inserts an order plan into the database.
  Future<int> insertOrderPlan(Map<String, dynamic> plan) async {
    final db = await database;
    return db.insert('OrderPlans', plan);
  }

  /// Fetches all saved order plans from the database.
  Future<List<Map<String, dynamic>>> fetchAllOrderPlans() async {
    final db = await database;
    return db.query('OrderPlans');
  }

  /// Updates a food item in the database.
  Future<int> updateFoodItem(int id, Map<String, dynamic> updatedItem) async {
    final db = await database;
    return db.update('FoodItems', updatedItem, where: 'id = ?', whereArgs: [id]);
  }

  /// Deletes a food item from the database.
  Future<int> deleteFoodItem(int id) async {
    final db = await database;
    return db.delete('FoodItems', where: 'id = ?', whereArgs: [id]);
  }
}