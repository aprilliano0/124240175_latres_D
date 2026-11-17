import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_controller.dart';
import '../views/pages/cart_page.dart';
import '../views/pages/login_page.dart';
import '../views/pages/main_navigation_page.dart';
import '../views/pages/product_detail_page.dart';
import 'app_routes.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<NavigationController>(NavigationController(), permanent: true);
    Get.lazyPut<ProductController>(() => ProductController());
  }
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => MainNavigationPage(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const ProductDetailPage(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartPage(),
    ),
  ];
}
