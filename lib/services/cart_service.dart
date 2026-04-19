class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<Map<String, dynamic>> _cartItems = [];

  // Get all cart items
  List<Map<String, dynamic>> get cartItems => List.from(_cartItems);

  // Get cart items count
  int get itemCount => _cartItems.length;

  // Get total items count (sum of quantities)
  int get totalItemCount {
    return _cartItems.fold(0, (sum, item) => sum + (item["qty"] as int? ?? 1));
  }

  // Add item to cart
  void addToCart(Map<String, dynamic> product) {
    // Check if item already exists in cart
    final existingIndex = _cartItems.indexWhere(
      (item) => item["name"] == product["name"] && item["brand"] == product["brand"],
    );

    if (existingIndex != -1) {
      // If item exists, increase quantity
      _cartItems[existingIndex]["qty"] = (_cartItems[existingIndex]["qty"] as int) + 1;
    } else {
      // Add new item with quantity 1
      _cartItems.add({
        "image": product["image"],
        "brand": product["brand"],
        "name": product["name"] ?? product["model"] ?? "",
        "price": product["price"],
        "qty": 1,
      });
    }
  }

  // Remove item from cart
  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
    }
  }

  // Update item quantity
  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _cartItems.length) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index]["qty"] = quantity;
      }
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
  }

  // Get subtotal
  double get subtotal {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item["price"] as double) * (item["qty"] as int),
    );
  }

  // Get shipping cost
  double get shipping => _cartItems.isEmpty ? 0 : 50;

  // Get total
  double get total => subtotal + shipping;
}

