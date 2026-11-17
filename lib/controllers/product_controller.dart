import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _apiService.fetchProducts();
      products.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  List<Product> get filteredProducts {
    if (searchQuery.value.trim().isEmpty) {
      return products;
    }
    final q = searchQuery.value.toLowerCase().trim();
    return products.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q);
    }).toList();
  }
}
