import 'package:cached_network_image/cached_network_image.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_event.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_state.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsSheet extends StatelessWidget {
  final Product product;
  final ScrollController scrollController;

  const ProductDetailsSheet({
    super.key,
    required this.product,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(),
            _buildProductImage(),
            _buildProductInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDEE),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 240,
      width: double.infinity,
      color: AppTheme.primarySurface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: CachedNetworkImage(
          imageUrl: product.image,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: Color(0xFFCCCCDD),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryBadge(),
          const SizedBox(height: 12),
          _buildTitle(context),
          const SizedBox(height: 12),
          _buildRatingRow(),
          const SizedBox(height: 16),
          _buildPrice(context),
          const SizedBox(height: 20),
          _buildDescriptionSection(context),
          const SizedBox(height: 32),
          _buildAddToCartSection(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        product.category.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      product.title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final r = product.rating.rate;
          if (i < r.floor()) {
            return const Icon(
              Icons.star_rounded,
              color: AppTheme.star,
              size: 18,
            );
          } else if (i < r) {
            return const Icon(
              Icons.star_half_rounded,
              color: AppTheme.star,
              size: 18,
            );
          }
          return const Icon(
            Icons.star_border_rounded,
            color: AppTheme.star,
            size: 18,
          );
        }),
        const SizedBox(width: 8),
        Text(
          '${product.rating.rate} (${product.rating.count} reseñas)',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Text(
      '\$${product.price.toStringAsFixed(2)}',
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
        color: AppTheme.primary,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descripción', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartSection(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final qty = state is CartLoaded
            ? state.getQuantityForProduct(product.id)
            : 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (qty > 0) ...[
              _buildCartIndicator(qty),
              const SizedBox(height: 12),
            ],
            _buildAddButton(context, qty),
          ],
        );
      },
    );
  }

  Widget _buildCartIndicator(int qty) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppTheme.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Ya tienes $qty en el carrito',
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, int qty) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<CartBloc>().add(AddProductToCart(product));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                qty > 0 ? '¡Cantidad aumentada!' : '¡Agregado al carrito!',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart_outlined),
        label: Text(qty > 0 ? 'Agregar una más' : 'Agregar al carrito'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
