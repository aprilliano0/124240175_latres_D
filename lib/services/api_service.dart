import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/product.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(AppConstants.apiProductsUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['products'] ?? [];
        return productsJson.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception(
            'Gagal memuat produk. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}
