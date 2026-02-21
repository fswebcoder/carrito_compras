import 'package:flutter/material.dart';

class CheckoutEmptyState extends StatelessWidget {
  final VoidCallback onGoToCatalog;

  const CheckoutEmptyState({super.key, required this.onGoToCatalog});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Color(0xFFCCCCDD),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay productos en el carrito',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onGoToCatalog,
            child: const Text('Ir al catálogo'),
          ),
        ],
      ),
    );
  }
}
