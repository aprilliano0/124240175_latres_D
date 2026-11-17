import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class DatabaseService {
  static late Box _cartBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _cartBox = await Hive.openBox(AppConstants.cartBoxName);
  }

  static String _generateKey(String username, int productId) {
    return '${username}_$productId';
  }

  // Menambah atau memperbarui item di Cart untuk user tertentu
  static Future<void> addToCart({
    required String username,
    required Product product,
    required int quantity,
  }) async {
    final key = _generateKey(username, product.id);
    final existingData = _cartBox.get(key);

    int finalQuantity = quantity;
    if (existingData != null && existingData is Map) {
      final currentQty = (existingData['quantity'] as num?)?.toInt() ?? 0;
      finalQuantity = currentQty + quantity;
      // Pastikan kuantitas tidak melebihi stok produk
      if (finalQuantity > product.stock) {
        finalQuantity = product.stock;
      }
    }

    final cartItem = CartItem(
      key: key,
      username: username,
      productId: product.id,
      title: product.title,
      price: product.price,
      image: product.images.isNotEmpty ? product.images.first : product.thumbnail,
      quantity: finalQuantity,
      stock: product.stock,
      category: product.category,
    );

    await _cartBox.put(key, cartItem.toMap());
  }

  // Mengambil semua item Cart milik username tertentu
  static List<CartItem> getCartItems(String username) {
    final List<CartItem> items = [];
    for (var key in _cartBox.keys) {
      final raw = _cartBox.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['username'] == username) {
          items.add(CartItem.fromMap(key.toString(), map));
        }
      }
    }
    return items;
  }

  // Menghapus satu item dari Cart berdasarkan key Hive
  static Future<void> deleteCartItem(String key) async {
    await _cartBox.delete(key);
  }

  // Memperbarui kuantitas item di Cart
  static Future<void> updateCartItemQuantity(String key, int newQuantity) async {
    final existingData = _cartBox.get(key);
    if (existingData != null && existingData is Map) {
      final map = Map<String, dynamic>.from(existingData);
      map['quantity'] = newQuantity;
      await _cartBox.put(key, map);
    }
  }

  // Menghapus semua item cart milik user tertentu (opsional jika checkout)
  static Future<void> clearUserCart(String username) async {
    final keysToDelete = <dynamic>[];
    for (var key in _cartBox.keys) {
      final raw = _cartBox.get(key);
      if (raw is Map && raw['username'] == username) {
        keysToDelete.add(key);
      }
    }
    await _cartBox.deleteAll(keysToDelete);
  }
}
