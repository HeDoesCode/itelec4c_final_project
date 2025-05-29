import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2), // Background color from palette
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Home',
                index: 0,
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                icon: Icons.favorite,
                label: 'Favorites',
                index: 1,
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
                index: 2,
                isSelected: currentIndex == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFFFAB40)
                  : Colors.transparent, // Primary color when selected
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? const Color(0xFF141414) // Text color when selected
                      : const Color(0xFF141414), // Text color when not selected
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected
                        ? const Color(0xFF141414) // Text color when selected
                        : const Color(
                          0xFF141414,
                        ), // Text color when not selected
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
