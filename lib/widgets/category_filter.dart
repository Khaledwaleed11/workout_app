import 'package:flutter/material.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: isDark ? const Color(0xFF181818) : Colors.grey.shade200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.orangeAccent
                    : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.orangeAccent
                      : (isDark ? Colors.white12 : Colors.grey.shade300),
                ),
              ),
              child: Center(
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}