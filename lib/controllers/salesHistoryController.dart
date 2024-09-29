// controllers/sales_history_controller.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart'; // Ensure you have the Cart model defined

class SalesHistoryController {
  List<Cart> salesHistory = [];

  // Fetch sales history from the API
  Future<void> fetchSalesHistory() async {
    print('response');
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/carts'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      salesHistory = data.map((json) => Cart.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sales history');
    }
  }
}
