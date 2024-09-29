// controllers/cart_controller.dart
import '../models/item.dart';

class CartController {
  List<Item> cart = [];

  // Add item to cart
  void addItem(Item item) {
    cart.add(item);
  }

  // Remove item from cart
  void removeItem(Item item) {
    cart.remove(item);
  }

  // Calculate total cost of items in cart
  double getTotalCost() {
    return cart.fold(0.0, (sum, item) => sum + item.price);
  }

  // Get total number of items in cart
  int getCartItemCount() {
    return cart.length;
  }

  // Perform checkout: reset cart and update quantities
  void checkout() {
    // Reduce quantity for each item in the cart
    // for (Item item in cart) {
    //   if (item.quantity > 0) {
    //    item.decrement();
    //     // item.quantity -= 1;  // Reduce item quantity by 1 (you can customize this based on your logic)
    //     print(item.quantity);
    //   }
    // }

    // Reset cart
    cart.clear();
  }
}
