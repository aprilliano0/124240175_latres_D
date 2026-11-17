import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxString currentUsername = ''.obs;

  void loadUserCart(String username) {
    currentUsername.value = username;
    final items = DatabaseService.getCartItems(username);
    cartItems.assignAll(items);
  }

  Future<void> addToCart({
    required String username,
    required Product product,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      Get.snackbar(
        'Kuantitas Tidak Valid',
        'Jumlah barang harus lebih dari 0',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return;
    }

    if (quantity > product.stock) {
      Get.snackbar(
        'Stok Tidak Cukup',
        'Jumlah melebihi stok yang tersedia (${product.stock})',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade800,
        colorText: Colors.white,
      );
      return;
    }

    await DatabaseService.addToCart(
      username: username,
      product: product,
      quantity: quantity,
    );

    loadUserCart(username);

    Get.snackbar(
      'Berhasil Ditambahkan',
      '$quantity x ${product.title} telah masuk ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  Future<void> removeFromCart(String key, String username) async {
    await DatabaseService.deleteCartItem(key);
    loadUserCart(username);

    Get.snackbar(
      'Item Dihapus',
      'Produk berhasil dihapus dari keranjang',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade800,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  Future<void> updateQuantity({
    required String key,
    required int newQuantity,
    required int maxStock,
    required String username,
  }) async {
    if (newQuantity <= 0) {
      await removeFromCart(key, username);
      return;
    }

    if (newQuantity > maxStock) {
      Get.snackbar(
        'Batas Stok Tercapai',
        'Maksimal stok tersedia adalah $maxStock',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade800,
        colorText: Colors.white,
      );
      return;
    }

    await DatabaseService.updateCartItemQuantity(key, newQuantity);
    loadUserCart(username);
  }

  Future<void> checkout(String username) async {
    if (cartItems.isEmpty) return;

    await DatabaseService.clearUserCart(username);
    loadUserCart(username);

    Get.snackbar(
      'Checkout Berhasil',
      'Terima kasih telah berbelanja di ${AppConstants.appName}!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItemCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
