import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart';
import '../services/session_service.dart';
import 'cart_controller.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxString username = ''.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> checkLoginStatus() async {
    final loggedIn = await SessionService.isLoggedIn();
    if (loggedIn) {
      final savedUser = await SessionService.getUsername();
      if (savedUser != null && savedUser.isNotEmpty) {
        username.value = savedUser;
        isLoggedIn.value = true;
        // Inisialisasi Cart untuk user ini
        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().loadUserCart(savedUser);
        }
      }
    }
  }

  Future<bool> login(String inputUsername, String inputPassword) async {
    final trimmedUsername = inputUsername.trim();
    final trimmedPassword = inputPassword.trim();

    if (trimmedUsername.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Username tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    if (trimmedPassword.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Password (NIM) tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    // Validasi Password: Password wajib NIM
    // Menerima defaultNim yang ditentukan atau format NIM (angka minimal 8 digit)
    final isNimValid = (trimmedPassword == AppConstants.defaultNim) ||
        (RegExp(r'^\d{8,15}$').hasMatch(trimmedPassword));

    if (!isNimValid) {
      Get.snackbar(
        'Login Gagal',
        'Password wajib menggunakan NIM Anda (berupa angka, contoh: ${AppConstants.defaultNim})',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    isLoading.value = true;
    try {
      // Simpan session
      await SessionService.saveSession(trimmedUsername);
      username.value = trimmedUsername;
      isLoggedIn.value = true;

      // Update cart controller
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().loadUserCart(trimmedUsername);
      }

      Get.snackbar(
        'Login Berhasil',
        'Selamat datang, $trimmedUsername!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );

      // Navigasi ke halaman utama
      Get.offAllNamed(AppRoutes.main);
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await SessionService.clearSession();
    username.value = '';
    isLoggedIn.value = false;
    
    Get.snackbar(
      'Logout',
      'Anda telah keluar dari aplikasi',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );

    Get.offAllNamed(AppRoutes.login);
  }
}
