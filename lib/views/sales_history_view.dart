// views/sales_history_view.dart

import 'package:flutter/material.dart';
import 'package:pos_flutter/controllers/salesHistoryController.dart';
import '../models/cart.dart'; // Ensure you have the Cart model defined

class SalesHistoryView extends StatefulWidget {
  @override
  _SalesHistoryViewState createState() => _SalesHistoryViewState();
}

class _SalesHistoryViewState extends State<SalesHistoryView> {
  final SalesHistoryController _salesHistoryController = SalesHistoryController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSalesHistory();
  }

  Future<void> fetchSalesHistory() async {
    try {
      await _salesHistoryController.fetchSalesHistory();
    } catch (e) {
      print('Error fetching sales history: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales History'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _salesHistoryController.salesHistory.isEmpty
          ? Center(child: Text('No sales history available'))
          : ListView.builder(
        itemCount: _salesHistoryController.salesHistory.length,
        itemBuilder: (context, index) {
          final cart = _salesHistoryController.salesHistory[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text('Cart ID: ${cart.id}'),
              subtitle: Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}'),
              children: cart.cartItems.map((item) {
                return ListTile(
                  title: Text(item.productName),
                  // subtitle: Text('Quantity: ${item.quantity} - \$${(item.price * item.quantity).toStringAsFixed(2)}'),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
