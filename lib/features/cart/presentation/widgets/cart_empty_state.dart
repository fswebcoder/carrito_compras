import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';

class CartEmptyState extends StatelessWidget {
  final VoidCallback onViewProducts;

  const CartEmptyState({super.key, required this.onViewProducts});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primarySurface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 56,
                color: AppTheme.primary,
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
              'Tu carrito está vacío',
              style: Theme.of(context).textTheme.headlineSmall,
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3, end: 0),
            const SizedBox(height: 8),
            Text(
              'Agrega productos desde el catálogo\npara empezar a comprar',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ).animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onViewProducts,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Ver productos'),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
