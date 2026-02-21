import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((cat) {
            final isSelected = cat == selectedCategory;
            final label = _getCategoryLabel(cat);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => onCategorySelected(cat),
                  selectedColor: AppTheme.primary,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primary
                        : const Color(0xFFE0E0E8),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'Todos':
        return 'Todos';
      case "men's clothing":
        return 'Hombres';
      case "women's clothing":
        return 'Mujeres';
      case 'jewelery':
        return 'Joyería';
      case 'electronics':
        return 'Electrónica';
      default:
        return category;
    }
  }
}
