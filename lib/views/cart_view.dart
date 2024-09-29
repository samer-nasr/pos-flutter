import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../controllers/home_controller.dart';
import '../models/item.dart';

class CartView extends StatefulWidget {
  final HomeController homeController;

  CartView({required this.homeController});

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool isLoading = false;

  // Create cart record using API
  Future<void> createCartAndAddItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Step 1: Create Cart
      final cartResponse = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/add_cart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "total_price": widget.homeController.getTotalPrice(),
        }),
      );

      if (cartResponse.statusCode == 200) {
        // Parse the cart ID from the response
        var cartData = jsonDecode(cartResponse.body);
        int cartId = cartData['id']; // Assuming the API returns cart ID

        // Step 2: Add each item to the cart (using cartId)
        for (Item item in widget.homeController.cart) {
          await addItemToCart(cartId, item);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout Complete!')),
        );

        // Clear the cart after successful checkout
        setState(() {
          widget.homeController.cart.clear();
        });

        // Step 3: Redirect to HomeView
        Navigator.popUntil(context, (route) => route.isFirst);

      } else {
        throw Exception('Failed to create cart');
      }
    } catch (e) {
      print('Checkout Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout Failed!')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Add individual item to the cart using API
  Future<void> addItemToCart(int cartId, Item item) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/add_cartItem'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "cart_id": cartId,
        "name": item.name,
        "price": item.price,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add item to cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.homeController.cart;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart / Checkout'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        widget.homeController.cart.remove(item);
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Total Cost and Checkout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display total cost
                Text(
                  'Total: \$${widget.homeController.getTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Proceed to Checkout button
                ElevatedButton(
                  onPressed: () {
                    createCartAndAddItems();
                  },
                  child: Text('Proceed to Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
