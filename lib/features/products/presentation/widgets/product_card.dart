import 'package:cached_network_image/cached_network_image.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_event.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_state.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:carrito_compras/features/products/presentation/widgets/product_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProductDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImageSection(), _buildInfoSection(context)],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: 3,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: AppTheme.primarySurface,
              padding: const EdgeInsets.all(12),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: const Color(0xFFE0F2F1),
                  highlightColor: const Color(0xFFF5FAFA),
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported_outlined,
                  size: 40,
                  color: Color(0xFFCCCCDD),
                ),
              ),
            ),
            Positioned(top: 8, left: 8, child: _buildCategoryBadge()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _shortCategory(product.category),
        style: const TextStyle(
          color: AppTheme.primary,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            const SizedBox(height: 4),
            _buildRating(),
            const Spacer(),
            _buildPriceAndCartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      product.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontSize: 12, height: 1.3),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 13, color: AppTheme.star),
        const SizedBox(width: 2),
        Text(
          product.rating.rate.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          ' (${product.rating.count})',
          style: const TextStyle(fontSize: 10, color: AppTheme.textHint),
        ),
      ],
    );
  }

  Widget _buildPriceAndCartButton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _buildAddToCartButton(context),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final qty = state is CartLoaded
            ? state.getQuantityForProduct(product.id)
            : 0;
        return GestureDetector(
          onTap: () {
            context.read<CartBloc>().add(AddProductToCart(product));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  qty > 0 ? '¡Cantidad aumentada!' : '¡Agregado al carrito!',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: qty > 0 ? 6 : 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: qty > 0 ? AppTheme.primarySurface : AppTheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: qty > 0
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shopping_cart_rounded,
                        size: 14,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        qty.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.add_rounded, size: 18, color: Colors.white),
          ),
        );
      },
    );
  }

  String _shortCategory(String category) {
    switch (category.toLowerCase()) {
      case "men's clothing":
        return 'HOMBRES';
      case "women's clothing":
        return 'MUJERES';
      case 'jewelery':
        return 'JOYERÍA';
      case 'electronics':
        return 'ELECTRÓNICA';
      default:
        return category.toUpperCase();
    }
  }

  void _showProductDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.96,
        expand: false,
        builder: (context, scrollController) => ProductDetailsSheet(
          product: product,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
