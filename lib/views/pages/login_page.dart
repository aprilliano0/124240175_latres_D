import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final TextEditingController usernameController =
      TextEditingController(text: 'nino');
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo / Store Icon
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    size: 50,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 16),

                // App Title
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Silakan login untuk mulai berbelanja',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),

                // Username Input Field
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    labelText: 'Username',
                    hintText: 'Contoh: nino',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Input Field (Must be NIM)
                Obx(
                  () => TextField(
                    controller: passwordController,
                    obscureText: !authController.isPasswordVisible.value,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Password (Wajib NIM)',
                      hintText: 'Contoh: ${AppConstants.defaultNim}',
                      suffixIcon: IconButton(
                        icon: Icon(
                          authController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: authController.togglePasswordVisibility,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.blue.shade600, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : () {
                              authController.login(
                                usernameController.text,
                                passwordController.text,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      child: authController.isLoading.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
