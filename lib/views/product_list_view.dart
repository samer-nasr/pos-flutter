import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/item.dart';

class ProductListView extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final HomeController _homeController = HomeController();
  List<Item> _filteredProducts = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // Fetch products and update the state
  Future<void> _fetchProducts() async {
    try {
      await _homeController.fetchProducts();
      setState(() {
        _filteredProducts = _homeController.products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Filter products based on search input
  void _filterProducts(String searchText) {
    setState(() {
      _filteredProducts = _homeController.products
          .where((product) =>
          product.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                _searchText = text;
                _filterProducts(_searchText);
              },
            ),
          ),

          // Product List
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(child: Text('No products found'))
                : ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: Text('Quantity: ${product.quantity.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
