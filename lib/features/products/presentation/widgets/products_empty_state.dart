import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProductsEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const ProductsEmptyState({
    super.key,
    this.title = 'Sin productos',
    this.subtitle = 'No hay productos en esta categoría',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 72,
            color: Color(0xFFCCCCDD),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
