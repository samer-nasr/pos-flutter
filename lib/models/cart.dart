// models/cart.dart

class Cart {
  final int id;
  final double totalPrice;
  final List<CartItem> cartItems;

  Cart({required this.id, required this.totalPrice, required this.cartItems});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<CartItem> cartItemsList = itemsFromJson.map((i) => CartItem.fromJson(i)).toList();

    return Cart(
      id: json['id'],
      totalPrice: json['total-price'],
      cartItems: cartItemsList,
    );
  }
}

class CartItem {
  final String productName;
  final double price;
  final int cart_id;

  CartItem({required this.productName, required this.price , required this.cart_id});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['name'],
      price: json['price'],
      cart_id: json['cart_id'],
    );
  }
}
