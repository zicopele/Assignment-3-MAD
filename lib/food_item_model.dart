/// Represents a Food Item in the application.
/// Contains methods to convert the FoodItem to and from a Map for database operations.

class FoodItem {
  final int? id; // Unique ID for the food item (nullable for new items)
  final String name; // Name of the food item
  final double price; // Price of the food item

  FoodItem({this.id, required this.name, required this.price});

  /// Converts a FoodItem object to a Map for database insertion/updating.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  /// Creates a FoodItem object from a Map retrieved from the database.
  static FoodItem fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }
}