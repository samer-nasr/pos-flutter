class Item {
  final String name;
  final double price;
  final double quantity;

  Item({required this.name, required this.price, required this.quantity});

  // Factory method to create Item from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      price: double.parse(json['price'].toString()),
      quantity: double.parse(json['quantity'].toString()),

    );
  }
}