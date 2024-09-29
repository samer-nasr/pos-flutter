import 'package:pos_flutter/models/item.dart';

class Category {
  final String name;
  final List<Item> items;

  Category({required this.name, required this.items});

  // Factory method to create Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<Item> items = itemsList.map((i) => Item.fromJson(i)).toList();
    return Category(
      name: json['name'],
      items: items,
    );
  }
}