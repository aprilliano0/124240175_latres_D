import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/navigation_controller.dart';
import 'product_home_page.dart';
import 'profile_page.dart';

class MainNavigationPage extends StatelessWidget {
  MainNavigationPage({super.key});

  final NavigationController nav = Get.find<NavigationController>();

  final List<Widget> pages = [
    ProductHomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: nav.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.currentIndex.value,
          onTap: nav.changePage,
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey.shade500,
          showUnselectedLabels: true,
          elevation: 12,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
