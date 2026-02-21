import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';

class CartSliverAppBar extends StatelessWidget {
  final int itemCount;
  final VoidCallback onBack;

  const CartSliverAppBar({
    super.key,
    required this.itemCount,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.primary,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: onBack,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mi Carrito',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          if (itemCount > 0)
            Text(
              '$itemCount ${itemCount == 1 ? 'producto' : 'productos'}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
      flexibleSpace: Container(color: AppTheme.primary),
    );
  }
}
