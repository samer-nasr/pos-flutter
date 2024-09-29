import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_flutter/models/category.dart';
import 'package:pos_flutter/models/item.dart';
import '../models/cart.dart';

class HomeController {
  List<Category> categories = [];
  List<Item> cart = [];
  List<Item> products = [];

  // Fetch categories from the API
  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/category_items'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      categories = data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch products from the API
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/items'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      products = data.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }


  // Adds an item to the cart
  void addToCart(Item item) {
    cart.add(item);
  }

  // Calculate total price of items in the cart
  double getTotalPrice() {
    return cart.fold(0.0, (sum, item) => sum + item.price);
  }

  // Returns the number of items in the cart
  int getCartItemCount() {
    return cart.length;
  }


}
