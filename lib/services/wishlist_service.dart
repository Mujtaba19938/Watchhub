class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final List<Map<String, dynamic>> _wishlistItems = [];

  // Get all wishlist items
  List<Map<String, dynamic>> get wishlistItems => List.from(_wishlistItems);

  // Get wishlist items count
  int get itemCount => _wishlistItems.length;

  // Check if product is in wishlist
  bool isInWishlist(Map<String, dynamic> product) {
    final productName = product["name"] ?? product["model"] ?? "";
    final productBrand = product["brand"] ?? "";
    
    return _wishlistItems.any(
      (item) {
        final itemName = item["name"] ?? "";
        final itemBrand = item["brand"] ?? "";
        return itemName == productName && itemBrand == productBrand;
      },
    );
  }

  // Add item to wishlist
  void addToWishlist(Map<String, dynamic> product) {
    // Check if item already exists
    if (!isInWishlist(product)) {
      final productName = product["name"] ?? product["model"] ?? "";
      final productBrand = product["brand"] ?? "";
      
      _wishlistItems.add({
        "image": product["image"] ?? "",
        "brand": productBrand,
        "name": productName,
        "price": product["price"] ?? 0.0,
        "oldPrice": product["oldPrice"],
        "model": product["model"],
        "sub": product["sub"],
      });
    }
  }

  // Remove item from wishlist
  void removeFromWishlist(Map<String, dynamic> product) {
    final productName = product["name"] ?? product["model"] ?? "";
    final productBrand = product["brand"] ?? "";
    
    _wishlistItems.removeWhere(
      (item) {
        final itemName = item["name"] ?? "";
        final itemBrand = item["brand"] ?? "";
        return itemName == productName && itemBrand == productBrand;
      },
    );
  }

  // Remove item by index
  void removeFromWishlistByIndex(int index) {
    if (index >= 0 && index < _wishlistItems.length) {
      _wishlistItems.removeAt(index);
    }
  }

  // Toggle wishlist item (add if not present, remove if present)
  bool toggleWishlist(Map<String, dynamic> product) {
    final wasInWishlist = isInWishlist(product);
    if (wasInWishlist) {
      removeFromWishlist(product);
      return false; // Removed
    } else {
      addToWishlist(product);
      // Verify it was added
      final wasAdded = isInWishlist(product);
      return wasAdded; // Return true if successfully added
    }
  }

  // Clear wishlist
  void clearWishlist() {
    _wishlistItems.clear();
  }
}

