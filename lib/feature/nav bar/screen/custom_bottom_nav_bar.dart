import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../home/screen/home_screen.dart';
import '../../profile/screens/profile_screen.dart';     // সঠিক ইমপোর্ট
import '../../search/screen/search_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    //DiscoverScreen(),
    //MediaScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex], // সঠিক ইনডেক্স
      bottomNavigationBar: _buildBottomNavigationBar(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /*Widget _buildFloatingActionButton() {
    return SizedBox(
      height: 69,
      width: 69,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 6,
        onPressed: () {
          Get.put(QRCodeScannerApiController());
          Get.to(() => const QrScannerScreen());
        },
        shape: const CircleBorder(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48.14),
          child: Image.asset(
            "assets/icons/qr_code_scanner.png",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.qr_code_scanner, size: 32, color: Colors.blue);
            },
          ),
        ),
      ),
    );
  }*/

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, Icons.home_outlined, 'Home'),
          _buildNavItem(1, Icons.search, Icons.search_outlined, 'Search'),
          //const SizedBox(width: 60), // FAB-এর জন্য স্পেস
          //_buildNavItem(2, Icons.photo_library, Icons.photo_library_outlined, 'Media'),
          _buildNavItem(2, Icons.person, Icons.person_outlined, 'Profile'), // ✅ Fixed index (was 3)
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index,
      IconData activeIcon,
      IconData inactiveIcon,
      String label,
      ) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
