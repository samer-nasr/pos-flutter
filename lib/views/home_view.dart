import 'package:flutter/material.dart';
import 'package:pos_flutter/views/cart_view.dart';
import 'package:pos_flutter/views/sales_history_view.dart';
import '../controllers/home_controller.dart';
import 'product_list_view.dart';  // Import ProductListView

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _homeController = HomeController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Fetch categories and update the state
  Future<void> _fetchCategories() async {
    try {
      await _homeController.fetchCategories();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories and Items'),
        actions: [
          // Button to navigate to ProductListView
          IconButton(
            icon: Icon(Icons.list),
            tooltip: 'View Products',
            onPressed: () {
              // Navigate to Product List View
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductListView()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Optionally navigate to cart view if needed
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SalesHistoryView()),
              );
            },
            child: Text('View Sales History'),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Categories Section
          Expanded(
            child: ListView.builder(
              itemCount: _homeController.categories.length,
              itemBuilder: (context, index) {
                var category = _homeController.categories[index];
                return ExpansionTile(
                  title: Text(category.name),
                  children: category.items.map((item) {
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _homeController.addToCart(item);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.name} added to cart!')),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Cart Summary Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items in Cart: ${_homeController.getCartItemCount()}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Total: \$${_homeController.getTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Cart/Checkout Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartView(homeController: _homeController),
                      ),
                    );
                  },
                  child: Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
